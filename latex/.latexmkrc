$pdf_mode = 1;
$bibtex_use = 1.5;
$latex = 'latex --src-specials %O %S';
$show_time = 1;
$pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode --shell-escape %O %S';

push @generated_exts, "cb";
push @generated_exts, "cb2";
push @generated_exts, "spl";
push @generated_exts, "nav";
push @generated_exts, "snm";
push @generated_exts, "tdo";
push @generated_exts, "nmo";
push @generated_exts, "brf";
push @generated_exts, "nlg";
push @generated_exts, "nlo";
push @generated_exts, "nls";
push @generated_exts, "auxlock";
push @generated_exts, "synctex.gz";
push @generated_exts, "synctex(busy)";
push @generated_exts, "pgf-plot.*";
push @generated_exts, "run.xml";

add_cus_dep('nlo', 'nls', 0, 'nlo2nls');
sub nlo2nls {
  system("makeindex $_[0].nlo -s nomencl.ist -o $_[0].nls -t $_[0].nlg" );
}

add_cus_dep('pytxcode', 'tex', 0, 'pythontex');
sub pythontex { return system("pythontex \"$_[0]\""); }

# vim: ft=perl
