Thanks for you interest in 2azerons, a productivity tool that turns your two Azerons into an all in one keyboard/mouse replacement!
=================Usage Instructions=======================
- Goal: make your two azerons function as shown in this google drawing diagram:
https://docs.google.com/drawings/d/1PFI0aIbMsL4FF6Snv8nXBqh_3spjvcGP_ZaFcOm-rbU/
- How-to overview:
- --- azeron-profiles.json contains profiles that you will need to load onto your Azerons. You will then run cursor.ahk and 2azerons.ahk to activate software remappings which will enable longpress and chording abilities
- How-to: detailed steps: 
- --- Part A: first you will need to get the source code (the entire folder containing this readme) on to your computer. 
- --- Part B: initial setup (load profiles)
- --- --- You only have to do this part once assuming you are ok with leaving the azeron profiles loaded on to your Azerons
- --- --- 1. plug in your left (i.e. right-handed) Azeron
- --- --- 2. make sure your right (i.e. left-handed) Azeron is unplugged
- --- --- 3. launch Azeron software
- --- --- 4. import azeron-profiles.json into the Azeron software. 
- --- --- 5. in the Azeron software, select software profile "workClick" and then load it to on board memory on the Azeron 
- --- --- 6. close Azeron software
- --- --- 7. unplug the left Azeron
- --- --- 8. plug in the right Azeron
- --- --- 9. launch Azeron software
- --- --- 10. load "workCursor" onto the  Azeron, similar to step 5.  
- --- --- 11. (optional) you may now close Azeron software
- --- Part C: activate AHK remappings
- --- --- to use 2azerons you will need to repeat this part at least every time you restart your computer
- --- --- 1. run cursor.ahk (as admin if possible)
- --- --- --- note: before you run cursor.ahk, your right Azeron should be plugged in and your left Azeron unplugged.
- --- --- 2. Move the thumbstick around to test.  It should now cause the mouse cursor to move. (pulling your right ring finger speeds up the cursor). If the cursor does not move, see troubleshooting below to get it working before proceeding.
- --- --- 3. run 2azerons.ahk (as admin if possible)
- --- --- 4. plug in the left Azeron
- --- --- 5. enjoy
- --- Part D: deactivate remapping when you are done using 2azerons, like when you want to use your Azerons or keyboard for something else
- --- --- note that the software remapping also affects any other keyboards you have. Although I have designed the remappings as to not drasticly interfere with using your regular keyboard, you may still notice unfamiliar behaviour on a regular keyboard if you tend to activate multiple keys at a time while typing quickly. For this reason you may want to disable software remapping at times, like when you want to type with your regular keyboard for example.
- --- --- Option A: simply press Win+Alt+, to turn off 2azerons.ahk and leave cursor.ahk running
- --- --- --- use this option when you want to return your keyboard to normal behaviour while still leaving the thumbstick cursor control active.
- --- --- --- note that cursor.ahk will continue to remap the joystick on your right Azeron as well as your "menu" key (aka "AppsKey") and pause/break key
- --- --- --- simply run 2azerons.ahk (as admin if possible) again when you are ready
- --- --- Option B: simply press Win+Alt+. to turn off both 2azerons.ahk and cursor.ahk
- --- --- --- Thanks for using 2azerons! Feel free to leave the profiles loaded on you Azerons and just repeat part C above whenever you are ready to use 2azerons again!
=============Troubleshooting===========
- In my experience, which is on Windows, the mouse cursor sometimes ends up getting stuck in the upper left corner of the screen due to AHK detecting constant joystick state of X000 Y000. Or maybe you run cursor.ahk and the cursor doesn't move at all with the joystick. Either way proceed with the following.
- --- I'm not sure what the cause is, but one way to fix this is as follows:
- --- the left Azeron should be unplugged and the right one plugged in.
- --- Device Manager >> View >> Devices By Container >> Expand the tree for Azeron >> right click the "USB composite device" >> uninstall
- --- Then you can unplug  right azeron, plug back in, restart the cursor.ahk script, and it should be detecting normal resting state for joystick (i.e. X050 Y050) and responding to manipulation appropriately
===========Customization Intro============
- customization is possible, but involves editing source code in most cases. Here are some possible customizations, ranked roughly from least to most difficult:
- --- move the action associated with a single standalone physical button (a button not connected to another by a magenta elipse in the google drawing) to a different standalone physical button. This can be done without editing source code. You just have to change the binding in the azeron software.
- --- move an entire chording group (set of buttons connected by magenta elipses in the google drawing) to a different finger that controls a congruent chording group. For example, swapping the behaviour of the left and right index finger or swapping the behaviour of any two fingers other than index fingers and thumb. This can also be achieved without editing source code.
- --- change the longpress or shortpress actions associated with any key or chord. This will require you to have some understanding of how 2azerons.ahk is arranged and the syntax that you will need to use to specify the desired actions. If you want to define complex macros, it helps to have a experience writing functions in AHK.
- --- define custom chording groups
- --- define new modes and button(s) for mode switching

===========Customization Overview============
- longpressify.ahk is relatively set in stone and users have been given alot of customization power without the need to change this file.
- There are two recommended places for making changes to customize behaviour:
- --- Profile Level: you may be able to relocate the actions shown in 2Azerons.png by moving bindings around in the Azeron profiles. However many customizations will require you make changes on the AHK level as well.
- --- AHK Level: 2azerons.ahk works by remapping keyboard and mouse signals with complete ignorance to which physical button or which device they are coming from. Changing behaviour from that which is shown in the google drawing requires editing the source code in 2azerons.ahk in most cases. Make changes to 2azerons.ahk to redefine the shortpress and longpress actions associated with each button or chording set on your Azeron. Within this script you will reference azeron buttons by the AHK name of the keyboard or mouse action that the button is binded to in the profile level. AHK Level changes are required for most customizations

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
