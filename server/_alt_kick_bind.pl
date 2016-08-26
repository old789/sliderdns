sub kick_bind{
my $zone=shift;
my $command=$cmd_sudo." ".$cmd_rndc." reload ".$zone;
my $errstr=&execute_cmd($command);

 &mylogger($errstr) if ($errstr);
 return;
}

