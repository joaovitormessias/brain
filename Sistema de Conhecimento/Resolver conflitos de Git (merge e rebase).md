___
Este topico descreve um fluxo pratico para entender e resolver conflitos de Git com o menor custo: identificar se o conflito vem de merge, rebase ou cherry-pick, listar arquivos unmerged e escolher a estrategia (manter A, manter B, combinar). O objetivo e sair do estado “em andamento” com seguranca e rapidamente voltar a um repositorio consistente para finalizar o commit e o push. Ele tambem define como coletar contexto minimo para eu conseguir sugerir a melhor resolucao.
___

Links: [[Index]]; [[Sistema de Conhecimento]]; [[Commit automatico com verificacao (Git)]]; [[Arquitetura de Software]];

# Conteudo

## Diagnostico rapido

1. Rode `git status`.
2. Se aparecer `You are in the middle of a rebase/merge/cherry-pick`, termine essa operacao antes de novo commit.
3. Liste conflitos:
   - `git diff --name-only --diff-filter=U`

## Resolucao eficiente (geral)

- Se for rebase:
  1. Abra cada arquivo em conflito e resolva os marcadores `<<<<<<<`, `=======`, `>>>>>>>`.
  2. `git add <arquivo>` para cada resolvido.
  3. `git rebase --continue`
- Se for merge:
  1. Resolva arquivos.
  2. `git add <arquivo>`
  3. `git commit` (o merge commit) ou `git merge --continue` (dependendo do fluxo).
- Se for cherry-pick:
  1. Resolva arquivos.
  2. `git add <arquivo>`
  3. `git cherry-pick --continue`

## Quando abortar

Se voce entrou na operacao errada (ex.: rebase em branch errado), prefira abortar e recomeçar:
- Rebase: `git rebase --abort`
- Merge: `git merge --abort`
- Cherry-pick: `git cherry-pick --abort`

## Contexto minimo para eu resolver com voce

Me envie (ou me deixe eu coletar) estes itens:
- Saida de `git status`
- Lista de `git diff --name-only --diff-filter=U`
- O report `_Artefatos/memory/git-safe-commit-last.report.txt`

Com isso eu consigo identificar “qual lado” representa o que mudou e propor uma resolucao que minimize retrabalho.
