# $Id$

use Test::More tests => 6;

use WebService::Validator::HTML::W3C;

my $v = WebService::Validator::HTML::W3C->new(
            http_timeout    =>  10,
        );
    
ok($v, 'object created');

ok($v->validate( { file => 't/valid.html' } ), 'validated valid file');
ok($v->is_valid(), 'valid file is valid');

ok( $v->validate( { file => 't/invalid.html' } ), 'validated invalid file');
ok( !$v->is_valid(), 'invalid file is invalid' );
is( $v->num_errors(), 2, 'correct number of errors');
