
use Test::More no_plan => 1; # FIXME

use ok( 'Regexp::Whitespace' );

{
  my $qr = Regexp::Whitespace->new( 'a b c', 'w' );
  # like( 'a b c', $qr ); does not work because Test::More
  #   thinks $qr must be converted to string first
  ok( 'a b c' =~ $qr, 'works with " "' );
  ok( 'a  b  c' =~ $qr, 'works with two spaces' );
  ok( "a\nb\nc" =~ $qr, 'works with newlines' );
  ok( "a    \t b   \t\n   c" =~ $qr, 'works with spaces, tabs, and newlines' );
  ok( "a bc" !~ $qr, 'requires at least one space' );
  ok( "a\rb\fc" =~ $qr, "copes with \\r and \\f too" );

  # TODO: more, see http://search.cpan.org/~rgarcia/perl-5.10.0/pod/perlrecharclass.pod#White_space

}

{
  my $qr = Regexp::Whitespace->new( '(a b c)', 'w' );
  # like( 'a b c', $qr ); does not work because Test::More
  #   thinks $qr must be converted to string first
  ok( 'a b c' =~ $qr, 'works with " " in capture' );
  ok( 'a  b  c' =~ $qr, 'works with two spaces in capture' );
  ok( "a\nb\nc" =~ $qr, 'works with newlines in capture' );
  ok( "a    \t b   \t\n   c" =~ $qr, 'works with spaces, tabs, and newlines in capture' );
  ok( "a bc" !~ $qr, 'requires at least one space in capture' );
  ok( "a\rb\fc" =~ $qr, "copes with \\r and \\f too in capture" );

  # TODO: more, see http://search.cpan.org/~rgarcia/perl-5.10.0/pod/perlrecharclass.pod#White_space

}

{
  my $qr = Regexp::Whitespace->new( 'a b c', 'w' );
  is( $qr->to_s, '/a b c/w', 'stringification ok' );
  is( $qr->_re_string, qr/a\s+b\s+c/ . '', '/a b c/w converts ok' );
}

{
  my $qr = Regexp::Whitespace->new( ' ', 'w' );
  is( $qr->_re_string, qr/\s+/ . '', '/ /w converts ok' );
}

{
  my $qr = Regexp::Whitespace->new( "\t", 'w' );
  is( $qr->_re_string, qr/\s+/ . '', '/\t/w converts ok' );
}

{
  my $qr = Regexp::Whitespace->new( "\n", 'w' );
  is( $qr->_re_string, qr/\s+/ . '', '/\n/w converts ok' );
}

{
  my $qr = Regexp::Whitespace->new( "\f", 'w' );
  is( $qr->_re_string, qr/\s+/ . '', '/\f/w converts ok' );
}

{
  my $qr = Regexp::Whitespace->new( '\r', 'w' );
  is( $qr->_re_string, qr/\s+/ . '', '/\r/w converts ok' );
}

{
  my $qr = Regexp::Whitespace->new( '\012', 'w' );
  is( $qr->_re_string, qr/\s+/ . '', '/\012/w converts ok' );
}

{
  my $qr = Regexp::Whitespace->new( '\x0A', 'w' ); # \n
  is( $qr->_re_string, qr/\s+/ . '', '/\x0A/w converts ok' );
}

{
  my $qr = Regexp::Whitespace->new( '\x0C', 'w' ); # \f
  is( $qr->_re_string, qr/\s+/ . '', '/\x0C/w converts ok' );
}

# TODO: utf8 escapes \x{}

{
  my $qr = Regexp::Whitespace->new( '\cI', 'w' ); # \t
  is( $qr->_re_string, qr/\s+/ . '', '/\cI/w converts ok' );
}

{
  my $qr = Regexp::Whitespace->new( '\cJ', 'w' ); # \n
  is( $qr->_re_string, qr/\s+/ . '', '/\cI/w converts ok' );
}

{
  my $qr = Regexp::Whitespace->new( '\cL', 'w' ); # \f
  is( $qr->_re_string, qr/\s+/ . '', '/\cI/w converts ok' );
}

{
  my $qr = Regexp::Whitespace->new( '\cM', 'w' ); # \r
  is( $qr->_re_string, qr/\s+/ . '', '/\cM/w converts ok' );
}

# TODO /\cA/w

# TODO: named escapes
#{
#  use charnames ':full';
#  my $qr = Regexp::Whitespace->new( '\N{LINE FEED (LF)}', 'w' ); # \r
#  is( $qr->_re_string, qr/\s+/ . '', '/\N{LINE FEED (LF)}/w converts ok' );
#}

{
  my $qr = Regexp::Whitespace->new( 'a  b', 'w' );
  is( $qr->_re_string, qr/a\s+b/ . '', '/a  b/w converts ok' );
}



