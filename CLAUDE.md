# cerro — image gallery

Static single-page gallery over a third-party photo API. No build step, no
dependencies, no test suite. Local dir is `~/Work/fotiar`, repo is
`braianj/cerro`, production is https://braianj.github.io/cerro/.

## Architecture

Everything lives in `index.html` (~1900 lines): markup, `<style>`, and one
inline `<script>`. There is no bundler, no package.json, no node_modules.
Editing this file IS editing the whole app.

Rough layout of the file:

| Section | What's there |
|---|---|
| `<style>` | All CSS, including the responsive grid and `.portrait` handling |
| markup | Filter bar, color palette, gallery container, modal |
| script: state | Globals (`currentImages`, `favorites`, `imageColors`, `perPage`) |
| script: helpers | `escapeHtml`, `safeSetItem` |
| script: URL | `getUrlParams`, `updateUrlParams`, `applyUrlParams` |
| script: data | `fetchImages`, `fetchPhotographers`, `loadAllTags`, `loadFavorites` |
| script: color | `buildColorSummary`, `extractImageColors`, `filterByColor`, `applyCustomColor` |
| script: render | `displayImages`, `openModal`, `updatePagination` |

## External services

Two third-party hosts, neither one ours. We cannot change their behavior,
their CORS headers, or what they sanitize.

1. **`api1.foti.ar`** — the photo API. POST, no auth, no API key. Supplies
   images, photographer names, tags and EXIF.
2. **CORS proxies** (`corsproxy.io`, `api.allorigins.win`) — proxy image bytes
   so canvas can read pixels for the color filter; the S3 bucket sends no CORS
   headers (verified 2026-08-05: 200 without `Access-Control-Allow-Origin`,
   OPTIONS 403). `PROXY_BUILDERS` is a fallback chain with retry/backoff —
   corsproxy.io alone rate-limited (429) under real usage. Every URL sent
   through a proxy is visible to that service.

## Hard rules

1. **Treat every API response as untrusted.** `api1.foti.ar` is not ours and
   we do not know what it sanitizes on input. Any value from it that reaches
   `innerHTML` must go through `escapeHtml()`. Prefer `textContent` when the
   value is the entire content of a node.
2. **Never write to `localStorage` directly.** Use `safeSetItem()`. The
   favorites cache stores whole image objects and can hit the ~5MB quota;
   a raw `setItem` throws and kills the calling function.
3. **Optional-chain into API objects.** `photographerData`, `exifData` and
   `Dimensions` are missing on some records. `image.photographerData.name`
   without `?.` is a crash waiting for the right photo.
4. **Do not re-add eager color analysis.** Color extraction runs only on
   explicit user action: `filterByColor()`, `applyCustomColor()`, opening one
   photo in the modal (single image), or `searchEntireRange()` (the "whole
   range" button — capped at `RANGE_SEARCH_MAX`, stoppable, aborted by any
   filter/tab/page change via `stopRangeSearch()`). It used to run on every
   `img.onload`, which pushed up to 1000 image URLs per page load through
   corsproxy.io. A `?color=` URL param counts as user action. The custom
   filter persists across pagination and re-applies per page.
5. **One deploy workflow only.** `.github/workflows/static.yml` owns the
   `pages` concurrency group. A second workflow on the same group makes both
   race on every push.
6. **No `pull_request` trigger on the deploy workflow.** With `pages: write`
   it would publish PR content to the live site.
7. **The workflow publishes an explicit file list**, not the repo root. If a
   new asset must ship, add it to the `Build site` step in `static.yml`.
   Nothing else in the repo reaches the public site.
8. **Pushing to `main` is deploying.** There is no staging, no branch
   protection and no CI that validates anything. The push IS the release.

## Verifying a change

There is no lint, no typecheck and no tests. Substitute:

```bash
# JS syntax of the inline script (the only automated check available)
sed -n '/<script>/,/<\/script>/p' index.html | sed '1d;$d' > /tmp/cerro-check.js
node --check /tmp/cerro-check.js

# Serve locally and click through
python3 -m http.server 8000
```

Manual pass before any push: gallery loads, tab switch to favorites and back,
open the modal and arrow through it, apply one color filter, reload with query
params in the URL. Watch the browser console for errors the whole time.

## Pitfalls

- **Line numbers drift.** The file is one 1900-line blob; anchor edits on
  function names, not line numbers.
- **`updateColorCounts()` counts the persisted cache**, not the current page,
  so swatch badges can exceed what is on screen. Known, not a regression.
- **The color cache format is v4**: `{c: [categories], p: [[r,g,b,permille]]}`.
  `p` holds dominant colors (>= 2% of area) plus small saturated accents
  grouped by hue band (>= 0.05%). The accents are what make a jacket findable
  in a snow photo — do not raise that floor without re-running the ground
  truth test. Bumping `COLOR_CACHE_VERSION` wipes every user's cache.
- **Custom color search is AND semantics**: with several hex values, a photo
  must contain all of them. `parseColorInput` handles one color,
  `parseColorList` handles the list; the URL uses comma-joined hex in
  `?color=` plus `&tol=`.
- **Cache writes are debounced** (`scheduleSaveColorCache`, 2s): a direct
  `saveColorCache()` per result is O(n²) when the range search analyzes
  thousands of photos. Proxy network errors are NOT cached (`err: true`
  entries) so a transient failure doesn't stick as "gris" forever.
- **`perPage` default is 100.** It was 1000. Options up to 5000 still exist in
  the select; they are slow and hammer the API.
- **The watermark-removal button** (`openWatermarkRemover`) opens a third-party
  site with a copy of the image URL. It carries legal exposure on a public repo
  under a real name. Flag it before extending it, do not quietly grow it.
- **`.DS_Store`** is gitignored but present on disk. Leave it out of commits.

## Git

- Commits: `<type>: <summary>`, single line, no attribution trailers.
- Commits are GPG-signed (`commit.gpgsign=true` globally).
- Remote is SSH. Never switch it to HTTPS.
