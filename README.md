
GENERALITIES
============

This is a Mage plug-in for SuperCollider.

It was compiled under Linux (Ubuntu 14.04 x64) and it works on SuperCollider 3.6.6.

Author :	Antonin Puleo - 2014

Last Update :	10-August-2014

INSTALL
=======
-----------------
 Linux (Ubuntu) :
-----------------
1.	Copy all the content of "Extensions" folder into your extension directory of SuperCollider.
	It should be :
	~/share/SuperCollider/Extensions/
	or /usr/local/share/SuperCollider/Extensions/
	or /usr/share/SuperCollider/Extensions/
	(check the Post window of SuperCollider when starting, it must be a line called "compiling dir" which indicates the path you have to use)

2.  Copy the data folder in /usr/. It contains all files you need to use correctly the Mage plug-in (voices, labels, dictionary).
	
3.	Open SuperCollider, it will automatically add Mage plug-in to its UGen's list. 
	If it was already started before copying files into Extensions folder, do a "Re-compile Class Library" in "Language" tab.

4.	Open MageExample.scd (located in Examples folder) with SuperCollider to test the plug-in.

5.	Have fun.

----------
 MAC OSX :
----------
TODO: compile it on OSX.

The steps are the same as for Linux but the extension directory of SuperCollider is slightly different, so check the Post window.
It should be :
~/Library/Application Support/SuperCollider/Extensions/
or /Library/Application Support/SuperCollider/Extensions/


