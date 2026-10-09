#!/usr/bin/env bash
# Builds the website: content/ + static/ -> site/
# Pages can be Markdown (.md, via pandoc) or Typst (.typ, via Typst's HTML export).
#   content/index.md        -> site/index.html          (ron-kit.xyz/)
#   content/about.typ       -> site/about/index.html    (ron-kit.xyz/about/)
#   content/posts/hello.md  -> site/posts/hello/index.html
# Files starting with _ (e.g. content/_lib.typ) are skipped, for shared Typst code.
set -euo pipefail
cd "$(dirname "$0")"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Typst page -> HTML body -> wrapped in template.html by pandoc (raw HTML passes through untouched).
typst_page() {
  local src=$1 out=$2
  if ! typst compile --features html --format html --root . "$src" "$tmp/page.html" 2>"$tmp/err"; then
    cat "$tmp/err" >&2
    exit 1
  fi
  python3 - "$tmp" <<'PY'
import html, pathlib, re, sys
d = pathlib.Path(sys.argv[1])
page = (d / "page.html").read_text()
title = re.search(r"<title>(.*?)</title>", page, re.S)
style = re.search(r"<style>.*?</style>", page, re.S)  # Typst's CSS for math
body = re.search(r"<body>(.*)</body>", page, re.S).group(1)
(d / "title").write_text(html.unescape(title.group(1)) if title else "")
(d / "style").write_text(style.group(0) if style else "")
(d / "page.md").write_text("````````{=html}\n" + body + "\n````````\n")
PY
  pandoc "$tmp/page.md" --template template.html --output "$out" \
    --metadata title="$(cat "$tmp/title")" --variable header-includes="$(cat "$tmp/style")"
}

markdown_page() {
  pandoc "$1" --from markdown-implicit_figures --template template.html --mathjax --output "$2"
}

rm -rf site
mkdir site
cp -r static/. site/

find content \( -name '*.md' -o -name '*.typ' \) ! -name '_*' | while read -r src; do
  rel=${src#content/}
  rel=${rel%.*}
  case "$rel" in
    index | */index) out="site/$rel.html" ;;
    *) out="site/$rel/index.html" ;;
  esac
  mkdir -p "$(dirname "$out")"
  case "$src" in
    *.typ) typst_page "$src" "$out" ;;
    *.md) markdown_page "$src" "$out" ;;
  esac
done

echo "Built $(find site -name '*.html' | wc -l) pages into site/"
