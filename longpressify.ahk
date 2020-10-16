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
#MaxThreadsPerHotkey 1000

LP_.setUp()

class LP_
{
	class activationQueue
	{
		static q:={}
		addTask(task)
		{	
				this.q.push(task)
				if(this.q.count() == 1)
				{
					
					%task%()
				}
		}
		taskComplete()
		{
			this.q.removeAt(1)
			task := this.q[1]
			if (task)
				%task%()
		}
	}
	
	setUp()
	{
		LP_modes.LP_instance := new LP_modes
		for modeName, mode in LP_modes
		{
			if (mode.hasKey("__Class"))
			{
				mode := new mode
				LP_modes.LP_instance[modeName] := mode
				mode.LP_paradigms := {}
				this.forEachKeyIn(mode, objBindMethod(this,"pluginTheParadigm",modeName, mode))
			}
		}
	}

	pluginTheParadigm(modeName,mode,buttonBehaviourParadigmName,buttonBehaviourParadigm)
	{
		if (buttonBehaviourParadigm.hasKey("__Class"))
		{
			
			bp := new buttonBehaviourParadigm
			if(bp.LP_Buttons)
			{
				new this.CGEventProcessor.restState(bp,modeName,mode)
			}
			else
			{
				new this.ButtonEventProcessor.restState(buttonBehaviourParadigmName,bp,modeName,mode)
			}
			mode[buttonBehaviourParadigmName] := bp
			mode.LP_paradigms[buttonBehaviourParadigmName]:=bp
		}
	}

	activate(modeName)
	{
		mode:=LP_modes.LP_instance[modeName]
		mode.LP_isActive := true	
		this.activationQueue.addTask(objBindMethod(this,"completeActivation",mode))
	}
	
	completeActivation(mode)
	{	
		for name,p in mode.LP_paradigms 
		{
			p.LP_eventProcessor.activate()
		}	
		this.activationQueue.taskComplete()
	}

	deactivate(modeName)
	{
		mode:=LP_modes.LP_instance[modeName]
		mode.LP_isActive := false
		this.activationQueue.addTask(objBindMethod(this,"doDeactivation",mode))
	}
	
	doDeactivation(mode)
	{
		
		mode.LP_paradigmsNotReadyForDeactivation := 0
		mode.LP_passedPointOfNoReturn:=false
		for name,p in mode.LP_paradigms 
		{
			callback:=objBindMethod(this, "receiveDeactivationReadinessChangeReport", mode, p)
			if(!p.LP_eventProcessor.prepareToDeactivate(callback))
				mode.LP_paradigmsNotReadyForDeactivation++
		}
		
		if(mode.LP_paradigmsNotReadyForDeactivation==0)
			this.completeDeactivation(mode)
	}	

	completeDeactivation(mode)
	{
		
		mode.LP_passedPointOfNoReturn:=true
		for name,p in mode.LP_paradigms 
		{
			p.LP_eventProcessor.deactivate()
		}	
		this.activationQueue.taskComplete()
	}

	receiveDeactivationReadinessChangeReport(mode,paradigm,readiness)
	{
		if (readiness)
		{
			mode.LP_paradigmsNotReadyForDeactivation--
		}
		else
			mode.LP_paradigmsNotReadyForDeactivation++
			
		p:=paradigm.__Class ;mode.LP_paradigmsNotReadyForDeactivation
	
		if(mode.LP_paradigmsNotReadyForDeactivation==0)
		{
			if(!mode.LP_passedPointOfNoReturn)
				this.completeDeactivation(mode)
		}
	}

	forEachKeyIn(obj, handler)
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



	augment(child, parent)
	{
		LP_.forEachKeyIn(parent, ObjBindMethod(LP_,"initializeKey",child))
	}


	initializeKey(obj,key,value)
	{
		if(!LP_.hasKey(obj, key))
			obj[key] := value
	}

	hasKey(obj,key)
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




static buttonByAlias := {one:"1",two:"2",three:"3",four:"4",five:"5",six:"6",seven:"7",eight:"8",nine:"9",zero:"0",grave:"``",accent:"``",hyphen:"-",dash:"-",equal:"=",equals:"=",openbracket:"[",closebracket:"]",comma:",",period:".",forwardslash:"/",backslash:"\",semicolon:";",quote:"'"}






	class ButtonEventProcessor
	{
		
		q := {}
		qIdle:=true
		
		__New(paradigmName,paradigm, modeName,mode) 
		{
			this.paradigm := paradigm
			
			
			if (!paradigm.hasKey("LP_button"))
			{
					paradigm.LP_button := paradigmName	
			}
			if (LP_.buttonByAlias.hasKey(this.LP_button))
				paradigm.LP_button := LP_.buttonByAlias[classname]
				
			button := paradigm.LP_button
			;msgbox %paradigmName%
			if (getKeyName(button)==null)
			{
				msgbox, ruhoh %button% appears to be not a valid button
			}	
				
			paradigm.LP_containingClassInstance := mode
			this.mode:=mode
			this.modeName:=modeName
			paradigm.LP_eventProcessor := this		
			if (paradigm.LP_init())
				paradigm.LP_init()
			LP_.augment(paradigm,this.paradigmAugmentor)
		}
/*			
		tryActivatingAgain()
		{
			this.dontTryActivatingAgain()
			this.activate()
		}
		
		dontTryActivatingAgain()
		{
			button := this.willTryActivatingAgain
			if (button!=null)
			{
				hotkey, ~%button% up, off
				this.willTryActivatingAgain := null
				return true
			}
			return false
		}
		
		tryActivatingAgainLater(button)
		{
			tryagain:=objBindMethod(this,"tryActivatingAgain")
			hotkey, ~%button% up, %tryagain%, on
			this.willTryActivatingAgain := button			
		}
		
		activate()
		{
			readyToActivate:=true
			for i,button in this.paradigm.LP_Buttons
			{
				if(getKeyState(button,"P"))
				{
					this.tryActivatingAgainLater()
					readyToActivate:=false
					break
				}
			}
			if (readyToActivate)
			{
				for i,button in this.paradigm.LP_Buttons
				{
					this.LP_hotkeyOn(this.paradigm.LP_prefixes[i],button)
				}				
			}
		}
		
		deactivate()
		{
		
			if(!this.dontTryActivatingAgain())
			{
				for i,button in this.paradigm.LP_Buttons
				{
					this.hotkeyOff(this.paradigm.LP_prefixes[i],button)
				}	
			}
		}
*/


		activate()
		{
			button := this.paradigm.LP_Button
			pre:=this.paradigm.LP_prefix
			this.hotkeyOn(pre, button)			
		}
		
		deactivate()
		{
			button := this.paradigm.LP_Button
			pre:=this.paradigm.LP_prefix
			this.hotkeyOff(pre, button)	
			this.delete("down") 
			this.delete("up")	
		}
		
/*
		when this is called, the eventProcessor must return whether it is ready to deactivate and also call the callback whenever this readiness changes
*/
		prepareToDeactivate(callback)
		{
			this.deactivationReadinessChangeCallback := callback
			this.down := this.downWhilePendingDeactivation
			this.up := this.upWhilePendingDeactivation
		
			return this.isUp
		}
	
		hotkeyOn(pre, button)
		{
			processor:=objBindMethod(this,"down")
			pusher:= objBindMethod(this,"add2Q", processor)
			hotkey, %pre%%button%, %pusher%, on


			processor:=objBindMethod(this,"up")
			pusher:= objBindMethod(this,"add2Q", processor)
			hotkey, %pre%%button% up, %pusher%, on			
		}
		
		hotkeyOff(pre, button)
		{	
			hotkey, % pre button, off
			hotkey, % pre button " up", off
		}

		add2Q(task)
		{
			;debugappend1(this.q.count())
			this.q.push(task)
			if(this.qIdle)
			{
				this.qIdle:=false
				while (this.q.count())
				{
					;debugappend1(this.q.count())
					task := this.q.removeAt(1)
					%task%()
				}
				this.qIdle:=true
			}
		}
	

		downWhilePendingDeactivation()
		{
				if(this.isUp)
				{
						fn:=this.deactivationReadinessChangeCallback
						%fn%(false)
				}
				this.base.down.call(this)	
		}



		
		upWhilePendingDeactivation()
		{
				;tooltip, %A_tickcount%
						fn:=this.deactivationReadinessChangeCallback
						%fn%(true)
				this.base.up.call(this)	
		}
		
		clearTimer()
		{
			fn:=this.timer
			SetTimer, %fn%, off
		}
				
		

		
		callDownHandlerAndResetRepeatCounters()
		{
			this.paradigm.LP_down()
			this.shortPhaseRepeats:=0
			this.longPhaseRepeats:=0
			this.repeatPhaseRepeats:=0
		}		
		
		heldDecide()
		{
			LP_msTillRepeat:=this.paradigm.LP_msTillRepeat
			if(LP_msTillRepeat>=0)
			{
				this.base:=this.longStateWithTimer
				this.paradigm.LP_held()
				fn:=ObjBindMethod(this,"enterRepeat")
				this.timer := fn
				SetTimer, %fn%, -%LP_msTillRepeat%	
				;msgbox howdy
			}
			else
			{
				this.base:= this.longState
				this.paradigm.LP_held()
			}
		
		}	
		enterRepeat()
		{
	
			this.base := this.repeatState
			this.paradigm.LP_enterRepeatPhase()
		}


		
		enterRest()
		{
			;c:=this.__Class
			;debugappend(c . ": enterdown")
			this.base := this.restState
		}

		class restState extends LP_.ButtonEventProcessor
		{
			static isUp := true
			down()
			{
				ms:=this.paradigm.LP_msTillLong
				if(ms>=0)
				{
					
					this.base := this.shortStateWithTimer
					this.callDownHandlerAndResetRepeatCounters()
					fn:=objBindMethod(this,"heldDecide")
					this.timer := fn
					SetTimer, %fn%, -%ms%
				}
				else
				{
					this.base := this.shortState
					this.callDownHandlerAndResetRepeatCounters()	
				}
			}
		}

		class shortStateWithTimer extends LP_.ButtonEventProcessor.shortState
		{
			up()
			{
				this.clearTimer()
				this.paradigm.LP_shortUp()
				this.enterRest()
			}
		}
			

		class shortState extends LP_.ButtonEventProcessor
		{

			
			down()
			{
				this.shortPhaseRepeats++
				this.paradigm.LP_shortRepeat()
			}

			up()
			{
				this.paradigm.LP_shortUp()
				this.enterRest()
			}
		}
			

		class longStateWithTimer extends LP_.ButtonEventProcessor.longState
		{
			up()
			{
				this.clearTimer()
				this.paradigm.LP_longUp()
				this.enterRest()
			}
			
		}


		class longState extends LP_.ButtonEventProcessor
		{

			down()
			{
				this.longPhaseRepeats++
				this.paradigm.LP_longRepeat()
			}

			up()
			{
				this.paradigm.LP_longUp()
				this.enterRest()
			}
		}


		class repeatState extends LP_.ButtonEventProcessor
		{



			down()
			{
				this.repeatPhaseRepeats++
				this.paradigm.LP_repeat()
			}

			up()
			{
				this.paradigm.LP_repeatUp()
				this.enterRest()
			}
		}
		
		class paradigmAugmentor
		{
	
			static LP_msTillLong := 300 
			static LP_msTillRepeat := 400
			static LP_prefix := "*"
			LP_repeatUp()
			{
				this.LP_longUp()
			}
			
			LP_repeat()
			{
			
			}
			
			LP_enterRepeatPhase()
			{
			
			}
			

			
			

			
			LP_longUp()
			{
			
			}
			
			LP_longRepeat()
			{
			
			}
			
			LP_held()
			{
			
			}
			
			
	

			LP_shortDown()
			{
				
			}
			
			LP_shortUp()
			{
				
			}
			LP_shortRepeat()
			{

			}
			
			LP_down()
			{
			
			}

		}

	}














	class CGEventProcessor
	{
		
		q := {}
		qIdle:=true
		
		__New(paradigm, modeName,mode) 
		{
			this.paradigm := paradigm
			
			paradigm.LP_containingClassInstance := mode
			this.mode:=mode
			this.modeName:=modeName
			paradigm.LP_eventProcessor := this
			this.flags := 0
			this.binaryPositionByButton := {}
			this.downStatusByButton := {}
			l := this.paradigm.LP_Buttons.maxIndex()
			for i,button in this.paradigm.LP_Buttons
			{
				;msgbox %button%
				this.binaryPositionByButton[button] := l-i
				this.downStatusByButton[button] := false
			}
			if(!this.paradigm.LP_prefixes)
			{
				this.paradigm.LP_prefixes:=[]
				for i,button in this.paradigm.LP_Buttons
				{
					this.paradigm.LP_prefixes[i]:="*"
				}			
			}

			this.chords := {}

			LP_.forEachKeyIn(this.paradigm,ObjBindMethod(this,"initializeChord"))
			
			if (this.paradigm.LP_init)
				this.paradigm.LP_init()
			LP_.augment(this.paradigm,this.paradigmAugmentor)	
			
		}
/*			
		tryActivatingAgain()
		{
			this.dontTryActivatingAgain()
			this.activate()
		}
		
		dontTryActivatingAgain()
		{
			button := this.willTryActivatingAgain
			if (button!=null)
			{
				hotkey, ~%button% up, off
				this.willTryActivatingAgain := null
				return true
			}
			return false
		}
		
		tryActivatingAgainLater(button)
		{
			tryagain:=objBindMethod(this,"tryActivatingAgain")
			hotkey, ~%button% up, %tryagain%, on
			this.willTryActivatingAgain := button			
		}
		
		activate()
		{
			readyToActivate:=true
			for i,button in this.paradigm.LP_Buttons
			{
				if(getKeyState(button,"P"))
				{
					this.tryActivatingAgainLater()
					readyToActivate:=false
					break
				}
			}
			if (readyToActivate)
			{
				for i,button in this.paradigm.LP_Buttons
				{
					this.LP_hotkeyOn(this.paradigm.LP_prefixes[i],button)
				}				
			}
		}
		
		deactivate()
		{
		
			if(!this.dontTryActivatingAgain())
			{
				for i,button in this.paradigm.LP_Buttons
				{
					this.hotkeyOff(this.paradigm.LP_prefixes[i],button)
				}	
			}
		}
*/



		

		activate()
		{
				for i,button in this.paradigm.LP_Buttons
				{
					this.hotkeyOn(this.paradigm.LP_prefixes[i],button)
				}				
		}
		
		deactivate()
		{
				for i,button in this.paradigm.LP_Buttons
				{
				
					this.hotkeyOff(this.paradigm.LP_prefixes[i],button)
				}	
				this.delete("processDown")
				this.delete("flagAsUp")
		}
		
/*
		when this is called, the eventProcessor must return whether it is ready to deactivate and also call the callback whenever this readiness changes
*/
		prepareToDeactivate(callback)
		{
			this.deactivationReadinessChangeCallback := callback
			this.processDown := this.processDownWhilePendingDeactivation
			this.flagAsUp := this.flagAsUpWhilePendingDeactivation
			return this.flags == 0
		}
		
		
		hotkeyOn(pre, button)
		{
			processor:=objBindMethod(this,"processDown", button)
			pusher:= objBindMethod(this,"add2Q", processor)
			hotkey, %pre%%button%, %pusher%, on


			processor:=objBindMethod(this,"up", button)
			pusher:= objBindMethod(this,"add2Q", processor)
			hotkey, %pre%%button% up, %pusher%, on			
		}
		
		hotkeyOff(pre, button)
		{	
			hotkey, % pre button, off
			hotkey, % pre button " up", off
		}

		add2Q(task)
		{
			;debugappend1(this.q.count())
			this.q.push(task)
			if(this.qIdle)
			{
				this.qIdle:=false
				while (this.q.count())
				{
					;debugappend1(this.q.count())
					task := this.q.removeAt(1)
					%task%()
				}
				this.qIdle:=true
			}
		}
	
		processDown(button)
		{
				
				status:=this.downStatusByButton[button]
				if(status)
					this.repeat(button)
				else
				{
					this.down(button)	
				}
		}

		processDownWhilePendingDeactivation(button)
		{
				status:=this.downStatusByButton[button]
				if(status)
					this.repeat(button)
				else
				{
					if (this.flags==0)
					{
						fn:=this.deactivationReadinessChangeCallback
						%fn%(false)
					}
					this.down(button)	
				}
		}
		
		clearTimer()
		{
			fn:=this.timer
			SetTimer, %fn%, off
		}
		

	
		initializeChord(chordName,chord)
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
				this.chords[chordIndex]:= c
				c.LP_containingClassInstance := this.paradigm
				
				this.paradigm[chordName] := c
				;this[chordName] := c
				if (c.LP_init)
					c.LP_init()
				LP_.augment(c,this.chordAugmentor)
				
			}
		}
		
		
		flagAsDown(button)
		{
		
			this.downStatusByButton[button] := true
			p:=this.binaryPositionByButton[button]
			mask := 1 << p
			this.flags:= (this.flags | mask)
			this.chord:=this.chords[this.flags]
			tt:=this.downStatusByButton.count()
			;msgbox %button%
				;c:=this.__Class
				;debugappend(c . ": flagAsDown chord: " . this.chord.__Class)
		}

		flagAsUp(button)
		{
			
			this.downStatusByButton[button] := false
			p:=this.binaryPositionByButton[button]
			mask := 1 << p
			this.flags := (this.flags & ~mask) 
			this.chord:=this.chords[this.flags]	
		}
		
		
		flagAsUpWhilePendingDeactivation(button)
		{

			this.base.flagAsUp.call(this,button)
			if(this.flags==0)
			{
				fn:=this.deactivationReadinessChangeCallback
				%fn%(true)
			}
		}			

		
		downDecide(button)
		{
			
			this.flagAsDown(button)
			if (!this.chord)
				this.enterRestdown(button)
			else
			{
				
				ms:=this.chord.LP_msTillLong
				if(ms>=0)
				{
					
					;c:=this.__Class
					;debugappend(c . ": enter")
					this.base := this.shortStateWithTimer
					this.callDownHandlerAndResetRepeatCounters(button)
					;debugappend(c . ": enter:chord: " . this.chord.__Class)
					fn:=objBindMethod(this,"heldDecide",button)
					this.timer := fn
					SetTimer, %fn%, -%ms%
				}
				else
				{
					this.base := this.shortState
					this.callDownHandlerAndResetRepeatCounters(button)	
				}
				
			
			}
		}
		
		callDownHandlerAndResetRepeatCounters(button)
		{
			
			this.chord.LP_down(button)
			this.shortPhaseRepeats:=0
			this.longPhaseRepeats:=0
			this.repeatPhaseRepeats:=0
		}		
		
		heldDecide(button)
		{
			LP_msTillRepeat:=this.chord.LP_msTillRepeat
			if(LP_msTillRepeat>=0)
			{
				;c:=this.__Class
				;debugappend(c . ": enter")
				this.base:=this.longStateWithTimer
				this.chord.LP_held(button)
				fn:=ObjBindMethod(this,"enterRepeat",button)
				this.timer := fn
				SetTimer, %fn%, -%LP_msTillRepeat%	
				;msgbox howdy
			}
			else
			{
				this.base:= this.longState
				this.chord.LP_held(button)
			}
		
		}	
		enterRepeat(button)
		{
			;c:=this.__Class
			;debugappend(c . ": enter")
			;msgbox hey
			this.base := this.repeatState
			this.chord.LP_enterRepeatPhase(button)
		}

		enterRestUp(button)
		{
			;c:=this.__Class
			;debugappend(c . ": enterup")
			this.base := this.restState
			this.flagAsUp(button)
		}
		
		enterRestDown(button)
		{
			;c:=this.__Class
			;debugappend(c . ": enterdown")
			this.base := this.restState
		}

		class restState extends LP_.CGEventProcessor
		{

			down(button)
			{
		
				this.downDecide(button)
			}

			repeat()
			{
				;c:=this.__Class
				;debugappend(c . ": repeat")
			
			}

			up(button)
			{
				;c:=this.__Class
				;debugappend(c . ": up")
				this.flagAsUp(button)
			}


		}

		class shortStateWithTimer extends LP_.CGEventProcessor.shortState
		{
			

			up(button)
			{ 
	
				this.clearTimer()
				this.chord.LP_shortUp(button)
				this.enterRestUp(button)
			}
			
			down(button)
			{
				;c:=this.__Class
				;debugappend(c . ": down")
				this.clearTimer()
				this.chord.LP_shortOver()
				this.downDecide(button)
			}

		}
			

		class shortState extends LP_.CGEventProcessor
		{
			down(button)
			{
				;c:=this.__Class
				;debugappend(c . ": down")
				this.chord.LP_shortOver()
				this.downDecide(button)
			}
			
			repeat(button)
			{
				;c:=this.__Class
				;debugappend(c . ": repeat")
				this.shortPhaseRepeats++
				this.chord.LP_shortRepeat(button)
			}

			up(button)
			{
				;c:=this.__Class
				;debugappend(c . ": up")
				this.chord.LP_shortUp(button)
				this.enterRestUp(button)
			}
		}
			

		class longStateWithTimer extends LP_.CGEventProcessor.longState
		{

			down(button)
			{
				;c:=this.__Class
				;debugappend(c . ": down")
				this.clearTimer()
				this.chord.LP_longOver(button)
				this.downDecide(button)
			}


			up(button)
			{
				;c:=this.__Class
				;debugappend(c . ": up")
				this.clearTimer()
				this.chord.LP_longUp(button)
				this.enterRestUp(button)
			}
			

		}


		class longState extends LP_.CGEventProcessor
		{
			down(button)
			{
				;c:=this.__Class
				;debugappend(c . ": down")
				this.chord.LP_longOver(button)
				this.downDecide(button)
			}

			repeat(button)
			{
				;c:=this.__Class
				;debugappend(c . ": repeat")
				this.longPhaseRepeats++
				this.chord.LP_longRepeat(button)
			}

			up(button)
			{
				;c:=this.__Class
				;debugappend(c . ": up")
				this.chord.LP_longUp(button)
				this.enterRestUp(button)
			}
		}


		class repeatState extends LP_.CGEventProcessor
		{

			down(button)
			{
				;c:=this.__Class
				;debugappend(c + ": down")
				this.chord.LP_repeatOver(button)
				this.downDecide(button)			
			}

			repeat(button)
			{
				;c:=this.__Class
				;debugappend(c . ": repeat")
				;msgbox hey
				this.repeatPhaseRepeats++
				this.chord.LP_repeat(button)
			}

			up(button)
			{
				;c:=this.__Class
				;debugappend(c . ": up")
				this.chord.LP_repeatUp()
				this.enterRestUp(button)
			}
		}
		
		class chordAugmentor
		{
	
			static LP_msTillLong := 400 
			static LP_msTillRepeat := 500 
			LP_repeatUp(button)
			{
				this.LP_longUp(button)
			}
			
			LP_repeat(button)
			{
			
			}
			
			LP_enterRepeatPhase(button)
			{
			
			}
			
			LP_repeatOver(button)
			{
				this.LP_repeatUp(button)
			}
			
			
			
			LP_longOver(button)
			{
				this.LP_longUp(button)
			}
			

			
			LP_longUp(button)
			{
			
			}
			
			LP_longRepeat(button)
			{
			
			}
			
			LP_held(button)
			{
			
			}
			
			
			LP_shortOver(button)
			{
				
			}

			
			LP_shortUp(button)
			{
				send sht
			}
			LP_shortRepeat(button)
			{

			}
			
			LP_down(button)
			{
			
			}

		}
		class paradigmAugmentor
		{
		
		}
	}




	


	
}
/*
Gui, Add, Edit, Readonly x10 y10 w400 h1500 vDebug
Gui, Show, w420 h1500, Debug Window


;debugappend(Data)
{

GuiControlGet, Debug
GuiControl,, Debug, %Debug%%Data%`r`n
}

debugappend1(Data)
{

GuiControlGet, Debug
GuiControl,, Debug, %Debug%%Data%`r`n
}

hotkey, f12, tear

clear()
{
GuiControl,, Debug, cleared
}

tear()
{
shortPhaseWithTimer.enter({},{})
;;debugappend(this.phase.__Class)
}
*/

