# $Id: 06detailed.t 41 2004-05-09 13:28:03Z struan $

use Test::More;
use WebService::Validator::HTML::W3C;

my $test_num = 7;

if ( $ENV{ 'TEST_AUTHOR' } ) {
	 $test_num = 8;
}

plan tests => $test_num;

my $v = WebService::Validator::HTML::W3C->new(
            http_timeout    =>  10,
            detailed        =>  1,
            output          =>  'soap12',
        );

SKIP: {
    skip "XML::XPath not installed", $test_num if -f 't/SKIPXPATH';

    ok($v, 'object created');

	if ( $ENV{ 'TEST_AUTHOR' } ) {
	    my $r = $v->validate('http://exo.org.uk/code/www-w3c-validator/invalid.html');

	    unless ($r) {
	        if ($v->validator_error eq "Could not contact validator")
	        {
	            skip "failed to contact validator", 6;
	        }
	    }

	    ok ($r, 'page validated');
	} else {
		$v->num_errors( 1 );
		$v->_content( qq{<?xml version="1.0" encoding="UTF-8"?>
<env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope">
<env:Body>
<m:markupvalidationresponse env:encodingStyle="http://www.w3.org/2003/05/soap-encoding" xmlns:m="http://www.w3.org/2005/10/markup-validator">
    
    <m:uri>http://iexo.org.uk/invalid/</m:uri>
    <m:checkedby>http://validator.w3.org/</m:checkedby>
    <m:doctype>HTML5</m:doctype>
    <m:charset>utf-8</m:charset>
    <m:validity>false</m:validity>
    <m:errors>
        <m:errorcount>3</m:errorcount>
        <m:errorlist>
          
            <m:error>
                <m:line></m:line>
                <m:col></m:col>
                <m:message>The character encoding was not declared. Proceeding using windows-1252.</m:message>
                <m:messageid>html5</m:messageid>
                <m:explanation>  <![CDATA[
                      <p class="helpwanted">
      <a
        href="feedback.html?uri=http%3A%2F%2Fparkinsonsclinic.com%2F;errmsg_id=html5#errormsg"
	title="Suggest improvements on this error message through our feedback channels" 
      >&#x2709;</a>
    </p>

                  ]]>
                </m:explanation>
                <m:source><![CDATA[]]></m:source>
            </m:error>
           
            <m:error>
                <m:line>16</m:line>
                <m:col>68</m:col>
                <m:message>Changing character encoding utf-8 and reparsing.</m:message>
                <m:messageid>html5</m:messageid>
                <m:explanation>  <![CDATA[
                      <p class="helpwanted">
      <a
        href="feedback.html?uri=http%3A%2F%2Fparkinsonsclinic.com%2F;errmsg_id=html5#errormsg"
	title="Suggest improvements on this error message through our feedback channels" 
      >&#x2709;</a>
    </p>
                  ]]>
                </m:explanation>
                <m:source><![CDATA[&#60;meta http-equiv=&#34;Content-Type&#34; content=&#34;text/html; charset=utf-8&#34;/<strong title="Position where error was detected.">&#62;</strong>]]></m:source>
            </m:error>
            <m:error>
                <m:line>16</m:line>
                <m:col>68</m:col>
                <m:message>Changing encoding at this point would need non-streamable behavior.</m:message>
                <m:messageid>html5</m:messageid>
                <m:explanation>  <![CDATA[
                      <p class="helpwanted">
      <a
        href="feedback.html?uri=http%3A%2F%2Fparkinsonsclinic.com%2F;errmsg_id=html5#errormsg"
	title="Suggest improvements on this error message through our feedback channels" 
      >&#x2709;</a>
    </p>
                  ]]>
                </m:explanation>
                <m:source><![CDATA[&#60;meta http-equiv=&#34;Content-Type&#34; content=&#34;text/html; charset=utf-8&#34;/<strong title="Position where error was detected.">&#62;</strong>]]></m:source>
            </m:error>
        </m:errorlist>
    </m:errors>
    <m:warnings>
        <m:warningcount>1</m:warningcount>
        <m:warninglist>
        </m:warninglist>
    </m:warnings>
</m:markupvalidationresponse>
</env:Body>
</env:Envelope>
		});
	}
            
    my $err = $v->errors->[0];
    isa_ok($err, 'WebService::Validator::HTML::W3C::Error');
    is($err->line, undef, 'Correct line number');
    is($err->col, undef, 'Correct column');
    is($err->msgid, 'html5', 'Correct messageid' );
    like($err->msg, qr/The character encoding was not declared. Proceeding using windows-1252./,
                    'Correct message');
    like($err->explanation, qr/Suggest improvement/,
                    'Correct explanation');
    
}
