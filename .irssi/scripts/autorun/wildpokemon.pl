# Put in ~/.irssi/scripts

use Irssi;
use strict;
use vars qw($VERSION %IRSSI); 
$VERSION = "0.1";
%IRSSI = (
    authors	=> "Jari Vetoniemi",
    name	=> "Wild Pokemon",
    description	=> "Replace JOIN with 'Wild <username> appears!' and PART with 'Wild <username> fainted!",
    license	=> "GPLv2 or later",
    url		=> "http://irssi.org/",
);

sub msg_join {
  my ($server, $channel, $nick) = @_;
  $server->print( $channel, "%B-%n!%B-%G Wild %Y$nick %Gappears!", MSGLEVEL_CLIENTCRAP);
  Irssi::signal_stop();
}

sub msg_part {
  my ($server, $channel, $nick) = @_;
  $server->print( $channel, "%B-%n!%B-%G Wild %Y$nick %Gfainted!", MSGLEVEL_CLIENTCRAP);
  Irssi::signal_stop();
}

Irssi::signal_add( {	'message join' => \&msg_join,
			'message part' => \&msg_part	} );
