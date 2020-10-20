Thanks for you interest in 2azerons, a productivity tool that turns your two Azerons into an all in one keyboard/mouse replacement!
=================Usage Instructions=======================
- Goal: make your two azerons function as shown in this google drawing diagram:
https://docs.google.com/drawings/d/1PFI0aIbMsL4FF6Snv8nXBqh_3spjvcGP_ZaFcOm-rbU/
- How-to overview:
- --- azeron-profiles.json contains profiles that you will need to load onto your Azerons. You will then run cursor.ahk and 2azerons.ahk to activate software remappings which will enable longpress and chording abilities
- How-to: detailed steps:  
- --- Part A: initial installation and setup (where you install some things on your computer and load some things on to your Azeron)
- --- --- You only have to do this part once assuming you are ok with leaving the azeron profiles loaded on to your Azerons
- --- --- 1. Make sure AHK is installed on your computer. The latest version can be found at https://www.autohotkey.com/
- --- --- 2. get the 2azerons source code (the entire folder containing this readme) on to your computer. In the steps that follow you will need to work directly with some of the files inside this folder
- --- --- 3. plug in your left (i.e. right-handed) Azeron
- --- --- 4. make sure your right (i.e. left-handed) Azeron is unplugged
- --- --- 5. launch Azeron software
- --- --- 6. import azeron-profiles.json into the Azeron software. 
- --- --- 7. in the Azeron software, select software profile "workClick" and then load it to on board memory on the Azeron 
- --- --- 8. close Azeron software
- --- --- 9. unplug the left Azeron
- --- --- 10. plug in the right Azeron
- --- --- 11. launch Azeron software
- --- --- 12. load "workCursor" onto the  Azeron, similar to step 5.  
- --- --- 13. (optional) you may now close Azeron software
- --- Part B: activate AHK remappings (where you run some autohotkey scripts and enjoy)
- --- --- to use 2azerons you will need to repeat this part at least every time you restart your computer
- --- --- 1. run cursor.ahk (as admin if possible)
- --- --- --- note: before you run cursor.ahk, your right Azeron should be plugged in with the workCursor on board profile active, and your left Azeron should be unplugged.
- --- --- 2. Move the thumbstick around to test.  It should now cause the mouse cursor to move. (pulling your right ring finger speeds up the cursor). If the cursor does not move, see troubleshooting below to get it working before proceeding.
- --- --- 3. run 2azerons.ahk (as admin if possible)
- --- --- 4. plug in the left Azeron
- --- --- 5. enjoy
- --- Part C: deactivate remapping (where you turn off 2azerons, like when you want to use your Azerons or keyboard for something else)
- --- --- note that the software remapping also affects any other keyboards you have. Although I have designed the remappings as to not drasticly interfere with using your regular keyboard, you may still notice unfamiliar behaviour on a regular keyboard if you tend to activate multiple keys at a time while typing quickly. For this reason you may want to disable software remapping at times, like when you want to type with your regular keyboard for example.
- --- --- Option I: simply press Win+Alt+comma to turn off 2azerons.ahk and leave cursor.ahk running
- --- --- --- use this option when you want to return your keyboard to normal behaviour while still leaving the thumbstick cursor control active.
- --- --- --- note that cursor.ahk will continue to remap the joystick on your right Azeron as well as your "menu" key (aka "AppsKey") and pause/break key
- --- --- --- simply run 2azerons.ahk again when you are ready to start using it again
- --- --- Option II: simply press Win+Alt+period to turn off both 2azerons.ahk and cursor.ahk
- --- --- --- Thanks for using 2azerons! Feel free to leave the profiles loaded on you Azerons and just repeat part B above whenever you are ready to use 2azerons again!

=============Troubleshooting===========
- In my experience, the mouse cursor sometimes ends up getting stuck in the upper left corner of the screen due to AHK detecting constant joystick state of X000 Y000. Or maybe you run cursor.ahk and the cursor doesn't move at all with the joystick. Either way proceed with the following.
- --- I'm not sure what the cause is, but one way to fix this is as follows:
- --- the left Azeron should be unplugged and the right one plugged in.
- --- Device Manager >> View >> Devices By Container >> Expand the tree for Azeron >> right click the "USB composite device" >> uninstall
- --- Then you can unplug  right azeron, plug back in, restart the cursor.ahk script, and it should be detecting normal resting state for joystick (i.e. X050 Y050) and responding to manipulation appropriately

===========Customization Intro============
- The remainder of this readme is aimed at giving you an understanding of how you can edit 2azerons.ahk to customize how your 2 azerons act. 

===========Customization Overview============
- longpressify.ahk is relatively set in stone and users have been given alot of customization power without the need to change this file.
- There are two recommended places for making changes to customize behaviour:
- --- Profile Level: you may be able to relocate the actions shown in 2Azerons.png by moving bindings around in the Azeron profiles. However many customizations will require you make changes on the AHK level as well.
- --- AHK Level: 2azerons.ahk works by remapping keyboard and mouse signals with complete ignorance to which physical button or which device they are coming from. Changing behaviour from that which is shown in the google drawing requires editing the source code in 2azerons.ahk in most cases. Make changes to 2azerons.ahk to redefine the shortpress and longpress actions associated with each button or chording set on your Azeron. Within this script you will reference azeron buttons by the AHK name of the keyboard or mouse action that the button is binded to in the profile level. AHK Level changes are required for most customizations. You can also define custom chording groups, modes, and mode switching button. 

============AHK Level customization kinesthetic learning resources===============
- since 2azerons.ahk is a lengthly and complex file, I have also provided a folder called "hello_world" with some educational example scripts that will help you gain a more fundamental understanding of the object oriented system of defining button behaviour in longpressify.ahk environment.
- --- these educational examples resemble 2azerons.ahk in essential structure, but the code and functionality is greatly stripped down.
- --- the example scripts only modify the behaviour of a few keys. All you need to do is find one inside the hello_world folder and run it. At the top of the code will will see a link to a diagram showing what the code does. Like 2azerons.ahk, these educational scripts also work with regular keyboards, so you dont need an Azeron to use the scripts.
- --- note that all of these example scripts, like 2azerons.ahk, consist of these 5 parts:

- --- --- 1. (optional) a helper library of functions, classes, and/or variables that are named as not to conflict with the reserved "LP_" prefix.
- --- --- 2. a global class named "LP_modes" which is properly structured as detialed in section below
- --- --- 3. an include statement referencing longpressify.ahk
- --- --- 4. a call to LP_activate(<modeName>), modeName being the name of a nested class in LP_modes
- --- --- 5. miscellaneous hotkeys at the bottom

============AHK Level customization: Theory: handlers and the state machine that calls them===============
At the heart of your ability to customize 2azerons, is the ability to associate custom handlers with buttons and chording groups (groups of buttons that can be pressed in various combinations). There are many different types of handlers (listed in this section below), and each one is called at a specific time in relation to the user's press, hold, and release of buttons. 
- What happens inside of handlers is entirely up to you. Send keystrokes, change variables, gui manipulations, etc...
- Where you define these handlers is detailed in the sections below. 
- When these handlers are called is determined by the state machines shown in the diagram linked here:
https://docs.google.com/drawings/d/1cXL_eKtvFOJAiGCwTwez9lKrTEyWbkvl_wkg0dDBrS4/

These 9 handlers can be used for stand alone buttons and chording groups:
- LP_down
- LP_shortRepeat
- LP_shortUp
- LP_held
- LP_longRepeat
- LP_longUp
- LP_enterRepeatPhase
- LP_repeat
- LP_repeatUp

These 3 handlers can also be used for chording groups:
- LP_shortOver
- LP_longOver
- LP_repeatOver
	
============AHK Level customization: structure of 2azerons.ahk from a distance========================
Inert Library
class LP_modes 
    class mode1
        class button1
	    LP_longDuration
	    LP_repeatDuration
            LP_down
            LP_shortUp
            LP_hold
            LP_longUP
            LP_repeat
            ...
        class button2
            ...
        ...
        class chordingGroup1
	    LP_Buttons
            class ooi
		LP_longDuration
		LP_repeatDuration
                LP_down
                LP_shortUp
                LP_hold
                LP_longUP
                LP_repeat
                ...
            class oio
		...
            class oii
		...
	    ...
        chordingGroup2
            class ooi
		...
            class oio
		...
            class oii
		...
	    ...
        ...
    mode2
        ...
    ...
#Include <path to longpressify.ahk>
LP_.activate(<modeName>)
Miscellaneous hotkey definitions including those for mode switching 


============AHK Level customization general overview============
- an outline of the structure of 2azerons.ahk is in the section above

- the content of 2azerons.ahk can be broken down into 5 main parts
- --- 1. the Inert Library which can contain whatever helper functions, global variables, or classes you desire. 
- --- --- to avoid overwriting anything important, do not use the prefix LP_ in any of your identifiers in the inert library section
- --- 2. LP_modes is a class definition which will contain one or more "modes", which are actually nested classes - one nested class for each mapping mode you wish to define.
- --- --- within each mode are more nested classes. Each is interpretted to describe a "behaviour paradigm" (i.e. how a single button or chording group should behave)
- --- --- --- Any nested class for which the key/property "LP_Buttons" is undefined will be interpretted to represent the behaviour you wish to define for a single stand-alone button. See section titled "defining behaviour of stand-alone button" below
- --- --- --- Any nested class for which the property "LP_buttons" (note this is distinct from "LP_button") is defined will be interpretted to represent the behaviour you wish to define for a set of buttons that can be pressed in various combinations to produce different actions. In this case LP_buttons should be an array of strings matching valid button/key names or scancodes as enumerated in the ahk keylist:  https://www.autohotkey.com/docs/KeyList.htm 
- --- --- --- The detailed structure of a chording group definition is in the section "defining behaviour of a chording group" below
- --- 3.  an include statement that references longpressify.ahk
- --- ---longpressify.ahk contains code that will interpret the behaviour definitions you make LP_modes and bring them to life.  It will define two functions- LP_activate and LP_deactive- which you can use to control on-the-fly which remapping modes are active. The script longpressify.ahk will also define many other classes, functions, and variables, all prefixed with "LP_", many of which are not explained here as you will probably never need to reference them in your code. 
- --- --- "LP_" is a reservered prefix. All the identifiers in longpressify.ahk are prefixed by "LP_". You will also need to use this prefix in specific locations in your code when necessary in order to communicate with longpressify.ahk, as detailed in later sections below.
- --- 4. One or more calls to LP_activate is necessary to specify what mode you wish to be active in the beginning. This function is defined in longpressify.ahk, hence this call(s) comes after the include statement. The function takes one input, as string, which is the name of a nested class in LP_modes, representing the mode you wish to activate.
- --- 5. Miscellaneous hotkey definitions. Here you put hotkeys used for mode control and whatever other custom hotkey definitions you want which are not well suited to being defined inside of a mode. For example, you may choose to define a simple hotkey for terminating the script.
- --- --- Control which modes are active with calls to LP_.activate and LP_.deactivate, passing one input- a string - the name of a nested class in LP_modes, representing the mode you wish to activate or deactivate.
- --- --- multiple modes can be active at the same time. This feature has only been tested in the context of mutually exlusive modes. If two modes modify one or more of the same buttons, I make no garantee as to the practicality of attempting to activate one without deactivating the other first. However, there is a mechanism in place that will automatically handle the situation where a mode is activated which modifies a button that is already held down. In this case, the mode will be activated on all other buttons but not apply to the held down button until it is released. The same waiting principle is applied to deactivation of held down buttons as well.
- The order of code parts 1-2 above is not important, but part 3-5 are expected to go in order after 1-2.
- also note that no instantiation of classes is required inside of 2azerons.ahk. It is the name, location, and content of your class definitions that allows them to be properly interpretted as button behaviour paradigms. Instantiation will be performed by longpressify.ahk, but the details of that will be covered later.


===================defining behaviour of a stand-alone button==================
- any class defintion which is nested inside a mode and does not have the key/property, LP_buttons, will be interpretted as the desired behaviour of a stand-alone button.
- You can use the name of the class to specify what button the paradigm pertains to. In this case the name of the class would be one of the following:
- --- a scan code or the name of a button/key as listed in the ahk keylist: https://www.autohotkey.com/docs/KeyList.htm (eg. "sc050" "sc046" "a" "esc" "numpad1")
- --- one of the acceptable aliases to certain buttons as enumerated in longpressify.ahk by the object LP_.buttonByAlias. These aliases are provided because many keynames in autohotkey are not valid class names. (eg. "one", "two", "forwardslash", "openbracket" as class names would be interpretted as meaning the keys "1" "2" "/" "[")
- it is also acceptable to name the class anything you want so long as the class has defined the property/key LP_button containing a string which belongs to one of the two categories above. (eg. LP_button := "a", LP_button := "sc046", LP_button := "1", "LP_button"="one")
- the class can have any properties or methods you desire as long as they do not conflict with some reserved method and properties names which are prefixed with "LP_", which include, but are not limited to the following:
- --- LP_msTillLong: specifies the number of milliseconds the user has to release the button before entering the long press phase (see LP_held and LP_longRepeat below). If the user does not define this, a default value of several hundreds will be used
- --- LP_msTillRepeat: specifies the duration, in milliseconds, of the long press phase, after which the repeat phase begins if the button has not been released (see LP_repeat below). If the user does not define this, a default value of several hundreds will be used
- --- LP_prefix: eg: "$", "*", "~". This string specifies the hotkey prefix that is to be used to control what what kind of key presses will activate the behaviour paradigm and whether or not the native behaviour of the button will be stifled. See https://www.autohotkey.com/docs/Hotkeys.htm for more details. Note that 2azerons has not been tested with modifier prefixes.
- --- the following are some of the methods you can define to specify behaviour of the button
- --- --- LP_down: called without delay on the button-down event. Only used in special circumstances
- --- --- LP_shortUp: called if button is released prior to entering the long press phase
- --- --- LP_held: called upon entering the long press phase
- --- --- LP_longUP: called if button is released in the long press or repeat phase
- --- --- LP_repeat: called if a repeat-down event fires during the repeat phase
- --- --- LP_shortRepeat: called if a repeat-down event fires prior to the long press phase
- --- --- LP_longRepeat: called if a repeat-down event fires during the long phase
- --- you can define all, some, or none of the supported handler methods. However, there are no default handlers, except for the backend ones that merely store and update information. Some examples of that information, which you may find useful in coding complex behaviour:
- --- --- LP_eventProcessor.repeatPhaseRepeats
- --- --- LP_eventProcessor.longPhaseRepeats
- --- --- LP_eventProcessor.shortPhaseRepeats
- --- the above are properties of the behaviour paradigm which are automatically updated to reflect how many repeat down events occur during each of the three phases of the button press.

============defining behaviour of a chording group================
- any class defintion which is nested inside a mode and has the key/property, LP_buttons, will be interpretted as the desired behaviour of a chording group, i.e. a set of buttons that when pressed in various combinations produce various actions.
- The structure of a chording group is a bit more layered than that of a stand-alone button. 
- the name of the class is not important.
- it should have defined the property/key, LP_buttons, which should be an array of strings matching valid button/key names or scancodes as enumerated in the ahk keylist:  https://www.autohotkey.com/docs/KeyList.htm 
- similar to stand-alone buttons detailed above, the class representing a chording group can have any properties and methods you desire as long as they do not conflict with some reserved method and properties names which are prefixed with "LP_". However one of the ways chording groups differ from stand alone buttons is that they must also contain nested classes which describe the desired behaviour of each chord you wish to define. These chord defintions will contain much of the same properties/keys and methods as stand-alone button definitions. However, one major distiction is that chords do not have LP_button defined and the name of a chord is not the name of a button. Instead, the name of a chord consists of a sequence of i's and o's, used to denote the binary representation of which buttons of the chording group make up that chord. For example, let's assume the chording group has LP_buttons=["a","s","d"], then the following are examples of how the names of nested classes would be used to denote various combinations of these three buttons:
- --- a nested class named "iii" describes the actions associated with pressing all three buttons, a,s, and d at the same time
- --- a nested class named "oii" describes the actions associated with pressing just the two buttons, s and d at the same time
- --- a nested class named "oio" describes the actions associated with pressing just the one button, s 
- --- ...
- Chording groups define LP_prefixes (array of strings) instead of LP_prefix

====================Other customization notes=======================
if you have defined button behaviour for a button on the numpad, then avoid toggling numlock while that key is held down, because doing so may cause the up event not to fire.
