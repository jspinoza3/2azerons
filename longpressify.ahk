#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#HotkeyInterval 1000  ;  (milliseconds).
#MaxHotkeysPerInterval 500
#SingleInstance force
;#InstallKeybdHook
;#InstallMouseHook
;KeyHistory
;#NoTrayIcon
;#MaxThreadsPerHotkey 100

LP_modeHeldDownFromByScanCode := {}

LP_setUp()
{
	
	for modeName, mode in LP_modes
	{

		if (mode.hasKey("__Class"))
		{
			mode := new mode
			objectKeysEncountered := {}
			modeInheritanceLayer := mode
			while(modeInheritanceLayer)
			{
				for buttonBehaviourParadigmName, buttonBehaviourParadigm in modeInheritanceLayer
				{
					if (buttonBehaviourParadigm.LP_initialize && !objectKeysEncountered[buttonBehaviourParadigmName])
					{
						(new buttonBehaviourParadigm).LP_initialize(buttonBehaviourParadigmName, modeName, mode)
					}
					objectKeysEncountered[buttonBehaviourParadigmName] := true
				}
				modeInheritanceLayer := modeInheritanceLayer.base
			}
		}

	}
}
LP_setUp()


class LP_longpressable
{
	static LP_buttonByAlias := {one:"1",two:"2",three:"3",four:"4",five:"5",six:"6",seven:"7",eight:"8",nine:"9",zero:"0",grave:"``",accent:"``",hyphen:"-",dash:"-",equal:"=",equals:"=",openbracket:"[",closebracket:"]",comma:",",period:".",forwardslash:"/",backslash:"\",semicolon:";",quote:"'"}
	LP_initialize(classname, modeName, containingClassInstance)
	{
		global LP_modeHeldDownFromByScanCode
		if (!this.hasKey("LP_button"))
		{
			if (this.LP_buttonByAlias.hasKey(classname))
				this.LP_button := this.LP_buttonByAlias[classname]
			else
				this.LP_button := classname
			
		}
		button := this.LP_button
		if (getKeyName(button)==null)
		{
			
			msgbox, ruhoh %button% appears to be not a valid button
		}	
		this.LP_modeName := modeName
		this.LP_containingClassInstance:=containingClassInstance
		;msgbox %modeName%
		this.LP_scanCode := getKeySC(button)
		LP_modeHeldDownFromByScanCode[this.LP_scanCode] := null
		this.LP_downsSinceLastPress := 0
		this.LP_downsSinceHeld := 0
		this.LP_downTime := 0
		this.LP_timer := null
		pre:=this.LP_prefix
		fn := Func("LP_HotkeyShouldFireDown").Bind(this)
		Hotkey If, % fn
		fn := Func("LP_onDown").Bind(this)
		hotkey, % pre button, % fn
		
		fn := Func("LP_HotkeyShouldFireUp").Bind(this)
		Hotkey If, % fn
		fn := Func("LP_onUp").Bind(this)
		hotkey, % pre button " up", % fn
		if (this.LP_init)
			this.LP_init()
	
			
		


	}

}



class LP_chordingGroup
{
	LP_armed := false
	LP_flags := 0
	
	
	LP_flagAsDown(p)
	{
		mask := 1 << p
		this.LP_flags:= (this.LP_flags | mask) 
		;tooltip %flags%
	}

	LP_flagAsUp(p)
	{
		mask := 1 << p
		this.LP_flags := (this.LP_flags & ~mask) 
	}
	
	
	LP_onDown(k,p)
	{
		global LP_modeHeldDownFromByScanCode
		fn:=this.LP_timer
		if (!this.LP_downStatusByButton[k])
		{
			
			if (fn)
			{
				SetTimer, %fn%, off
			}
			if(this.LP_flags==0)
			{
				for button,isDown in this.LP_downStatusByButton
				{
					sc := this.LP_scanCodes[button]
					LP_modeHeldDownFromByScanCode[sc] := this.modeName
				}
			}
			chord := this.LP_chords[this.LP_flags]
			if (chord.LP_over)
				chord.LP_over()
			this.LP_flagAsDown(p)
			this.LP_armed := true
			this.LP_downStatusByButton[k] := true
			chord := this.LP_chords[this.LP_flags]
			chord.LP_downTime := A_TickCount
			chord.LP_longLongTime := chord.LP_downTime + chord.LP_longDuration + chord.LP_repeatDuration
			fn:=ObjBindMethod(this,"LP_timeout",chord)
			this.LP_timer := fn
			longDuration := chord.LP_longDuration
			SetTimer, %fn%, -%longDuration%
			if (chord.LP_down)
				chord.LP_down()
		}
		else
		{
			chord := this.LP_chords[this.LP_flags]
			if(fn)
			{
				if (chord.LP_shortRepeat)
					chord.LP_shortRepeat()
			}
			else if (chord.LP_repeatDuration == null )
			{
				if (chord.LP_longRepeat)
					chord.LP_longRepeat()
			}
			else if (A_TickCount < chord.LP_longLongTime)
			{
				if (chord.LP_longRepeat)
					chord.LP_longRepeat()
			}
			else if (chord.LP_repeat)
				chord.LP_repeat()
		}
	}

	LP_onUp(k,p)
	{
		
		global LP_modeHeldDownFromByScanCode
		if (this.LP_armed)
		{
			this.LP_armed := false
			chord:=this.LP_chords[this.LP_flags]
			fn:=this.LP_timer
			if (fn)
			{
				SetTimer, %fn%, off
			
				if (chord.LP_shortUp)
					chord.LP_shortUp()	
			}
			else
			{
				if (chord.LP_longUp)
					chord.LP_longUp()
			}
			
		}
		this.LP_downStatusByButton[k] := false
		this.LP_flagAsUp(p)
		if(this.LP_flags==0)
		{
			for button,isDown in this.LP_downStatusByButton
			{
				sc := this.LP_scanCodes[button]
				LP_modeHeldDownFromByScanCode[sc] := null
			}
		}
	}
	
	LP_timeout(chord)
	{
		this.LP_timer := null
		if (chord.LP_held)
			chord.LP_held()
	}
	
	LP_initialize(className, modeName, containingClassInstance)
	{
		this.LP_modeName := modeName
		this.LP_containingClassInstance := containingClassInstance
		arr:={}
		
		l := this.LP_Buttons.maxIndex()
		for k,v in this.LP_Buttons
		{
			arr[v] := l-k
		}
		this.LP_downStatusByButton := arr


		this.LP_chords := {}
		objectKeysEncountered := {}
		inheritanceLayer := this
		while(inheritanceLayer)
		{
			for chordName,chord in inheritanceLayer
			{
				
				if (chord.LP_initialize && !objectKeysEncountered[chordName])
				{
					;msgbox, in me:  %chordName%
					l:=strLen(chordName)
					chordIndex:=0
					Loop, Parse, chordName
					{
						p:=l-A_Index 
						if (A_LoopField=="i")
						{
							mask := 1 << p
							chordIndex:= (chordIndex | mask) 
						}
					}
					;msgbox %chordIndex% : %chordName%
					this.LP_chords[chordIndex]:= new chord
					this.LP_chords[chordIndex].LP_initialize(this)
				}
				objectKeysEncountered[chordName] := true
			}
			inheritanceLayer := inheritanceLayer.base
		}

		this.LP_scanCodes := {}
		for button,binaryPosition in this.LP_downStatusByButton
		{
		
			fn := ObjBindMethod(this, "LP_shouldFireDown", button)
			Hotkey If, % fn
			;msgbox, %binaryPosition%
			fn := ObjBindMethod(this, "LP_onDown", button, binaryPosition)  
			hotkey, % "*" button, % fn
			
			fn := ObjBindMethod(this, "LP_shouldFireUp", button)
			Hotkey If, % fn
			fn := ObjBindMethod(this, "LP_onUp", button, binaryPosition)  
			hotkey, % "*" button " up", % fn
			this.LP_downStatusByButton[button] := false
			sc := getKeySC(button)
			this.LP_scanCodes[button] := sc
			LP_modeHeldDownFromByScanCode[sc] := null

		}
		if (this.LP_init)
			this.LP_init()
	
	}
	
	
	LP_shouldFireDown(button)
	{
		global LP_modeHeldDownFromByScanCode
		;msgbox, delish
		if (this.LP_flags!=0)
		{
			return true
		}
		bool := true
		for k,v in this.LP_downStatusByButton
		{
			sc := this.LP_scanCodes[k]
			;msgbox, %sc%
			bool := bool && LP_modeHeldDownFromByScanCode[sc]==null
		}
		m:=this.LP_modeName
		;msgbox, %m%
		return bool && LP_getActiveMode() == this.LP_modeName
	}

	LP_shouldFireUp(button)
	{
		return this.LP_flags!=0
	}
	
}




class LP_chord
{

	LP_longDuration := 400
	LP_repeatDuration := 600
	;static LP_isChord := true
	LP_initialize(containingClassInstance)
	{
		this.LP_containingClassInstance := containingClassInstance
		if (this.LP_init)
			this.LP_init()
	}

	
}



LP_HotkeyShouldFireDown(buttonBehaviourParadigm, thisHotkey)
{
	global LP_modeHeldDownFromByScanCode
	modeName := buttonBehaviourParadigm.LP_modeName
	sc:=buttonBehaviourParadigm.LP_scanCode

	;heldDownFrom := LP_modeHeldDownFromByScanCode[buttonBehaviourParadigm.LP_scanCode] 
	;yo:=LP_getActiveMode()
		;send %modeName% 
	return (buttonBehaviourParadigm.LP_isDown) || (  (LP_getActiveMode() == modeName) && LP_modeHeldDownFromByScanCode[s]==null)
}

LP_HotkeyShouldFireUp(buttonBehaviourParadigm, thisHotkey)
{
	;global LP_modeHeldDownFromByScanCode
	;return LP_modeHeldDownFromByScanCode[buttonBehaviourParadigm.LP_scanCode] == buttonBehaviourParadigm.LP_modeName
	return buttonBehaviourParadigm.LP_isDown
}




;BoundFunc Object
LP_onDown(buttonBehaviourParadigm)
{
	
	global LP_modeHeldDownFromByScanCode
	sc := buttonBehaviourParadigm.LP_scanCode
	;msgbox , hi
	;heldDownFrom := LP_modeHeldDownFromByScanCode[sc] 
	alreadyDown := buttonBehaviourParadigm.LP_isDown
	if (!alreadyDown)
	{
			buttonBehaviourParadigm.downsSinceLastPress := 0
			buttonBehaviourParadigm.LP_downTime := A_TickCount
			buttonBehaviourParadigm.LP_longLongTime := buttonBehaviourParadigm.LP_downTime + buttonBehaviourParadigm.LP_longDuration + buttonBehaviourParadigm.LP_repeatDuration
			mode := buttonBehaviourParadigm.LP_modeName
			LP_modeHeldDownFromByScanCode[sc]  := mode
			buttonBehaviourParadigm.LP_isDown := true
			fn := Func("LP_timeout").bind(buttonBehaviourParadigm)
			buttonBehaviourParadigm.LP_timer := fn
			longDuration := buttonBehaviourParadigm.LP_longDuration
			SetTimer, %fn%, -%longDuration%
			if (buttonBehaviourParadigm.LP_down)
				buttonBehaviourParadigm.LP_down()
	}
	else
	{
		fn := buttonBehaviourParadigm.LP_timer
		if(fn)
		{
			if (buttonBehaviourParadigm.LP_shortRepeat)
				buttonBehaviourParadigm.LP_shortRepeat()
		}
		else if (buttonBehaviourParadigm.LP_repeatDuration == null )
		{
			if (buttonBehaviourParadigm.LP_longRepeat)
				buttonBehaviourParadigm.LP_longRepeat()
		}
		else if (A_TickCount < buttonBehaviourParadigm.LP_longLongTime)
		{
			if (buttonBehaviourParadigm.LP_longRepeat)
				buttonBehaviourParadigm.LP_longRepeat()
		}
		else if (buttonBehaviourParadigm.LP_repeat)
			buttonBehaviourParadigm.LP_repeat()
	}
	buttonBehaviourParadigm.LP_downsSinceLastPress++
	if (!buttonBehaviourParadigm.LP_timer)
		buttonBehaviourParadigm.LP_downsSinceLastHeld++
	
}

LP_onUp(buttonBehaviourParadigm)
{

	global  LP_modeHeldDownFromByScanCode
	LP_modeHeldDownFromByScanCode[buttonBehaviourParadigm.LP_scanCode] := null
	buttonBehaviourParadigm.LP_isDown := false
	fn := buttonBehaviourParadigm.LP_timer
	if (fn)
	{
		SetTimer, %fn%, off
		;;;;;;;;;;;what we do when short key press ends;;;;;;;;;;;;
		if (buttonBehaviourParadigm.LP_shortUp)
			buttonBehaviourParadigm.LP_shortUp()
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	}
	else
	{
		;;;;;;;;;;;;;;;;;;;;;What we do when long key press ends;;;;;;;;;;;;;;;;;;;;;;;;
		if (buttonBehaviourParadigm.LP_longUp)
			buttonBehaviourParadigm.LP_longUp()
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	}
	
}

LP_timeout(buttonBehaviourParadigm)
{
	
	buttonBehaviourParadigm.LP_downsSinceLastHeld := 0
	buttonBehaviourParadigm.LP_timer := null
	;;;;;;;;;;;;;;;;;;;What we do when long key press begins;;;;;;;;;;;;;;
	if (buttonBehaviourParadigm.LP_held)
		buttonBehaviourParadigm.LP_held()
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
}






