# $Id: Error.pm,v 1.1 2003/11/21 15:32:38 struan Exp $

package WebService::Validator::HTML::W3C::Error;

use strict;

sub new {
    my $ref   = shift;
    my $class = ref $ref || $ref;
    my $obj   = {};
    bless $obj, $class;
    $obj->_init(@_);
    return $obj;
}

sub _init {
    my $self = shift;
    my %args = @_;

    $self->line( $args{line} );
    $self->col( $args{col} );
    $self->msg( $args{msg} );
}

sub line {
    my $self = shift;
    return $self->_accessor( 'line', @_ );
}

sub col {
    my $self = shift;
    return $self->_accessor( 'col', @_ );
}

sub msg {
    my $self = shift;
    return $self->_accessor( 'msg', @_ );
}

sub _accessor {
    my $self = shift;
    my ( $option, $value ) = @_;

    if ( defined $value ) {
        $self->{$option} = $value;
    }

    return $self->{$option};
}

1;

