# $Id: 03invalid.t,v 1.1 2003/11/11 22:49:12 struan Exp $

use Test::More tests => 4;
use WebService::Validator::HTML::W3C;

my $v = WebService::Validator::HTML::W3C->new();

ok ($v, 'object created');
ok ($v->validate('http://exo.org.uk/code/www-w3c-validator/invalid.html'), 'page validated');
ok (!$v->is_valid, 'page is not valid');
is ($v->num_errors, 2, 'correct number of errors');
