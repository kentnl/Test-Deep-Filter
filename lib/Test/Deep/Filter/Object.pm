use 5.006;    # our
use strict;
use warnings;

package Test::Deep::Filter::Object;

# ABSTRACT: Internal plumbing for Test::Deep::Filter

# AUTHORITY

our $VERSION = '0.001002';

use parent 'Test::Deep::Cmp';

=method C<init>

  my $object = Test::Deep::Filter::Object->new( $filter, $expected_structure );

=cut

sub init {
  my ( $self, $filter, $expected ) = @_;
  $self->{ __PACKAGE__ . '_filter' }   = $filter;
  $self->{ __PACKAGE__ . '_expected' } = $expected;
  return;
}

=method C<filter>

  my $filter_sub = $object->filter;

=method C<expected>

  my $expected = $object->expected;

=cut

## no critic ( RequireArgUnpacking, RequireFinalReturn )
sub filter   { $_[0]->{ __PACKAGE__ . '_filter' } }
sub expected { $_[0]->{ __PACKAGE__ . '_expected' } }
## use critic

=method C<descend>

  my $result = $object->descend( $got );

=cut

sub descend {
  my ( $self, $got ) = @_;
  delete $self->{ __PACKAGE__ . '_error' };
  my $return;
  {
    local $@ = undef;
    $return = eval { local $_ = $got; $self->filter->($got) };
    if ( defined $@ and length $@ ) {
      $self->{ __PACKAGE__ . '_error' } = $@;
      return 0;
    }
  }
  require Test::Deep;
  return Test::Deep::wrap( $self->expected )->descend($return);    ## no critic (ProhibitCallsToUnexportedSubs)
}

=method C<diagnostics>

  my $diagnostics = $object->diagnostics($where, $last_exp);

=cut

sub diagnostics {
  my ( $self, $where, $last_exp ) = @_;
  return $self->{ __PACKAGE__ . '_error' } if exists $self->{ __PACKAGE__ . '_error' };
  return $self->expected->diagnostics( $where, $last_exp );
}
1;

