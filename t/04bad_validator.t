# $Id: 04bad_validator.t,v 1.1 2003/11/11 22:49:12 struan Exp $

use Test::More tests => 12;

use WebService::Validator::HTML::W3C;

my $v = WebService::Validator::HTML::W3C->new( validator_uri => 'http://exo.org.uk/cgi-bin/cgi-test.cgi');

ok($v, 'object created');

ok(!$v->validate(), 'fails with no uri passed');
is($v->validator_error(), 'You need to supply a URI to validate',
    'you need to supply a uri error');
ok(!$v->validate('exo.org.uk/'), 'fails if no URI schema');
is($v->validator_error(), 'You need to supply a URI schema (e.g http)',
    'you need to supply a schema error');
is($v->validator_uri, 'http://exo.org.uk/cgi-bin/cgi-test.cgi', 
    'correct validator uri');
ok(!$v->validate('http://exo.org.uk/code/www-w3c-validator/valid.html'), 
    'validation fails');
is($v->validator_error, 'Not a W3C Validator or Bad URI', 
    'not a W3C validator error');

ok($v->validator_uri('http://doa.exo.org.uk/'), 'validator address changed');
is($v->validator_uri, 'http://doa.exo.org.uk/', 'correct validator uri');

ok(!$v->validate('http://exo.org.uk/code/valid.html'), 'validation fails');
is($v->validator_error, 'Could not contact validator', 
    'validator unreachable error');
