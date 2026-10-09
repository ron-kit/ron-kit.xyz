# ron-kit.xyz

Simple portfolio: pages are written in Markdown (`.md`, built with pandoc) or Typst (`.typ`, built with Typst's experimental HTML export).

```
content/             pages, in Markdown
  index.md           -> ron-kit.xyz/
  about.typ          -> ron-kit.xyz/about/
  projects.md        -> ron-kit.xyz/projects/
  posts.md           -> ron-kit.xyz/posts/
  photos.md          -> ron-kit.xyz/photos/
  posts/hello.md     -> ron-kit.xyz/posts/hello/
static/              copied as-is: css/, img/, fonts/
template.html        menu + footer wrapped around every page
build.sh             content/ + static/ -> site/
site/                generated output (not in git)
wrangler.jsonc       Cloudflare hosting config (uploads site/)
```

Every page starts with a title for the browser tab:

```
---
title: About · Ron
---
```

Raw HTML works anywhere in a `.md` file. Math (`$x^2$`) works too.

Typst pages set their tab title and heading like this:

```typst
#set document(title: "About · Ron")
#title[About]
```

In Typst, link images with `#html.img(src: "/img/x.jpg", alt: "...")`. Plain `#image(...)` embeds the whole file into the page.
Files starting with `_` (e.g. `content/_lib.typ`) are not built, so you can keep shared Typst code there.

New menu section: add `content/name.md` and a link in the `<nav>` of `template.html`.

Preview locally: `./build.sh && python3 -m http.server 8000 -d site`, then open http://localhost:8000

Publish: `npx wrangler deploy` (runs `build.sh` first)
