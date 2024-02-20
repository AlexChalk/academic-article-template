# Academic Article Template

## Useful comands:

### Export bibliography
```bash
papis --clear-cache
papis export --all --format json | jq 'map(.id = .ref)' > bibliography.json
```
### Generate unused biblatex file for lsp integration:
```bash
pandoc bibliography.json --from csljson --to biblatex --standalone --output bibliography.bib --verbose
```

### "microsoft-word-style" wordcount:
```bash
pdftotext article.pdf - | sed 's/•//' | sed --regexp-extended 's/^[[:digit:]]+[[:space:]]*$//' | wc --words
```

### Misc
```bash
latexmk article.tex
rm *.aux ; rm *.bbl ; rm *.blg ; rm *.ccf ; rm *.fdb_latexmk ; rm *.fls ; rm *.log ; rm *.out ; rm *.synctex.gz
```

### Relevant projects:
- https://github.com/papis/papis
- https://github.com/citation-style-language
- https://github.com/citation-style-language/schema
- https://github.com/zepinglee/citeproc-lua
- https://github.com/jgm/pandoc
- https://gitlab.freedesktop.org/poppler/poppler
- https://tug.org/texlive
