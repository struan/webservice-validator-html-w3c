# $Id: 06detailed.t 41 2004-05-09 13:28:03Z struan $

use Test::More tests => 6;
use WebService::Validator::HTML::W3C;

my $v = WebService::Validator::HTML::W3C->new(
            validator_uri   =>  'http://qa-dev.w3.org/wmvs/HEAD/check',
            http_timeout    =>  10,
            detailed        =>  1,
            output          =>  'soap12',
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
    like($err->msg, qr/end tag for "div" omitted, but OMITTAG NO was specified/,
                    'Correct message');
    
}
