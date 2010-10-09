/*
   00-start-here-kde-fedora.js - Set launcher icon to start-here-kde-fedora
   Copyright (C) 2010 Kevin Kofler <kevin.kofler@chello.at>
   Copyright (C) 2010 Rex Dieter <rdieter@fedoraproject.org>

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.

   Portions lifted from 01-kubuntu-10.04.js:
   Harald Sitter, apachelogger@ubuntu.com 2010-04-02
   Jonathan Riddell, jriddell@ubuntu.com 2010-02-18
   Copyright Canonical Ltd, may be copied under the GNU GPL 2 or later
*/

launcherFound = false;

pids = panelIds;
for (i = 0; i < pids.length; ++i) {
  p = panelById(pids[i]);
  if (!p) continue;
  ids = p.widgetIds;
  for (j = 0; j < ids.length; ++j) {
    w = p.widgetById(ids[j]);
    if (!w || (w.type != "launcher" && w.type != "simplelauncher")) continue;
    launcherFound = true;
    if ( w.readConfig("icon", "start-here-kde") == "start-here-kde" ||
         w.readConfig("icon", "start-here-kde") == "start-here" ) {
      w.writeConfig("icon", "start-here-kde-fedora");
    }
    break;
  }
  if (launcherFound) break;
}
if (!launcherFound)
  print("No launcher found");


