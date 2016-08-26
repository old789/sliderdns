#!/usr/bin/perl -w

use strict;
#use utf8;
#use open qw(:std :utf8);
#use POSIX;
use DNS::ZoneParse;
use Sys::Syslog qw(:DEFAULT setlogsock);

my $conf_file="/usr/local/etc/sliderdns.conf";
my $dns_dir="/etc/namedb/sliderdns/";
my $cmd_sudo="/usr/local/bin/sudo";
my $cmd_rndc="/usr/sbin/rndc";
my $from="sliderdns";
my $debug=1;

my @pairs=();
my %form=();
my $pair="";
my $name="";
my $value="";
my $ip="";
my $hostname="";
my $errstr="";
my $email="";
my $notify=0;
my $allow_modify=0;
my $user_exist=0;

my $progname=(($_=rindex($0,"/"))<0)?$0:substr($0,($_+1));

my $req_metod=exists($ENV{'REQUEST_METHOD'})?$ENV{'REQUEST_METHOD'}:"none";
my $get_query_string=exists($ENV{'QUERY_STRING'})?$ENV{'QUERY_STRING'}:"";
my $rem_addr=exists($ENV{'REMOTE_ADDR'})?$ENV{'REMOTE_ADDR'}:"";
my $user=exists($ENV{'REMOTE_USER'})?$ENV{'REMOTE_USER'}:"";

 if ($req_metod ne 'GET') {
   &print_error(405,"Not Allowed","Invalid request method");
   exit;
 }
 if ($user eq "") {
   &print_error(403,"Forbidden","Unauthorized access is prohibited");
   exit;
 }

 @pairs = split(/&/, $get_query_string);
 foreach $pair (@pairs){
   $pair =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
   ($name,$value)=split(/=/,$pair);
   $form{lc($name)} = $value;
 }

 if (exists($form{"ip"})) {
   if ($form{"ip"} =~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/){
     $ip=$form{"ip"};
   }else{
     &print_error(405,"Not Allowed","Invalid IP address");
     exit;
   }
 }
 $ip=$rem_addr unless ($ip);

 if (exists($form{"hostname"})) {
   $form{"hostname"}=lc($form{"hostname"});
   if ($form{"hostname"} =~ /^[a-z\d][a-z\d\.\-_]{1,254}$/){
     $hostname=$form{"hostname"};
   }else{
     &print_error(405,"Not Allowed","Invalid hostname");
     exit;
   }
 }
 unless ($hostname){
   &print_error(405,"Not Allowed","Unknown hostname");
   exit;
 }

 if (($errstr=&config_read) ne ""){
   &mylogger($errstr);
   &print_error(500,"Internal Server Error","Internal Server Error: ".$errstr);
   exit;
 }

 unless ($user_exist) {
   &mylogger("User ".$user." is logged in, but are not described in the configuration");
   &print_error(403,"Forbidden","Unauthorized access is prohibited");
   exit;
 }

 unless ($allow_modify) {
   &mylogger("User ".$user." was trying to change the hostname ".$hostname);
   &print_error(403,"Forbidden","Unauthorized access is prohibited");
   exit;
 }

 if ( &edit_zone() and $email and $notify ){
   &send_mail($from,$email,$hostname." changed","IP address of the hostname ".$hostname." changed to ".$ip."\n");
 }
 print <<END_OF_HTML;
Content-type: text/html

<HTML>
<HEAD><TITLE>modified</TITLE></HEAD>
<BODY>
$hostname set to $ip
</BODY>
</HTML>
END_OF_HTML

 exit;

#---------------------------------------------------

