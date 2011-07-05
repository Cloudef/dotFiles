##
## Put me in ~/.irssi/scripts, and then execute the following in irssi:
##
##       /load perl
##       /script load notify
##


use strict;
use Irssi;
use vars qw($VERSION %IRSSI);


$VERSION = "0.01";
%IRSSI = (
    authors     => 'Luke Macken, Paul W. Frields',
    contact     => 'lewk@csh.rit.edu, stickster@gmail.com',
    name        => 'notify.pl',
    description => 'Use libnotify to alert user to hilighted messages',
    license     => 'GNU General Public License',
    url         => 'http://lewk.org/log/code/irssi-notify',
);


Irssi::settings_add_str('notify', 'notify_icon', 'gtk-dialog-info');
Irssi::settings_add_str('notify', 'notify_time', '5000');

sub notify {
    my ($server, $summary, $message) = @_;


    # Make the message entity-safe
    my $cmd = "EXEC - notify-send" .
        " -i " . Irssi::settings_get_str('notify_icon') .
        " -t " . Irssi::settings_get_str('notify_time') .
        " -- \"" . $summary . "\"" .
        " \"" . $message . "\"";


    $server->command($cmd);
}

sub print_text_notify {
    my ($dest, $text, $stripped) = @_;
    my $server = $dest->{server};


    return if (!$server || !($dest->{level} & MSGLEVEL_HILIGHT));
    $stripped =~ s/[^a-zA-Z0-9 öäÖÄ.,!?\@:\>\-']//g;
    my $summary = $dest->{target};
    notify($server, $summary, $stripped);
}


sub message_private_notify {
    my ($server, $msg, $nick, $address) = @_;


    return if (!$server);
    $msg =~ s/[^a-zA-Z0-9 öäÖÄ.,!?\@:\>\-']//g;
    notify($server, "Private message from ".$nick, $msg);
}


sub dcc_request_notify {
    my ($dcc, $sendaddr) = @_;
    my $server = $dcc->{server};


    return if (!$dcc);
    notify($server, "DCC ".$dcc->{type}." request", $dcc->{nick});
}


Irssi::signal_add('print text', 'print_text_notify');
Irssi::signal_add('message private', 'message_private_notify');
Irssi::signal_add('dcc request', 'dcc_request_notify');
