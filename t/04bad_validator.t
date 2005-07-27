# $Id$

use Test::More tests => 12;

use WebService::Validator::HTML::W3C;

my $v = WebService::Validator::HTML::W3C->new( validator_uri => 'http://exo.org.uk/cgi-bin/cgi-test.cgi');

ok($v, 'object created');

ok(!$v->validate(), 'fails with no uri passed');
is($v->validator_error(), 'You need to supply a URI to validate',
    'you need to supply a uri error');
ok(!$v->validate('exo.org.uk/'), 'fails if no URI scheme');
is($v->validator_error(), 'You need to supply a URI scheme (e.g http)',
    'you need to supply a scheme error');
is($v->validator_uri, 'http://exo.org.uk/cgi-bin/cgi-test.cgi', 
    'correct validator uri');

SKIP: {
    skip "no internet connection", 2 if -f 't/SKIPLIVE';
    
    ok(!$v->validate('http://exo.org.uk/code/www-w3c-validator/valid.html'), 
        'validation fails');
    is($v->validator_error, 'Not a W3C Validator or Bad URI', 
        'not a W3C validator error');
}

ok($v->validator_uri('http://doa.example.com/'), 'validator address changed');
is($v->validator_uri, 'http://doa.example.com/', 'correct validator uri');

ok(!$v->validate('http://exo.org.uk/code/valid.html'), 'validation fails');
is($v->validator_error, 'Could not contact validator', 
    'validator unreachable error');
