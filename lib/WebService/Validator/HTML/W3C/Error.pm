# $Id: Error.pm,v 1.4 2003/11/26 13:52:18 struan Exp $

package WebService::Validator::HTML::W3C::Error;

use strict;
use base qw(Class::Accessor);

__PACKAGE__->mk_accessors( qw( line col msg ) );

1;

__END__

=head1 NAME 

WebService::Validator::HTML::W3C::Error - Error messages from the W3Cs online Validator

=head1 DESCRIPTION

This is a wee internal module for WebService::Validator::HTML::W3C. It has
three methods: line, col and msg which return the line number, column number 
and the error that occured at that location in a validated page.

=head1 SEE ALSO

L<WebService::Validator::HTML::W3C>

=head1 AUTHOR

Struan Donald E<lt>struan@cpan.orgE<gt>

=cut
