# $Id: 06detailed.t,v 1.3 2003/11/17 13:17:44 struan Exp $

use Test::More tests => 6;
use WebService::Validator::HTML::W3C;

my $v = WebService::Validator::HTML::W3C->new(
            http_timeout    =>  10,
            detailed        =>  1,
        );

SKIP: {
    skip "no internet connection", 6 if -f 't/SKIPLIVE';
    skip "XML::XPath not installed", 6 if -f 't/SKIPXPATH';

    ok($v, 'object created');
    ok ($v->validate('http://exo.org.uk/code/www-w3c-validator/invalid.html'), 
            'page validated');
            
    my $err = $v->errors->[0];
    isa_ok($err, 'WebService::Validator::HTML::W3C::Error');
    is($err->line, 11, 'Correct line number');
    is($err->col, 6, 'Correct column');
    is($err->msg, qq/ end tag for "div" omitted, but OMITTAG NO was specified/,
                    'Correct message');
    
}
