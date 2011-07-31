use strict;
use Irssi;
use vars qw($VERSION %IRSSI);

$VERSION = "1.0";
%IRSSI = (
    authors     => 'Cloudef'.
    name        => 'notify.pl',
    description => 'The better notify script',
    license     => 'WTFPL',
);

Irssi::settings_add_str('notify', 'notify_icon', 'gtk-dialog-info');
Irssi::settings_add_str('notify', 'notify_time', '5000');

sub notify {
    my ($server, $summary, $message) = @_;

    $SIG{CHLD} = 'IGNORE';
    if(fork() == 0)
    {
		close(STDOUT);
		close(STDIN);
		close(STDERR);

      my(@args) = ($summary, $message);
      system('notify-send', @args);
      exit(0);
    }
}

sub print_text_notify {
    my ($dest, $text, $stripped) = @_;
    my $server = $dest->{server};


    return if (!$server || !($dest->{level} & MSGLEVEL_HILIGHT));
    my $summary = $dest->{target};
    notify($server, $summary, $stripped);
}

sub message_private_notify {
    my ($server, $msg, $nick, $address) = @_;


    return if (!$server);
    notify($server, $nick, $msg);
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
