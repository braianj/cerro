# .claude — agent kit for cerro

`CLAUDE.md` at the repo root is the source of truth. This directory only adds
automation around it. Nothing here is duplicated from CLAUDE.md; rules are
cited by number (rule 1, rule 4, …).

## Layout

```
.claude/
├── README.md                       this file
├── settings.json                   registers the hooks below
├── hooks/
│   ├── pre-bash-block-destructive.sh   blocks force-push to main, hard resets,
│   │                                   and rm of index.html / .github
│   ├── post-edit-check-syntax.sh       node --check on the inline <script>
│   │                                   after every edit to index.html
│   └── session-start.sh                prints branch + the deploy warning
└── skills/
    ├── edit-gallery/SKILL.md       changing index.html without breaking it
    └── ship-to-production/SKILL.md pre-push checklist (push to main = deploy)
```

No agents. The globally installed `pr-review-toolkit:code-reviewer` plus
CLAUDE.md covers review here; a repo-local copy would not add anything.

## Why these hooks

This repo has no CI, no linter, no tests and no branch protection, and the
entire app is a single file. That combination means a bad edit reaches
production with nothing in between. The hooks are the only safety net:

- `post-edit-check-syntax.sh` is the closest thing to a build.
- `pre-bash-block-destructive.sh` guards the one file that IS the app.
- `session-start.sh` restates rule 8 every session, because it is the rule
  that costs the most when forgotten.

All hooks fail open if `jq` is missing.

## Opt-in

Per-developer overrides go in `.claude/settings.local.json` (gitignored), not
in `settings.json`.
