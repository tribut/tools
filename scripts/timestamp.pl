#!/usr/bin/perl

# add timestamp to stdin (for long-running commands or with tail), e.g.
# tail -f logfile | timestamp.pl
use POSIX qw(strftime);
while (<>) {
	my $date = strftime "[%Y-%m-%d %H:%M:%S]", localtime;
	print "$date $_";
}
