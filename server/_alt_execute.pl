sub execute_cmd{
my $execcmd=shift;
my $exitcode=0;
my @a;

 if (open(EXE,$execcmd." 2>&1|")){
   @a=<EXE>;
   close(EXE);
   $exitcode=$?>>8;
   if ($exitcode) {
     if (defined($a[0])) { chomp($a[0]); $a[0]=" : \"".$a[0]."\"";}
     else { $a[0]="" };
     return("\"".$execcmd."\" exited with error code ".$exitcode.$a[0]);
   }
   return("");
 }
 return("Can't run \"".$execcmd."\":\"".$!."\"");
}

