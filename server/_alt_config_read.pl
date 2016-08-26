sub config_read{
my @row=();
my $continue=0;

 unless (open(CNF,$conf_file)){ return("Can't open config file $conf_file"); }
 while (<CNF>){
   chomp;
   if ($_ eq "") {next;}
   elsif (/^\s*\#+.*$/ ) {next;}
   elsif (/^(.+)\s+\#+.*$/ ) { @row=split(/\#/);$_=$row[0];}

   if (/^\s*username\s+(\S+).*$/) {
     if ($user eq $1){
       $continue=0;
       $user_exist++;
     }else{
       $continue=1;
     }
   }
   elsif ($continue){
     next;
   }
   elsif (/^\s*email\s+(\S+).*$/) {
     $email=$1;
   }
   elsif (/^\s*hostname\s+(\S+)\s+notify\s*.*$/) {
     if ($hostname eq lc($1)) {
       $allow_modify++;
       $notify++;
     }
   }
   elsif (/^\s*hostname\s+(\S+).*$/) {
     $allow_modify++ if ($hostname eq lc($1));
   }
   else{
     &mylogger("For user ".$user." unknown string in config:\"".$_."\"") if ($debug);
   }
 }
 close(CNF);
 return("");
}

