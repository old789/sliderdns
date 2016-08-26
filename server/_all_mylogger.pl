sub mylogger{
 my $errm=join(" ",@_);
# print STDERR $errm."\n" if ($debug);
 setlogsock("unix");
 openlog($progname, "nowait", "user");
 syslog("err",$errm);
 closelog;
 return;
}

