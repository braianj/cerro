---
name: edit-gallery
description: Use when changing index.html in the cerro gallery — adding a filter, touching the modal, rendering any field that comes from api1.foti.ar, or working with favorites/color caching in localStorage. Covers the invariants that have no automated check behind them.
---

# Editing index.html

The whole app is one file with no build, no linter and no tests. Nothing will
catch a mistake for you except the syntax hook and your own browser pass.

## When to use

Any edit to `index.html`.

## When NOT to use

Changes to `.github/workflows/` — see `ship-to-production` instead.

## Steps

1. **Locate by function name, not line number.** The file is ~1900 lines and
   every edit shifts them. `grep -n "function displayImages" index.html`.

2. **If the change renders API data, escape it.** Rule 1. Every value from
   `api1.foti.ar` (`photographerData.name`, `tags`, `exifData.*`) that lands in
   `innerHTML` goes through `escapeHtml()`. If the value is the whole content
   of a node, use `textContent` and skip the template literal:

   ```js
   node.textContent = value;                          // preferred
   node.innerHTML = `<b>Tag:</b> ${escapeHtml(tag)}`; // when markup is needed
   ```

3. **If the change reads an API object, optional-chain it.** Rule 3.
   `photographerData`, `exifData` and `exifData.Dimensions` are absent on some
   records. Use `image.photographerData?.name || 'Sin fotógrafo'`.

4. **If the change persists state, use `safeSetItem()`.** Rule 2. Never call
   `localStorage.setItem` directly — the favorites cache holds full image
   objects and hits the quota on large sessions.

5. **If the change touches color analysis, keep it lazy.** Rule 4. Extraction
   belongs in `filterByColor()`, on user action. Do not call
   `extractImageColors()` from `img.onload` or from `displayImages()`; that
   sends every image URL on the page to corsproxy.io.

6. **Verify.** The hook runs `node --check` automatically on save. Then:

   ```bash
   python3 -m http.server 8000   # open http://localhost:8000
   ```

   Click through: gallery loads, switch to favorites and back, open the modal
   and arrow through it, apply a color filter, reload with `?tab=favorites`.
   Console must stay clean.

## Common mistakes

- Adding a new `innerHTML` template with raw API values in it. The existing
  ones are escaped; a new one starts unescaped.
- Bumping `COLOR_CACHE_VERSION` without reason — it wipes every user's cached
  color analysis and forces a full re-proxy on next filter.
- Assuming `updateColorCounts()` reflects the current page. It counts the
  persisted cache across all pages ever viewed.
- Reintroducing a `perPage` default above 100. Rule: options up to 5000 exist
  but are slow and hit the third-party API hard.
