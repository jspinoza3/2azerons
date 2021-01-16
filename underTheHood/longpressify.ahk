#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
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




	class keyState
	{
		static occupationByScanCode := {}
		
		/*
			PARAMS:
			- ep: yep
			- button:  (may also be a scan code)
			Result:
			- Prior to completing activation, an EventProcessor ep,  should call this to report intent to activate and receive confirmation that no other active EventProcessor is occupying the button, no other EventProcessors started waiting to occupy the button before ep, and the button is not currently down.  If  all those conditions are satisfied, the button becomes occupied by ep and the method returns true.  If the button is not available for immediate occupation, then ep will be added to the waiting list and alerted whenever occupation is acheived. Alert comes as a call to ep.receiveOccupationConfirmation(button)
			- definition:  an EventProcessor is said to "explicitly occupy a button", if it is active and its paradigm explicity modifies the button (I.E. declares a hotkey using the button name or using the scancode if the button is a scancode). 
			- definition:  an EventProcessor, ep, is said to "implicitly occupy a button" if one of the following is true:
			- --- the button is a scancode and ep is active and its paradigm modifies a button that has that scancode
			- --- the button is not a scancode and ep is active and its paradigm modifies the scancode of the button
			Implementation remarks:
			- example of de/activation dependencies
				https://docs.google.com/drawings/d/12P7_ZwgnjDVV47tOwK6IlJ3isOzet8g8UaJhBbN13BA/edit
			- if ep modifies a ScanCode explicitly (rather than specifying a button), then we must check if anyone is currently occupying button1 as well as button 2 as well as the scancode
			- if no one occupies scan code than someone can wait on button 1 while someone else waits on button 2
			-occupied status is organized like below. SC1 represents a Scancode and button1 and button2 represent button names associated with that scancode
			--------------------------
			-SC1 
			- --- occupiers
			- --- --- scancode:
			- --- --- button1:
			- --- --- button2:  
			- --- waiters:
			- --- --- scancode:
			- --- --- button1:
			- --- --- button2: 
			------------------------------
		*/
		
		reserve( button, ep)
		{
			sc:=getKeySC(button) 
			fb:=this.format(button)
			if(!this.occupationByScanCode[sc])
				this.occupationByScanCode[sc] := {occupiers:{}, waiters:{}}
			o:= {eventProcessor:ep,button:button}
			
			/*
				series of if statements to determine if the button is available
			*/
			if(!this.occupationByScanCode[sc].occupiers.scancode) ;is the scancode available?
			{
				if( this.occupationByScanCode[sc].occupiers.count()==0 || (fb!="scancode" && !this.occupationByScanCode[sc].occupiers[fb])    )  ;is either everything unoccupied or at least the button not a scancode and unoccupied?
				{
					if(!getKeyState(button, "P"))
					{
						this.occupationByScanCode[sc].occupiers[fb] := o
						return true
					}
					fn := objBindMethod(this,"freakout",sc,button)
					hotkey, *%button% up, %fn%, on
						
				}
			}
			this.occupationByScanCode[sc].waiters[fb] := o
			
			
		}
		
		
		
	
		freakout(sc,button)
		{
			;msgbox freaky
			hotkey, *%button% up, off
			this.checkWaiters(sc)
		}
	
		
		checkWaiters(sc)
		{
			if(!this.occupationByScanCode[sc].occupiers.scancode)
			{
				todelete:=[]
				for i, v in this.occupationByScanCode[sc].waiters
				{
					button := v.button
					if( this.occupationByScanCode[sc].occupiers.count()==0 || (i!="scancode" && !this.occupationByScanCode[sc].occupiers[i]))
					{
						if(!getKeyState(button, "P"))
						{
						
							this.occupationByScanCode[sc].occupiers[i] := v
							todelete.push(i)
							v.eventProcessor.receiveOccupationConfirmation(button)
						}
						else
						{
							fn := objBindMethod(this,"freakout",sc,button)
							hotkey, *%button% up, %fn%, on
						}
					}
				}
				for ii,vv in todelete
					this.occupationByScanCode[sc].waiters.delete(vv)
			}
		}
		
		
		format(button)
		{
			upper := Format("{:U}", button)
			if (substr(upper,1,2)=="SC" && strLen(button)==5)
				return "scancode"
			else 
				return getKeyName(button)
		}

		relinquish(button, ep)
		{
	
			sc:=getKeySC(button) 
			fb:=this.format(button)
			if (this.occupationByScanCode[sc].occupiers[fb].eventProcessor==ep) ;is the supplied event processor occupying supplied button?
			{
				this.occupationByScanCode[sc].occupiers.delete(fb)
				ep.receiveOccupationRelinquishedConfirmation(button)
				this.checkWaiters(sc)
			}
			else  ; under usage assumptions, the supplied event processor is waiting on supplied button
			{
				this.occupationByScanCode[sc].waiters.delete(fb)
			}
		}


	}




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
		Critical ON
		mode:=LP_modes.LP_instance[modeName]
		mode.LP_isActive := true	
		;this.activationQueue.addTask(objBindMethod(this,"doActivation",mode))
		this.doActivation(mode)
		Critical Off
	}
	
	doActivation(mode)
	{	
		for name,p in mode.LP_paradigms 
		{
			p.LP_eventProcessor.activate()
		}	
		;this.activationQueue.taskComplete()
	}

	deactivate(modeName)
	{
		Critical ON
		mode:=LP_modes.LP_instance[modeName]
		mode.LP_isActive := false
		;this.activationQueue.addTask(objBindMethod(this,"doDeactivation",mode))
		this.doDeactivation(mode)
		Critical Off
	}

	modeSwap(m1,m2)
	{
		Critical ON
		this.deactivate(m1)
		this.activate(m2)
		Critical Off
	}

	doDeactivation(mode)
	{
		for name,p in mode.LP_paradigms 
		{
			p.LP_eventProcessor.deactivate()
		}	
		;this.activationQueue.taskComplete()
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



/*
implementation notes:
\blueprints\
and online at
https://docs.google.com/drawings/d/10ANSzFFevo6t3euTuVNjSGXll8fylYxbjK8Y5oy_es8/edit
*/


	class ButtonEventProcessor
	{
		
		q := {}
		qIdle:=true
		
		__New(paradigmName,paradigm, modeName,mode) 
		{
			this.shortPhaseRepeats:=0
			this.longPhaseRepeats:=0
			this.repeatPhaseRepeats:=0
		
			this.paradigm := paradigm
			
			
			if (!paradigm.hasKey("LP_button"))
			{
					paradigm.LP_button := paradigmName	
			}
			if (LP_.buttonByAlias.hasKey(paradigm.LP_button))
				paradigm.LP_button := LP_.buttonByAlias[paradigm.LP_button]
				
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



		activate()
		{
			
			if(LP_.keyState.reserve(this.paradigm.LP_Button, this))
				this.hotkeyOn()			
		}
		
		deactivate()
		{
			if(this.isUp)
			{
				LP_.keyState.relinquish(this.paradigm.LP_button, this)
			}
			else
				this.up := this.upWhilePendingDeactivation
		}
		
		
		receiveOccupationConfirmation(button)	
		{
			
			this.hotkeyOn()		
		}
		
		
		
		receiveOccupationRelinquishedConfirmation(button)
		{
			
			this.hotkeyOff()	
		}
		
/*
		when this is called, the eventProcessor must return whether it is ready to deactivate and also call the callback whenever this readiness changes
*/
	
	
		hotkeyOn()
		{
			button := this.paradigm.LP_Button
			pre:=this.paradigm.LP_prefix
			processor:=objBindMethod(this,"down")
			pusher:= objBindMethod(this,"add2Q", processor)
			hotkey, %pre%%button%, %pusher%, on


			processor:=objBindMethod(this,"up")
			pusher:= objBindMethod(this,"add2Q", processor)
			hotkey, %pre%%button% up, %pusher%, on			
		}
		
		hotkeyOff()
		{	
			button := this.paradigm.LP_Button
			pre:=this.paradigm.LP_prefix
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


		upWhilePendingDeactivation()
		{
			LP_.keyState.relinquish(this.paradigm.LP_button, this)
			this.delete("flagAsUp")
			this.base.up.call(this)	
		}
		
		clearTimer()
		{
			fn:=this.timer
			SetTimer, %fn%, off
		}
				
		

		
		callDownHandlerAndResetRepeatCounters()
		{
			this.paradigm.LP_down(this.paradigm.LP_Button)
			this.shortPhaseRepeats:=0
			this.longPhaseRepeats:=0
			this.repeatPhaseRepeats:=0
		}		
		
		heldDecide()
		{
			ms:=this.paradigm.LP_msTillRepeat
			if(ms>=0)
			{
				this.base:=this.longStateWithTimer
				this.paradigm.LP_held(this.paradigm.LP_Button)
				
				
				;gotta push these timeout events in the queue or else LP_enterRepeatPhase might not finish prior to calls to LP_repeat	
				processor:=objBindMethod(this,"enterRepeat")
				pusher:= objBindMethod(this,"add2Q", processor)
				this.timer := pusher
				SetTimer, %pusher%, -%ms%
			}
			else
			{
				this.base:= this.longState
				this.paradigm.LP_held(this.paradigm.LP_Button)
			}
		
		}	
		enterRepeat()
		{
	
			this.base := this.repeatState
			this.paradigm.LP_enterRepeatPhase(this.paradigm.LP_Button)
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
					
					;gotta push these timeout events in the queue or else LP_held might not finish prior to calls to LP_longRepeat
					processor:=objBindMethod(this,"heldDecide")
					pusher:= objBindMethod(this,"add2Q", processor)
					this.timer := pusher
					SetTimer, %pusher%, -%ms%
					
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
				this.paradigm.LP_shortUp(this.paradigm.LP_Button)
				this.enterRest()
			}
		}
			

		class shortState extends LP_.ButtonEventProcessor
		{

			
			down()
			{
				this.shortPhaseRepeats++
				this.paradigm.LP_shortRepeat(this.paradigm.LP_Button)
			}

			up()
			{
				this.paradigm.LP_shortUp(this.paradigm.LP_Button)
				this.enterRest()
			}
		}
			

		class longStateWithTimer extends LP_.ButtonEventProcessor.longState
		{
			up()
			{
				this.clearTimer()
				this.paradigm.LP_longUp(this.paradigm.LP_Button)
				this.enterRest()
			}
			
		}


		class longState extends LP_.ButtonEventProcessor
		{

			down()
			{
				this.longPhaseRepeats++
				this.paradigm.LP_longRepeat(this.paradigm.LP_Button)
			}

			up()
			{
				this.paradigm.LP_longUp(this.paradigm.LP_Button)
				this.enterRest()
			}
		}


		class repeatState extends LP_.ButtonEventProcessor
		{



			down()
			{
				this.repeatPhaseRepeats++
				this.paradigm.LP_repeat(this.paradigm.LP_Button)
			}

			up()
			{
				this.paradigm.LP_repeatUp(this.paradigm.LP_Button)
				this.enterRest()
			}
		}
		
		class paradigmAugmentor
		{
	
			static LP_msTillLong := 300 
			static LP_msTillRepeat := 400
			static LP_prefix := "*"
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
			

			
			

			
			LP_longUp(button)
			{
				
			}
			
			LP_longRepeat(button)
			{
			
			}
			
			LP_held(button)
			{
			
			}
			
			
	
			
			LP_shortUp(button)
			{
				
			}
			LP_shortRepeat(button)
			{

			}
			
			LP_down(button)
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
			this.shortPhaseRepeats:=0
			this.longPhaseRepeats:=0
			this.repeatPhaseRepeats:=0
		
		
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
			this.prefixByButton:=[]
			for i,button in this.paradigm.LP_Buttons
			{
				this.prefixByButton[button] := this.paradigm.LP_prefixes[i]
			}	
			this.chords := {}

			LP_.forEachKeyIn(this.paradigm,ObjBindMethod(this,"initializeChord"))
			
			if (this.paradigm.LP_init)
				this.paradigm.LP_init()
			LP_.augment(this.paradigm,this.paradigmAugmentor)	
			
		}


		activate()
		{
				for i,button in this.paradigm.LP_Buttons
				{
					if(LP_.keyState.reserve(button, this))
					{
						this.hotkeyOn(this.paradigm.LP_prefixes[i],button)
					}
				}				
		}

		deactivate()
		{
			for i,button in this.paradigm.LP_Buttons
			{
				if (!this.downStatusByButton[button])
				{
					
					LP_.keyState.relinquish(button, this)
				}
			}
			if(this.flags!=0)
			{
				this.flagAsUp := this.flagAsUpWhilePendingDeactivation
			}
				
		}
		

		receiveOccupationConfirmation(button)	
		{
			
			this.hotkeyOn(this.prefixByButton[button],button)		
		}
		
		
		
		receiveOccupationRelinquishedConfirmation(button)
		{
			
			this.hotkeyOff(this.prefixByButton[button],button)	
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
				c.LP_eventProcessor := this
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
			LP_.keyState.relinquish(button, this) ;changed
			this.base.flagAsUp.call(this,button)
			if(this.flags==0)
			{
				this.delete("flagAsUp")
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
					
					this.base := this.shortStateWithTimer
					this.callDownHandlerAndResetRepeatCounters(button)
					
					;gotta push these timeout events in the queue or else LP_held might not finish prior to calls to LP_longRepeat
					processor:=objBindMethod(this,"heldDecide",button)
					pusher:= objBindMethod(this,"add2Q", processor)
					this.timer := pusher
					SetTimer, %pusher%, -%ms%
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

				this.base:=this.longStateWithTimer
				this.chord.LP_held(button)
		
				;gotta push these timeout events in the queue or else LP_enterRepeatPhase might not finish prior to calls to LP_repeat
				processor:=objBindMethod(this,"enterRepeat",button)
				pusher:= objBindMethod(this,"add2Q", processor)
				this.timer := pusher
				SetTimer, %pusher%, -%LP_msTillRepeat%	
				
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
				this.chord.LP_shortOver(button)
				this.downDecide(button)
			}

		}
			

		class shortState extends LP_.CGEventProcessor
		{
			down(button)
			{
				;c:=this.__Class
				;debugappend(c . ": down")
				this.chord.LP_shortOver(button)
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
				this.chord.LP_repeatUp(button)
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

