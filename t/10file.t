# $Id$

use Test::More tests => 8;

use WebService::Validator::HTML::W3C;

my $v = WebService::Validator::HTML::W3C->new(
            http_timeout    =>  10,
        );
    
SKIP: {
    skip "no internet connection", 8 if -f 't/SKIPLIVE';

    ok($v, 'object created');

    ok( !$v->validate_file(), 'fails if no file' );
    is( $v->validator_error(), 'You need to supply a file to validate',
        'you need to supply a file error' );

    my $r = $v->validate_file( 't/valid.html' );

    unless ($r) {
        if ($v->validator_error eq "Could not contact validator")
        {
            skip "failed to contact validator", 5;
        }
    }

    ok($r, 'validated valid file');
    ok($v->is_valid(), 'valid file is valid');

    $r = $v->validate_file( 't/invalid.html' );

    unless ($r) {
        if ($v->validator_error eq "Could not contact validator")
        {
            skip "failed to contact validator", 3;
        }
    }

    ok( $r, 'validated invalid file');
    ok( !$v->is_valid(), 'invalid file is invalid' );
    is( $v->num_errors(), 4, 'correct number of errors');
}
