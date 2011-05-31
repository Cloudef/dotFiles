      #!/bin/python2
# -*- coding: utf-8 -*-

#   This file is part of emesene.
#
#    Emesene is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    emesene is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with emesene; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

# Deadbeef

VERSION = '0.1'

import CurrentSong
import os
import commands

class Deadbeef( CurrentSong.CurrentSong ):
   '''Deadbeef interface'''
 
   def __init__( self ):
      CurrentSong.CurrentSong.__init__( self )
      self.artist = ''
      self.title = ''
      self.album = ''
          
   def getStatus( self ):
      if os.name != 'posix':
         return ( False, _( 'This plugin only works in posix systems' ) ) #no posix here
      return ( True, 'Ok' ) #ok, run baby
    
   def isRunning( self ):
      if os.path.exists( os.path.expanduser("~/.config/deadbeef/nowPlaying") ):
         stop = commands.getoutput("cat ~/.config/deadbeef/nowPlaying | head -n8 | tail -n1")
         if stop != '1':
            return True
      return False

   def check( self ):
      if self.isRunning():
         artist = commands.getoutput("cat ~/.config/deadbeef/nowPlaying | head -n2 | tail -n1")
         title = commands.getoutput("cat ~/.config/deadbeef/nowPlaying | head -n1")
         album = commands.getoutput("cat ~/.config/deadbeef/nowPlaying | head -n3 | tail -n1")
      
      if self.artist != artist or \
         self.title != title or \
         self.album != album:
            self.artist = artist
            self.title = title
            self.album = album
            return True  

      self.artist = ''
      self.title = ''
      self.album = ''
      return False
