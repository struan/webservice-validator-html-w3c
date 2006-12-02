# $Id$

use Test::More tests => 8;

use WebService::Validator::HTML::W3C;

my $valid = qq{
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title></title>
</head>
<body>

</body>
</html>
};

my $invalid = qq{
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title></title>
</head>
<body>

<div>
    
</body>
</html>
};

my $v = WebService::Validator::HTML::W3C->new(
            http_timeout    =>  10,
        );

SKIP: {
    skip "no internet connection", 8 if -f 't/SKIPLIVE';

    ok($v, 'object created');

    ok( !$v->validate_markup(), 'fails if no markup' );
    is( $v->validator_error(), 'You need to supply markup to validate',
        'you need to supply markup error' );

    ok($v->validate_markup( $valid ), 'validated valid scalar');
    ok($v->is_valid(), 'valid scalar is valid');

    ok( $v->validate_markup( $invalid ), 'validated invalid scalar');
    ok(!$v->is_valid(), 'invalid scalar is invalid');
    is( $v->num_errors(), 1, 'correct number of errors');
}
