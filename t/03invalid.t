# $Id: 03invalid.t,v 1.2 2003/11/11 23:15:08 struan Exp $

use Test::More tests => 4;
use WebService::Validator::HTML::W3C;

my $v = WebService::Validator::HTML::W3C->new();

SKIP: {
    skip "no internet connection", 4 if -f 't/SKIPLIVE';

    ok ($v, 'object created');
    ok ($v->validate('http://exo.org.uk/code/www-w3c-validator/invalid.html'), 'page validated');
    ok (!$v->is_valid, 'page is not valid');
    is ($v->num_errors, 2, 'correct number of errors');
}
