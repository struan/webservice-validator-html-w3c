# $Id: W3C.pm,v 1.16 2003/11/26 14:57:39 struan Exp $

package WebService::Validator::HTML::W3C;

use strict;
use base qw( Class::Accessor );
use LWP::UserAgent;
use URI::Escape;
use WebService::Validator::HTML::W3C::Error;

__PACKAGE__->mk_accessors(
    qw( http_timeout validator_uri _http_method
      is_valid num_errors uri _content ) );

use vars qw( $VERSION $VALIDATOR_URI $HTTP_TIMEOUT );

$VERSION       = 0.02;
$VALIDATOR_URI = 'http://validator.w3.org/check';
$HTTP_TIMEOUT  = 30;

=head1 NAME

WebService::Validator::HTML::W3C - Access the W3Cs online HTML validator

=head1 SYNOPSIS

    use WebService::Validator::HTML::W3C;

    my $v = WebService::Validator::HTML::W3C->new();

    if ( $v->validate("http://www.example.com/") ) {
        if ( $v->is_valid ) {
            printf ("%s is valid\n", $v->uri);
        } else {
            printf ("%s is not valid\n", $v->uri);
            foreach $error ( $v->errors ) {
                printf("%s at line %n\n", $error->msg,
                                          $error->line);
            }
        }
    } else {
        printf ("Failed to validate the website: %s\n", $v->validate_error);
    }

=head1 DESCRIPTION

WebService::Validator::HTML::W3C provides access to the W3C's online
Markup validator. As well as reporting on whether a page is valid it 
also provides access to a detailed list of the errors and where in
the validated document they occur.

=head1 METHODS

=head2 new

    my $v = WebService::Validator::HTML::W3C->new();

Returns a new instance of the WebService::Validator::HTML::W3C object. 

There are various options that can be set when creating the Validator 
object like so:

    my $v = WebService::Validator::HTML::W3C->new( http_timeout => 20 );

=over 4

=item validator_uri

The URI of the validator to use.  By default this accesses the W3Cs validator at http://validator.w3.org/check. If you have a local installation of the validator ( recommended if you wish to do a lot of testing ) or wish to use a validator at another location then you can use this option. Please note that you need to use the full path to the validator cgi.

=item http_timeout

How long (in seconds) to wait for the HTTP connection to timeout when
contacting the validator. By default this is 30 seconds.

=back 

=cut

sub new {
    my $ref   = shift;
    my $class = ref $ref || $ref;
    my $obj   = {};
    bless $obj, $class;
    $obj->_init(@_);
    return $obj;
}

sub _init {
    my $self = shift;
    my %args = @_;

    $self->http_timeout( $args{http_timeout}   || $HTTP_TIMEOUT );
    $self->validator_uri( $args{validator_uri} || $VALIDATOR_URI );
    $self->_http_method( $args{detailed} ? 'GET' : 'HEAD' );
}

=head2 validate

    $v->validate( 'http:://www.example.com/' );

Validate a URI. Returns 0 if the validation fails (e.g if the 
validator cannot be reached), otherwise 1.

=cut

sub validate {
    my $self = shift;
    my $uri  = shift;

    return $self->validator_error("You need to supply a URI to validate")
      unless $uri;

    return $self->validator_error("You need to supply a URI scheme (e.g http)")
      unless $uri =~ m(^.*?://);

    my $uri_orig = $uri;
    my $req_uri  = $self->_construct_uri($uri);

    my $method = $self->_http_method();
    my $ua = LWP::UserAgent->new( agent   => __PACKAGE__ . "/$VERSION",
                                  timeout => $self->http_timeout );
    my $request  = new HTTP::Request( $method, "$req_uri" );
    my $response = $ua->simple_request($request);

    if ( $response->is_success )    # not an error, we could contact the server
    {

        # set both valid and error number according to response

        my ( $valid, $valid_err_num ) =
          $self->_parse_validator_response($response);
        $self->_content( $response->content() )
          if $self->_http_method() !~ /HEAD/;

        # we know the validator has been able to (in)validate if
        # $self->valid is not NULL

        if ( $valid and $valid_err_num ) {
            $self->is_valid(0);
            $self->num_errors($valid_err_num);
            $self->uri($uri_orig);
            return 1;
        }
        elsif ( !defined $valid ) {
            return $self->validator_error('Not a W3C Validator or Bad URI');
        }
        elsif ( $valid =~ /\bvalid\b/i ) {
            $self->is_valid(1);
            $self->num_errors($valid_err_num);
            $self->uri($uri_orig);
            return 1;
        }

        return $self->validator_error(
                            'Did not get a sensible result from the Validator');
    }
    else {
        return $self->validator_error('Could not contact validator');
    }
}

=head2 is_valid 

    $v->is_valid;

Returns true (1) if the URI validated otherwise 0.


=head2 uri

    $v->uri();

Returns the URI of the last page on which validation succeeded.


=head2 num_errors

    $num_errors = $v->num_errors();

Returns the number of errors that the validator encountered.

=head2 errors

    $errors = $v->errors();
    
    foreach my $err ( @$errors ) {
        printf("line: %s, col: %s\n\terror: %s\n", 
                $err-line, $err->col, $err->msg);
    }

Returns an array ref of WebService::Validator::HTML::W3C::Error objects.
These have line, col and msg methods that return a line number, a column 
in that line and the error that occurred at that point.

Note that you need XML::XPath for this to work.

=cut

sub errors {
    my $self = shift;

    return undef unless $self->num_errors();

    my @errs;

    eval { require XML::XPath; };
    if ($@) {
        warn "XML::XPath must be installed in order to get detailed errors";
        return undef;
    }

    my $xp       = XML::XPath->new( xml => $self->_content() );
    my @messages = $xp->findnodes('/result/messages/msg');

    foreach my $msg (@messages) {
        my $err = WebService::Validator::HTML::W3C::Error->new(
                                    {
                                      line => $msg->getAttribute('line'),
                                      col  => $msg->getAttribute('col'),
                                      msg  => $msg->getChildNode(1)->getValue(),
                                    }
                                    );

        push @errs, $err;
    }

    return \@errs;
}

=head2 validator_error

    $error = $v->validator_error();

Returns a string indicating why validation may not have occurred. This is not
the reason that a webpage was invalid. It is the reason that no meaningful 
information about the attempted validation could be obtained. This is most
likely to be an HTTP error

Possible values are:

=over 4

=item You need to supply a URI to validate

You didn't pass a URI to the validate method

=item You need to supply a URI with a scheme

The URI you passed to validate didn't have a scheme on the front. The 
W3C validator can't handle URIs like www.example.com but instead
needs URIs of the form http://www.example.com/.

=item Not a W3C Validator or Bad URI

The URI did not return the headers that WebService::Validator::HTML::W3C 
relies on so it is likely that there is not a W3C Validator at that URI. 
The other possibility is that it didn't like the URI you provided. Sadly
the Validator doesn't give very useful feedback on this at the moment.

=item Could not contact validator

WebService::Validator::HTML::W3C could not establish a connection to the URI.

=item Did not get a sensible result from the validator

Should never happen and most likely indicates a problem somewhere but
on the off chance that WebService::Validator::HTML::W3C is unable to make
sense of the response from the validator you'll get this error.

=back

=cut

sub validator_error {
    my $self            = shift;
    my $validator_error = shift;

    if ( defined $validator_error ) {
        $self->{'validator_error'} = $validator_error;
        return 0;
    }

    return $self->{'validator_error'};
}

=head2 validator_uri

    $uri = $v->validator_uri();
    $v->validator_uri('http://validator.w3.org/check');

Returns or sets the URI of the validator to use. Please note that you need
to use the full path to the validator cgi.


=head2 http_timeout

    $timeout = $v->http_timeout();
    $v->http_timeout(10);

Returns or sets the timeout for the HTTP request.

=cut

sub _construct_uri {
    my $self            = shift;
    my $uri_to_validate = shift;

    # creating the HTTP query string with all parameters
    my $req_uri =
      join ( '', "?uri=", uri_escape($uri_to_validate), ";output=xml" );

    return $self->validator_uri . $req_uri;
}

sub _parse_validator_response {
    my $self     = shift;
    my $response = shift;

    my $valid         = $response->header('X-W3C-Validator-Status');
    my $valid_err_num = $response->header('X-W3C-Validator-Errors');

    return ( $valid, $valid_err_num );
}
1;

__END__

=head1 OTHER MODULES

Please note that there is also an official W3C module that is part of the
L<W3C::LogValidator> distribution. However that module is not very useful outside
the constraints of that package. WebService::Validator::HTML::W3C is meant as a more general way to access the W3C Validator.

L<HTML::Validator> uses nsgmls to validate against
the W3Cs DTDs. You have to fetch the relevant DTDs and so on.

There is also the L<HTML::Parser> based L<HTML::Lint> which mostly checks for 
known tags rather than XML/HTML validity.

=head1 IMPORTANT

This module is not in any way associated with the W3C so please do not 
report any problems with this module to them. Also please remember that
the online Validator is a shared resource so do not abuse it. This means
sleeping between requests. If you want to do a lot of testing against it
then please consider downloading and installing the Validator software
which is available from the W3C. Debian testing users will also find that 
it is available via apt-get.

=head1 BUGS

While the interface to the Validator is fairly stable it may be 
updated. I will endeavour to track any changes with this module so please
check on CPAN for new versions if you find things break. Also note that this 
module is only guaranteed to work with the currently stable version of the 
validator. It will most likely work with any Beta versions but don't rely 
on it.

If in doubt please try and run the test suite before reporting bugs. 

That said I'm very happy to hear about bugs. All the more so if they come
with patches ;).

=head1 THANKS

To the various people on the code review ladder mailing list who 
provided useful suggestions.

=head1 SUPPORT

author email or via http://rt.cpan.org/.

=head1 AUTHOR

Struan Donald E<lt>struan@cpan.orgE<gt>

L<http://www.exo.org.uk/code/>

=head1 COPYRIGHT

Copyright (C) 2003 Struan Donald. All rights reserved.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

perl(1).

=cut

