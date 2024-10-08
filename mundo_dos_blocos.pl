%Renata Rodrigues Coelho
%Thiago Vitor Gomes Pereira
place(1).
place(2).
place(3).
place(4).
place(5).
place(6).


block(a).
block(b).
block(c).
block(d).
block(e).

% Estado inicial:
start_state([clear(c), clear(2), clear(3), clear(d), clear(5), on(c,1), on(a,4), on(b,6), on(d,a), on(e,b)]).

% Metas (goals):
goal_state([on(c,a), on(a,d), on(b,d), on(d,4), clear(1), clear(2), clear(3), clear(c)]).

% Define um objeto (pode ser um bloco ou lugar)
object(X):- place(X) ; block(X).

% Regras que verificam se é possível fazer uma ação
can_move(move(Block, From, To), [clear(Block), clear(To), on(Block, From)]) :-
    block(Block), % Bloco que será movido
    object(To),   % To pode ser um bloco ou um lugar
    To \== Block, % O bloco tem que ser movido para um lugar diferente de si mesmo
    object(From), % From pode ser um bloco ou um lugar
    From \== To,  % Não move para o mesmo lugar
    Block \== From. % Bloco não pode ser igual ao lugar de origem

% Efeitos de alguma ação
add_effects(move(Block, From, To), [on(Block, To), clear(From)]).
delete_effects(move(Block, From, To), [on(Block, From), clear(To)]).

% Verifica se os objetivos foram atingidos
goals_satisfied(State, Goals) :- 
    remove_all(Goals, State, []).

% Seleciona uma meta
select_goal(State, Goals, Goal) :- 
    member(Goal, Goals).

% Verifica se uma ação alcança uma meta
action_achieves(Action, Goal) :- 
    add_effects(Action, AddList),
    member(Goal, AddList).

% Verifica se uma ação preserva as metas
action_preserves(Action, Goals) :- 
    delete_effects(Action, DelList),
    \+ (member(Goal, DelList), member(Goal, Goals)).

% Faz a regressão de metas a partir de uma ação
regress_goals(Goals, Action, Condition, RegressedGoals) :- 
    add_effects(Action, NewRelations),
    remove_all(Goals, NewRelations, RemainingGoals),
    add_new(Condition, RemainingGoals, RegressedGoals).

% Substitui as variáveis
replace_vars([], _, []).
replace_vars([clear(X) | Rest], State, [clear(X) | ReplacedRest]) :-
    replace_vars(Rest, State, ReplacedRest).
replace_vars([on(Block, Place) | Rest], State, [on(Block, ReplacedPlace) | ReplacedRest]) :-
    member(on(Block, ReplacedPlace), State),
    replace_vars(Rest, State, ReplacedRest).

% Adiciona novas metas às anteriores
add_new([], L, L).
add_new([X | L1], L2, L3) :- 
    add_new(L1, L2, L3).

% Diferença entre os conjuntos
remove_all([], _, []).
remove_all([X | L1], L2, Diff) :-
    member(X, L2), !,
    remove_all(L1, L2, Diff).
remove_all([X | L1], L2, [X | Diff]) :-
    remove_all(L1, L2, Diff).

% Predicado para gerar o plano
plan(State, Goals, []) :-
    goals_satisfied(State, Goals), % Verifica se as metas foram alcançadas
    !. % Se todas as metas foram alcançadas, encerra o plano

plan(State, Goals, [Action | PrePlan]) :-
    select_goal(State, Goals, Goal),                  % Seleciona uma meta
    action_achieves(Action, Goal),                    % Verifica se a ação atinge a meta
    can_move(Action, Condition),                      % Verifica se a ação é possível
    replace_vars(Condition, State, ReplacedCondition), % Substitui as variáveis da condição
    action_preserves(Action, Goals),                  % Garante que as metas sejam preservadas
    regress_goals(Goals, Action, ReplacedCondition, RegressedGoals), % Regressão de metas
    plan(State, RegressedGoals, PrePlan).             % Chamada recursiva para fazer o plano com a nova meta

% Executa o planejador
planejador(Plan) :-
    start_state(State),
    goal_state(Goals),
    plan(State, Goals, Plan).

%addnew(NewGoals, OldGoals, AllGoals):
% AllGoals is the union of NewGoals and OldGoals 
% NewGoals and OldGoals must be compatible

addnew([], L, L).

addnew([Goal | _], Goals, _):-
	impossible(Goal, Goals), % Goal incompatible with Goals
    !,
    fail. % Cannot be added

addnew([X | L1], L2, L3):-
    member(X, L2), !, % Ignore duplicate
    addnew(L1, L2, L3). 

addnew([X | L1], L2, [X | L3]):-
    addnew(L1, L2, L3).

% delete_all(L1, L2, Diff): Diff is set-difference of lists L1 and L2
delete_all([],_,[]).

delete_all([X | L1], L2, Diff):-
    member( X, L2), !,
    delete_all(L1, L2, Diff).

delete_all([X | L1], L2, [X | Diff]):-
	delete_all(L1, L2, Diff).