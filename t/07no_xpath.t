# $Id: 07no_xpath.t,v 1.1 2003/11/25 11:43:14 struan Exp $

use Test::More tests => 3;
use WebService::Validator::HTML::W3C;

my $v = WebService::Validator::HTML::W3C->new(
            http_timeout    =>  10,
            detailed        =>  1,
        );

SKIP: {
    skip "no internet connection", 3 if -f 't/SKIPLIVE';

    ok($v, 'object created');
    ok($v->validate('http://exo.org.uk/code/www-w3c-validator/invalid.html'), 
            'page validated');
            
    *CORE::GLOBAL::require = sub { return 0; };

    ok(!$v->errors(), 'no errors returned if no XML::XPath');
    
} 
