#Persistent  ; Keep this script running until the user explicitly exits it.
f:=1
SetTimer, WatchAxis, 20
return



WatchAxis:
JoyX := GetKeyState("JoyX")  ; Get position of X axis.
JoyZ := GetKeyState("JoyZ")  ; Get position of Z axis.
JoyR := GetKeyState("JoyR")  ; Get position of R axis.
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
x:=f*x/4
y:=f*y/4
SetMouseDelay, -1
DllCall("mouse_event",uint,1,int, x ,int, y,uint,0,int,0)
return


pgup::WheelUp
pgdn::WheelDown

pause::
	f:=1
return

pause up::
	f:=3
return
~!#.::
ExitApp
return
