# $Id: 06detailed.t,v 1.1 2003/11/11 22:49:12 struan Exp $

use Test::More tests => 3;
use WebService::Validator::HTML::W3C;

my $v = WebService::Validator::HTML::W3C->new(
            http_timeout    =>  10,
            detailed        =>  1,
        );

ok($v, 'object created');
ok ($v->validate('http://exo.org.uk/code/www-w3c-validator/invalid.html'), 
        'page validated');
        
my $val_err = [ { 
                    line    => 11, 
                    col     => 6, 
                    msg     => qq/ end tag for "div" omitted, but OMITTAG NO was specified/ 
                }, 
                { 
                    line    => 9, 
                    col     => 0, 
                    msg     => qq/ start tag was here/ 
                } ];

is_deeply($v->errors, $val_err, 'correct error returned');
