
use strict;
use warnings;

use Regexp::Whitespace ();

# that's a simple example to extract a piece of text from
# within text samples with arbitrary spaces
# (coming from example from stripping tags of HTML files)
#
# The date position is marked around a "fixed" text
# like "date of event which ..." but spaces should be
# replaced by \s+
#
# With Regexp::Whitespace, instead of writing
# "date \s+ of \s+ event \s+ ...", the regex may look
# like simple text and the \w modifier does the magic.

my $re = q/(?imsx:
             \G \s*
                    ( .*?                        # advance until you find
                      ((?-x)date of event which requires filing of (?x: this | the )  statement)
                      .*?
                      $                          # and to the end of line
                    )
            )/;

my $qr = Regexp::Whitespace->new( $re, 'w' );

my @samples = (

q{
                                 August 31, 2007
             (Date of event which requires filing of this statement)
},

q{
                  January
                    14, 2008




                  Date
                    of Event Which Requires Filing of the
                    Statement
}

);

for my $text ( @samples ) {
    if ( $text =~ $qr ) {
        my ($piece, $literal) = ($1, $2);
        $piece =~ s/ \Q$literal\E //msx; # remove the fixed part
        $piece =~ s/ [^\w.]+ \z //msx; # remove "weird" trailing chars (like '(') 
        $piece =~ s/ \s+ / /msgx; # normalize spaces

        print "matched, date found: $piece\n";

    }
}
