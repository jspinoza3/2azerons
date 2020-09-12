#Persistent  ; Keep this script running until the user explicitly exits it.
SetTimer, WatchAxis, 5
return

jx := 0

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


SetMouseDelay, -1
DllCall("mouse_event",uint,1,int, x/2 ,int, y/2,uint,0,int,0)
return


pgup::WheelUp
pgdn::WheelDown

~!#.::
ExitApp
return
