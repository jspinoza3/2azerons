#include ..\longpressify.ahk
	
class abstractChord extends LP_chord
{
    LP_longDuration := 300 ;overrides default of 400
    LP_repeatDuration := 400 ;overrides default of 600
}

active:="peopleMode"
LP_getActiveMode()
{
	global active
	
	return active
}
	

   
class LP_modes 
{

  class creatureMode
  {
		class leftMiddleFingerUpper extends LP_chordingGroup
		{
			LP_Buttons := ["f5","f4"]
			
			class oi extends abstractChord
			{
				LP_shortUp()
				{
				  send 🥚
				}
				LP_held()
				{
				  send 🦅
				}												
			}	
			class io extends abstractChord
			{
				LP_shortUp()
				{
				  send 🐍
				}
				LP_held()
				{
				  send 🐊
				}
			}	
				
			class ii extends abstractChord
			{
				LP_shortUp()
				{
				  send 🍳
				}
				LP_held()
				{
				  send 🐉
				}
			}	

		}
		
 }
 
  class peopleMode
  {
		class leftMiddleFingerUpper extends LP_chordingGroup
		{
			LP_Buttons := ["f5","f4"]
			
			class oi extends abstractChord
			{
				LP_shortUp()
				{
				  send 👦
				}
				LP_held()
				{
				  send 👨
				}												
			}	
			class io extends abstractChord
			{
				LP_shortUp()
				{
				  send 👧
				}
				LP_held()
				{
				  send 👩
				}
			}	
				
			class ii extends abstractChord
			{
				LP_shortUp()
				{
				  send 💕
				}
				LP_held()
				{
				  send 👶
				}
			}	

		}
 }
}


*f1::
if (active == "creatureMode")
	active := "peopleMode"
else
	active := "creatureMode"
return


~!#.::
ExitApp
return 