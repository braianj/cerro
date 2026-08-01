#!/bin/bash
# Guards the only file that matters (index.html) and the path to production.
# See CLAUDE.md rule 8: pushing to main IS deploying, there is no CI in between.
set -u

if ! command -v jq >/dev/null 2>&1; then
  marker="${TMPDIR:-/tmp}/.claude-cerro-jq-warned-$PPID"
  if [ ! -f "$marker" ]; then
    echo "WARNING: jq not found — .claude/hooks/* operate in fail-open mode (no guards). Install with 'brew install jq'." >&2
    : > "$marker" 2>/dev/null
  fi
  exit 0
fi

cmd=$(jq -r '.tool_input.command // empty')
[ -z "$cmd" ] && exit 0

block() {
  echo "BLOCKED by .claude/hooks/pre-bash-block-destructive.sh" >&2
  echo "Reason: $1" >&2
  echo "Recovery: $2" >&2
  exit 2
}

# index.html is the entire application and has no backup outside git history.
if printf '%s' "$cmd" | grep -Eq '\brm\b.*(-[a-zA-Z]*f|-[a-zA-Z]*r).*index\.html'; then
  block "deleting index.html — that file is the whole app (CLAUDE.md: Architecture)" \
        "edit the file instead; to revert use 'git checkout -- index.html'"
fi

if printf '%s' "$cmd" | grep -Eq '\brm\b.*-[a-zA-Z]*r.*(\.github|\.claude)\b'; then
  block "deleting .github or .claude — that removes the deploy workflow or the agent kit" \
        "delete individual files with 'git rm <path>' so the change is reviewable"
fi

# Force-pushing main rewrites what is already live.
if printf '%s' "$cmd" | grep -Eq 'git\s+push\b.*(--force\b|--force-with-lease\b|\s-f(\s|$))' \
   && printf '%s' "$cmd" | grep -Eq '\b(main|origin\s+main|HEAD:main)\b'; then
  block "force-pushing main — main is production (CLAUDE.md rule 8)" \
        "push a normal commit, or ask the user before rewriting published history"
fi

if printf '%s' "$cmd" | grep -Eq 'git\s+reset\s+--hard'; then
  block "git reset --hard discards uncommitted work in a repo with no build artifacts to regenerate it" \
        "use 'git stash' to park changes, or 'git checkout -- <file>' for one file"
fi

if printf '%s' "$cmd" | grep -Eq 'git\s+clean\s+-[a-zA-Z]*f'; then
  block "git clean -f removes untracked files (notes, local drafts) permanently" \
        "run 'git clean -n' first and delete deliberately"
fi

if printf '%s' "$cmd" | grep -Eq 'git\s+commit\b.*--no-verify'; then
  block "--no-verify skips GPG signing and local checks" \
        "commit normally; if a check is wrong, fix the check"
fi

# The remote must stay on SSH (CLAUDE.md: Git).
if printf '%s' "$cmd" | grep -Eq 'git\s+remote\s+(set-url|add).*https://'; then
  block "switching the git remote to HTTPS" \
        "use the SSH form: git@github.com:braianj/cerro.git"
fi

exit 0
