#!/usr/bin/env python

#========================================================================
#      Copyright 2007 Raja <rajajs@gmail.com>
#
#      This program is free software; you can redistribute it and/or modify
#      it under the terms of the GNU General Public License as published by
#      the Free Software Foundation; either version 2 of the License, or
#      (at your option) any later version.
#
#      This program is distributed in the hope that it will be useful,
#      but WITHOUT ANY WARRANTY; without even the implied warranty of
#      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#      GNU General Public License for more details.
#
#      You should have received a copy of the GNU General Public License
#      along with this program; if not, write to the Free Software
#      Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#==========================================================================

import sys
import urllib
import feedparser
from optparse import OptionParser

gmail_url = "https://mail.google.com/gmail/feed/atom"
plaincolor = 'white'
alertcolor = 'red'

###########################################################

class GmailRSSOpener(urllib.FancyURLopener):
    '''Logs on with given password and username'''
    def prompt_user_passwd(self, host, realm):
        return (username, password)

def getOptions(parser):
    """Parse the commandline arguments for options"""
    parser.add_option("-u", "--username", dest="username", default=None,
                      help="Your gmail username")
    parser.add_option("-p", "--password", dest="password", default=None,
                      help="Your gmail password")
    parser.add_option("-m", "--messages", dest="messages", default=5,
                      help="Number of messages to show, default is 5")
    parser.add_option("-l", "--length", dest="headerlength",default=3,
                      help="Number of words in mail header, default is 3")
    options, args = parser.parse_args()

    # lets do some checking
    if not options.username:
        fatalError('did not provide username')

    if not options.password:
        fatalError('did not provide password')

    try:
        messages = int(options.messages)
        headerlength = int(options.headerlength)
    except ValueError:
        fatalError('messages and headerlength should be numbers')

    if not (messages > 0 and headerlength > 0):
        fatalError('messages and headerlength should be positive numbers')

    return options.username, options.password, messages, headerlength

def fatalError(msg):
    print "^tw() Fatal Error: ", msg
    print "^cs()"
    parser.print_help()
    sys.exit(1)

def auth():
    '''The method to do HTTPBasicAuthentication'''
    opener = GmailRSSOpener()
    f = opener.open(gmail_url)
    feed = f.read()
    return feed

def showmail(feed):
    '''Parse the Atom feed and print a summary'''
    atom = feedparser.parse(feed)
    newmails = len(atom.entries)
    if newmails == 0:
        title = "^fg(%s) ^i(/home/jari/.config/dwm/blue_envelope.xpm) %02d" % (plaincolor,0)
    else:
        title = "^fg(%s) ^i(/home/jari/.config/dwm/red_envelope.xpm) %02d" % (alertcolor,newmails)

    # print the title with formatting
    print "^tw()" +title
    #clear the slave window
    print "^cs()"

    #then print the messages
    for i in range(min(messages,newmails)):

        emailtitle = atom.entries[i].title
        # show only first few words if title is too long
        if len(emailtitle.split()) > headerlength:
            emailtitle = ' '.join(emailtitle.split()[:headerlength])

        print "^fg(%s)%40s [%s]" % (plaincolor, emailtitle, atom.entries[i].author)
    else:
        print ""
        print ""
        print "Nothing here"

if __name__ == "__main__":

    print 'arg', sys.argv
    print len(sys.argv)
    if len(sys.argv) < 2:
        print sys.argv
        sys.argv = '-h'
    parser = OptionParser()
    username, password, messages, headerlength = getOptions(parser)
    feed = auth()
    showmail(feed)
