# $Id: 05options.t,v 1.1 2003/11/11 22:49:12 struan Exp $

use Test::More tests => 3;
use WebService::Validator::HTML::W3C;

my $v = WebService::Validator::HTML::W3C->new(
            validator_uri   =>  'http://example.com/',
            http_timeout    =>  10,
        );

ok($v, 'object created');
is($v->validator_uri(), 'http://example.com/', 'correct uri set');
is($v->http_timeout(), 10, 'correct http timeout set');

