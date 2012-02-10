# Put in ~/.irssi/scripts

use Irssi;
use strict;
use vars qw($VERSION %IRSSI);
$VERSION = "0.1";
%IRSSI = (
   authors     => "Jari Vetoniemi",
   name        => "Wild Pokemon",
   description => "Replace JOIN with 'Wild <username> appears!' and PART with 'Wild <username> fainted!
                   It's also possible to edit the theme style for QUITS/JOINS/PARTS, if you don't want script.",
   license     => "GPLv2 or later",
   url         => "http://irssi.org/",
);

sub msg_join {
   my ($server, $channel, $nick) = @_;
   $server->print( $channel,    " %m            * %K|%W %B-%n!%B-%G Wild %Y$nick %Gappears!", MSGLEVEL_JOINS);
   Irssi::signal_stop();
}

sub msg_part {
   my ($server, $channel, $nick, $address, $reason) = @_;
   if($reason) {
      $server->print( $channel, " %m            * %K|%W %B-%n!%B-%G Wild %Y$nick %Gfainted! %W[$reason]", MSGLEVEL_PARTS);
   } else {
      $server->print( $channel, " %m            * %K|%W %B-%n!%B-%G Wild %Y$nick %Gfainted!", MSGLEVEL_PARTS);
   }
   Irssi::signal_stop();
}

sub msg_quit {
   my ($server, $nick, $address, $reason) = @_;
   foreach my $channel ($server->channels())
   {
      if($channel->nick_find($nick))
      {
         msg_part($server, $channel->{name}, $nick, $address, $reason);
      }
   }
   Irssi::signal_stop();
}

Irssi::signal_add( {    'message join'          => \&msg_join,
                        'message part'          => \&msg_part,
                        'message quit'          => \&msg_quit,
                   } );
