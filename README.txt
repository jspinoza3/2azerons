To use, import azeron-profiles.json into the azeron software. Load "workType" onto your left (i.e. right-handed) Azeron and "workMouse" onto your right (i.e. left-handed) Azeron. Then run longpressify.ahk and mouse.ahk

The result is your Azerons will function as shown in 2Azerons.png

=============Troubleshooting===========
In my experience, which is on Windows, the mouse cursor sometimes ends up getting stuck in the upper left corner of the screen due to AHK detecting constant joystick state of X000 Y000
I'm not sure what the cause is, but one way to fix this is as follows:
Device Manager >> View >> Devices By Container >> Expand the tree for Azeron >> right click the "USB composite device" >> uninstall
Then you can unplug azeron, plug back in, restart the AHK script, and it should be detecting normal resting state for joystick (i.e. X050 Y050) and responding to manipulation appropriately
