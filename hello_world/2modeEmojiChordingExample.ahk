/*
This script uses f4 and f5 to send emojis and uses f1 to switch modes. See diagram:
https://docs.google.com/drawings/d/161c4M-Gj9kyPLyaHVzja4ZpBg_vo8d4BV3e1tln-Uu8/edit
*/

class abstractChord
{
	
	LP_msTillLong := 500 
	LP_msTillRepeat := 600
}
   
class LP_modes 
{

  class creatureMode
  {
		class thisIsAChordingGroup
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
	
		class thisIsAChordingGroup
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

LP_.activate("creatureMode")
*f1::
if (LP_modes.LP_instance.creatureMode.LP_isActive)
{
	
	LP_.deactivate("creatureMode")
	LP_.activate("peopleMode")
/*
		SoundPlay, *-1
*/
}
else
{
	
	LP_.deactivate("peopleMode")
	LP_.activate("creatureMode")
/*
		SoundPlay, *-1
*/
}

return


~!#.::
ExitApp
return 