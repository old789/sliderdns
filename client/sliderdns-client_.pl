#!/usr/bin/perl -w

use strict;
use utf8;
use open qw(:std :utf8);
use Socket;
#use Net::Interface;
use IO::Interface::Simple;
use Sys::Syslog qw(:DEFAULT setlogsock);
require LWP::UserAgent;

#--------------------------------------------------------------------
#                     Настройки
#
#  имя хоста
my $my_host='atom';
#  домен, в котором живет хост
my $my_domain='zz.km.ua';
#  hostname, порт и URL по которому отвечает страница, отдающая IP
my $host_responder='ns.zz.km.ua';
my $port_responder=80;
my $url_responder='';
#  hostname, порт и URL, по которому отвечает скрипт, изменяющий DNS
my $host_alterer='ns.zz.km.ua';
my $port_alterer=80;
my $url_alterer='cgi-bin/sliderdns-altering.cgi';
#  имя пользователя и пароль на доступ к скрипту
my $http_user='slider';
my $http_passw='deh0burd';
# хост имеет "серый IP"
my $private_addr=0;
#  TTL DNS зоны
my $zone_ttl=300;
#  каталог, в котором будет храниться файл состояния
my $state_file_dir='/tmp/';
#
#                  Настройки завершены
#--------------------------------------------------------------------

my $debug=1;
my $silent=0;
my $last_change=0;
my $need_update=0;
my $errstr="";
my $ip_current="";
my $ip_prev="";
my $ip_dns="";
my $ip_intf="";
my $ipv4=0;
my $ipv6=0;
my $response="";
my $my_fullhostname=$my_host.'.'.$my_domain;
my $state_file=$state_file_dir.'sliderdns.'.$my_fullhostname;
my $browser=LWP::UserAgent->new;
my $progname=(($_=rindex($0,"/"))<0)?$0:substr($0,($_+1));

  unless ($private_addr){
    # determine my ip by default route
    &mylogger($errstr) if (($errstr=&get_ip_intf) ne "");

    # check private network
    unless ( &check_ip($ip_intf,"192.168.0.0",16) and
             &check_ip($ip_intf,"172.16.0.0",12)  and
             &check_ip($ip_intf,"10.0.0.0",8) ){
      $private_addr++;
      &mylogger("Private IP (RFC 1918) detected: ".$ip_intf) if ($debug);
      $ip_intf="";
    }
  }

  if ( !$private_addr and $ip_intf ){
    $ip_current=$ip_intf;
  }else{
    # determine my external-visible ip by responder
    &mylogger($errstr) if (($errstr=&get_ip_visible) ne "");
    &mylogger("Answer from responder: ".$ip_current) if ($debug);
  }

  &byebye("Unknown IP, shit happens...") unless ( $ip_current or $ip_intf );

  # read my previously ip from state-file
  &mylogger($errstr) if (($errstr=&read_state) ne "");
  &mylogger("Previously IP not known") unless ($ip_prev);

  if ($ip_current ne $ip_prev){
    $need_update++;
  }elsif ( (time()-$zone_ttl) >= $last_change ){
    # resolving current DNS record
    if ($ip_dns=gethostbyname($my_fullhostname)){
      $ip_dns=inet_ntoa($ip_dns);
    }
    $need_update++ if ($ip_current ne $ip_dns);
  }

  if ($need_update) {
    &byebye($errstr) if (($errstr=&register_new_ip($ip_current)) ne "");
    &mylogger("Update DNS: host ".$my_fullhostname." is assigned ip address ".$ip_current);
    &byebye($errstr) if (($errstr=&write_state) ne "");
  }
  exit;

#---------------------------------------------------

