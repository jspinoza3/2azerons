/*
write comments here
*/

class abstractButton
{
	
	LP_msTillLong := -1 
	LP_msTillRepeat := -1
}
   
class LP_modes 
{

  class creatureMode
  {
            class u extends abstractButton
            {
                LP_down()
                {
                  send {2 down}
                }
                LP_shortUp()
                {
                  send {2 up}
                }  

				LP_shortRepeat()
				{
					send {2 down}
				}
                                                        
            }    
	}
        
 }
		
 

#include ..\longpressify.ahk

*f1::
if (LP_modes.LP_instance.creatureMode.LPisActive)
{

    LP_.deactivate("creatureMode")
}
else
{
    LP_.activate("creatureMode")

}

return


~!#.::
ExitApp
return