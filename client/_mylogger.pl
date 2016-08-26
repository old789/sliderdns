sub mylogger{
 setlogsock("unix");
 openlog($progname, "nowait", "user");
 print STDERR join(" ",@_)."\n" if ($debug);
 syslog("err",join(" ",@_));
 closelog;
 return;
}

sub byebye{
 &mylogger(@_);
 if ($silent) { exit(1);}
 die(join(" ",@_)."\n");
}

