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

# Add support for pythontex
# $clean_ext .= " pythontex-files-%R/*";
# push @generated_exts, 'pytxcode';
# $pythontex = 'pythontex %O %S';
# foreach my $cmd ('latex', 'lualatex', 'pdflatex', 'xelatex' ) {
#   ${$cmd} = "internal latex_python %R %Y $cmd %O %S";
# }
# sub latex_python {
#   # Run *latex, then set pythontex rule if needed.
#   # Arguments: Root name, directory for aux files (with terminator),
#   #            latex program to run, arguments for latex.

#   my $root = shift;
#   my $dir_string = shift;
#   my $pytx_code = "$dir_string$root.pytxcode";
#   my $result_dir = $dir_string."pythontex-files-$root";
#   my $pytx_out_file = "$result_dir/$root.pytxmcr";
#   my $pytx_rule_name = "pythontex $root";
#   my $ret = system @_;
#   if ( test_gen_file( $pytx_code ) ) {
#     print "=== Pythontex being used\n";
#     if (! rdb_rule_exists( $pytx_rule_name ) ) {
#       print "=== Creating rule '$pytx_rule_name'\n";
#       rdb_create_rule( $pytx_rule_name, 'external', $pythontex, '', 1,
#         $pytx_code, $pytx_out_file, $root, 1 );
#       system "echo No file \"$pytx_out_file\". >> \"$dir_string$root.log\"";
#     }
#   }
#   return $ret;
# }

# vim: ft=perl
