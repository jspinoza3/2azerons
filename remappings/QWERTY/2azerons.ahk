


class NoRepeatButton
{
	LP_msTillLong := -1
	LP_msTillRepeat := -1
	
	LP_down(button)
	{
		b := this.button
		tosend := "{blind}{" . b . " down}"	
		send %tosend%
	
	}
	LP_shortUp(button)
	{
		b := this.button
		tosend := "{blind}{" . b . " up}"	
		send %tosend%
	}
	LP_shortOver(button)
	{
		b := this.button
		tosend := "{blind}{" . b . " up}"	
		send %tosend%
	}
}	
	
class RepeatButtonChord
{
	LP_msTillLong := 400
	LP_msTillRepeat := -1
	

	LP_shortUp(button)
	{
		b := this.button
		tosend := "{blind}{" . b . " down}"	
		send %tosend%
		tosend := "{blind}{" . b . " up}"	
		send %tosend%
	}

	LP_longRepeat(button)
	{
		b := this.button
		tosend := "{blind}{" . b . " down}"	
		send %tosend%				
	}
	LP_longUp(button)
	{
		b := this.button
		tosend := "{blind}{" . b . " up}"	
		send %tosend%				
	}
	
	LP_init()
	{
		if (this.hasKey("index"))
		{
			this.button := this.LP_containingClassInstance.LP_Buttons[this.index]
		}
	}
}	



		
class  NonIndexFingerCG
{
	
		
	class ioo extends RepeatButtonChord
	{
		index := 1
	}			

	class oio extends RepeatButtonChord
	{
		index := 2
	}				
	class ooi extends RepeatButtonChord
	{
		index := 3
	}		
}


class longRepeat
{
	LP_msTillLong :=300
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

class LP_modes 
{

	class typing
	{

		class rightIndexFinger
		{
			LP_Buttons := ["u","j","m","h"]
			
			
			class iioo extends NoRepeatButton
			{
				button := "RShift"
			}			
			class iooo extends longRepeat
			{
				long := "y"
				short := "u"
				
			}			
		
			class oioo extends RepeatButtonChord
			{
				index := 2
			}				
			class ooio extends RepeatButtonChord
			{
				index := 3
			}		
			class oooi extends RepeatButtonChord
			{
				index := 4
			}		
			class ooii extends RepeatButtonChord
			{
				button := "="
			}			
			class oiio extends RepeatButtonChord
			{
				button := "'"
			}			
			class oioi extends RepeatButtonChord
			{
				button := "``"
			}			
			;class iooi extends RepeatButtonChord{}			
		}
		
		class rightMiddleFinger extends NonIndexFingerCG
		{
			LP_Buttons := ["i","k",","]
			
			class iio extends NoRepeatButton
			{
				button := "RCtrl"
			}			

			class oii extends RepeatButtonChord
			{
				button := "["
			}		

		}
		
		
		class rightRingFinger extends NonIndexFingerCG
		{
			LP_Buttons := ["o","l","."]
			
			class iio extends NoRepeatButton
			{
				button := "WIN"
			}			

			class oii extends RepeatButtonChord
			{
				button := "]"
			}		

		}
		
		class rightPinkyFinger extends NonIndexFingerCG
		{
			LP_Buttons := ["p",";","/"]
			
			class iio extends NoRepeatButton
			{
				button := "RAlt"
			}			

			class oii extends RepeatButtonChord
			{
				button := "\"
			}		
			

		}	
	

	}

	class mouse
	{
	
		class six
		{
				LP_msTillLong := -1
				LP_msTillRepeat := -1
							    
		

				LP_shortUp(button)
				{
					
					send  ^c
				}
		}
		class seven 
		{
				LP_msTillLong := -1
				LP_msTillRepeat := -1
							    
		

				LP_shortUp(button)
				{
					
					send  ^v
				}
		}	
		class eight
		{
				LP_msTillLong := -1
				LP_msTillRepeat := -1
							    
		

				LP_shortUp(button)
				{
					
					send  #v
				}
		}	
		class h 
		{
				LP_msTillLong := -1
				LP_msTillRepeat := -1
							    
		

				LP_shortUp(button)
				{
					
					send  {LButton}
					if (LP_modes.LP_instance.mouse.LP_isActive)
					{
						LP_.deactivate("mouse")
						LP_.activate("typing")
					}
				}
		}
		
		 class rightIndexFinger
		{
			LP_Buttons := ["u","j","m"]
			
			
			class iio extends NoRepeatButton
			{
				button := "rshift"
		  	}	

			class ioo
			{
				LP_msTillLong := -1
				LP_msTillRepeat := -1
							    
		

				LP_shortUp(button)
				{
					send {rshift down}
					send  {LButton}
					send {rshift up}
				}
				 
			}	


			class oio extends NoRepeatButton
			{
				button := "LButton"
			}
						
			class oii extends RepeatButtonChord
			{
				button := "'"
			}	

			class ooi
			{
				LP_msTillLong := 200
				LP_msTillRepeat := -1
				

				LP_shortUp(button)
				{
					send {blind}{WheelLeft}	
				}

				LP_longRepeat(button)
				{
					send {blind}{WheelLeft}				
				}
				
			}	
		
				
		}
		
		class rightMiddleFinger
		{
			LP_Buttons := ["i","k",","]
			
			class ioo
			{
				LP_msTillLong := 400
				LP_msTillRepeat := -1
				

				LP_shortUp(button)
				{
					send {blind}{WheelUp}	
				}

				LP_longRepeat(button)
				{
					send {blind}{WheelUp}				
				}
				
			}	
			
			class iio extends NoRepeatButton
			{
				button := "rctrl"
			}	

	


			class oio extends NoRepeatButton
			{
				button := "RButton"
			}

			class oii extends RepeatButtonChord
			{
				button := "["
			}	
			
			class ooi
			{
				LP_msTillLong := 200
				LP_msTillRepeat := -1
				

				LP_shortUp(button)
				{
					send {blind}{WheelDown}	
				}

				LP_longRepeat(button)
				{
					send {blind}{WheelDown}				
				}
				
			}			
				
		}
	
		
		class rightRingFinger
		{
			LP_Buttons := ["o","l","."]
			
			class ioo
			{
				LP_msTillLong := 400
				LP_msTillRepeat := -1
				

				LP_shortUp(button)
				{
					cursorSpeed.increase()	
				}

				LP_longRepeat(button)
				{
					cursorSpeed.increase()				
				}
				
			}	
			
			class iio extends NoRepeatButton
			{
				button := "rwin"

			}	
			
			
			

	


			class oio
			{
				LP_msTillLong := -1
				LP_msTillRepeat := -1
				
				LP_down(button)
				{
					cursorSpeed.toggle()
				
				}
				LP_shortUp(button)
				{
					cursorSpeed.toggle()
				}
				LP_shortOver(button)
				{
					cursorSpeed.toggle()
				}
			}

			class oii extends RepeatButtonChord
			{
				button := "]"
			}	
			
			class ooi
			{
				LP_msTillLong := 400
				LP_msTillRepeat := -1
				

				LP_shortUp(button)
				{
					cursorSpeed.decrease()	
				}

				LP_longRepeat(button)
				{
					cursorSpeed.decrease()				
				}
				
			}		
				
		}
		 class rightPinkyFinger
		{
			LP_Buttons := ["p",";","/"]
			
			
			class iio extends NoRepeatButton
			{
				button := "ralt"
		  	}	

			class ioo
			{
				LP_msTillLong := -1
				LP_msTillRepeat := -1
							    
		

				LP_shortUp(button)
				{
					send {rctrl down}
					send  {LButton}
					send {rctrl up}
				}
				 
			}	


			class oio extends NoRepeatButton
			{
				button := "MButton"
			}
						
			class oii extends RepeatButtonChord
			{
				button := "\"
			}	

			class ooi
			{
				LP_msTillLong := 320
				LP_msTillRepeat := -1
				

				LP_shortUp(button)
				{
					send {blind}{WheelRight}	
				}

				LP_longRepeat(button)
				{
					send {blind}{WheelRight}				
				}
				
			}	
		
				
		}		
	
	}
	
	

	
    class left13
	{

		class leftIndexFinger
		{
			LP_Buttons := ["r","f","v","g"]
			
			class iioo extends NoRepeatButton
			{
				button := "Lshift"
			}			
			class iooo extends longRepeat
			{
				long := "t"
				short := "r"
				
			}			
		
			class oioo extends RepeatButtonChord
			{
				index := 2
			}				
			class ooio extends RepeatButtonChord
			{
				index := 3
			}		
			class oooi extends RepeatButtonChord
			{
				index := 4
			}		
			class ooii extends RepeatButtonChord
			{
				button := "-"
			}			
			class oiio extends RepeatButtonChord
			{
				button := "end"
			}			
			class oioi extends RepeatButtonChord
			{
				button := "delete"
			}			
			;class iooi extends RepeatButtonChord{}			
		}
		
		class leftMiddleFinger extends NonIndexFingerCG
		{
			LP_Buttons := ["e","d","c"]
			
			class iio extends NoRepeatButton
			{
				button := "LCtrl"
			}			

			class oii extends RepeatButtonChord
			{
				button := "home"
			}		

		}
		
		
		class leftRingFinger extends NonIndexFingerCG
		{
			LP_Buttons := ["w","s","x"]
			
			class iio extends NoRepeatButton
			{
				button := "LWin"
			}			

			class oii extends RepeatButtonChord
			{
				button := "insert"
			}		
			

		}
		
		class leftPinkyFinger extends NonIndexFingerCG
		{
			LP_Buttons := ["q","a","z"]
			
			class iio extends NoRepeatButton
			{
				button := "LAlt"
			}			

			class oii
			{
				
				LP_shortUp()
				{
					SetCapsLockState % !GetKeyState("CapsLock", "T")
				}
				LP_held()
				{
					SetNumLockState % !GetKeyState("NumLock", "T")
				}
			}		
			

		}
	

	}	
	
	
	
	
	class left13FunctionKeys
	{

		class leftIndexFinger
		{
			LP_Buttons := ["r","f","v","g"]
			
			class iioo extends NoRepeatButton
			{
				button := "Lshift"
			}			
			class iooo extends RepeatButtonChord
			{
				button := "f12"
				
			}			
		
			class oioo extends RepeatButtonChord
			{
				button := "f8"
			}				
			class ooio extends RepeatButtonChord
			{
				button := "f4"
			}		
			class oooi extends RepeatButtonChord
			{
				button := "f13"
			}		
			class ooii extends RepeatButtonChord
			{
				button := "-"
			}			
			class oiio extends RepeatButtonChord
			{
				button := "end"
			}			
			class oioi extends RepeatButtonChord
			{
				button := "delete"
			}			
			;class iooi extends RepeatButtonChord{}			
		}
		
		class leftMiddleFinger
		{
			LP_Buttons := ["e","d","c"]
			
			class iio extends NoRepeatButton
			{
				button := "LCtrl"
			}			
			class ioo extends RepeatButtonChord
			{
				button := "f11"
			}			
		
			class oio extends RepeatButtonChord
			{
				button := "f7"
			}				
			class ooi extends RepeatButtonChord
			{
				button := "f3"
			}		
			class oii extends RepeatButtonChord
			{
				button := "home"
			}		

		}
		
		
		class leftRingFinger
		{
			LP_Buttons := ["w","s","x"]
			
			class iio extends NoRepeatButton
			{
				button := "LWin"
			}			
			class ioo extends RepeatButtonChord
			{
				button := "f10"
			}			
			class oio extends RepeatButtonChord
			{
				button := "f6"
			}				
			class ooi extends RepeatButtonChord
			{
				button := "f2"
			}	
			class oii extends RepeatButtonChord
			{
				button := "insert"
			}		
			

		}
		
		class leftPinkyFinger
		{
			LP_Buttons := ["q","a","z"]
			
			class iio extends NoRepeatButton
			{
				button := "LAlt"
			}			
			class ioo extends RepeatButtonChord
			{
				button := "f9"
			}			
		
			class oio extends RepeatButtonChord
			{
				button := "f5"
			}				
			class ooi extends RepeatButtonChord
			{
				button := "f1"
			}	
			class oii
			{
				
				LP_shortUp()
				{
					SetCapsLockState % !GetKeyState("CapsLock", "T")
				}
				LP_held()
				{
					SetNumLockState % !GetKeyState("NumLock", "T")
				}
			}		
			

		}
	

	}	
	
	class alwaysOn
	{

		
												  
		class pause
		{
		
			LP_shortUp()
			{
				if (LP_modes.LP_instance.mouse.LP_isActive)
				{
					LP_.deactivate("mouse")
					LP_.activate("typing")
				}
			}
			LP_held()
			{
				if (!LP_modes.LP_instance.mouse.LP_isActive)
				{
					LP_.deactivate("typing")
					LP_.activate("mouse")
				}
			}

		}
		
		class AppsKey
		{
		
			LP_msTillLong:=-1
			LP_msTillRepeat:=-1
			LP_shortUp()
			{
				send {blind}{printscreen up}
			}
			LP_down()
			{
				send {blind}{printscreen down}
			}
			LP_shortRepeat()
			{
				send {blind}{printscreen down}
			}

		}
		
		
		
        class scrolllock
		{
			LP_msTillLong:=-1
			LP_msTillRepeat:=-1
			LP_shortUp()
			{
				setFKeysState(false)
			}
			LP_down()
			{
				setFKeysState(true)
			}	
		}

        class pgup
		{
			LP_msTillLong:=-1
			LP_msTillRepeat:=-1
			LP_shortUp()
			{
				cursorSpeed.toggle()
			}
		}

	}
	
	
	

}




class cursorSpeed
{
	static current:=2/16
	static other:=2/5
	static coolDown:=0
	toggle()
	{
		temp := cursorSpeed.current
		cursorSpeed.current := cursorSpeed.other
		cursorSpeed.other := temp
	}
	
	
	increase()
	{
		cursorSpeed.current *= 1.5
	}
	
	decrease()
	{
		cursorSpeed.current /= 1.5
	}

}


#include ..\..\underTheHood\longpressify.ahk

startErUp()

startErUp()
{
		LP_.activate("mouse")
		LP_.activate("left13")
		LP_.activate("alwaysOn")
		SetTimer, WatchAxis, 20
		
}

toggleRemapping()
{

	if (LP_modes.LP_instance.left13FunctionKeys.LP_isActive)
		LP_.deactivate("left13FunctionKeys")
	else if (LP_modes.LP_instance.left13.LP_isActive)
	{
		LP_.deactivate("left13")
	}
	else
	{
		startErUp()
		return
	}
	SetTimer, WatchAxis, off
	if (LP_modes.LP_instance.mouse.LP_isActive)
	{
		LP_.deactivate("mouse")
	}
	else
	{
		LP_.deactivate("typing")
	}
	
	LP_.deactivate("alwaysOn")


}









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;cursor stuff;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


return



WatchAxis:
JoyX := GetKeyState("JoyX")  ; Get position of X axis.
JoyY := GetKeyState("JoyY")  ; Get position of Y axis.
;tooltip, %JoyR%
;deadx := 0
;deady := 0
;e := 1.4
x := JoyX - 50 
y := JoyY - 50
x:=cursorSpeed.current*x
y:=cursorSpeed.current*y
if (x<.5 && x>-.5 && y<.5 && y>-.5)
	return
	
if (!LP_modes.LP_instance.mouse.LP_isActive && cursorSpeed.coolDown==0)
{
	LP_.deactivate("typing")
	LP_.activate("mouse")
	cursorSpeed.coolDown :=20
}
else if (cursorSpeed.coolDown>0)
{
	cursorSpeed.coolDown--
}

SetMouseDelay, -1
DllCall("mouse_event",uint,1,int, x ,int, y,uint,0,int,0)
return


/*
f1::f13
f2::f14
f3::f15
f4::f16
f5::f17
*/




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






setFKeysState(b)
{
	isActive := LP_modes.LP_instance.left13FunctionKeys.LP_isActive
	if (isActive == b)
		return
	if (b)
	{
		LP_.deactivate("left13")
		LP_.activate("left13FunctionKeys")
	}
	else
	{
		LP_.deactivate("left13FunctionKeys")
		LP_.activate("left13")
	}
}




/*
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
*/




~!#.::
ExitApp
return 


~!#,::
	toggleRemapping()
return
