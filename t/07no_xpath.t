# $Id: 07no_xpath.t,v 1.2 2003/11/25 15:16:18 struan Exp $

use Test::More tests => 3;

BEGIN {
    SKIP: {
        skip "no Test::Without::Module", 3, if -f 't/SKIPWITHOUT';

        require Test::Without::Module;
        import Test::Without::Module qw( XML::XPath );

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
                    
            ok(!$v->errors(), 'no errors returned if no XML::XPath');
            
        } 
    }
}
