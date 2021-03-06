﻿class clay
{
	LP_msTillLong := 300
	LP_msTillRepeat := 600
	LP_prefix := "*"
}

class longRepeat extends clay
{
	
	LP_repeat(button)
	{
		this.LP_held(button)
	}
	LP_shortUp(button) 
	{
		b := this.short
		tosend := "{blind}{" . b . " down}"	
		send %tosend%
		tosend := "{blind}{" . b . " up}"	
		send %tosend%
	}
	LP_held(button)
	{
		b := this.long
		tosend := "{blind}{" . b . " down}"	
		send %tosend%
	}
	LP_longUp(button)
	{
		b := this.long
		tosend := "{blind}{" . b . " up}"	
		send %tosend%
	}

}

class longDontRepeat extends clay
{
	LP_shortUp(button)
	{
		b := this.short
		tosend := "{blind}{" . b . " down}"	
		send %tosend%
		tosend := "{blind}{" . b . " up}"	
		send %tosend%
		
	}
	LP_held(button)
	{
		
		b := this.long
		tosend := "{blind}{" . b . " down}"	
		send %tosend%
	}
	LP_longUp(button)
	{
		b := this.long
		tosend := "{blind}{" . b . " up}"	
		send %tosend%
	}
}

class longDontRepeatChord
{
	LP_shortUp(button)
	{
		b := this.short
		tosend := "{blind}{" . b . " down}"	
		send %tosend%
		tosend := "{blind}{" . b . " up}"	
		send %tosend%
		
	}
	LP_held(button)
	{
		
		b := this.long
		tosend := "{blind}{" . b . " down}"	
		send %tosend%
	}
	LP_longUp(button)
	{
		b := this.long
		tosend := "{blind}{" . b . " up}"	
		send %tosend%
	}
}

class longRepeatChord extends longDontRepeatChord
{
	LP_repeat(button)
	{
		this.LP_held(button)
	}

}



class longCandid extends longRepeat
{
	LP_init()
	{
		this.long := this.LP_button
	}
} 


class shortCandid extends longRepeat
{
	LP_init()
	{
		this.short := this.LP_button
	}
} 

class shortRepeatChord
{
	LP_repeat(button)
	{
		this.LP_longRepeat(button)
	}
	LP_shortUp(button)
	{
		b := this.short
		tosend := "{blind}{" . b . " down}"	
		send %tosend%
		tosend := "{blind}{" . b . " up}"	
		send %tosend%
		
	}
	LP_longRepeat(button)
	{
	
		b := this.short
		tosend := "{blind}{" . b . " down}"	
		send %tosend%	
	}
	LP_longUp(button)
	{
		b := this.short
		tosend := "{blind}{" . b . " up}"	
		send %tosend%
	}
}

class dontRepeatChord
{
	LP_shortUp(button)
	{
		b := this.short
		tosend := "{blind}{" . b . " down}"	
		send %tosend%
		tosend := "{blind}{" . b . " up}"	
		send %tosend%
		
	}
	LP_held(button)
	{
	
		b := this.short
		tosend := "{blind}{" . b . " down}"	
		send %tosend%	
	}
	LP_longUp(button)
	{
		b := this.short
		tosend := "{blind}{" . b . " up}"	
		send %tosend%
	}
}

parents := {}
parents.longRepeat := {button:longRepeatChord, dontRepeat:longRepeatChord,word:shortWordLongRepeatChord,string:shortStringLongRepeatChord}
parents.longWord := {button:longWordChord, dontRepeat:longWordChord,word:wordChord,string:shortStringLongWordChord}
parents.longString := {button:longStringChord, dontRepeat:longStringChord,word:shortWordLongStringChord,string:stringChord}
parents.longNull := {button:shortRepeatChord, dontRepeat:dontRepeatChord, word:shortWordChord,string:shortStringChord}
parents.longDontRepeat := {button:longDontRepeatChord, dontRepeat:longDontRepeatChord,word:shortWordLongDontRepeatChord,string:shortStringLongDontRepeatChord}



class orphanChord
{

	
	LP_init()
	{

	global parents

		this.setShortLong()
		if(this.long==null)
		{

			b:=parents.longNull
		}
		else if (this.long.hasKey(1))
		{
				b:=parents.longWord
		}
		else if (this.long.haskey("string"))
		{
				b:=parents.longString
				this.long := this.long.string
		}
		else if (this.long.hasKey("dontRepeat"))
		{
			b:=parents.longDontRepeat
			this.long := this.long.dontRepeat
		}
		else
		{
			b:=parents.longRepeat
		}
		

		if (this.short.hasKey(1))
		{

			b:=b.word

		}
		else if (this.short.hasKey("string"))
		{

			b:=b.string
			this.short := this.short.string
		}
		else if (this.short.hasKey("dontRepeat"))
		{
			this.short := this.short.dontRepeat
			b:=b.dontRepeat
		}
		else
		{
			b:=b.button
		}
		
		this.base := b
	}

}

class shortStringChord
{
	LP_shortUp(button)
	{
		b := this.short
		send %b%
	}
	LP_held(button)
	{
		this.LP_shortUp(button)
	}	
}

class shortWordChord
{
	LP_shortUp(button)
	{
		sendWord(this.short)
	}
	
	LP_held(button)
	{
		sendWord(this.short)
	}	
}

class longStringChord
{
	LP_shortUp(button)
	{
		b := this.short
		tosend := "{blind}{" . b . " down}"	
		send %tosend%
		tosend := "{blind}{" . b . " up}"	
		send %tosend%
		
	}
	LP_held(button)
	{
		b := this.long
		send %b%
	}

}

class longWordChord extends wordChord
{
	LP_shortUp(button)
	{
		b := this.short
		tosend := "{blind}{" . b . " down}"	
		send %tosend%
		tosend := "{blind}{" . b . " up}"	
		send %tosend%
		
	}
}

class shortWordLongStringChord extends wordChord
{

	LP_held(button)
	{
		b := this.long
		;tosend := "{blind}" . b	
		send %b%
	}	
}

sendWord(w)
{
	if (getKeyState("ctrl")||getKeyState("alt")||getKeyState("win"))
		return
	if (getKeyState("shift"))
	{
		b:=w[1]
		if(b.hasKey("string"))
		{
			b:=b.string
			send %b%
		}
		else 
		{
			if (b.hasKey(1))
			{
				b:=b[1]
			}
			tosend := "{blind}" . b
			send %tosend%
		}

		l:=w.maxIndex()
		i:=2
		while i<=l
		{
			v:=w[i]
			if(v.hasKey("string"))
			{
				b:=v.string
				send %b%
			}
			if (v.hasKey(1))
			{
				b := v[1]
				b:= "{blind}" . b
				send %b%
			}
			else
			{
				
				send %v%
			}
			i++
		}	
		
	}
	else
	{
		for k,v in w
		{
			if(v.hasKey("string"))
			{
				v:=v.string
				send %v%
			}
			else
			{
				if (v.hasKey(1))
				{
					v := v[1]
				}

				tosend := "{blind}" . v
				send %tosend%
			}
		}
	}	
}

class wordChord
{
	LP_shortUp(button)
	{
		sendWord(this.short)
	}
	
	LP_held(button)
	{
		sendWord(this.long)
	}	
}

class shortStringLongWordChord extends wordChord
{
	LP_shortUp(button)
	{
		b := this.short
		send %b%
	}
}

class shortStringLongRepeatChord extends longRepeatChord
{
	LP_shortUp(button)
	{
		b := this.short
		send %b%
	}
}

class shortStringLongDontRepeatChord extends longDontRepeatChord
{
	LP_shortUp(button)
	{
		b := this.short
		send %b%
	}
}

class shortWordLongRepeatChord extends longRepeatChord
{
	LP_shortUp(button)
	{
		sendWord(this.short)
	}
}

class shortWordLongDontRepeatChord extends longDontRepeatChord
{
	LP_shortUp(button)
	{
		sendWord(this.short)
	}
}

class stringChord
{
	LP_shortUp(button)
	{
		b := this.short
		send %b%
	}
	LP_held(button)
	{
		b := this.long
		;tosend := "{blind}" . b	
		send %b%
	}	
}



class LP_modes 
{

	class default
	{


		class numpadSub extends clay
		{
			short := "printscreen"
			LP_shortUp()
			{
				b := this.short
				tosend := "{blind}{" . b . " down}"	
				send %tosend%
				tosend := "{blind}{" . b . " up}"	
				send %tosend%
				
			}
			LP_held()
			{
				send {blind}^x
			}

		}
		
		class numpadMult extends clay
		{
			LP_shortUp()
			{
				send {LButton}{LButton}
				send ^c
			}
			LP_held()
			{
				send {LButton}{LButton}{LButton}
				send ^c
			}


			
		}
		
		class numpadAdd extends clay
		{
			LP_shortUp()
			{
				send {blind}#v
			}
			LP_held()
			{
				send {blind}^v
			}

			LP_repeat()
			{
				this.LP_held()
			}

			
		}
		
		class capslock extends clay
		{
			LP_shortUp()
			{
				SetCapsLockState % !GetKeyState("CapsLock", "T")
			}
	
			LP_held()
			{
				send {blind}{insert down}
			}
			LP_longUp()
			{
				send {blind}{insert up}
			}
			

			
		}
		
		class numlock extends clay
		{
			LP_shortUp()
			{
				SetNumLockState % !GetKeyState("NumLock", "T")
			}
			LP_held()
			{
				SetScrollLockState % !GetKeyState("ScrollLock", "T")
			}



					
		
		
		}

		class end extends shortCandid
		{
			long := "home"
		}
/*
		class Esc extends shortCandid
		{
			long := "Del"
		}
*/

		class leftMiddleFinger
		{
			LP_Buttons := ["n","i","m"]
			longs := [["n","e","v","e","r"], StrSplit("issue"), StrSplit("monitor")]
			top2 := ","
			top2long := null
			bottom2 := "f3"
			bottom2long := "f9"
		
			class ooi extends orphanChord
			{
				setShortLong()
				{
					this.long:=this.LP_containingClassInstance.longs[3]
					this.short:=this.LP_containingClassInstance.LP_Buttons[3]
				}
			}	
			

					
			
			
			class oio extends orphanChord
			{
				setShortLong()
				{
					this.long:=this.LP_containingClassInstance.longs[2]
					this.short:=this.LP_containingClassInstance.LP_Buttons[2]
				}
			}	
			class oii extends orphanChord
			{
				setShortLong()
				{
					this.long:=this.LP_containingClassInstance.bottom2long
					this.short:=this.LP_containingClassInstance.bottom2
				}
			}	
			class ioo extends orphanChord
			{
				
				setShortLong()
				{
					this.long:=this.LP_containingClassInstance.longs[1]
					this.short:=this.LP_containingClassInstance.LP_Buttons[1]
				}
			}		
			class ioi
			{
				LP_shortUp(button)
				{
					send wowzers
				}	
				LP_longUp(button)
				{
					send wowzers
				}
			}	
			class iio extends orphanChord
			{
				setShortLong()
				{
					this.long:=this.LP_containingClassInstance.top2long
					this.short:=this.LP_containingClassInstance.top2
				}
			}
			class iii 
			{
				LP_shortUp(button)
				{
					send holy shnikes
				}	
				LP_longUp(button)
				{
					send holy shnikes
				}
			}

		}
		
		class leftIndexFingerUpper
		{
			LP_Buttons := ["6","4"]
			longs := [null,null]
			both  := "."
			bothLong := "\"
			class oi extends orphanChord
			{
				setShortLong()
				{
					this.long:=this.LP_containingClassInstance.longs[2]
					this.short:=this.LP_containingClassInstance.LP_Buttons[2]
				}
			}	
			class io extends orphanChord
			{
				setShortLong()
				{
					this.long:=this.LP_containingClassInstance.longs[1]
					this.short:=this.LP_containingClassInstance.LP_Buttons[1]
				}
			}	
			class ii extends orphanChord
			{
				setShortLong()
				{
					this.long:=this.LP_containingClassInstance.bothLong
					this.short:=this.LP_containingClassInstance.both
				}
			}

		}
		

		
		class leftMiddleFingerUpper extends LP_modes.default.leftIndexFingerUpper
		{
			LP_Buttons := ["5","3"]
			longs := [null,null]
			both := ","
			bothLong := "["
		}
		
		class rightMiddleFingerUpper extends LP_modes.default.leftIndexFingerUpper
		{
			LP_Buttons := ["0","8"]
			longs := [null,null]
			both := "="
			bothLong := "]"
		}
		
		class rightIndexFingerUpper extends LP_modes.default.leftIndexFingerUpper
		{
			LP_Buttons := ["9","7"]
			longs := [null,null]
			both := "-"
			bothLong := "/"
		}
		
		class leftRingFinger extends LP_modes.default.leftMiddleFinger
		{
			LP_Buttons := ["l","a","w"]
			longs := [StrSplit("limit"), StrSplit("always"), StrSplit("works")]
			top2 := ";"
			top2long := null
			bottom2 := "f2"
			bottom2long := "f8"

		}
		
		
		class rightMiddleFinger extends LP_modes.default.leftMiddleFinger
		{
			LP_Buttons := ["d","g","b"]
			longs := ["j", "q", StrSplit("broken")]
			top2 := "="
			top2long := null
			bottom2 := "f6"
			bottom2long := "f12"

		}
		
		class leftIndexFinger extends LP_modes.default.rightIndexFinger
		{
			LP_Buttons := ["s","e","f","y"]
			longs := ["z", StrSplit("every"), "v", StrSplit("yesterday")]
			top2 := "."
			top2long := null
			bottom2 := "f4"
			bottom2long := "f10"
			middle2 := "["
			middle2long := null
			top3 := {string:"🐦"}
			top3long := {string:"🐧"}
			bottom3 := {string:"🕊"}
			bottom3Long := {string:"🦅"}
			topSide := "``"
			topSideLong := null
			bottomSide := "\"
			bottomSideLong := null
		}
		
		class rightIndexFinger
		{
			LP_Buttons := ["t","c","p","h"]
			longs := [StrSplit("tomorrow"), "k", StrSplit("permanent"), "x"]
			top2 := "-"
			top2long := null
			bottom2 := "f5"
			bottom2long := "f11"
			middle2 := "]"
			middle2long := null
			top3 := {string:"🦍"}
			top3long := {string:"🐒"}
			bottom3 := {string:"🦧"}
			bottom3Long := {string:"🦥"}
			topSide := "'"
			topSideLong := null
			bottomSide := "/"
			bottomSideLong := null
			
			class oooi extends orphanChord
			{
				setShortLong()
				{
					this.long:=this.LP_containingClassInstance.longs[4]
					this.short:=this.LP_containingClassInstance.LP_Buttons[4]
				}
			}	
			class ooio extends orphanChord
			{
				setShortLong()
				{
					this.long:=this.LP_containingClassInstance.longs[3]
					this.short:=this.LP_containingClassInstance.LP_Buttons[3]
				}
			}	
			class ooii extends orphanChord
			{
				setShortLong()
				{
					this.long:=this.LP_containingClassInstance.bottomSideLong
					this.short:=this.LP_containingClassInstance.bottomSide
				}
			}	
			class oioo extends orphanChord
			{
				
				setShortLong()
				{
					this.long:=this.LP_containingClassInstance.longs[2]
					this.short:=this.LP_containingClassInstance.LP_Buttons[2]
				}
			}		
			class oioi extends orphanChord
			{
				setShortLong()
				{
					this.long:=this.LP_containingClassInstance.middle2long
					this.short:=this.LP_containingClassInstance.middle2
				}
			}	
			class oiio extends orphanChord
			{
				setShortLong()
				{
					this.long:=this.LP_containingClassInstance.bottom2long
					this.short:=this.LP_containingClassInstance.bottom2
				}
			}
			class oiii extends orphanChord
			{
				setShortLong()
				{
					this.long:=this.LP_containingClassInstance.bottom3long
					this.short:=this.LP_containingClassInstance.bottom3
				}
			}
			class iooo extends orphanChord
			{
				setShortLong()
				{
					this.long:=this.LP_containingClassInstance.longs[1]
					this.short:=this.LP_containingClassInstance.LP_Buttons[1]
				}
			}
			class iooi extends orphanChord
			{
				setShortLong()
				{
					this.long:=this.LP_containingClassInstance.topSidelong
					this.short:=this.LP_containingClassInstance.topSide
				}
			}
			class ioio extends orphanChord
			{
				setShortLong()
				{
					this.long:=StrSplit("how the heck did you do that?")
					this.short:=StrSplit("how the heck did you do that?")
				}
			}
			class ioii extends orphanChord
			{
				setShortLong()
				{
					this.long:=StrSplit("how the heck did you do that?")
					this.short:=StrSplit("how the heck did you do that?")
				}
			}
			class iioo extends orphanChord
			{
				setShortLong()
				{
					this.long:=this.LP_containingClassInstance.top2long
					this.short:=this.LP_containingClassInstance.top2
				}
			}
			class iioi extends orphanChord
			{
				setShortLong()
				{
					this.long:=this.LP_containingClassInstance.top3long
					this.short:=this.LP_containingClassInstance.top3
				}
			}
			class iiio extends orphanChord
			{
				setShortLong()
				{
					this.long:=StrSplit("how the heck did you do that?")
					this.short:=StrSplit("how the heck did you do that?")
				}
			}
			class iiii extends orphanChord
			{
				setShortLong()
				{
					this.long:=StrSplit("how the heck did you do that?")
					this.short:=StrSplit("how the heck did you do that?")
				}
			}


		}
		
		class leftPinky extends LP_modes.default.leftMiddleFinger
		{
			LP_Buttons := ["r","o","u"]
			longs := [StrSplit("restore"), StrSplit("object"), StrSplit("understand")]
			top2 := "esc"
			top2long := null
			bottom2 := "f1"
			bottom2long := "f7"

		}
	
		
	}
	
/*	
	class test
	{
		class p
		{
			LP_down()
			{
				send this is a test
			}
		}
	}
*/	

}

#include ..\..underTheHood\longpressify.ahk
LP_.activate("default")













;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;cursor stuff;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
f:=1
down:=false

press()
{
	global down
	if(!down)
		toggle()
	down:=true
}

release()
{
	global down
	down:=false
	toggle()
}

hotkey,pause, press


hotkey, pause up, release

hotkey, AppsKey, toggle




SetTimer, WatchAxis, 20
return



WatchAxis:
JoyX := GetKeyState("JoyX")  ; Get position of X axis.
JoyY := GetKeyState("JoyY")  ; Get position of Y axis.
;tooltip, %JoyR%
deadx := 0
deady := 0
;e := 1.4
x := JoyX - 50 
y := JoyY - 50

x:=f*x/4
y:=f*y/4
SetMouseDelay, -1
DllCall("mouse_event",uint,1,int, x ,int, y,uint,0,int,0)
return



toggle()
{
	global f
	if (f==1)
		f:=5
	else
		f:=1
}
             
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pgup::WheelUp
pgdn::WheelDown




~!#,::
if (LP_modes.LP_instance.default.LP_isActive)
{
	LP_.deactivate("default")
}
else
{
	LP_.activate("default")
}
return





~!#.::
ExitApp
return 
