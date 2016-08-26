sub get_ip_intf{
my $cmd_line="netstat -rn";
my $gateway="";
my $str="";
my $intf="";
my @o=();
my @f=();
my @ifs=();
my $bip="";
my $ip="";
my $bitmask="";

 # get IP of default gateway
 return("Can't run \"".$cmd_line."\" : \"".$!."\"") unless (open(DFR,$cmd_line." |"));
 @o=<DFR>;
 close(DFR);
 foreach $str (@o){
   next if ( (index($str,"default")!=0) and (index($str,"0.0.0.0")!=0) );
   chomp($str);
   $gateway = (split(/\s+/,$str))[1];
   last;
 }
 return("Default route not found") unless ($gateway);
 # determine IP interface for default gateway
 #@ifs = Net::Interface->interfaces();
 @ifs = IO::Interface::Simple->interfaces;
 foreach $intf (@ifs) {
 #  if ($bip=$intf->address(AF_INET)){
 #    $ip=inet_ntoa($bip);
 #    $bitmask=Net::Interface::mask2cidr($intf->netmask(AF_INET));
    if ( ($bip=$intf->address) and $intf->is_running ) {
     $bitmask=&net2bit($intf->netmask);
     #print $intf->name." ".$ip."/".$bitmask."\n";
     push(@f,$ip) unless (&check_ip($gateway,$ip,$bitmask));
   }
 }
 return("Default interface not found") unless (scalar(@f));
 if (scalar(@f) > 1) {
   &mylogger("Multiple default interfaces") ;
 }else{
   $ip_intf=$f[0];
 }
 return("");
}

