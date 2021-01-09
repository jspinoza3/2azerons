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

  class mode
  {
            class u extends simpleButton
            {
               remap := "2"                                        
            }  
            class capslock extends simpleButton
            {
               remap := "1"                                        
            } 			
	}
        
 }
		
 

#include ..\underTheHood\longpressify.ahk

*f1::
if (LP_modes.LP_instance.mode.LP_isActive)
{

    LP_.deactivate("mode")
}
else
{
    LP_.activate("mode")

}

return


~!#.::
ExitApp
return