___
Este topico adiciona uma ferramenta simples para automatizar commits do vault com seguranca: antes de commitar, ela verifica se existe merge/rebase/cherry-pick em andamento, se ha arquivos em conflito (unmerged) e se o branch esta atras do upstream. Se estiver atras, a ferramenta tenta sincronizar via `git pull --rebase --autostash` e so continua quando o repositorio estiver consistente. Quando aparece conflito, ela gera um report para diagnostico rapido e para eu te ajudar a resolver.
___

Links: [[Index]]; [[Sistema de Conhecimento]]; [[Artefatos de Busca e Economia de Tokens]]; [[Resolver conflitos de Git (merge e rebase)]];

# Conteudo

## Ferramenta

Script: `_Artefatos/git-safe-commit.sh`

## Mensagem de commit (geracao automatica)

Se voce nao passar `-m`, o script gera uma mensagem seguindo boas praticas:
- Subject no estilo Conventional Commits: `type(scope): subject`
- Subject curto (tenta manter <= ~72 caracteres)
- Body com estatisticas (quantos arquivos, modulos tocados, etc.)

## Uso (exemplos)

- Commit automatico (gera mensagem se nao passar `-m`):
  - `bash _Artefatos/git-safe-commit.sh`
- Commit com mensagem:
  - `bash _Artefatos/git-safe-commit.sh -m "Atualiza index e modulos"`
- Commit + push (por padrao, ele faz push se houver upstream):
  - `bash _Artefatos/git-safe-commit.sh`
- Commit sem push:
  - `bash _Artefatos/git-safe-commit.sh --no-push`
- Apenas checar o que faria:
  - `bash _Artefatos/git-safe-commit.sh --dry-run`

## O que ele verifica (ordem)

1. Operacao Git em andamento (merge/rebase/cherry-pick/revert).
2. Arquivos unmerged (conflitos pendentes).
3. (Opcional) `fetch` e sincronizacao com upstream via rebase.
4. `git add -A` (por padrao).
5. Cria o commit (ou `--amend`) e opcionalmente `--push`.

## Quando der conflito

Ele para e escreve um report em `_Artefatos/memory/git-safe-commit-last.report.txt`.
Se voce me pedir ajuda, eu uso esse report + os arquivos conflitantes para propor a resolucao mais eficiente.
