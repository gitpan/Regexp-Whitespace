
package Regexp::Whitespace;

use 5.008;
use strict;
use warnings;

our $VERSION = '0.001_0';
our @ISA;

BEGIN {
  @ISA = qw( Regexp );
}

use Regexp::Whitespace::Builder ();

use Attribute::Memoize;
use Scalar::Util qw( refaddr );

use overload 
    '""'     => \&to_s,
    fallback => 1;

sub new {
    my $self = shift;
    my $proto = ref $self || $self;
    my $qr = $self->_factory->build(@_);
    my $s = "$qr";
    bless $qr, $proto;
    $qr->raw( qq{/$_[0]/w} ); # FIXME
    $qr->_re_string( $s ); # FIXME
    return $qr;
}

sub _factory :Memoize {
    return 'Regexp::Whitespace::Builder';
}

{
    # FIXME an incomplete inside-out approach
    my %raw_of;
    my %string_of; # I am using this because I could not
                   # invoke the default Regexp stringification
                   # after blessing
    sub raw {
        my $self = shift;
        if ( @_ ) {
            $raw_of{refaddr $self} = shift;
        }
        return $raw_of{refaddr $self};
    }
    # the stringfication of the underlying regex
    sub _re_string {
        my $self = shift;
        if ( @_ ) {
            $string_of{refaddr $self} = shift;
        }
        return $string_of{refaddr $self};
    }
    # FIXME: needs DESTROY
}

sub to_s {
    return shift->raw;
}


#sub import {
#    use overload;
#
#    overload::constant
#      qr => sub {
#          my ($raw) = @_;
#          ...
#      };
#}

1;
