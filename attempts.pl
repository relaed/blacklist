#!/usr/bin/perl
#
# Prints user attempts to trade from blacklisted networks
#
##

use strict;
require 'IPv4Addr.pm';

my $blacklist_filename = 'blacklist.txt';
my $net_descr = 'unknown';

if ( $#ARGV + 1 != 1 ) {
	print "Usage $0 <ip to check>\n";
	exit 1;
}

my $ip_to_check = $ARGV[0];

open(BLACKLIST, "<$blacklist_filename") || die("Could not open file $blacklist_filename");
while (<BLACKLIST>) {
	chomp;
	if ( m/^#\s+(.*)/ ) {
		# comment - use for network description
		$net_descr = $1;
	} elsif ( m/^\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}\/(16|24|32)/ ) {
		my $isInRange = Network::IPv4Addr::ipv4_in_network($_, $ip_to_check);		
		if ( $isInRange ) {
			print("$ip_to_check found in $net_descr\n");
			exit 1;
		}
	}
}
close(BLACKLIST);

exit 0;
