sub edit_zone{
my $found=0;
my $modify=0;
my $modified=0;
my $record="";
my $msg="";

my $point=index($hostname,".");

 if ($point < 1){
   &print_error(405,"Not Allowed","Invalid hostname");
   exit;
 }

my $zone=substr($hostname,$point+1);
my $host=substr($hostname,0,$point);
my $zonefile=$dns_dir.$zone;

my $zonedata=DNS::ZoneParse->new($zonefile);
my $a_records = $zonedata->a();

 foreach $record (@$a_records) {
   if ($record->{'name'} eq $host){
     $found++;
     if ($record->{'host'} ne $ip){
       $msg="IP address of the host ".$hostname." is changed from ".$record->{'host'}." to ".$ip;
       $record->{'host'}=$ip;
       $modify++;
     }
     last;
   }
 }

 unless ($found){
   push (@$a_records, { name => $host, class => 'IN',
                        host => $ip, ttl => '', ORIGIN => $zone.'.' });
   $modify++;
   $msg="host ".$hostname." is assigned ip address ".$ip;
 }

 if ($modify){
   $zonedata->new_serial(1);
   unless (open(OU,">".$zonefile.".temp")){
     &mylogger("Can't open  file ".$zonefile." : \"".$!."\"");
   }else{
     print OU $zonedata->output();
     close(OU);
     system("cp ".$zonefile." ".$zonefile."~");
     rename($zonefile.".temp",$zonefile);
     &mylogger($msg);
     &kick_bind($zone);
     $modified++;
   }
 }
 return($modified);
}

