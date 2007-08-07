# $Id$

use Test::More;
use WebService::Validator::HTML::W3C;

my $test_num = 5;

if ( $ENV{ 'TEST_AUTHOR' } ) {
	 $test_num = 6;
}

plan tests => $test_num;

my $v = WebService::Validator::HTML::W3C->new(
            http_timeout    =>  10,
            detailed        =>  1,
        );

SKIP: {
    skip "XML::XPath not installed", $test_num if -f 't/SKIPXPATH';

    ok($v, 'object created');

	if ( $ENV{ 'TEST_AUTHOR' } ) {
 	   my $r = $v->validate('http://exo.org.uk/code/www-w3c-validator/invalid.html');

	    unless ($r) {
	        if ($v->validator_error eq "Could not contact validator")
	        {
	            skip "failed to contact validator", 5;
	        }	
	    }
	
		ok ($r, 'page validated');
	} else {
		$v->num_errors( 1 );
		$v->_content( qq{<?xml version="1.0" encoding="UTF-8"?>
<result>                                                                        
  <meta>                                                                        
    <uri>http://exo.org.uk/code/www-w3c-validator/invalid.html</uri>            
    <modified>Sat Oct  4 14:53:18 2003</modified>                               
    <server>Apache/1.3.28 (Unix)  (Red-Hat/Linux) mod_ssl/2.8.15 OpenSSL/0.9.7a PHP/4.0.6 mod_perl/1.26 FrontPage/4.0.4.3</server>                              
    <size>256</size>                                                            
    <encoding>utf-8</encoding>                                                  
    <doctype>-//W3C//DTD XHTML 1.0 Strict//EN</doctype>                         
  </meta>                                                                       
  <warnings>                                                                    
    <warning>  &#60;em&#62;Note&#60;/em&#62;: The Validator XML support has     
  &#60;a href=&#34;http://openjade.sf.net/doc/xml.htm&#34;                      
     title=&#34;Limitations in Validator XML support&#34;&#62;some limitations&#60;/a&#62;.                                                                     
</warning>                                                                      
    <warning>      This interface is highly experimental and the output *will* change                                                                           
      -- probably even several times -- before finished. Do *not* rely on it!   
      See http://validator.w3.org:8001/docs/users.html#api-warning              
</warning>                                                                      
  </warnings>                                                                   
  <messages>                                                                    
    <msg line="11" col="6" offset="235"> end tag for &#34;div&#34; omitted, but OMITTAG NO was specified</msg>                                                  
    <msg line="9" col="0" offset="220"> start tag was here</msg>                
  </messages>                                                                   
</result>
}
		);
	}
    
            
    my $err = $v->errors->[0];
    isa_ok($err, 'WebService::Validator::HTML::W3C::Error');
    is($err->line, 11, 'Correct line number');
    is($err->col, 6, 'Correct column');
    like($err->msg, qr/end tag for "div" omitted, but OMITTAG NO was specified/,
                    'Correct message');
    
}
