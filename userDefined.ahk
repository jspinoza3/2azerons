/*
- With longpressify.ahk relatively set in stone, this file serves as a place to customize what actions are associated with various physical button presses see readme.txt for details
*/


	class clay extends LP_longpressable
	{
		LP_longDuration := 400
		LP_longLongDuration := 600
		LP_prefix := "*"
	}

	class longRepeat extends clay
	{
		
		LP_longLongRepeat()
		{
			this.LP_held()
		}
		LP_shortUp()
		{
			b := this.short
			tosend := "{blind}{" . b . " down}"	
			send %tosend%
			tosend := "{blind}{" . b . " up}"	
			send %tosend%
		}
		LP_held()
		{
			b := this.long
			tosend := "{blind}{" . b . " down}"	
			send %tosend%
		}
		LP_longUp()
		{
			b := this.long
			tosend := "{blind}{" . b . " up}"	
			send %tosend%
		}

	}
	
	class longRepeatChord extends LP_chord
	{
		LP_longLongRepeat()
		{
			this.LP_held()
		}
		LP_shortUp()
		{
			b := this.short
			tosend := "{blind}{" . b . " down}"	
			send %tosend%
			tosend := "{blind}{" . b . " up}"	
			send %tosend%
		}
		LP_held()
		{
			b := this.long
			tosend := "{blind}{" . b . " down}"	
			send %tosend%
		}
		LP_longUp()
		{
			b := this.long
			tosend := "{blind}{" . b . " up}"	
			send %tosend%
		}
	}
	
	class phraseChord extends LP_chord
	{
		LP_shortUp()
		{
			b := this.short
			;tosend := "{blind}" . b	
			send %b%
		}
		LP_held()
		{
			b := this.long
			;tosend := "{blind}" . b	
			send %b%
		}	
	}
	
	class longCandid extends longRepeat
	{
		LP_init()
		{
			this.long := this.LP_button
		}
	} 
	
	
	class shortCandid extends longRepeat
	{
		LP_init()
		{
			this.short := this.LP_button
		}
	} 
	

	active:="default"
	LP_getActiveMode()
	{
		global active
		
		return active
	}
	

   class LP_modes 
   {

		class default
		{
			class NumLock extends shortCandid
			{
				long := "ScrollLock"
			}
			class insert extends longCandid
			{
				short := "printscreen"
			}
			class end extends shortCandid
			{
				long := "home"
			}
			class Esc extends shortCandid
			{
				long := "Del"
			}
			class r extends shortCandid
			{
				long := "j"
			}
			
			class zero extends shortCandid
			{
				long := "["
			}
			class two extends shortCandid
			{
				long := "\"
			}
			class three extends shortCandid
			{
				long := "'"
			}
			class four extends shortCandid
			{
				long := ","
			}
			class five extends shortCandid
			{
				long := "."
			}
			class six extends shortCandid
			{
				long := "`"
			}
			class seven extends shortCandid
			{
				long := "/"
			}
			class nine extends shortCandid
			{
				long := "]"
			}
			
			
			class f1 extends shortCandid
			{
				long := "f7"
			}
			class f2 extends shortCandid
			{
				long := "f8"
			}
			class f3 extends shortCandid
			{
				long := "f9"
			}
			class f4 extends shortCandid
			{
				long := "f10"
			}
			class f5 extends shortCandid
			{
				long := "f11"
			}
			class f6 extends shortCandid
			{
				long := "f12"
			}
			
			class home extends longCandid
			{
				short := "end"
			}
			
			class CapsLock extends longCandid
			{
				LP_shortUp()
				{
					
				}
			}

			class leftIndexFinger extends LP_modes.default.leftMiddleFinger
			{
				LP_Buttons := ["s","n","t"]
				longs := ["z", "l", "d"]
				first2 := "-"
				first2long := "--- "
				last2 := "🐪"
				last2long := "🐫"
			}
			
			class leftMiddleFinger extends LP_chordingGroup
			{
				LP_Buttons := ["f","h","e"]
				longs := ["v", "x", "y"]
				first2 := "="
				first2long := ";"
				last2 := "🍣"
				last2long := "🍑"
				
				class ooi extends longRepeatChord
				{
					LP_init()
					{
						this.long:=this.LP_parentClassInstance.longs[3]
						this.short:=this.LP_parentClassInstance.LP_Buttons[3]
					}
				}	
				class oio extends longRepeatChord
				{
					LP_init()
					{
						this.long:=this.LP_parentClassInstance.longs[2]
						this.short:=this.LP_parentClassInstance.LP_Buttons[2]
					}
				}	
				class oii extends LP_modes.default.leftMiddleFinger.iio
				{
					setShortLong()
					{
						this.long:=this.LP_parentClassInstance.last2long
						this.short:=this.LP_parentClassInstance.last2
					}
				}	
				class ioo extends longRepeatChord
				{
					
					LP_init()
					{
						this.long:=this.LP_parentClassInstance.longs[1]
						this.short:=this.LP_parentClassInstance.LP_Buttons[1]
					}
				}		
				class ioi extends LP_chord
				{
					LP_shortUp()
					{
						send 5
					}	
				}	
				class iio extends LP_chord
				{
					LP_init()
					{
						
						this.setShortLong()
						if (strlen(this.long)>1)
							this.base := phraseChord
						else
							this.base := longRepeatChord
						if (strlen(this.short)>1)
						{
							this.LP_shortUp := phraseChord.LP_shortUp
						}
						else
						{
							this.LP_shortUp := longRepeatChord.LP_shortUp
						}
					}
					setShortLong()
					{
						this.long:=this.LP_parentClassInstance.first2long
						this.short:=this.LP_parentClassInstance.first2
					}
				}
				class iii extends LP_chord
				{
					LP_shortUp()
					{
						send 7
					}
				}

			}
			
			class leftRingFinger extends LP_modes.default.leftMiddleFinger
			{
				LP_Buttons := ["m","c","a"]
				longs := ["w", "k", "i"]
				first2 := "🦏"
				first2long := "🐘"
				last2 := "🐜"
				last2long := "🦂"

			}
			
			class leftPinky extends LP_modes.default.leftMiddleFinger
			{
				LP_Buttons := ["p","g","o"]
				longs := ["b", "q", "u"]
				first2 := "🦕"
				first2long := "🦖"
				last2 := "🐒"
				last2long := "🦍"

			}
			
			
		}
		

   }

/*
f12::
if (active == "default")
	active := "mode2"
else
	active := "default"
return
*/

~!#.::
ExitApp
return 
