#!/bin/bash
set -u

branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
dirty=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')

cat <<EOF
cerro — branch: $branch | uncommitted files: $dirty | live: https://braianj.github.io/cerro/

  - Pushing to main deploys to production immediately. No CI, no staging (rule 8).
  - index.html is the entire app. No build, no tests. Verify in a browser.
  - api1.foti.ar is a third-party API: escapeHtml() everything it returns (rule 1).
  - Color analysis only runs on user action, never on img.onload (rule 4).
EOF

exit 0
