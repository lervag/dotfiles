$print_type = 'pdf';
$pdf_mode = 1;
$pdf_previewer = 'start okular';
push @generated_exts, "synctex.gz";
push @generated_exts, "spl";
push @generated_exts, "nav";
push @generated_exts, "snm";
push @generated_exts, "tdo";
$latex = 'latex --src-specials %O %S';
$pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode --shell-escape %O %S';