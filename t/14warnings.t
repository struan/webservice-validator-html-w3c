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

    my $r = $v->validate('http://exo.org.uk/code/www-w3c-validator/warning.html');

    unless ($r) {
        if ($v->validator_error eq "Could not contact validator")
        {
            skip "failed to contact validator", 5;
        }
    }

    ok ($r, 'page validated');
            
    my $err = $v->warnings->[0];
    isa_ok($err, 'WebService::Validator::HTML::W3C::Warning');
    is($err->line, undef, 'Correct line number');
    is($err->col, undef, 'Correct column');
    like($err->msg, qr/Unable to Determine Parse Mode/,
                    'Correct message');
    
}
