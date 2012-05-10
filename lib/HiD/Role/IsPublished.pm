package HiD::Role::IsPublished;
# ABSTRACT: Role to be consumed by classes that are published during processing
use Moose::Role;
use namespace::autoclean;

use File::Basename  qw/ fileparse /;
use HiD::Types;
use Path::Class     qw/ file /;

requires 'publish';

=attr basename ( ro / isa = Str / lazily built from input_filename

=cut

has basename => (
  is      => 'ro',
  isa     => 'Str' ,
  lazy    => 1 ,
  builder => '_build_basename',
);

sub _build_basename {
  my $self = shift;
  my $ext = '.' . $self->ext;
  return fileparse( $self->input_filename , $ext );
}

=attr dest_dir ( ro / isa = HiD_DirPath / required )

The path to the directory where the output_filename will be written.

=cut

has dest_dir => (
  is       => 'ro' ,
  isa      => 'HiD_DirPath' ,
  required => 1 ,
);

=attr ext ( ro / isa = HiD_FileExtension / lazily built from filename )

The extension on the input filename of the consuming object.

=cut

has ext => (
  is      => 'ro' ,
  isa     => 'HiD_FileExtension' ,
  lazy    => 1 ,
  default => sub {
    my $self = shift;
    my( $extension ) = $self->input_filename =~ m|\.([^.]+)$|;
    return $extension;
  },
);

=attr input_filename ( ro / isa = HiD_FilePath / required )

The path of the consuming object's file. Required for instantiation.

=cut

has input_filename => (
  is       => 'ro' ,
  isa      => 'HiD_FilePath' ,
  required => 1 ,
);

=attr input_path ( ro / isa = HiD_DirPath / lazily built from input_filename )

=cut

has input_path => (
  is      => 'ro' ,
  isa     => 'HiD_DirPath' ,
  lazy    => 1 ,
  default => sub {
    my $self = shift;
    my( undef , $path ) = fileparse( $self->input_filename );
    return $path;
  },
);

=attr output_filename

Path to the file that will be created when the C<write> method is called.

=cut

has output_filename => (
  is      => 'ro' ,
  isa     => 'Str' ,
  lazy    => 1 ,
  default => sub {
    my $self = shift;

    my $url = $self->url;
    $url .= 'index.html' if $url =~ m|/$|;

    return file( $self->dest_dir , $url )->stringify;
  },
);

=attr source ( ro / isa = Str )

Same as 'source' in HiD.pm. Normally shouldn't need to be provided...

=cut

has source => (
  is      => 'ro' ,
  isa     => 'Str' ,
  default => '' ,
);

=attr url ( ro / isa = Str / lazily built from output_filename and dest_dir )

The URL to the output path for the written file.

=cut

has url => (
  is      => 'ro' ,
  isa     => 'Str' ,
  lazy    => 1 ,
  builder => '_build_url' ,
);

no Moose::Role;
1;
