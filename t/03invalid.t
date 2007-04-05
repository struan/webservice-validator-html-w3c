# $Id$

use Test::More tests => 3;
use WebService::Validator::HTML::W3C;

my $v = WebService::Validator::HTML::W3C->new( );

SKIP: {
    skip "no internet connection", 3 if -f 't/SKIPLIVE';

    ok ($v, 'object created');

    my $r = $v->validate('http://exo.org.uk/code/www-w3c-validator/invalid.html');

    unless ($r) {
        if ($v->validator_error eq "Could not contact validator")
        {
            skip "failed to contact validator", 2;
        }
    }

    ok (!$v->is_valid, 'page is not valid');
    is ($v->num_errors, 1, 'correct number of errors');
}
