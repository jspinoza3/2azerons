

active:="peopleMode"
LP_getActiveMode()
{
	global active
	
	return active
}
	
class abstractChord
{
	
	LP_longDuration := 600 
	LP_repeatDuration := 1200 
}
   
class LP_modes 
{

  class creatureMode
  {
		class leftMiddleFingerUpper
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
		class leftMiddleFingerUpper
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

#include ..\longpressify.ahk
LP_activate("creatureMode")
*f1::
if (LP_modes.LP_instance.creatureMode.LP_isActive)
{
	LP_deactivate("creatureMode")
	LP_activate("peopleMode")
}
else
{
	LP_deactivate("peopleMode")
	LP_activate("creatureMode")
}
return


~!#.::
ExitApp
return 