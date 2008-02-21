
use strict;
use warnings;

use Clone;

package Regexp::Whitespace::Parser;

our $VERSION = '0.001_0';

use YAPE::Regex qw( Regexp::Whitespace::Parser );

package Regexp::Whitespace::Parser::Element;

our @ISA;

BEGIN {
  push @ISA, qw( Clone );
}

sub convert {
    # clone by default
    return shift->clone;
}

package Regexp::Whitespace::Parser::container;

sub convert {
    my $self = shift;
    my $clone = $self->clone(1); # shallow copy
    my @content = map { $_->convert } @{$self->{CONTENT}};
    $clone->{CONTENT} = \@content;
    return $clone;
}

# register this package into @ISA of container types
{
    my @container_types = qw( cut lookahead lookbehind group capture );
    no strict 'refs';
    for my $type (@container_types) {
        unshift @{ 'Regexp::Whitespace::Parser::' . $type . '::ISA' }, __PACKAGE__;
    }
}

package Regexp::Whitespace::Parser::exact;

sub convert {
    my $self = shift;
    my $exact = $self->exact_text;

    # are there ocurrences of \s ?
    if ( $exact =~ /\s/ ) {
        my @pieces;

        if ( length $exact > 1 ) {
            # note: only 'text' types need this loop,
            #  being the only one whose exact text may have
            #  a length greater than 1

            # assertions
            die "panic: quantity modifier should not present for multi-character text" if $self->quant;
            die "panic: non-greedy modifier should not present for multi-character text" if $self->ngreed;

            LOOP : {
                if ( $exact =~ / \G \z /xgc ) {
                    last LOOP;
                }
                if ( $exact =~ / \G \s+ /xgc ) {
                    # replace matches of /\s+/ with a macro '\s+'
                    push @pieces, Regexp::Whitespace::Parser::macro->new( 's', '+', '' );
                    redo LOOP;
	        }
                if ( $exact =~ / \G (\S+) /xgc ) {
	            push @pieces, Regexp::Whitespace::Parser::text->new( $1, '', '' );
                    redo LOOP;
                }
            }
        } else {
           # FIXME: these conversion rules needs checking
           #   s is any char that matches /\s/
           # s      becomes   \s+
           # s?     becomes   \s*
           # s*     becomes   \s*
           # s{0}   becomes   \s*
           # s{0,N} becomes   \s*
           # s{M,N} becomes   \s+
           # s+     becomes   \s+
           # 
           # the non-greedy flag is kept (don't know if that's correct)
           my ($q, $ng) = ($self->quant, $self->ngreed);
           my $nq = ( $q =~ /\A ( [?*] | [{]0 ) /x ) ? '*' : '+';
           return Regexp::Whitespace::Parser::macro->new( 's', $nq, $ng );

           # TODO: some tests would be nice
        }

        return @pieces;

    } else {
        # no needed conversion
        return $self->clone;
    }
}

# register this package into @ISA of exact types
{
    my @exact_types = qw( text oct hex slash ctrl named ); # ?! utf8hex
    no strict 'refs';
    for my $type (@exact_types) {
        unshift @{ 'Regexp::Whitespace::Parser::' . $type . '::ISA' }, __PACKAGE__;
    }
}

package Regexp::Whitespace::Parser::text;

sub exact_text {
    return shift->{TEXT};
}

package Regexp::Whitespace::Parser::oct;

sub exact_text {
    return chr oct(shift->{TEXT});
}

package Regexp::Whitespace::Parser::hex;

sub exact_text {
    return chr hex(shift->{TEXT});
}

#package ...::utf8hext; # FIXME wait for new release of YAPE::Regex

package Regexp::Whitespace::Parser::slash;

my %known_sequences = (
   't' => "\t",
   'n' => "\n",
   'r' => "\r",
   'a' => "\a",
   'f' => "\f",
   'b' => "\b",
   'e' => "\e",
);

sub exact_text {
    my $t = shift->{TEXT};
    return $known_sequences{$t} || $t;
}

package Regexp::Whitespace::Parser::ctrl;

sub exact_text {
    my $t = shift->{TEXT};
    return chr( ord(uc $t) ^ 0x40 );
}

package Regexp::Whitespace::Parser::named;

sub exact_text {
    require charnames;
    return charnames::vianame(shift->{TEXT});
}


1;

