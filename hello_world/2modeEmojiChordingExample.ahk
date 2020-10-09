
	
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
			LP_Buttons := ["o","p"]

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
			LP_Buttons := ["o","p"]
			LP_shouldDelayDeactivation(isDown,timing) ;up,down, change policy, mode
			{
				return true
			}
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
				  this.LP_containingClassInstance.LP_switchDelayPolicyForCurrentDeactivation()
				}
				LP_held()
				{
				  send 👶
				}
			}	

		}
		
	/*	
		class numpad4
		{

				LP_down()
				{
				  send eah
				}
				LP_shortUp()
				{
				  send budd
				}

				LP_longUp()
				{
				  send budd
				}
		}
		class numpadleft
		{
				LP_down()
				{
				  send ohhhh
				}
				LP_shortUp()
				{
				  send shit
				}

				LP_longUp()
				{
				  send shit
				}
		}
		*/
 }
}

#include ..\longpressify.ahk
LP_activate("creatureMode")
LP_activate("persist")
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