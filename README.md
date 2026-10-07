# ron-kit.xyz

Plain HTML/CSS portfolio. No build step: what's in `site/` is the website.

```
site/
  index.html           home page  -> ron-kit.xyz/
  about/index.html     -> ron-kit.xyz/about/
  projects/index.html  -> ron-kit.xyz/projects/
  posts/index.html     -> ron-kit.xyz/posts/
  photos/index.html    -> ron-kit.xyz/photos/
  css/style.css        styling for every page
  img/                 images
wrangler.jsonc         Cloudflare hosting config (uploads only site/)
```

New page: copy `site/about/` to `site/newpage/`, edit the text, add a link in the `<nav>` of every page.

Preview locally: `python3 -m http.server 8000 -d site`, then open http://localhost:8000

Publish: `npx wrangler deploy`
