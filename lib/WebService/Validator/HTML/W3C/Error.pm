# $Id: Error.pm,v 1.3 2003/11/24 21:55:59 struan Exp $

package WebService::Validator::HTML::W3C::Error;

use strict;
use base qw(Class::Accessor);

__PACKAGE__->mk_accessors( qw( line col msg ) );

1;

=head1 NAME WebService::Validator::HTML::W3C::Error

=head1 DESCRIPTION

This is a wee internal module for WebService::Validator::HTML::W3C. It has
three methods: line, col and msg which return the line number, column number 
and the error that occured at that location in a validated page.

See the WebService::Validator::HTML::W3C Documentation for more details.

=head1 AUTHOR

Struan Donald

=cut
