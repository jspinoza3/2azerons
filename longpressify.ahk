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

LP_buttonByAlias := {one:"1",two:"2",three:"3",four:"4",five:"5",six:"6",seven:"7",eight:"8",nine:"9",zero:"0",grave:"``",accent:"``",hyphen:"-",dash:"-",equal:"=",equals:"=",openbracket:"[",closebracket:"]",comma:",",period:".",forwardslash:"/",backslash:"\",semicolon:";",quote:"'"}

LP_setUp()
{
	LP_modes.LP_instance := new LP_modes
	for modeName, mode in LP_modes
	{
		if (mode.hasKey("__Class"))
		{
			mode := new mode
			LP_modes.LP_instance[modeName] := mode
			mode.LP_paradigms := {}
			LP_forEachKeyIn(mode, Func("LP_augmentAndInitialize").bind(modeName, mode))
		}
	}
}
LP_setUp()


LP_augmentAndInitialize(modeName,mode,buttonBehaviourParadigmName,buttonBehaviourParadigm)
{
	if (buttonBehaviourParadigm.hasKey("__Class"))
	{
		bp := new buttonBehaviourParadigm
		if(bp.LP_Buttons)
		{
			
			type:= LP_chordingGroup
		}
		else
		{
			type:= LP_longpressable
		}
		LP_augment(bp, type)
		mode[buttonBehaviourParadigmName] := bp
		mode.LP_paradigms[buttonBehaviourParadigmName]:=bp
		bp.LP_initialize(buttonBehaviourParadigmName, modeName, mode)
		
	}
}

LP_activate(modeName)
{
	for name,p in LP_modes.LP_instance[modeName].LP_paradigms 
	{
		p.LP_activate()
	}
	LP_modes.LP_instance[modeName].LP_isActive := true
}

LP_deactivate(modeName)
{
	for name,p in LP_modes.LP_instance[modeName].LP_paradigms 
	{
		p.LP_deactivate()
	}
	LP_modes.LP_instance[modeName].LP_isActive := false
}

LP_forEachKeyIn(obj, handler)
{
	objectKeysEncountered := {__Class:true}
	while(obj)
	{
		for k,v in obj
		{
			if (!objectKeysEncountered[k])
			{
				
				handler.call(k,v)
				objectKeysEncountered[k] := true
			}
		}
		obj := obj.base
	}
}

LP_augment(child, parent)
{
	LP_forEachKeyIn(parent, Func("LP_initializeKey").bind(child))
}

LP_overwrite(child, parent)
{
	LP_forEachKeyIn(parent, Func("LP_setKey").bind(child))
}

LP_initializeKey(obj,key,value)
{
	if(!LP_hasKey(obj, key))
		obj[key] := value
}

LP_setKey(obj,key,value)
{
	obj[key] := value
}

LP_hasKey(obj,key)
{
	has := false
	while(obj && !has)
	{
		if (obj.hasKey(key))
			has := true
		obj := obj.base
	}
	return has
}


class LP_longpressable extends LP_behaviourParadigm
{

	static LP_prefix := "*"
	static LP_longDuration :=  300
	static LP_repeatDuration := 400
	
	LP_initialize(classname, modeName, containingClassInstance)
	{
		global LP_buttonByAlias
		if (!this.hasKey("LP_button"))
		{
				this.LP_button := classname	
		}
		if (LP_buttonByAlias.hasKey(this.LP_button))
			this.LP_button := LP_buttonByAlias[classname]
			
		button := this.LP_button
		if (getKeyName(button)==null)
		{
			
			msgbox, ruhoh %button% appears to be not a valid button
		}	
		this.LP_modeName := modeName
		this.LP_containingClassInstance:=containingClassInstance
		;msgbox %modeName%

		this.LP_shortPhaseRepeats := 0
		this.LP_longPhaseRepeats := 0
		this.LP_repeatPhaseRepeats := 0
		this.LP_downTime := 0
		this.LP_timer := null
		if (this.LP_init)
			this.LP_init()
		

	}
	
	
	LP_activate()
	{
		button := this.LP_button
		pre:=this.LP_prefix
		this.LP_hotkeyOn(pre, button)
	}
	
	LP_deactivate()
	{
		button := this.LP_button
		pre:=this.LP_prefix
		this.LP_hotkeyOff(pre, button)
	}
	
	
	LP_onDown()
	{

		alreadyDown := this.LP_isDown
		if (!alreadyDown)
		{
				this.LP_shortPhaseRepeats := 0
				this.LP_longPhaseRepeats := 0
				this.LP_repeatPhaseRepeats := 0
				this.LP_downTime := A_TickCount
				this.LP_repeatTime := this.LP_downTime + this.LP_longDuration + this.LP_repeatDuration
				mode := this.LP_modeName
				this.LP_isDown := true
				fn := ObjBindMethod(this, "LP_timeout")
				this.LP_timer := fn
				longDuration := this.LP_longDuration
				SetTimer, %fn%, -%longDuration%
				if (this.LP_down)
					this.LP_down()
		}
		else
		{
			
			fn := this.LP_timer
			if(fn)
			{
				this.LP_shortPhaseRepeats++
				if (this.LP_shortRepeat)
					this.LP_shortRepeat()
			}
			else 
			{
				if (this.LP_repeatDuration == null || A_TickCount < this.LP_repeatTime)
				{
					this.LP_longPhaseRepeats++
					if (this.LP_longRepeat)
						this.LP_longRepeat()
				}
				else 
				{
					this.LP_repeatPhaseRepeats++
					if (this.LP_repeat)
						this.LP_repeat()
				}
			}
		}
		
			
		
	}

	LP_onUp()
	{

		this.LP_isDown := false
		fn := this.LP_timer
		if (fn)
		{
			SetTimer, %fn%, off
			;;;;;;;;;;;what we do when short key press ends;;;;;;;;;;;;
			if (this.LP_shortUp)
				this.LP_shortUp()
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
		}
		else
		{
			;;;;;;;;;;;;;;;;;;;;;What we do when long key press ends;;;;;;;;;;;;;;;;;;;;;;;;
			if (this.LP_longUp)
				this.LP_longUp()
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		}
		
	}

	LP_timeout()
	{
		
		this.LP_downsSinceLastHeld := 0
		this.LP_timer := null
		;;;;;;;;;;;;;;;;;;;What we do when long key press begins;;;;;;;;;;;;;;
		if (this.LP_held)
			this.LP_held()
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	}
	

}

class LP_behaviourParadigm
{

	LP_hotkeyOn(pre, button)
	{
	
		fn := ObjBindMethod(this, "LP_onDown", button) 
		hotkey, % pre button, % fn, on
		
		fn := ObjBindMethod(this, "LP_onUp", button)  
		hotkey, % pre button " up", % fn, on
	}
	
	LP_hotkeyOff(pre, button)
	{	
		hotkey, % pre button, off
		hotkey, % pre button " up", off
	}

}

class LP_chord
{
	static LP_longDuration :=  400
	static LP_repeatDuration := 500
}

class LP_chordingGroup extends LP_behaviourParadigm
{

	LP_flagAsDown(button)
	{
		this.LP_downStatusByButton[button] := true
		p:=this.LP_binaryPositionByButton[button]
		mask := 1 << p
		this.LP_flags:= (this.LP_flags | mask)
		
	}

	LP_flagAsUp(button)
	{
		this.LP_downStatusByButton[button] := false
		p:=this.LP_binaryPositionByButton[button]
		mask := 1 << p
		this.LP_flags := (this.LP_flags & ~mask) 
	}

	
	LP_onDown(button)
	{
		fn:=this.LP_timer
		if (!this.LP_downStatusByButton[button])
		{
			if (fn)
			{
				SetTimer, %fn%, off
			}
			/*
			if(this.LP_flags==0)
			{
				for button,isDown in this.LP_downStatusByButton
				{
					sc := this.LP_scanCodes[button]
				}
			}
			*/
			chord := this.LP_chords[this.LP_flags]
			if (chord.LP_over)
				chord.LP_over()
			this.LP_flagAsDown(button)
			this.LP_armed := true
			chord := this.LP_chords[this.LP_flags]
			chord.LP_downTime := A_TickCount
			chord.LP_repeatTime := chord.LP_downTime + chord.LP_longDuration + chord.LP_repeatDuration
			chord.LP_shortPhaseRepeats := 0
			chord.LP_longPhaseRepeats := 0
			chord.LP_repeatPhaseRepeats := 0
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
				chord.LP_shortPhaseRepeats++
				if (chord.LP_shortRepeat)
					chord.LP_shortRepeat()
			}
			else 
			{
				if (chord.LP_repeatDuration == null || A_TickCount < chord.LP_repeatTime)
				{
					chord.LP_longPhaseRepeats++
					if (chord.LP_longRepeat)
						chord.LP_longRepeat()
				}
				else 
				{
					chord.LP_repeatPhaseRepeats++
					if (chord.LP_repeat)
						chord.LP_repeat()
				}
			}
		}
	}

	LP_onUp(button)
	{
		
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
		this.LP_flagAsUp(button)
		if(this.LP_flags==0)
		{
			for button,isDown in this.LP_downStatusByButton
			{
				sc := this.LP_scanCodes[button]
			}
		}
	}
	
	LP_timeout(chord)
	{
		this.LP_timer := null
		if (chord.LP_held)
			chord.LP_held()
	}
	
	LP_initializeChord(chordName,chord)
	{
		
		if (chord.hasKey("__Class"))
		{
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
				else if (A_LoopField!="o")
					msgbox ruhoh %chordNames% should consist of i's and o's
			}
			;msgbox %chordIndex% : %chordName%
			c := new chord
			LP_augment(c,LP_chord)
			this.LP_chords[chordIndex]:= c
			c.LP_containingClassInstance := this
			this[chordName] := c
			if (c.LP_init)
				c.LP_init()
		}
	}
	
	LP_initialize(className, modeName, modeInstance)
	{
	
		this.LP_armed := false
		this.LP_flags := 0
		this.LP_modeName := modeName
		this.LP_containingClassInstance := modeInstance
		this.LP_binaryPositionByButton := {}
		this.LP_downStatusByButton := {}
		l := this.LP_Buttons.maxIndex()
		for i,button in this.LP_Buttons
		{
			this.LP_binaryPositionByButton[button] := l-i
			this.LP_downStatusByButton[button] := false
		}

		this.LP_chords := {}

		LP_forEachKeyIn(this,ObjBindMethod(this,"LP_initializeChord"))


		if (this.LP_init)
			this.LP_init()
	
	}
	
	
	LP_activate()
	{
			
		for i,button in this.LP_Buttons
		{
			this.LP_hotkeyOn("*",button)
		}
	}
	
	LP_deactivate()
	{
		for i,button in this.LP_Buttons
		{
			this.hotkeyOff("*",button)
		}	
	}
	
	
}






/*
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


*/







