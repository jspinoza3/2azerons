Usage:
1. import azeron-profiles.json into the azeron software. Load "workClick" onto your left (i.e. right-handed) Azeron and "workCursor" onto your right (i.e. left-handed) Azeron.  
2. unplug the right handed Azeron, leave the left handed Azeron plugged in
3. run mouse.ahk 
4. plug the right handed Azeron back in
5. run 2azerons.ahk 
- The result is your Azerons will function as shown in https://docs.google.com/drawings/d/1J0TGq8c7ay8VvnnXzxw-0XywEEVH48xgGWWT8ssfDr8/edit 
To exit the script, press Win+Alt+.
=============Troubleshooting===========
- In my experience, which is on Windows, the mouse cursor sometimes ends up getting stuck in the upper left corner of the screen due to AHK detecting constant joystick state of X000 Y000. Or maybe you run mouse.ahk and the cursor doesn't move with the joystick. Either way proceed with the following.
- --- I'm not sure what the cause is, but one way to fix this is as follows:
- --- Device Manager >> View >> Devices By Container >> Expand the tree for Azeron >> right click the "USB composite device" >> uninstall
- --- Then you can unplug azeron, plug back in, restart the AHK script, and it should be detecting normal resting state for joystick (i.e. X050 Y050) and responding to manipulation appropriately
===========Customization Overview============
- longpressify.ahk is relatively set in stone and users have been given alot of customization power without the need to change this file.
- There are two recommended places for making changes to customize behaviour:
- --- Profile Level: you can relocate the actions shown in 2Azerons.png by moving bindings around in the Azeron profiles. 
- --- AHK Level: make changes to 2azerons.ahk to redefine the shortpress and longpress actions associated with each button or chording set on your Azeron. within this script you will reference azeron buttons by the AHK name of the key that the button is binded to in the profile level. 
============AHK Level customization kinesthetic learning resources===============
- since 2azerons.ahk is a lengthly and complex file, I have also provided a folder called "hello_world" with some educational example scripts that will help you gain a more fundamental understanding of the object oriented system of defining button behaviour in longpressify.ahk environment.
- --- these educational examples resemble 2azerons.ahk in essential structure, but the code and functionality is greatly stripped down.
- --- the example scripts only modify the behaviour of a few keys. All you need to do is find one inside the hello_world folder and run it. Like 2azerons.ahk, they also work with regular keyboards, so you can skip the Azeron profile step. In fact you don't even need an Azeron to use the scripts.
- --- note that all of these example scripts, like 2azerons.ahk, consist of these 5 parts:

- --- --- 1. a global class named "LP_modes" which is properly structured as detialed in section below
- --- --- 2. a function named LP_getActiveMode
- --- --- 3. (optional) a helper library of functions, classes, and/or variables that are named as not to conflict with the reserved "_LP" prefix.
- --- --- 4. an include statement referencing longpressify.ahk
- --- --- 5. miscellaneous hotkeys at the bottom
============AHK Level customization general overview============
- an outline of the structure of 2azerons.ahk is in the section below

- the content of 2azerons.ahk can be broken down into 5 main parts
- --- 1. at the top of 2azerons.ahk is an include statement that references longpressify.ahk
- --- ---longpressify.ahk contains code that will process the behaviour definitions you make in 2azerons.ahk and bring them to life.
- --- --- "LP_" is a reservered prefix. All the identifiers in longpressify.ahk are prefixed by "LP_". You will also need to use this prefix in specific locations, but as long as you use it exactly as directed in the documentation, you code should work beautifully. 
- --- 2. the Inert Library which can contain whatever helper functions, global variables, or classes you desire. 
- --- --- to avoid overwriting anything important, do not use the prefix LP_ in any of your identifiers in the inert library section
- --- 3. LP_modes is a class definition which will contain one or more "modes", which are actually nested classes - one nested class for each mapping mode you wish to define.
- --- --- within each mode are more nested classes.  
- --- --- --- Any nested class extending LP_longressable will be interpretted to represent the behaviour you wish to define for a single stand-alone button
- --- --- --- Any nested class extending LP_chordingGroup will be interpretted to represent the behaviour you wish to define for a set of buttons that can be pressed in various combinations to produce different actions.
- --- 4. LP_getActiveMode is a function you define which longpressify.ahk will use to dynamically determine what remapping mode is active. This function should return a name of a nested class inside of LP_modes. Whatever name is returned, longpressify.ahk will then enforce as the active mode.
- --- 5. Miscellaneous hotkey definitions. Here you put whatever other custom hotkey definitions you want which are not well suited to being defined inside of a mode. For example, you may choose to define a simple hotkey for mode switching here, or perhaps a hotkey for terminating the script.
- The order of code parts 1-3 above is not important, but part 4-5 are expected to go at the end of your script.
- also note that no instantiation of classes is required inside of 2azerons.ahk. It is the name, location, and content of your class definitions that allows them to be properly interpretted as button behaviour paradigms. Instantiation will be performed by longpressify.ahk, but the details of that is not covered in this brief introduction.

============AHK Level customization: high level structure of 2azerons.ahk========================
Include <path to longpressify.ahk>
Inert Library
LP_getActiveMode
LP_modes 
    mode1
        button1
            LP_down
            LP_shortUp
            LP_hold
            LP_longUP
            LP_repeat
            ...
        button2
            ...
        ...
        chordingGroup1
            chord1
                LP_down
                LP_shortUp
                LP_hold
                LP_longUP
                LP_repeat
                ...
            chord2
            ...
        chordingGroup2
            chord1
            chord2
            ...
        ...
    mode2
        ...
    ...
Miscellaneous hotkey definitions
====================Other customization notes=======================
if you have defined button behaviour for a button on the numpad, then avoid toggling numlock while that key is held down, because doing so may cause the up event not to fire.
