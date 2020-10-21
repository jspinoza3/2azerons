/*
WORK IN PROGRESS
This script uses H and W to send various actions and uses f1 to switch modes. the "hello" mode contains one nested class, a behaviour paradigm which describes the state machine in this diagram:
https://docs.google.com/drawings/d/1JijpUo575Bc2RLW65jbtVsHNbFz341wYJE1maVM_MEE/edit
*/

class abstractChord
{
	
	LP_msTillLong := 500 
	LP_msTillRepeat := 600
}
   
class LP_modes 
{

  class hello
  {
		class thisIsAChordingGroup
		{
			LP_Buttons := ["H","W"]

			class oi extends abstractChord
			{
				LP_down()
				{
					send hello
				}
				LP_shortRepeat()
				{

				}
				LP_shortUp()
				{

				}
				LP_held()
				{

				}
				LP_longRepeat()
				{

				}
				LP_longUp()
				{

				}
				LP_enterRepeatPhase()
				{

				}
				LP_repeat()
				{

				}
				LP_repeatUp()
				{

				}
				LP_shortOver()
				{
					send goodbye
				}
				LP_longOver()
				{

				}
				LP_repeatOver()
				{
				
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
 
  class goodbye
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

LP_.activate("hello")
*f1::
if (LP_modes.LP_instance.creatureMode.LP_isActive)
{
	
	LP_.deactivate("hello")
	LP_.activate("goodbye")
/*
		SoundPlay, *-1
*/
}
else
{
	
	LP_.deactivate("goodbye")
	LP_.activate("hello")
/*
		SoundPlay, *-1
*/
}

return


~!#.::
ExitApp
return 