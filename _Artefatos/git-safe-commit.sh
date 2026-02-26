#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"

usage() {
  cat <<'EOF'
git-safe-commit.sh - commit automatico com checagens de conflito

Uso:
  bash _Artefatos/git-safe-commit.sh [opcoes]

Opcoes:
  -m, --message <msg>   Mensagem do commit (se omitida, gera automaticamente)
  --no-add              Nao roda "git add -A" (comita apenas o que ja estiver staged)
  --no-fetch            Nao roda "git fetch --prune"
  --no-rebase           Nao tenta sincronizar com upstream via rebase
  --push                Faz push no final (se houver upstream)
  --amend               Faz amend do commit atual (mantem staged)
  --dry-run             Mostra o que faria, sem alterar nada
  -h, --help            Ajuda

Quando detecta conflito (merge/rebase/cherry-pick em andamento ou arquivos unmerged),
gera um report em "_Artefatos/memory/git-safe-commit-last.report.txt".

Mensagem automatica:
- Segue um formato tipo Conventional Commits: "type(scope): subject"
- Adiciona um body curto com estatisticas (arquivos, modulos tocados)
EOF
}

say() { printf '%s\n' "$*"; }
err() { printf '%s\n' "$*" >&2; }

timestamp_utc() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

repo_root() {
  git rev-parse --show-toplevel 2>/dev/null
}

report_path_for_repo() {
  local root="$1"
  printf '%s\n' "$root/_Artefatos/memory/git-safe-commit-last.report.txt"
}

write_report() {
  local root="$1"
  local report_path
  report_path="$(report_path_for_repo "$root")"

  mkdir -p "$(dirname "$report_path")"

  {
    say "timestamp_utc: $(timestamp_utc)"
    say "repo_root: $root"
    say "branch: $(git branch --show-current 2>/dev/null || true)"
    say "head: $(git rev-parse --short HEAD 2>/dev/null || true)"
    say "upstream: $(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo '(no upstream)')"
    if git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then
      say "ahead_behind: $(git rev-list --left-right --count HEAD...@{u} 2>/dev/null || true)"
    else
      say "ahead_behind: (no upstream)"
    fi

    say ""
    say "in_progress:"
    git rev-parse -q --verify MERGE_HEAD >/dev/null 2>&1 && say "- merge" || true
    test -d "$(git rev-parse --git-path rebase-merge)" && say "- rebase-merge" || true
    test -d "$(git rev-parse --git-path rebase-apply)" && say "- rebase-apply" || true
    git rev-parse -q --verify CHERRY_PICK_HEAD >/dev/null 2>&1 && say "- cherry-pick" || true
    git rev-parse -q --verify REVERT_HEAD >/dev/null 2>&1 && say "- revert" || true

    say ""
    say "unmerged_files:"
    git diff --name-only --diff-filter=U 2>/dev/null | sed 's/^/- /' || true

    say ""
    say "status_porcelain_v2:"
    git status --porcelain=v2 --branch 2>/dev/null || true
  } >"$report_path"

  say "$report_path"
}

has_in_progress_operation() {
  git rev-parse -q --verify MERGE_HEAD >/dev/null 2>&1 && return 0
  test -d "$(git rev-parse --git-path rebase-merge)" && return 0
  test -d "$(git rev-parse --git-path rebase-apply)" && return 0
  git rev-parse -q --verify CHERRY_PICK_HEAD >/dev/null 2>&1 && return 0
  git rev-parse -q --verify REVERT_HEAD >/dev/null 2>&1 && return 0
  return 1
}

has_unmerged_files() {
  test -n "$(git diff --name-only --diff-filter=U 2>/dev/null || true)"
}

auto_message() {
  # Conventional Commits-ish (type(scope): subject) with a small body.
  # mode:
  # - "staged": usa apenas staged (git diff --cached)
  # - "working": simula o que entraria com "git add -A" (tracked diff vs HEAD + untracked)
  local mode="${1:-staged}"
  local subject body

  local staged_count
  local name_only name_status

  if [[ "$mode" == "working" ]]; then
    name_only="$(
      {
        git diff --name-only HEAD
        git ls-files --others --exclude-standard
      } | sed '/^$/d' | sort -u
    )"
    name_status="$(
      {
        git diff --name-status HEAD
        git ls-files --others --exclude-standard | sed 's/^/A\t/'
      } | sed '/^$/d'
    )"
  else
    name_only="$(git diff --cached --name-only | sed '/^$/d')"
    name_status="$(git diff --cached --name-status | sed '/^$/d')"
  fi

  staged_count="$(printf '%s\n' "$name_only" | sed '/^$/d' | wc -l | tr -d '[:space:]')"

  local added modified deleted renamed
  added="$(printf '%s\n' "$name_status" | awk '$1 ~ /^A/ {c++} END{print c+0}')"
  modified="$(printf '%s\n' "$name_status" | awk '$1 ~ /^M/ {c++} END{print c+0}')"
  deleted="$(printf '%s\n' "$name_status" | awk '$1 ~ /^D/ {c++} END{print c+0}')"
  renamed="$(printf '%s\n' "$name_status" | awk '$1 ~ /^R/ {c++} END{print c+0}')"

  local obsidian artefatos notes other
  obsidian="$(printf '%s\n' "$name_only" | awk -F/ '$1==".obsidian" {c++} END{print c+0}')"
  artefatos="$(printf '%s\n' "$name_only" | awk -F/ '$1=="_Artefatos" {c++} END{print c+0}')"
  notes="$(printf '%s\n' "$name_only" | awk 'tolower($0) ~ /\.md$/ {c++} END{print c+0}')"
  other="$(printf '%s\n' "$name_only" | awk 'tolower($0) !~ /\.md$/ && $0 !~ /^_Artefatos\// && $0 !~ /^\.obsidian\// {c++} END{print c+0}')"

  local scope="vault"

  # Detect if all changes are within a single top-level directory (module).
  local unique_modules
  unique_modules="$(printf '%s\n' "$name_only" | awk -F/ 'NF==1 {print "Raiz"; next} {print $1}' | sort -u)"
  local module_count
  module_count="$(printf '%s\n' "$unique_modules" | sed '/^$/d' | wc -l | tr -d '[:space:]')"
  if [[ "$module_count" -eq 1 ]]; then
    scope="$(printf '%s\n' "$unique_modules" | head -n 1)"
    if [[ "$scope" == "Raiz" ]]; then
      scope="vault"
    fi
  fi

  # Normalize scope to a conventional-commit friendly token.
  scope="$(printf '%s' "$scope" | tr '[:upper:]' '[:lower:]')"
  scope="$(printf '%s' "$scope" | sed -E 's/c\\+\\+/cpp/g; s/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"
  [[ -z "$scope" ]] && scope="vault"

  local type="chore"
  if [[ "$notes" -gt 0 && "$artefatos" -eq 0 && "$obsidian" -eq 0 && "$other" -eq 0 ]]; then
    type="docs"
  elif [[ "$obsidian" -gt 0 && "$artefatos" -eq 0 && "$notes" -eq 0 && "$other" -eq 0 ]]; then
    type="chore"
    scope="obsidian"
  elif [[ "$artefatos" -gt 0 && "$obsidian" -eq 0 && "$notes" -eq 0 && "$other" -eq 0 ]]; then
    type="chore"
    scope="artefatos"
  elif [[ "$other" -gt 0 ]]; then
    type="chore"
  else
    # Mixed notes + artifacts, or notes + obsidian, etc.
    type="chore"
    scope="vault"
  fi

  local action="update"
  if [[ "$added" -gt 0 && "$modified" -eq 0 && "$deleted" -eq 0 && "$renamed" -eq 0 ]]; then
    action="add"
  elif [[ "$deleted" -gt 0 ]]; then
    action="refactor"
  fi

  local short_target="changes"
  if [[ "$notes" -gt 0 && "$artefatos" -eq 0 && "$obsidian" -eq 0 && "$other" -eq 0 ]]; then
    short_target="notes"
  elif [[ "$artefatos" -gt 0 && "$notes" -eq 0 && "$obsidian" -eq 0 && "$other" -eq 0 ]]; then
    short_target="artifacts"
  elif [[ "$obsidian" -gt 0 && "$notes" -eq 0 && "$artefatos" -eq 0 && "$other" -eq 0 ]]; then
    short_target="workspace"
  elif [[ "$notes" -gt 0 && "$artefatos" -gt 0 && "$other" -eq 0 ]]; then
    short_target="notes and artifacts"
  fi

  if [[ "$staged_count" -eq 1 ]]; then
    local only_file
    only_file="$(printf '%s\n' "$name_only" | head -n 1)"
    local only_title
    only_title="$(basename "$only_file")"
    subject="$type($scope): $action $only_title"
  else
    subject="$type($scope): $action $short_target ($staged_count files)"
  fi

  # Keep subject reasonably short (~72 chars). If too long, fall back.
  if [[ "${#subject}" -gt 72 ]]; then
    subject="$type($scope): $action $short_target ($staged_count files)"
  fi

  # Small informative body with high-signal stats and modules touched.
  local modules_line
  modules_line="$(printf '%s\n' "$unique_modules" | sed '/^$/d' | paste -sd ',' - | sed 's/,/, /g')"

  body=$(
    cat <<EOF
Changes:
- files: $staged_count (A:$added M:$modified D:$deleted R:$renamed)
- notes: $notes, artifacts: $artefatos, obsidian: $obsidian, other: $other
- modules: $modules_line
EOF
  )

  say "$subject"
  say ""
  say "$body"
}

has_changes_to_commit() {
  if [[ "$DO_ADD" -eq 0 ]]; then
    ! git diff --cached --quiet
    return
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    test -n "$(git status --porcelain)"
    return
  fi

  ! git diff --cached --quiet
}

MESSAGE=""
DO_ADD=1
DO_FETCH=1
DO_REBASE=1
DO_PUSH=0
DO_AMEND=0
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    -m|--message)
      MESSAGE="${2:-}"
      shift 2
      ;;
    --no-add)
      DO_ADD=0
      shift
      ;;
    --no-fetch)
      DO_FETCH=0
      shift
      ;;
    --no-rebase)
      DO_REBASE=0
      shift
      ;;
    --push)
      DO_PUSH=1
      shift
      ;;
    --amend)
      DO_AMEND=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      err "Argumento desconhecido: $1"
      err ""
      usage
      exit 2
      ;;
  esac
done

ROOT="$(repo_root || true)"
if [[ -z "${ROOT}" ]]; then
  err "Nao parece ser um repositorio Git."
  exit 2
fi

cd "$ROOT"

if has_in_progress_operation || has_unmerged_files; then
  err "Conflito/operacao em andamento detectado. Resolva antes de commitar."
  err "Report: $(write_report "$ROOT")"
  exit 3
fi

UPSTREAM=""
if git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then
  UPSTREAM="$(git rev-parse --abbrev-ref --symbolic-full-name @{u})"
fi

if [[ -n "$UPSTREAM" && "$DO_FETCH" -eq 1 ]]; then
  if [[ "$DRY_RUN" -eq 1 ]]; then
    say "[dry-run] git fetch --prune"
  else
    git fetch --prune
  fi
fi

if [[ -n "$UPSTREAM" && "$DO_REBASE" -eq 1 ]]; then
  # left-right count returns: "<ahead> <behind>"
  read -r AHEAD BEHIND < <(git rev-list --left-right --count HEAD..."$UPSTREAM" 2>/dev/null || echo "0 0")
  if [[ "${BEHIND:-0}" -gt 0 ]]; then
    if [[ "$DRY_RUN" -eq 1 ]]; then
      say "[dry-run] git pull --rebase --autostash --prune"
    else
      if ! git pull --rebase --autostash --prune; then
        err "Falha ao sincronizar com upstream (provavel conflito de rebase)."
        err "Report: $(write_report "$ROOT")"
        exit 4
      fi
    fi
  fi
fi

if has_in_progress_operation || has_unmerged_files; then
  err "Conflito detectado apos sincronizacao. Resolva antes de commitar."
  err "Report: $(write_report "$ROOT")"
  exit 3
fi

if [[ "$DO_ADD" -eq 1 ]]; then
  if [[ "$DRY_RUN" -eq 1 ]]; then
    say "[dry-run] git add -A"
  else
    git add -A
  fi
fi

if ! has_changes_to_commit; then
  if [[ "$DO_ADD" -eq 0 ]]; then
    say "Nada staged para commitar."
  else
    say "Nada para commitar."
  fi
  exit 0
fi

if [[ -z "$MESSAGE" ]]; then
  if [[ "$DRY_RUN" -eq 1 && "$DO_ADD" -eq 1 ]]; then
    MESSAGE="$(auto_message working)"
  else
    MESSAGE="$(auto_message staged)"
  fi
fi

if [[ "$DRY_RUN" -eq 1 ]]; then
  say ""
  say "--- commit message (preview) ---"
  say "$MESSAGE"
  say ""
fi

if [[ "$DO_AMEND" -eq 1 ]]; then
  if [[ "$DRY_RUN" -eq 1 ]]; then
    say "[dry-run] git commit --amend -m <subject> -m <body>"
  else
    SUBJECT="${MESSAGE%%$'\n'*}"
    REST="${MESSAGE#"$SUBJECT"}"
    REST="${REST#"$'\n'"}"
    if [[ -n "${REST// }" ]]; then
      git commit --amend -m "$SUBJECT" -m "$REST"
    else
      git commit --amend -m "$SUBJECT"
    fi
  fi
else
  if [[ "$DRY_RUN" -eq 1 ]]; then
    say "[dry-run] git commit -m <subject> -m <body>"
  else
    SUBJECT="${MESSAGE%%$'\n'*}"
    REST="${MESSAGE#"$SUBJECT"}"
    REST="${REST#"$'\n'"}"
    if [[ -n "${REST// }" ]]; then
      git commit -m "$SUBJECT" -m "$REST"
    else
      git commit -m "$SUBJECT"
    fi
  fi
fi

if [[ -n "$UPSTREAM" && "$DO_PUSH" -eq 1 ]]; then
  if [[ "$DRY_RUN" -eq 1 ]]; then
    say "[dry-run] git push"
  else
    if ! git push; then
      err "Falha no push (possivel non-fast-forward ou permissao)."
      err "Report: $(write_report "$ROOT")"
      exit 5
    fi
  fi
fi

if [[ "$DRY_RUN" -eq 0 ]]; then
  say "OK. Commit criado: $(git rev-parse --short HEAD)"
fi
