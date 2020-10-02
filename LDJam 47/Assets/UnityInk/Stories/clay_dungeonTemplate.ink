
// THESE ARE MORE GENERIC AND CAN BE USED ANYWHERE. USAGE:
/*
->AdvancedSkillCheck(_warchief, easy, 0, _warriors, warriors, smallAmount, ->dungeon_advancedCheckSuccess, ->dungeon_advancedCheckFail)->
{dungeon_advanced_success && not dungeon_advanced_fumbled: ->roompicker|->room1}
*/
VAR dungeon_advanced_success = false
VAR dungeon_advanced_fumbled = false
==dungeon_advancedCheckSuccess(fumbled)==
~dungeon_advanced_success = true
~dungeon_advanced_fumbled = fumbled
->->
==dungeon_advancedCheckFail(fumbled)==
~dungeon_advanced_success = false
~dungeon_advanced_fumbled = fumbled
->->

//DUNGEON TEMPLATE
// This variable should be unique to this dungeon!
VAR dungeon_continuePoint = ->dungeon_start.go_to_next_level

==dungeon_start
{dungeon_start<2: 
This is the start of the dungeon and the first description of it.
- else:
This is the start of the dungeon after the first visit.
}
+ [Enter]->dungeon_continuePoint(false)
+ [Leave]->leave

/// FUNCTIONS 
=go_to_next_level
{&->level0|->level1|->level2|->finalLevel}

=save_and_leave(->savePoint)
~dungeon_continuePoint = savePoint
This is a save room?

+ [Save and leave]->leave
+ [Continue onward]->savePoint

=leave
Leaving the dungeon.
{debug:
->debugLeave
-else:
->DONE
}
// END FUNCTIONS

//// LEVEL 0          \\\\\\\\\\         //////////
=level0
[Level 0]
{level0<2: 
This is the description for the first-time entry to the level.
- else:
This is the repeated description for level entry.
}
- (roompicker)
// This picks which room is the first room to enter - in this case in order.
Roompicker for level 0
{->room1|->room2|->room3|->finalRoom}

- (room1)
This the first room. You can go to the next room from here if you pass a check! 
+ {room2<1}[Go to next room {displayCheck(_warchief, easy)}]
->AdvancedSkillCheck(_warchief, easy, 0, _warriors, warriors, smallAmount, ->dungeon_advancedCheckSuccess, ->dungeon_advancedCheckFail)->
{dungeon_advanced_success && not dungeon_advanced_fumbled: ->roompicker|->room1}
+ {room2>0}[Go to room 2]->room2
+ [Leave the dungeon]->save_and_leave(->room1)

- (room2)
This is room 2. You can go to room 1 or 3 from here. Room 1 no longer has a challenge if you do go there.
+ [Go up]->room1
+ [Go down]->room3
- (room3)
This is room3. You can go to room 1 or 2, OR you can go a level down!
+ [Go back]->room1
+ [Go further back]->room2
+ [To next level]->finalRoom
- (finalRoom)
This is the final room for LEVEL 0
+ [Go to the next level]->
->go_to_next_level
+ [Save here and leave.]
->save_and_leave(->finalRoom)

//// LEVEL 1          \\\\\\\\\\         //////////
=level1
[Level 1]
{level0<2: 
This is the description for the first-time entry to the level.
- else:
This is the repeated description for level entry.
}
- (roompicker)
// This picks which room is the first room to enter - in this case in order.
Roompicker for level 1
{->randomRoom|->randomRoom|->randomRoom|->finalRoom}

- (randomRoom)
This room repeats.
~temp randomNr = RANDOM(0,2)
~temp randomSkill = _warchief
~temp randomDifficulty = easy
{randomNr:
- 0:
A fight ensues!
~randomSkill = _warchief
- 1:
A talk ensues!
~randomSkill = _pactmaker
- 2:
A trickery ensues!
~randomSkill = _trickster
}
+ [{displayCheck(randomSkill, randomDifficulty)}]
{skillCheck(randomSkill, randomDifficulty) && not fumbleCheck(0):
->roompicker
- else:
->randomRoom
}
+ [Escape]->save_and_leave(->randomRoom)

- (finalRoom)
This is the final room for LEVEL 1
+ [Go to the next level]->
->go_to_next_level
+ [Save here and leave.]
->save_and_leave(->finalRoom)

//// LEVEL 2          \\\\\\\\\\         //////////
=level2
[Level 2]
{level0<2: 
This is the description for the first-time entry to the level.
- else:
This is the repeated description for level entry.
}
// We start with the 'lose' random rooms
->roompickerLose

// These are the rooms it goes through when you succeed. Note you can only go to finalRoom from room3!
- (roompickerWin)
{->room1|->room2|->room3|}
// These are the random rooms it picks between when you lose
- (roompickerLose)
{~->randomRoom1|->randomRoom2|->randomRoom3}

- (randomRoom1)
Nothing happens here. {~Variations.|of|nothing} But you can leave!
+ [Go to next room]->roompickerLose
+ [Leave dungeon]->save_and_leave(->randomRoom1)

- (randomRoom2)
If you succeed at a check you get to go to the next real room!
+ [Fight!{displayCheck(_warchief, easy)}]
{skillCheck(_warchief, easy) && not fumbleCheck(0):
->roompickerWin
- else:
You lost! 
->roompickerLose
}

- (randomRoom3)
If you succeed at a check you get to go to the next real room!
+ [Be tricky!{displayCheck(_trickster, easy)}]
{skillCheck(_trickster, easy) && not fumbleCheck(0):
->roompickerWin
- else:
You lost! 
->roompickerLose
}

- (room1)
This is room 1! Now you go back to the random gauntlet, haha.
+ [Continue]->roompickerLose
+ [Leave dungon]->save_and_leave(->room1)

- (room2)
This is room 2. It has a check, and then more random gauntlet, hah! If you don't win, you go back to this room lol.
+ [Talk! {displayCheck(_pactmaker, easy)}]
{skillCheck(_pactmaker, easy) && not fumbleCheck(0):
->roompickerLose
- else:
->room2
}
+ [Leave]->save_and_leave(->room2)

- (room3)
This is room3. 
+ [Go back]->room1
+ [Go further back]->room2
+ [To next level]->roompickerWin

- (finalRoom)
This is the final room for LEVEL 2
+ [Go to the next level]->
->go_to_next_level
+ [Save here and leave.]
->save_and_leave(->finalRoom)

//// FINAL LEVEL          \\\\\\\\\\         //////////
=finalLevel
You have reached the final level! Yay!
~dungeon_continuePoint = ->dungeon_start.finalLevel
+ [Save here and leave.]->leave
+ [Go back to the start]->go_to_next_level
