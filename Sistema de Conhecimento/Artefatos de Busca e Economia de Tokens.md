___
Esta nota documenta os artefatos leves criados para busca e roteamento no vault. Eles existem para reduzir leitura desnecessaria e custo de tokens em tarefas futuras. Em vez de abrir varias notas longas de imediato, o fluxo comeca por arquivos pequenos de catalogo, relacoes e roteador. O resultado e triagem mais rapida, menor ruido de contexto e maior previsibilidade nas respostas do agente ao consultar a base de conhecimento.
___

Links: [[Sistema de Conhecimento]]; [[Index]]; [[Context Engineering para o Vault]]; [[Pipeline de Conhecimento (Captura, Sintese e Reuso)]]; [[_Artefatos/PLAYBOOK]];

# Conteudo

Artefatos ativos:
- `_Artefatos/router.yaml`: decide quais arquivos abrir por tipo de tarefa.
- `_Artefatos/catalogo.jsonl`: inventario enxuto de notas com metadados.
- `_Artefatos/crosslinks.jsonl`: grafo simples de relacoes entre notas.
- `_Artefatos/memory/*.jsonl`: memoria append-only de decisoes, falhas e aprendizados.

Sequencia recomendada:
1. Classificar tarefa no router.
2. Buscar candidatos no catalogo.
3. Usar crosslinks para expandir somente o necessario.
4. Abrir notas completas apenas no fim.
