use strict;
use warnings;

use Test::Tester 0.08;
use Test::More;

use Test::Deep qw( cmp_deeply );
use Test::Deep::Filter qw( filter );

our $TODO;

can_ok( 'main', qw( filter cmp_deeply ) ) or $TODO = "Method not declared";

my ( $premature, @results ) = check_test(
  sub {
    cmp_deeply( "Hello", filter( sub { $_ }, "Hello" ), "Identity passthrough comparsion test" );
  },
  {

  }
);
note explain $premature, \@results;

done_testing;
