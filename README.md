# ron-kit.xyz

Plain HTML/CSS portfolio. No build step: what's in this folder is the website.

```
index.html          home page  -> ron-kit.xyz/
about/index.html    -> ron-kit.xyz/about/
projects/index.html -> ron-kit.xyz/projects/
posts/index.html    -> ron-kit.xyz/posts/
origami/index.html  -> ron-kit.xyz/origami/
css/style.css       styling for every page
img/                images
```

New page: copy `about/` to `newpage/`, edit the text, add a link in the `<nav>` of every page.

Preview locally: `python3 -m http.server 8000`, then open http://localhost:8000
