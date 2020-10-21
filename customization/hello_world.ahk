/*

This script is designed to familiarize you with all the different handlers that can be defined in a behaviour paradigm. Run the script and use H and W on your keyboard in various combinations and durations of pressing to see when the handlers get called.  

The handlers are methods of classes nested inside of thisIsAChordingGroup, which is a chordingGroup behaviour paradigm and describes an instance of the state machine depicted in:
hello_world.svg
and also online:
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

			class io extends abstractChord
			{
				LP_down()
				{
					send hello
				}
				LP_shortRepeat()
				{
					send o
				}
				LP_shortUp()
				{
					send {space}there
				}
				LP_held()
				{
					send OOO
				}
				LP_longRepeat()
				{
					send {!}
				}
				LP_longUp()
				{
					this.LP_shortUp()
				}
				LP_enterRepeatPhase()
				{
					send 🖖
				}
				LP_repeat()
				{
					send 👋
				}
				LP_repeatUp()
				{
					send {space}My friend{!} Stay a while and listen
				}
				LP_shortOver()
				{
					send {space}{enter}
				}
				LP_longOver()
				{
					send {enter}{enter}
				}
				LP_repeatOver()
				{
					send {enter}{enter}{enter}
				}
			}	
			
	
			class oi extends abstractChord
			{
				globeSide:=1
				globes:=["🌎","🌏","🌍"]
				LP_down()
				{
					send w
				}
				LP_shortRepeat()
				{
					send o
				}
				LP_shortUp()
				{
					send orld
				}
				LP_held()
				{
					n:=this.LP_eventProcessor.shortPhaseRepeats
					;msgbox %n%
					while(n--)
					{
						send {bs}
					}
				}
				LP_longRepeat()
				{
					send 🌐
				}
				LP_longUp()
				{
					send 🌐rld
				}
				LP_enterRepeatPhase()
				{
					n:=this.LP_eventProcessor.longPhaseRepeats
					;msgbox %n%
					while(n--)
					{
						send {bs}
					}
				}
				LP_repeat()
				{
					this.sendGlobe()
					this.globeSide++
					if(this.globeSide>this.globes.count())
						this.globeSide:=1
				}
				sendGlobe()
				{
					s:= this.globes[this.globeSide]
					send %s%			
				}
				LP_repeatUp()
				{
					this.sendGlobe()
					send rld
				}
				LP_shortOver()
				{
					this.LP_shortUp()
					send {space}{enter}
				}
				LP_longOver()
				{
					this.LP_longUP()
					send {enter}{enter}
				}
				LP_repeatOver()
				{
					this.LP_repeatUp()
					send {enter}{enter}{enter}
				}
			}	
				
			class ii extends abstractChord
			{
				LP_down()
				{
				  send 👽
				}
			}	

		}
		
 }
  
}

#include ..\longpressify.ahk

LP_.activate("hello")

/*
*f1::
if (LP_modes.LP_instance.hello.LP_isActive)
{
	
	LP_.deactivate("hello")
	LP_.activate("goodbye")

}
else
{
	
	LP_.deactivate("goodbye")
	LP_.activate("hello")

}
*/
return


~!#.::
ExitApp
return 