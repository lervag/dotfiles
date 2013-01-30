$print_type = 'pdf';
$pdf_mode = 1;
$pdf_previewer = 'start mupdf -r 95';
$pdf_update_method = 2;
$pdf_update_signal = 'SIGHUP';
$bibtex_use = 2;
push @generated_exts, "cb";
push @generated_exts, "cb2";
push @generated_exts, "spl";
push @generated_exts, "nav";
push @generated_exts, "snm";
push @generated_exts, "tdo";
push @generated_exts, "nmo";
push @generated_exts, "synctex.gz";
push @generated_exts, "tex.latexmain";
$latex = 'latex --src-specials %O %S';
$pdflatex = 'pdflatex -interaction=nonstopmode --shell-escape %O %S';
$compiling_cmd = "xdotool search --name \"%D\" set_window --name \"%D compiling...\"";
$success_cmd   = "xdotool search --name \"%D\" set_window --name \"%D OK\"";
$failure_cmd   = "xdotool search --name \"%D\" set_window --name \"%D FAILURE\"";

# vim: ft=perl
