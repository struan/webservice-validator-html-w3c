# $Id$

use Test::More tests => 1;

use WebService::Validator::HTML::W3C;

my $v = WebService::Validator::HTML::W3C->new(
            http_timeout    =>  10,
        );
    
ok($v, 'object created');
