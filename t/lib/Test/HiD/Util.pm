use strict;
use warnings;
use 5.010;

package Test::HiD::Util;

use File::Temp qw/ tempfile tempdir /;
use HiD::Layout;
use HiD::Page;
use HiD::Post;
use Template;

use Exporter 'import';
our @EXPORT_OK = qw/ make_layout make_page make_post /;

sub make_layout {
  my( %arg ) = @_;

  state $template = Template->new( ABSOLUTE => 1 );

  my( $fh , $file) = tempfile( SUFFIX => '.html' );
  print $fh $arg{content};
  close( $fh );

  my $layout_args = {
    filename  => $file ,
    processor => $template ,
  };
  $layout_args->{layout} = $arg{layout} if $arg{layout};

  return HiD::Layout->new( $layout_args );
}

sub make_page {
  my( %arg ) = @_;

  state $input_dir = tempdir();
  state $dest_dir  = tempdir();

  my $file = join '/' , $input_dir , $arg{file};

  open( my $OUT , '>' , $file ) or die $!;
  print $OUT $arg{content};
  close( $OUT );

  return HiD::Page->new({
    dest_dir       => $dest_dir,
    input_filename => $file ,
    layouts        => $arg{layouts} ,
    source         => $input_dir,
  });
}

1;
