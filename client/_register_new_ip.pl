sub register_new_ip{
my $ip_new=shift;

 $browser->credentials($host_alterer.':'.$port_alterer, 'sliderdns access', $http_user => $http_passw);
 $response=$browser->get("http://".$host_alterer.':'.$port_alterer.'/'.$url_alterer.'?hostname='.$my_fullhostname.'&ip='.$ip_new);
 unless ($response->is_success){
   return("Can't get answer from alterer: ".$response->status_line);
 }else{
   $last_change=time();
 }
return("");
}

