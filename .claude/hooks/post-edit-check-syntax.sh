#!/bin/bash
# The repo has no build, no lint and no tests. This is the only automated
# check that a change to index.html still parses. Non-blocking on purpose:
# it reports, it does not stop the edit.
set -u

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

file=$(jq -r '.tool_input.file_path // empty')
[ -z "$file" ] && exit 0

case "$file" in
  *index.html) ;;
  *) exit 0 ;;
esac

[ -f "$file" ] || exit 0
command -v node >/dev/null 2>&1 || exit 0

tmp="${TMPDIR:-/tmp}/cerro-inline-script-$$.js"
sed -n '/<script>/,/<\/script>/p' "$file" | sed '1d;$d' > "$tmp" 2>/dev/null

if [ ! -s "$tmp" ]; then
  echo "WARNING: could not extract the inline <script> from index.html — check the script tags." >&2
  rm -f "$tmp"
  exit 1
fi

if ! err=$(node --check "$tmp" 2>&1); then
  echo "SYNTAX ERROR in the inline <script> of index.html:" >&2
  # macOS resolves /var to /private/var, so match on the basename instead of $tmp.
  printf '%s\n' "$err" | sed "s|[^ ]*$(basename "$tmp")|index.html (inline script)|g" >&2
  echo "Fix this before pushing — a push to main deploys straight to production (CLAUDE.md rule 8)." >&2
  rm -f "$tmp"
  exit 1
fi

rm -f "$tmp"
exit 0
