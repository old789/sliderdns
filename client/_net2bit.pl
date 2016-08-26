sub net2bit{
 my $netmask=shift;
 return(0) unless ($netmask =~ /(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})/);
 my $oc=unpack("B*",pack("CCCC",$1,$2,$3,$4));
 $oc =~ s/0//g;
 return(length($oc));
}

