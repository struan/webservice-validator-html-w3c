use ExtUtils::MakeMaker;

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


$filename = "t/SKIPWITHOUT";
eval { require Test::Without::Module; };
if ($@) {
    open( F, ">$filename" ) or die "Can't create $filename";
    close F;
} else {
    unlink $filename;
}

WriteMakefile
  ('DISTNAME' => 'WebService-Validator-HTML-W3C',
   'VERSION' => '0.10',
   'PL_FILES' => {},
   'PREREQ_PM' => {
        'Class::Accessor' => 0,
        'LWP' => '0',
        'Test::More' => '0',

          },
  );
