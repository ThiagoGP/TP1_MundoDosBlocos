# TP1 - MUNDOS DOS BLOCOS

**Alunos:**
- Renata Rodrigues Coelho
- Thiago Vítor Gomes Pereira
## Planejador de Blocos:
Este projeto implementa um planejador simples em Prolog, que resolve um problema de movimentação de blocos para alcançar um estado final desejado. O planejador utiliza blocos identificados pelas letras a, b, c, d e e, movendo-os entre posições numeradas e entre si, de acordo com o estado inicial e as metas (goals) definidas.

## Guia de Execução Passo a Passo

### Ambiente Prolog

O código foi desenvolvido e testado utilizando o SWISH-Prolog.

### Carregar o Código

Abra o ambiente de desenvolvimento Prolog e carregue o arquivo fornecido.

### Configurar o Estado Inicial

Edite a definição do estado inicial (`sart_state` predicado) no arquivo Prolog, conforme o problema que você está resolvendo.

### Configurar a Meta
Edite a definição  o estado final (`goal_state` predicado) no arquivo Prolog, conforme o problema que você está resolvendo.

### Executar o Planejador

Após configurar o estado inicial e as metas, execute o planejamento para simular e resolver o problema. digite na query
? - planejador(Plan)
