# $Id$

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

    my $r = $v->validate('http://exo.org.uk/code/www-w3c-validator/invalid.html');

    unless ($r) {
        if ($v->validator_error eq "Could not contact validator")
        {
            skip "failed to contact validator", 5;
        }
    }

    ok ($r, 'page validated');
            
    my $err = $v->errors->[0];
    isa_ok($err, 'WebService::Validator::HTML::W3C::Error');
    is($err->line, 11, 'Correct line number');
    is($err->col, 6, 'Correct column');
    like($err->msg, qr/end tag for "div" omitted, but OMITTAG NO was specified/,
                    'Correct message');
    
}
