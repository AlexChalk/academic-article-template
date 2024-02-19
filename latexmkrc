# Use LuaLaTeX for PDF generation
$pdf_mode = 4;

# Use citeproc-lua
$bibtex = "citeproc-lua %S";

# Quieter output
$lualatex = 'lualatex -interaction=batchmode -synctex=1 %O %S';
