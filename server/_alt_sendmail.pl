sub send_mail {
my($from,$to,$subj,$message)=@_;
my $mailprog = '/usr/sbin/sendmail';

 open(MAIL,"|$mailprog -t") || return;
 print MAIL "To: $to\n";
 print MAIL "From: $from\n";
 print MAIL "Mime-Version: 1.0\n";
 print MAIL "Content-Type: text/plain; charset=koi8-r\n";
 print MAIL "Content-Transfer-Encoding: 8bit\n";
 print MAIL "Subject: $subj\n\n";
 print MAIL $message;
 close (MAIL);
 return;
}

