sub check_ip{
my ($test_ip,$test_net,$test_cidr)=@_;
my $test_p_ip="";
my $begin_ip="";
my $lennet=0;
my @b=();

 @b=split(/\./,$test_ip);
 return(1) if ( scalar(@b) != 4 );
 $test_p_ip=pack("C4",@b);
 @b=split(/\./,$test_net);
 return(1) if ( scalar(@b) != 4 );
 return(1) if (($test_cidr < 0) || ($test_cidr > 32));
 $lennet=2**(32-$test_cidr)-1;
 $begin_ip=(pack("C4",@b)) & ~(pack("N",$lennet));
 #print join(".",unpack("C4",$begin_ip))." ".$test_cidr."\n";
 return(0) if (unpack("N",$test_p_ip ^ $begin_ip) <= $lennet);
 return(1);
}

