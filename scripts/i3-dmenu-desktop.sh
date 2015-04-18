$OpenBSD: patch-i3-dmenu-desktop,v 1.4 2014/07/11 15:49:58 dcoppa Exp $

commit 9b0ec8b2ae56e3a66487ac420eca236f64aa4c4c
Author: Michael Stapelberg <michael@stapelberg.de>
Date:   Fri Jul 11 09:51:05 2014 +0200

Bugfix: i3-dmenu-desktop: quote path

--- i3-dmenu-desktop.orig	Sun Jun 15 19:12:43 2014
+++ i3-dmenu-desktop	Fri Jul 11 16:49:32 2014
@@ -107,7 +107,7 @@ $xdg_data_home = $ENV{HOME} . '/.local/share' if
     ! -d $xdg_data_home;
 
 my $xdg_data_dirs = $ENV{XDG_DATA_DIRS};
-$xdg_data_dirs = '/usr/local/share/:/usr/share/' if
+$xdg_data_dirs = '${LOCALBASE}/share/' if
     !defined($xdg_data_dirs) ||
     $xdg_data_dirs eq '';
 
@@ -209,12 +209,12 @@ for my $file (values %desktops) {
 #     'evince.desktop' => {
 #         'Exec' => 'evince %U',
 #         'Name' => 'Dokumentenbetrachter',
-#         '_Location' => '/usr/share/applications/evince.desktop'
+#         '_Location' => '${LOCALBASE}/share/applications/evince.desktop'
 #       },
 #     'gedit.desktop' => {
 #         'Exec' => 'gedit %U',
 #         'Name' => 'gedit',
-#         '_Location' => '/usr/share/applications/gedit.desktop'
+#         '_Location' => '${LOCALBASE}/share/applications/gedit.desktop'
 #       }
 #   };
 
@@ -410,7 +410,7 @@ $exec =~ s/%k/$location/g;
 $exec =~ s/%%/%/g;
 
 if (exists($app->{Path}) && $app->{Path} ne '') {
-    $exec = 'cd ' . $app->{Path} . ' && ' . $exec;
+    $exec = 'cd ' . quote($app->{Path}) . ' && ' . $exec;
 }
 
 my $nosn = '';
@@ -420,7 +420,7 @@ if (exists($app->{Terminal}) && $app->{Terminal}) {
     # we need to create a temporary script that contains the full command line
     # as the syntax for starting commands with arguments varies from terminal
     # emulator to terminal emulator.
-    # Then, we launch that script with i3-sensible-terminal.
+    # Then, we launch that script with xterm.
     my ($fh, $filename) = tempfile();
     binmode($fh, ':utf8');
     say $fh <<EOT;
@@ -431,7 +431,7 @@ EOT
     close($fh);
     chmod 0755, $filename;
 
-    $cmd = qq|exec i3-sensible-terminal -e "$filename"|;
+    $cmd = qq|exec ${X11BASE}/bin/xterm -e "$filename"|;
 } else {
     # i3 executes applications by passing the argument to i3â€™s â€œexecâ€ command
     # as-is to $SHELL -c. The i3 parser supports quoted strings: When a string
@@ -472,7 +472,7 @@ notifications.
 
 The .desktop files are searched in $XDG_DATA_HOME/applications (by default
 $HOME/.local/share/applications) and in the "applications" subdirectory of each
-entry of $XDG_DATA_DIRS (by default /usr/local/share/:/usr/share/).
+entry of $XDG_DATA_DIRS (by default ${LOCALBASE}/share/).
 
 Files with the same name in $XDG_DATA_HOME/applications take precedence over
 files in $XDG_DATA_DIRS, so that you can overwrite parts of the system-wide
@@ -486,7 +486,7 @@ file respectively) by appending it to the name of the 
 want to launch "GNU Emacs 24" with the patch /tmp/foobar.txt, you would type
 "emacs", press TAB, type " /tmp/foobar.txt" and press ENTER.
 
-.desktop files with Terminal=true are started using i3-sensible-terminal(1).
+.desktop files with Terminal=true are started using xterm(1).
 
 .desktop files with NoDisplay=true or Hidden=true are skipped.