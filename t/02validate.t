# $Id$

use Test::More tests => 7;

use WebService::Validator::HTML::W3C;

my $v = WebService::Validator::HTML::W3C->new( );

ok($v, 'Object created');

is($v->validator_uri(), 'http://validator.w3.org/check', 'correct default validator uri');

SKIP: {
    skip "no internet connection", 5 if -f "t/SKIPLIVE";
    
    my $r = $v->validate('http://exo.org.uk/code/www-w3c-validator/valid.html');

    unless ($r) {
        if ($v->validator_error eq "Could not contact validator")
        {
            skip "failed to contact validator", 5;
        }
    }

    ok($r, 'validates page');
    ok($v->is_valid, 'page is valid');
    is($v->num_errors, 0, 'no errors in valid page');
    is($v->errors, undef, 'no information on errors returned');
    is($v->uri, 'http://exo.org.uk/code/www-w3c-validator/valid.html', 'uri correct');
}
