# $Id: 02validate.t,v 1.1 2003/11/11 22:49:12 struan Exp $

use Test::More tests => 6;

use WebService::Validator::HTML::W3C;

my $v = WebService::Validator::HTML::W3C->new();

ok($v, 'Object created');

is($v->validator_uri(), 'http://validator.w3.org/check', 'correct default validator uri');

ok($v->validate('http://exo.org.uk/code/www-w3c-validator/valid.html'), 'validates page');
ok($v->is_valid, 'page is valid');
is($v->num_errors, 0, 'no errors in valid page');
is($v->uri, 'http://exo.org.uk/code/www-w3c-validator/valid.html', 'uri correct');
