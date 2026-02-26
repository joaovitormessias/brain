
___
Este playbook define o fluxo padrao para consultas no vault com minimo consumo de tokens. Ele prioriza artefatos curtos para classificar a tarefa e somente depois abre notas extensas. O objetivo e manter respostas precisas, rastreaveis e consistentes com a arquitetura de modulos/topicos do `[[Index]]`. Sempre que um conteudo novo entrar, atualize catalogo, crosslinks e memoria para preservar qualidade de recuperacao e evitar regressao de contexto.
___

Links: [[Index]]; [[Sistema de Conhecimento]]; [[Context Engineering para o Vault]]; [[Artefatos de Busca e Economia de Tokens]]; [[Commit automatico com verificacao (Git)]];

# Conteudo

Fluxo operacional:
1. Ler `_Artefatos/router.yaml` e escolher trilha da tarefa.
2. Consultar `_Artefatos/catalogo.jsonl` por `module`, `tipo` e `keywords`.
3. Expandir contexto com `_Artefatos/crosslinks.jsonl` (1-2 saltos maximo).
4. Abrir apenas notas candidatas.
5. Registrar decisoes relevantes em `_Artefatos/memory/decisions.jsonl`.

Regras:
- Preferir fontes primarias para temas tecnicos.
- Evitar carregar modulos inteiros quando um topico resolve.
- Atualizar artefatos apos criar modulo/topico novo.

Manutencao Git (commit):
- Usar `bash _Artefatos/git-safe-commit.sh` para commitar com checagens e report de conflito.
