# $Id: Error.pm,v 1.2 2003/11/24 21:50:32 struan Exp $

package WebService::Validator::HTML::W3C::Error;

use strict;
use base qw(Class::Accessor);

__PACKAGE__->mk_accessors( qw( line col msg ) );

1;

