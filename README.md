# Academic Article Template

## Useful comands:

### Export bibliography
```bash
papis --cc # clears cache
papis export --all --format json | jq 'map(.id = .ref)' > bibliography.json
```
### Generate unused biblatex file for lsp integration:
```bash
pandoc bibliography.json -f csljson -t biblatex -s -o bibliography.bib --verbose
```

### "microsoft-word-style" wordcount:
```bash
pdftotext article.pdf - | sed 's/•//' | sed -E 's/^[[:digit:]]+[[:space:]]*$//' | wc -w
```

### Misc
```bash
latexmk article.tex
rm *.aux ; rm *.bbl ; rm *.blg ; rm *.ccf ; rm *.fdb_latexmk ; rm *.fls ; rm *.log ; rm *.out ; rm *.synctex.gz
```

### Relevant projects:
- https://github.com/papis/papis
- https://github.com/citation-style-language
- https://github.com/zepinglee/citeproc-lua
- https://github.com/jgm/pandoc
- https://gitlab.freedesktop.org/poppler/poppler
- https://tug.org/texlive
