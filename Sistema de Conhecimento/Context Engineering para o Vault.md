
___
Esta nota aplica os principios de context engineering ao vault: trocar prompts gigantes por arquitetura de contexto em camadas. A ideia central e usar roteamento progressivo para carregar apenas o necessario em cada tarefa, reduzindo tokens e aumentando precisao. O modelo opera em tres niveis: roteador global, instrucoes do modulo e dados/notas-alvo. Tambem define hierarquia de instrucoes para evitar conflitos e manter manutencao local, com regras claras por modulo.
___

Links: [[Sistema de Conhecimento]]; [[Index]]; [[LLMs]]; [[Harmeness Engineering]]; [[Arquitetura de Software]]; [[Artefatos de Busca e Economia de Tokens]];

# Conteudo

Principios aplicados:
- Contexto importa mais que prompt isolado.
- Progressive disclosure em 3 niveis:
  1) rotear tarefa para modulo certo,
  2) carregar instrucao curta do modulo,
  3) abrir apenas notas e dados realmente necessarios.
- Hierarquia de instrucoes:
  - nivel repositorio (`AGENTS.md` e `Index.md`),
  - nivel modulo (nota-modulo),
  - nivel topico (nota especifica).
- Modulos isolam carga, crosslinks conectam raciocinio.

Regra operacional:
- Antes de abrir notas longas, consultar `_Artefatos/router.yaml`, `_Artefatos/catalogo.jsonl` e `_Artefatos/crosslinks.jsonl`.

Fontes:
- https://x.com/koylanai/status/2025286163641118915?s=20
- https://api.fxtwitter.com/i/status/2025286163641118915
