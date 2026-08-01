---
name: ship-to-production
description: Use before pushing cerro to main or when changing .github/workflows/static.yml. A push to main deploys straight to https://braianj.github.io/cerro/ with no CI, no staging and no branch protection, so this checklist is the release gate.
---

# Shipping cerro

Rule 8: the push IS the release. Nothing runs between `git push` and the live
site except the deploy workflow, which does not validate anything.

## When to use

Before any `git push` to `main`, and for any edit to
`.github/workflows/static.yml`.

## Pre-push checklist

1. **Syntax of the inline script:**

   ```bash
   sed -n '/<script>/,/<\/script>/p' index.html | sed '1d;$d' > /tmp/cerro-check.js
   node --check /tmp/cerro-check.js
   ```

2. **Browser pass** on `python3 -m http.server 8000`: gallery, favorites tab
   round-trip, modal navigation, one color filter, a reload carrying query
   params. Console clean.

3. **Review the diff for the invariants** that have no automated check:
   unescaped API values in `innerHTML`, direct `localStorage.setItem`, eager
   color analysis. See the `edit-gallery` skill.

4. **Confirm nothing private is about to ship.** The workflow publishes an
   explicit file list (rule 7), so a stray note in the repo root is safe from
   the public site but still public on GitHub — the repo itself is public.

5. Commit single-line, `<type>: <summary>`, no attribution trailers.

## Touching the workflow

`.github/workflows/static.yml` is the only deploy workflow and owns the `pages`
concurrency group.

- Do not add a second workflow on that group (rule 5) — they race on every push.
- Do not add a `pull_request` trigger (rule 6) — with `pages: write` a PR would
  publish to the live site.
- To ship a new asset, add it to the `Build site` step (rule 7). Files not
  copied into `_site/` never reach production.

## After pushing

```bash
gh run list --repo braianj/cerro --limit 3
```

Expect exactly one run per push. Two runs means a second workflow came back.
