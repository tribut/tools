#!/usr/bin/perl
# vboxconvert.pl (c) 2002 felix eckhofer <felix@tribut.de>

use CGI qw(:standard);
use CGI qw/escapeHTML unescapeHTML/;
use CGI::Carp 'fatalsToBrowser';
$CGI::POST_MAX=1024 * 2048; # max 2mb

$tempbase = "/usr/local/httpd/htdocs/kunden/web255/vbox/temp";
$autovbox = "/usr/local/httpd/htdocs/kunden/web255/vbox/autovbox";
$autemp = "$tempbase/autemp";
$lockfile = "$tempbase/lockfile";
$errorfile = "$tempbase/errors";
$logfile = "$tempbase/log";
$scriptversion = "1.0";

if (param()){
    $aufile = param("aufile");
    if (!$aufile){Fehler("You did not provide any File!");}

    if (-e $lockfile){
        $NoCleanUp = "true";
        Fehler("The System is currently busy - please retry in a minute!");
    }else{
        open (LOCKFILE, ">$lockfile") || Fehler("could not open lockfile ($!)");
        print LOCKFILE "locked";
        close (LOCKFILE);
    }

    open (LOGFILE,">>$logfile") || Fehler("file open problem ($!)");
    ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst)=localtime(time);
    $mon++;
    $year = $year + 1900;  # Y2K bug fix
    if (length($min) == 1) {
        $min = "0" . $min;
    }
    print LOGFILE "$mday.$mon.$year $hour:$min - $ENV{'REMOTE_HOST'} ($ENV{'REMOTE_ADDR'}) - $aufile - $ENV{'CONTENT_LENGTH'}\n";
    close(LOGFILE);

    open(TEMPFILE, ">$autemp") || Fehler("could not open autemp ($!)");
    while (<$aufile>){
        print TEMPFILE;
    }
    close (TEMPFILE);

    if (-z $autemp){
        Fehler("File does not contain anything");
    }

    if (param("useulaw") eq 'true'){
        $finalcommand = "$autovbox -u <$autemp";
    }else{
        $finalcommand = "$autovbox <$autemp";
    }

    unlink $errorfile;
    $abc = `$finalcommand >/dev/null 2>$errorfile`;
    $the_errors = `cat $errorfile`;

    if ($the_errors){
        Fehler("autovbox had Problems processing your file - " .
            "maybe it is not a valid au-file?" .
            p . "<PRE>" . escapeHTML($the_errors) . "</PRE>");
    }else{
        print "Content-type:application/octet-stream\n";
        print "Content-Disposition:attachment;filename=temp.msg\n\n";
        print `$finalcommand`;
    }

    unlink $autemp;
    unlink $lockfile;

    exit 0;
}else{
    print header;
    print start_html('Main >> VboxConvert');
    print h1("VboxConvert - Interface to autovbox"),p,start_multipart_form,
        "The au-File: ", filefield(-name=>'aufile'),p,
        checkbox(-name=>'useulaw',-value=>'true',-label=>'Use ULAW Compression (otherwise ADPCM-4 is assumed)'),p,
        submit(-value=>'Convert'), defaults('reset'), " Please click only once!", 
        VCFooter(), end_html;
        exit 0;
}

sub Fehler{
    print header;
    print start_html('Error >> VboxConvert');
    print h1("Error");
    print p(@_);
    print VCFooter();
    print end_html;
    CleanUp();
    exit 1;
}

sub CleanUp{
    if ($NoCleanup) {return};
    unlink $autemp;
    unlink $lockfile;
}

sub VCFooter{
    my @progv = `$autovbox -v 2>&1`;
    return hr,font({-size=>"1"},"VboxConvert.pl by <a href=mailto:felix\@tribut.de>Felix Eckhofer</a>, Version $scriptversion, running @progv");
}
