# $Id$

use Test::More tests => 2;
eval "use HTTP::Proxy 0.16";
plan skip_all => "HTTP::Proxy required for testing proxy" if $@;

use WebService::Validator::HTML::W3C;

my $test = Test::Builder->new;

# this is to work around tests in forked processes
$test->use_numbers(0);
$test->no_ending(1);

my $p = HTTP::Proxy->new( port => 3128, max_connections => 1 );
$p->init;

my $pid = fork;
if ( $pid == 0 ) {
    $p->start;
    exit 0;
} else {
    sleep 1; # just to make proxy is started
    my $v = WebService::Validator::HTML::W3C->new( proxy => $p->url );
    ok($v->validate('http://exo.org.uk/code/www-w3c-validator/valid.html'), 'validates page');
    ok($v->is_valid, 'page is valid');
    wait;
}
