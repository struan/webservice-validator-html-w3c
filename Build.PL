use strict;
use Module::Build;

# Much logic stolen from WWW::Mechanize Makefile.PL
# the theory here is that we're looking for a connection and if it's
# not there then we skip a whole load of tests. We could ask the user
# but I figure on not doing that as I'm trying to avoid any interactivity
my $skiplive = 0;

require IO::Socket;
my $s = IO::Socket::INET->new(PeerAddr => "www.google.com:80",
                  Timeout  => 10,
                 );
if ($s) {
    close($s);
    $skiplive = 0;
} else {
    $skiplive = 1;
} # failed connect

my $filename = "t/SKIPLIVE";
if ( $skiplive ) {
    open( F, ">$filename" ) or die "Can't create $filename";
    close F;
} else {
    unlink $filename;
}

$filename = "t/SKIPXPATH";
eval { require XML::XPath; };
if ($@) {
    open( F, ">$filename" ) or die "Can't create $filename";
    close F;
    print <<EOT
    
XML::XPath is not installed. This means that you will not be able to 
access the full functionality of this module. However should you install
XML::XPath at a later date this functionality will become available

EOT
            
} else {
    unlink $filename;
}


Module::Build
    ->new(
        module_name =>  "WebService::Validator::HTML::W3C",
        license     =>  'perl',
        requires    =>  {
                            'Class::Accessor'   =>  0,
                            'LWP' =>  '0',
                        },
        build_requires  =>  {
                                'Test::More'    =>  0,
                            },
         )
    ->create_build_script;
