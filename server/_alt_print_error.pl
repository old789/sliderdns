sub print_error{
my ($code,$short_message,$message)=@_;

print <<END_OF_HTML;
Status: $code $short_message
Content-type: text/html

<HTML>
<HEAD><TITLE>$code $short_message</TITLE></HEAD>
<BODY>
  <H1>Error</H1>
  <P>$message</P>
</BODY>
</HTML>
END_OF_HTML
}

