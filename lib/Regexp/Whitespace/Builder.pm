
package Regexp::Whitespace::Builder;

use 5.008;
use strict;
use warnings;

our $VERSION = '0.001_0';

use Regexp::Whitespace::Parser ();

use constant _debug => 0;

use if _debug, DDS => 'Dump';
#use charnames ':full'; # FIXME make it conditional

sub build {
    my $self = shift;
    my $re = shift;
    my $flags = shift;
    die "flags must be 'w' in this early version" if $flags ne 'w';

    my $p = Regexp::Whitespace::Parser->new( $re );
    $p->parse;
    my $t = $p->top;
    die "could not parse $re: " . $p->error unless $t || $p->error;

    Dump( $t ) if _debug;

    # walk the RE tree doing transformations [\s] -> \s+
    my $nt = $t->convert;

    Dump( $nt ) if _debug;

    my $regex = $nt->fullstring;

    # FIXME: there's a bug here if we're using \N{named} escapes
    #   because they are replaced at compile time and
    #   would need something like eval qq{use charnames ':full'; qr/$s/}
    #
    # Instead, we should mark (TODO) there is named escapes involved
    #   and do a substitution   s/\N{([^}])}/charnames::vianame($1)/ge
    #   before mounting the regex

    if ( $regex =~ /\A [(][?]-imsx: (.*) [)] \z/sx ) { # FIXME
       #warn "# GOT";
       return qr/$1/;
    }
    #warn "# FALLBACK";
    return qr/$regex/;
}

1;
