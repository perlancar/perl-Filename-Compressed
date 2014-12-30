package Filename::Compressed;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(check_compressed_filename);
#list_compressor_suffixes

our %SUFFIXES = (
    '.Z'   => {name=>'NCompress'},
    '.gz'  => {name=>'Gzip'},
    '.bz2' => {name=>'Bzip2'},
    '.xz'  => {name=>'XZ'},
);

our %SPEC;

$SPEC{check_compressed_filename} = {
    v => 1.1,
    summary => 'Check whether filename indicates being compressed',
    description => <<'_',


_
    args => {
        filename => {
            schema => 'str*',
            req => 1,
            pos => 0,
        },
        # recurse?
        # ci?
    },
    result_naked => 1,
    result => {
        schema => ['any*', of=>['bool*', 'hash*']],
        description => <<'_',

Return false if no compressor suffixes detected. Otherwise return a hash of
information, which contains these keys: `compressor_name`, `compressor_suffix`,
`uncompressed_filename`.

_
    },
};
sub check_compressed_filename {
    my %args = @_;

    my $filename = $args{filename};
    $filename =~ /(\.\w+)\z/ or return 0;
    my $suffix = $1;
    my $spec = $SUFFIXES{$1} or return 0;
    (my $ufilename = $filename) =~ s/\.\w+\z//;

    return {
        compressor_name       => $spec->{name},
        compressor_suffix     => $suffix,
        uncompressed_filename => $ufilename,
    };
}

1;
# ABSTRACT:

=head1 SYNOPSIS

 use Filename::Compressed qw(check_compressed_filename);
 my $res = check_compressed_filename(filename => "foo.txt.gz");
 if ($res) {
     printf "File is compressed with %s, uncompressed name: %s\n",
         $res->{compressor_name},
         $res->{uncompressed_filename};
 } else {
     print "File is not compressed\n";
 }

=head1 DESCRIPTION


=head1 TODO

=head1 SEE ALSO

L<Filename::Archive>

=cut
