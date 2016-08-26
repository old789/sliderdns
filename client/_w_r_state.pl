sub write_state{
my $errm=shift;
my $aout="";

 return("Can't open state file ".$state_file." : \"".$!."\"") unless (open(STF,">".$state_file));
 $aout.="IPADDRESS ".$ip_current."\n";
 $aout.="LASTCHG  ".$last_change."\n";
 print STF $aout;
 close(STF);
 return("");
}

sub read_state{
my $str="";

 return("Can't open state file ".$state_file." : \"".$!."\"") unless (open(STF,$state_file));
 while($str=<STF>){
#  $str=lc($_);
   chomp($str);
   next unless ($str);
   if ($str =~ /^IPADDRESS\s+(\S+)$/) {
     $ip_prev=$1;
   }elsif ($str =~ /^LASTCHG\s+(\d+)$/) {
     $last_change=$1;
   }
   #  elsif ($str =~ /^xxx\s+(\d+)$/) {
   #  $xxx=$1;
   #}
   else{
      &mylogger("Unknown string in state file: \"".$str."\"") if ($debug);
   }
 }
 close(STF);
 return("");
}

