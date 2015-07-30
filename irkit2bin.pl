#!/usr/bin/env perl
# http://www.geocities.jp/shrkn65/remocon/panasonic_bsd.htm
use strict;
use warnings;
use utf8;
use Encode;
use Data::Dumper;
use JSON;

my $json_text = <STDIN>;
my @bufs = JSON->new()->decode($json_text);
my @data = ($bufs[0]->{data});
#print Dumper @data;
#
my $T = $data[0][0]/12 + $data[0][1]/12;
my @signal = ();
my $idx = 2;
while ( exists $data[0][$idx] &&  exists $data[0][$idx+1] ) {
	if ($data[0][$idx+1] == 65535) {
		#printf "%d,%d",  $data[0][$idx],$data[0][$idx+1];
		$idx = $data[0];
	}
	elsif ( $T/2 < $data[0][$idx+1] || $data[0][$idx+1] < 4 * $T) {
		#printf "%d,%d",  $data[0][$idx],$data[0][$idx+1];
		my $d0 =  ($data[0][$idx]   / $T);
		my $d1 =  ($data[0][$idx+1] / $T);
		my $mag = $data[0][$idx+1] / $data[0][$idx] ;
		my $sig = $mag > 3? 1 : 0;
		#printf "\t%d,%d\t%d\t%d\n",  $d0,$d1, $mag , $sig;
		@signal = (@signal , $sig);
	}
	$idx=$idx+2;
}
#print $idx;
print @signal,"\n";



