sub get_ip_visible{
my $str="";
my $brct_l=0;
my $brct_r=0;
my $naddr="";

  $response=$browser->get("http://".$host_responder.":".$port_responder."/".$url_responder);
  unless ($response->is_success){
    &mylogger("Can't get answer from responder: ".$response->status_line);
    exit(1);
  }

  # extract IP
  $str=(length($response->content) > 512)?substr($response->content,0,512):$response->content;
  $str=~s/[\s\t\r\n]//g;
  if (index($str,"IPADDRESS:[") > -1){
    $brct_l=index($str,"[");
    $brct_r=index($str,"]");
    if ( ($brct_l>-1) and ($brct_r>-1) and ($brct_l < $brct_r) ){
      $ip_current=substr($str,$brct_l+1,$brct_r-$brct_l-1);
    }
  }

  # validate IP
  unless ($ip_current){
    return("IP not found");
  } elsif ($naddr=inet_aton($ip_current)){
    $ipv4++;
  } elsif ($naddr=inet_pton($ip_current)){
    $ipv6++;
  } else {
    $ip_current="";
    return("Incorrect IP");
  }
  return("");
}

