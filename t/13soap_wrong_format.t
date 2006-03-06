# $Id: 06detailed.t 41 2004-05-09 13:28:03Z struan $

use Test::More tests => 6;
use WebService::Validator::HTML::W3C;

my $v = WebService::Validator::HTML::W3C->new(
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
            
    is($v->errors, 0, 'Returned 0 for wrong format with SOAP');
    is($v->validator_error, 'Result format does not appear to be SOAP', 'Correct error returned for wrong format with SOAP');
    $v->_output('xml');
    is($v->errors, 0, 'Returned 0 for wrong format with XML');
    is($v->validator_error, 'Result format does not appear to be XML', 'Correct error returned for wrong format with XML');
}
