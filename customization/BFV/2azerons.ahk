﻿class clay
{
	LP_msTillLong := -1
	LP_msTillRepeat := -1
	LP_prefix := "~"
}


class cursor
{
				static fast:= 9
				static slow:=3/4
				static normal:=3
				static f:=3
}

class LP_modes 
{

	class default
	{

		
		class j extends clay
		{
			LP_down()
			{
				if(cursor.f==cursor.fast)
				{
					cursor.f:=cursor.normal
				}
				else
					cursor.f:=cursor.fast
				return
			}
		}
	
		class y extends clay
		{
			LP_down()
			{
				if(cursor.f==cursor.slow)
				{
					cursor.f:=cursor.normal
				}
				else
					cursor.f:=cursor.slow
				return
			}
		}
	
		class k extends clay
		{
				goLeft := true
				LP_down()
				{
				 
					prone()
					
					if(this.goLeft)
						setTimer, left180, -190
					else
						setTimer, right180, -190
					this.goLeft := !this.goLeft
				}	
	
		}
		
		
		
		class u extends clay
		{
				goLeft := true
				LP_down()
				{
				 
					scope()
					setTimer, peakLeft, -190
				}	

		}
		class o extends clay
		{
				goLeft := true
				LP_down()
				{
				 
					scope()
					setTimer, peakRight, -190
				}	

		}
		
		
			class m extends clay
			{
				LP_shortUp()
				{
					SetMouseDelay, -1
					DllCall("mouse_event",uint,1,int, -4134 ,int, 0,uint,0,int,0)
				}	
			}
			
			class period extends clay
			{
			
				LP_shortUp()
				{
					SetMouseDelay, -1
					DllCall("mouse_event",uint,1,int, 4134 ,int, 0,uint,0,int,0)
				}	
			}
			
			class comma extends clay
			{
				goLeft := true
				LP_down()
				{
					turnAround(this.goLeft)
					this.goLeft := !this.goLeft
				}	
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

left180()
{
	turnAround(true)
	prone()
}
prone()
{
	send {f13}
}
right180()
{
	turnAround(false)
	prone()
}

scope()
{
	send {f14}
}
peakLeft()
{
	send {f15}
}

peakRight()
{
	send {f16}
}

turnAround(goLeft)
{
					SetMouseDelay, -1
					DllCall("mouse_event",uint,1,int, goLeft?-8267:8267 ,int, 0,uint,0,int,0)
}

forward(down)
{
	
}

toggleVoip()
{
		if (getKeyState("f17"))
		{
			send {f17 up}
			SoundPlay, off.wav
		}
		else
		{
			send {f17 down}
			SoundPlay, on.wav
		}
}

#include ..\..\underTheHood\longpressify.ahk
LP_.activate("default")













;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;cursor stuff;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetTimer, WatchAxis, 10
return



WatchAxis:
JoyX := GetKeyState("JoyX")  ; Get position of X axis.
;JoyZ := GetKeyState("JoyZ")  ; Get position of Z axis.
;JoyR := GetKeyState("JoyR")  ; Get position of R axis.
JoyY := GetKeyState("JoyY")  ; Get position of Y axis.
;tooltip, %JoyR%
deadx := 0
deady := 0
;e := 1.4
x := JoyX - 50 
y := JoyY - 50

/*
if (y>40)
	y:=40
if (y<-40)
	y:=-40

if (x>40)
	x:=40
if (x<-40)
	x:=-40
   
if (Abs(x)>0)
	x:=(x/Abs(x))*1.11**Abs(x) ;x:=(x*(Abs(x)**(1/3)))
if (Abs(y)>0)
	y:=(y/Abs(y))*1.11**Abs(y) ;y:=(y*(Abs(y)**(1/3)))
*/



x:=cursor.f*x/4
y:=cursor.f*y/4
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
*pgup::wheelup
*pgdn::wheeldown
~i::scope()
~e::return

~e up::
toggleVoip()
return


~!#,::
if (LP_modes.LP_instance.default.LP_isActive)
{
	LP_.deactivate("default")
	cursor.f:=cursor.normal
}
else
{
	LP_.activate("default")
}
return





~!#.::
ExitApp
return 
