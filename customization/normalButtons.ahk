/*
write comments here
*/

class simpleButton
{
	LP_msTillLong := -1 
	LP_down()
	{
		b := this.remap
		tosend := "{blind}{" . b . " down}"	
		send %tosend%
	}
	LP_shortUp()
	{
		b := this.remap
		tosend := "{blind}{" . b . " up}"	
		send %tosend%
	}  

	LP_shortRepeat()
	{
		b := this.remap
		tosend := "{blind}{" . b . " down}"	
		send %tosend%
	}
}
  
class LP_modes 
{

  class creatureMode
  {
            class u extends simpleButton
            {
               remap := "2"                                        
            }    
	}
        
 }
		
 

#include ..\longpressify.ahk

*f1::
if (LP_modes.LP_instance.creatureMode.LP_isActive)
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