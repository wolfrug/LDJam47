// Keep this include while working/testing, I will comment out when integrating
//INCLUDE clay_functions.ink
// Change the 'locationName' of all of these to correspond to the knot name below
// Set in the 'leave' stitch
VAR battlefield_last_visit = -1
// this is set to true when the location is spawned. Needs to be set to false manually
VAR battlefield_new = true
// this is set when spawned.
VAR battlefield_creationTime = 0
// this is set when the object is very close to the edge
VAR battlefield_dangerClose = false
// set this to true if you want it to be hidden
VAR battlefield_hidden = true
VAR battlefield_description = "A place of interest"

//DUNGEON
// This variable should be unique to this dungeon!
VAR battlefield_continuePoint = ->battlefield_start.go_to_next_level
VAR battlefield_buildSpeed = 1
VAR battlefield_buildProgress = 0
VAR battlefield_buildStartTime = 0

==debugLeave
{PassInkTime(10)}
Last visited battlefield: {battlefield_last_visit}
Current time: {currentTime}
->battlefield_start

==battlefield
{battlefield<2:
As you near the site, more and more Vulture-drones buzz past you, diving and rising up again to circle. Your crew goes silent as you take in the signs of a great battle. The pavement is broken by craters; metal signs lie in pools of melt; and all around lie the mostly-disassembled wrecks of Hunter-Killer drones - and more. It is around these that the Vulture-drones assemble, likes flies on corpses, their tiny fire-lances cutting and collecting the shattered drones bit by bit.

{companions?Barr: Barr grips her blade, looking tense. ->Say("'Nothing I have ever seen or heard of has ever killed this many Hunter-Killers at once.'", Barr)->}
{companions?Jaerd: Jaerd nears one of the destroyed drones. The Vulture-drones buzz away to give him a clear look at it. He frowns. ->Say("'Odd. Its mouth is welded shut.'", Jaerd)->}
{companions?Valfrig: Valfrig's head is on a swivel, turning this way and that. ->Say("'Something...something extraordinary happened here.'", Valfrig)->}
{companions?Chi: 
Chi gives you an uncertain look. It looks like she's already regretting this.
}
{companions?Fayni: Fayni pulls her pack closer to her, frowning. ->Say("'This doesn't feel right. How can there be so many dead Hunter-Killers? Who could've done this?'", Fayni)->}

A thought strikes you: could this have been a fight the City lost? In that case, against what? That has only happened before once, according to the legends.
~battlefield_description = "The Battlefield"
->battlefield_start
- else:
->battlefield_start
}

=SetHide(hidden)
#updateLocationVisibility
~battlefield_hidden = hidden
{not battlefield_hidden:
[A new location has been revealed on the map!]
- else:
[You can no longer visit this location]
}
->->

==battlefield_start
#spawn.background.grassland
~battlefield_buildProgress = battlefield_buildSpeed*(currentTime-battlefield_creationTime)
{battlefield_start<2: 
You follow the trail of destruction until you reach what can only be described as a giant maw; a passageway into the under-city, torn forcibly open by whatever force successfully battled the City. Broken pipes and metal bars jut out of the walls and roof; but amidst the rubble you can see clear path leading down.

Something awaits in the darkness, but you cannot know what. You have a sense that you will need to come prepared.
- else:
You return to the still-open maw, amazed that the City has not yet repaired it. It is as if whatever force tore it open also severed the City's connection to its own tissue, leaving it necrotic.
}
+ [Delve down]
#spawn.background.tunnels
->battlefield_continuePoint(false)
+ [Leave]->leave

/// FUNCTIONS 
=go_to_next_level
{&->level0|->level1|->level2|->finalLevel}

=save_and_leave(->savePoint)
~battlefield_continuePoint = savePoint
->leave

=leave
You leave the deep maw behind you {battlefield_start.finalLevel>0:, hopefully for good.| for now.}
~battlefield_last_visit = currentTime
{debug:
->debugLeave
-else:
->DONE
}
// END FUNCTIONS

//// LEVEL 0          \\\\\\\\\\         //////////
=level0
{level0<2: 
You follow the jagged tunnel into the darkness, until you must light torches to see where you step. Lose stones rattle and echo as they precede you downwards. You can hear the sound of water dripping, and soon you find yourself in a slow-moving river. Tunnels - City-made - stretch in every direction.
- else:
You make your way down the slope again, following the sound of water. The walls glisten, wet, in the light of your torches.
}
- (roompicker)
// This picks which room is the first room to enter - in this case in order.
// Roompicker level 0
{->room1|->room2|->room3|->finalRoom}

- (room1)
{room1<2:
You follow the signs of battle to a collapsed tunnel entrance. No - not collapsed: blocked. The walls are stretched and twisted, forced to make a seal. It is imperfect: you can see light on the other side.
~battlefield_buildProgress = 0
- else:
You find yourself in front of the blocked entrance. You can see light through the cracks. 
}
* {room2<2}[Find another way around {displayCheck(_trickster, medium)}]
{skillCheck(_trickster, medium) && not fumbleCheck(0):
You shine a light at the top of the blocked entrance. Barely visible in the shadows is a metal net that has been burned away and then forced inward.

You instruct your crew to boost you up. It fits a person, if barely. You crawl through. 
{GiveReward(_tricksterXP, smallReward)}
{GiveReward(_courageXP, smallReward)}
->roompicker
- else:
You shine a light all around the entrance to no avail. This seems to be the only entrance.
->room1
}
+ {room2<2}[{Req(_clay, 5)}Undo the seal with Claywork.{displayTime(mediumTime)}{displayCheck(_clayworker, hard)}]
{PassInkTime(mediumTime)}
{skillCheck(_clayworker, hard):
{alter(_clay, -5)}
Your Clayworkers, after hours of work, manage to tease life out of the City's body. They whisper to the walls, apply poultices, and curse. But in the end, the dead-seeming walls begin to move. They retract, just enough to let a person squeeze through.
{GiveReward(_courageXP, mediumReward)}
->roompicker
- else:
{alter(_clay, -RANDOM(1,5))} 
Your Clayworkers apply poultices of clay, swear at the wall, and work tirelessly for hours attempting to bring the dead wall back to life. In the end they have to admit defeat.
->room1
}
+ {room2>0}[Squeeze through to the next room.]->room2
+ [Leave]->save_and_leave(->room1)

- (room2)
The signs of battle in this room are different. The walls themselves have formed into spears and swords, creating a labyrinth of jagged death. All of it is inert now - at least you hope it is. A dead sec-bot casts its claylight across the room, the shadows sharp.

Your wercru cowers, indecisive.
+ [Continue through {displayCheck(_courage, medium)}]
{skillCheck(_courage, medium):
They trust your leadership. They follow your lead as you weave between glass-sharp spears and duck under frozen cleavers. 
{GiveReward(_courageXP, mediumReward)}
- else:
After some hesitation, your crew follows. At least most of them do.
{RemoveRandomCivilian(false)}
{GiveReward(_failureXP, smallReward)}
}
->roompicker
+ [Leave]->save_and_leave(->room2)

- (room3)
This time, the exit to the room has been forced open rather than sealed, a frozen wave of reticent clay admitting you further into the under-city. More dead sec-bots, practically pulverized, are strewn about the space beyond. In the middle, a dark hole sits.

* [Explore the hole.]
The hole is perfectly circular and smooth: as if someone melted straight through the floor like a glowing lead ball through packed snow. You drop a torch down, and you count the seconds until it stops: immediately extinguished. You saw, for a brief moment, a stagnant river.

{companions?Jaerd:
->Say("Jaerd frowns, crouching by the edge of the hole. 'We can get down there. But we will need winches. Rope. Manpower and time.'", Jaerd)->
- else:
    {clayworker>0:
    A clayworker approaches the edge, looking doubtful. They drop down a glowing pebble of clay, counting seconds. It too disappears in the water. "We can do it. But it'll require a fair bit of time and manpower."
    - else:
    You frown at the hole. It is a long drop. You have seen clayworkers fashion devices that can scale high buildings, and you have no doubt they could handle this too. But it will take time and effort.
    }
}
->roompicker

+ [Leave.]
Your wercru mutters unhappily about having to navigate the room of swords again, although they seem happy to be leaving. ->save_and_leave(->room3)

- (finalRoom)
~temp neededClayworkers = 2
{companions?Jaerd:
~neededClayworkers++
}
{finalRoom<2:
You consider your options. You are sure clayworkers can build a device to go down, but it will take both material - clay - experts - clayworkers - and time.
- else:
You return to the room with the hole. It remains as before, mysterious depths beckoning. Somewhere down there is the trail of whoever could defy the City and live. If they lived.
}
+ [{Req(_clayworker, neededClayworkers)}Start the work.]->
->go_to_next_level
+ [Leave for now.]
->save_and_leave(->finalRoom)

//// LEVEL 1          \\\\\\\\\\         //////////
=level1
{level0<2: 
The first order of business for your clayworkers is arranging light. Someone harvests the claylight from the broken drone in the preceding room, adding its light to the glowrocks, torches and light-strips the clayworkers put up. You watch your shadows multiply. {alter(_clayworker, -2)}
{companions?Jaerd:
Jaerd is in the middle of it all, ordering, instructing. Everything is that much smoother with him present.
~battlefield_buildSpeed+=1
}
- else:
The room is well-lit and bustling with activity.
}
- (roompicker)
// This picks which room is the first room to enter - in this case in order.
{->room1|->room2|->room3|->finalRoom}

- (room1)
{room1<2:
The first order of business is to begin constructing the winch and the ropes and the other tools. Your clayworkers argue over a tablet for a while until they present you with a figure.
- else:
You return to the room. It is looking increasingly like a clayworker workshop, with tables set up and the floors cleaned. Your clayworkers come up to you, excited to get started.
}

* [{Req(_clay, 20)} Provide them with the Clay they need.]
Your clayworkers take the unprocessed Clay with barely-concealed eagerness and divide it up. 
{GiveReward(_courageXP, largeReward)}
{alter(_clay, -20)}
->roompicker

+ [Leave]->save_and_leave(->room1)

- (room2)
{room2<2:
Claywork is painstakingly slow - each step of the process requiring great precision and skill. A misspoken word, the wrong temperature or simply bad luck can ruin a whole batch. Your father often reminded you claywork is always an act of trickery: fooling the City into accepting your additions as its own.

The clayworkers say they will need about three days of uninterrupted work. Less if more clayworkers are added.
~battlefield_creationTime = currentTime
- else:
You return to the Clayworkers, still diligently working at their tables.
~temp debugOldWork = battlefield_buildProgress - battlefield_buildSpeed*(battlefield_last_visit-battlefield_creationTime)
/*Creation time: {battlefield_creationTime}
CurrentTime: {currentTime}
Work done: {battlefield_buildProgress} (+ {debugOldWork})
*/
}
~temp neededWork = dayLength*3

+ [Add Clayworkers({clayworker})]
~temp addedWorkers = 0
~temp actualClayWorkers = clayworker
{companions?Jaerd: 
~actualClayWorkers--
}
->AssignWorkers(_clayworker, addedWorkers, "Build speed", actualClayWorkers, 1)->
{addedWorkers>0:
{alter(_clayworker, -addedWorkers)}
~battlefield_buildSpeed+=addedWorkers
You add more Clayworkers to the task. This should speed things up considerably.
}
->room2
+ [{ReqS(battlefield_buildProgress, neededWork, "")} The work is finished.]
->roompicker
+ [Leave]->save_and_leave(->room2)

- (room3)
The Clayworkers proudly show off their contraption, a thing made out of clay and wood and parts scavenged from around the tunnels. A basket lets several tribesmen sit in safety at once while they are lowered. One of the clayworkers says he tested it and the waters below: it is shallow enough to stand in.

The clayworkers teach you the words for lowering and raising the basket; like many clayworker devices, it requires no human to operate it once finished. You watch the clayworkers congratulate each other on their cleverness, happy to head back towards the Corral after many days of toil.
{GiveReward(_tricksterXP, largeReward)}
{GiveReward(_courageXP, largeReward)}
->roompicker
+ [Leave]->save_and_leave(->room3)

- (finalRoom)
The clayworkers have finally finished their contraption. It is time to go down. You recall the words used to speak to the winch, hoping they work.
+ [Begin lowering your people down.]->
->go_to_next_level
+ [Leave it for later.]
You take one look at the swinging basket, and the dark waters below, and decide to leave it for later.
->save_and_leave(->finalRoom)

//// LEVEL 2          \\\\\\\\\\         //////////
=level2
~temp randomFindChance = 25
{level0<2: 
You step off the platform and into the knee-high water. The tunnel here is old brickwork, from before the City became alive. You try to get your bearings. The tunnels - perhaps used once for sewage, or transportation - seem to go on in every direction. The under-undercity.

With no other clue to go by, you follow the current into the dark.
- else:
You descend into the water once again, the darkness suffocating.
}
// We start with the 'lose' random rooms
->roompickerLose

// These are the rooms it goes through when you succeed.
- (roompickerWin)
{->room1|->room2|->room3|->finalRoom}
// Pick between these while 'lost' - passes ink time.
- (roompickerLose)
//Random Find Chance: {randomFindChance}
{PassInkTime(5)}
~randomFindChance+=1
{~->randomRoom1|->randomRoom2|->randomRoom3}

- (randomRoom1)
You are close to where you started. Light streams in from the room above, forming a perfect circle on the surface of the water. You could take your basket up and leave this cursed place behind.
+ [Continue your search. {displayTime(5)}]
->roompickerLose
+ [Leave]->save_and_leave(->level2)

- (randomRoom2)
A platform takes you into {~a warren of rooms filled with dusty shelves, laden with old-world things. {clayworker>0: A clayworker pokes at them, but nothing is Clay-infused.} Dead, dumb things.|a set of narrow corridors filled with dead ends and collapsed passages.| a new branch of the tunnels, making you wonder how big this place is.} Soon, you will be lost.

* {shaman>0 && not (companions?Valfrig)} [Ask your Shamans to augur your path {displayCheck(_shaman, medium)}]
{skillCheck(_shaman, medium) && not fumbleCheck(0):
Your shaman reads the sigils on the wall. After a while, they determine it is a map of the area. You follow them as they lead you towards the symbol of 'stairs'.
{GiveReward(_courageXP, mediumReward)}
->roompickerWin
- else:
Your shaman throws up their hands in frustration. Everything is mute, nothing speaks, nothing makes any sense. Being below the ground like this is not natural.

You have no choice but to continue blind.
->roompickerLose
}
* {companions?Valfrig} [Valfrig excitedly calls you over.]
->Say("'See this? This is a map! A map of this area!' He points at a strange image on the wall, filled with sharp corners and faded colors.", Valfrig)->
->Say("'This was made before the City came alive - none of these walls ever moved. They stayed the same. So this map...is still valid.'", Valfrig)->
You look at it again, seeing it properly for the first time. Elbéar maps have few solid features on them, and none map interior spaces.
->Say("'Think of it as...looking from above. This is the room we are in. And here...' His finger moves. 'Is where we want to go.'", Valfrig)->
You follow him, quietly impressed. Perhaps cartography isn't the most useless skill to have in the City, after all.
->roompickerWin
* {companions?Fayni} [Fayni pulls at your sleeve.]
She takes you a little distance away from the others, lowering her voice.
->Say("'This is a big place, and we need to look everywhere. But...' She nods at the rest of the wercry. 'They are too afraid to explore properly.'", Fayni)->
->Say("'I think...' She swallows, looking around. 'I <i>think</i> these walls are dumb...old. They cannot hurt us. But they need some time to process it.'", Fayni)->
You take a look at your crew, noting how they pass by narrow passages, and try to stay away from the walls, their expressions tight.
->Say("'Let's take a break and eat. I'll talk to them. Hm?'", Fayni)->
You consider it, wondering if it will just be a waste of time. But then, Fayni does know people.
* * [{Req(_food, 1)} You nod, and give her leave to distribute extra provisions.{displayTime(20)}]
{alter(_food, -1)} {PassInkTime(20)}
You settle down in one of the larger rooms, and Fayni distributes the rations. She makes jokes, touches shoulders, smiles. Pulls down boxes from the shelves to make seats. Even you start to feel a bit more relaxed by the end.

Afterwards, the search continues - and almost immediately leads to a result, as a {PickRandomCrewMemberF(false)}{pickedRandomCrewMemberString} calls out from a narrow passage. You and Fayni exchange a glance as you hurry over.
->roompickerWin
+ [Continue your search.{displayTime(5)}]
{RANDOM(0,100)<randomFindChance:->roompickerWin|->roompickerLose}

- (randomRoom3)
{randomRoom3<3:
You wander into a {|another|yet another|} dead end. {~How frustrating.|Your legs are tired from walking through the water.|Every path looks the same to you.} The walls feel like they are closing in. Elbéar are not meant to be in enclosed spaces. No sign of your quarry either.
- else:
You wandering to a familiar-looking dead end. You begin to get the feeling this place is not as big as you think.
}
* {companions?Chi} [Chi looks thoughtful.]
Chi comes up to you. She looks much calmer than anyone else in your crew.

->Say("'Hey boss. Usually when I'm lost underground I start scratching things into the walls. Y'know, to mark where I've been.", Chi)->

You stare at her: scratching the walls of the City on purpose is something even the youngest children are taught not to do. Also: how often is Chi lost underground? But then you realize these walls <i>aren't</i> the City's - they are dumb.

She takes out a knife from her back pocket and scratches a cross into a nearby wall. Everyone instinctively freezes for a second. Chi sighs.

->Say("'I'll do it, if you're all so scared.' She smirks at you. 'Bet you're glad you brought me now.'", Chi)->
Although at first with hesitation, soon enough everyone is marking the passageways they have entered. Soon, a cry comes up - someone has found something!
->roompickerWin
* {companions?Jaerd} [Jaerd looks like he has an idea.]
Jaerd clears his throat to get your attention. He looks slightly less miserable than everyone else at being encased in four walls.
->Say("'I have an idea. We could leave glowballs to mark where we've been. They should stay lit long enough for us to map this place out.'", Jaerd)->
He takes out a piece of clay, rolls it into a ball and then whispers something to it. It lights up, bright, and he pushes it into the wall with his thumb.
->Say("'I don't need much clay for this to work.' He looks at you expectantly.", Jaerd)->
* * {clay>0}[{Req(_clay, 1)}Give him some clay]
Soon little glowballs adorn every other doorway, marking where you've been. Your systematic approach leads to results faster than anticipated. You follow the  {PickRandomCrewMemberF(false)}{pickedRandomCrewMemberString} to their find.
->roompickerWin
* * ->
You don't have any clay to give him. He shrugs.
->roompickerLose
+ [Continue your search.{displayTime(5)}]
{RANDOM(0,100)<randomFindChance:->roompickerWin|->roompickerLose}

/// THE ACTUAL ROOMS FOR LEVEL 2
- (room1)
Through a narrow passageway and up a ladder, you find a dead-end room filled with dusty planks all stacked up against the walls. You also find blood - human blood, staining a piece of cloth thrown into a corner. {playful: So whoever you are chasing <i>is</i> human after all? You're not sure what else you were expecting, really.} {thoughtful: You touch the cloth. It seems much like any other - wool, inert clay-threads; like what your mother would sew. A human thing.}{honorable: That means whoever you are chasing was wounded by the city - which means they are human. Not invulnerable.}

{companions?Barr:
Barr considers the room with a frown, hand on the hilt of her blade.
->Say("'Why would they stop here to treat their wounds? This room has no exits. If the City trapped them here...' She rubs her chin.", Barr)->
After a moment, she starts removing the piles of planks, many of them nailed together to form pallets. You don't see why - the dust on them is clearly ancient, and quickly fills the room as Barr works.

But she was right. Cleverly hidden, near floor-level, is a hole in the wall, large enough for a person to sneak through. Barr grins at you.
->Say("'I don't know what magic they used to make the dust resettle, but whoever they are, they're a cunning warrior.'", Barr)->

You slap her on the back as you pass her, and she tries her best to hide her pride.
->roompickerWin
- else:
Aside from the center of the room where you find the rag, however, the room is untouched, the dust covering the debris gathered over centuries. They must have left the same way they came - which means you are still no closer to finding them. You order the wercru back to the search.
}
// Just-in-case divert
+ [Back to the search.{displayTime(5)}]->roompickerLose
- (room2)
{room2<2:
You have to crouch low to get through to the room hidden beyond. Once inside you raise your torch high. You realize from the reflections on the walls you are back - or adjacent - to the City, and that the space you are standing in was created by your quarry.

It goes upwards, in steps and inclines. With every twist and turn, every barely-manageable passageway, you feel the City's anger, its attempt to squash the thing inside it. Yet even here, even literally inside the belly of the beast, your quarry kept themselves alive.

The path continues, getting narrower. The walls look inert - but your every instinct is telling you to stop - telling you the City might awaken at any time and trap you here in a lightless, airless dark forever. On a whim. By accident. Knowingly or unknowingly. 

You arrive at a climb too high for you alone - perhaps the stairs were destroyed by the City, or perhaps your quarry used the City to create a moving platform for themselves. Whatever the case, you cannot climb this without help. That is when you notice your wercru has stopped.
- else:
The passage goes up into the dark, narrow and filled with jagged edges. You definitely can't make it up there by yourself.
}
+ [{Req(_courage, 3)} Order them to continue.]
{alter(_courage, -3)} They have learned to trust you; even if that means crawling into almost certain death. After a moment, they begin moving, boosting you up and then helping others get up. One by one, until everyone is up. 
->roompickerWin
* [Attempt to convince them. {displayCheck(_pactmaker, hard)}]
You speak to your wercru; they gather and listen, your voice muffled by the dead City's skin.
{playful:
You talk about the City that always wins if someone dares to challenge it outright. A City you have to sneak around, trick and lie to just for it to let you live. And here comes someone who can fight it - head to head - and live; whoever they are, you <i>have</i> to find them. If for no other reason then for the story.
}
{thoughtful:
Your speech is passionate and inspiring. You remind them that there is a person at the end of this journey, a person who can and has challenged the City itself; something not even the most legendary of elders could do. But it also a person who is bleeding and hurt - a person who deserves help. And who, no doubt, would help you in return.
}
{honorable:
First of all you remind them of their duty and the promises they made when they joined your wercru; but you also remind them of what you have already seen: dead Hunter-Killers and sec-bots by the dozens, the power to create and destroy the City at will, the kind of power that would finally free the Elbéar from the shackles of the Bozes, and of the City itself.
}
{skillCheck(_pactmaker, hard) && not fumbleCheck(0):
You finish, looking at your gathered crew. You can see in their eyes that right now they do not see just a cruboss when they look at you, but the future chieftain. After a moment, they begin moving, boosting you up and then helping others get up. One by one, until everyone is up.
{GiveReward(_pactmakerXP, largeReward)}{GiveReward(_courageXP, largeReward)}
->roompickerWin
- else:
Your crew listens, and although you see some nodding heads - {LIST_COUNT(companions)>1:your companions among them}{LIST_COUNT(companions)==1:{companions} among them} - your words lack conviction. ->room2
}
+ [Leave, for now.] 
As you turn around to leave, palpable relief ripples through the crew.
->save_and_leave(->room2)

- (room3)
A little distance later, you come across a scene of bloodshed. Dry blood and a broken spear-point reflect the light from your torches. It must have taken your quarry by surprise. Or maybe they were getting tired, or careless. The passageway becomes even more cramped, as if City's attempts at crushing the interloper had come closer and closer to succeeding. You and your wercru continue, first crouched, then prone, spelunking through the dark. No-one speaks. Blood flecks the walls.

Eventually, the darkness makes way for light - natural light. Soon you crawl out into an open space; a gargantuan dome, which you estimate must be almost entirely buried under the ground. You crane your neck back, but even then you cannot fully comprehend the size of it. Shafts of sunlight enter through several cracks at the top of the dome, big enough to let through the dead Hunter-Killers you see scattered about the room.

Vulture-drones flock in through the cracks in the top, coming to feast on their ruined brethren. All is still.

Your wercru slowly crawls out behind you, each stopping in awe at the sight. This was where the final battle took place. Where the City finally caught up with whoever you were following.
{GiveReward(_courageXP, largeReward)}
->roompickerWin

- (finalRoom)
You stand at the threshold of the battlefield. Grass grows in patches wherever the sunlight can reach. You can see the tops of trees through the cracks up above. A vulture-drone alights, circles, and then lands again.

+ [Explore the battlefield]->
->go_to_next_level
+ [Turn around and leave {displayTime(10)}]
It is a long crawl back.
->save_and_leave(->finalRoom)

//// FINAL LEVEL          \\\\\\\\\\         //////////
=finalLevel

You walk among the destroyed remnants of the City's defences. Some of the bots have simply died. Others have been sheared in half, exploded in bits, or charred to nothing. The Vulture-drones are hard at work. Soon enough, all evidence of the fight here will have been erased - nothing is permanent in the City. 

You are not surprised when you find the body, burnt almost beyond recognition. The damage to it is extreme: all that remains is a skeleton encased in a burned shroud. You cannot tell if they were man or woman, but they <i>were</i> human.

->comp_corral_battlefield_comment1->

- (body)
{body>1:
The journey is long, but eventually you reach the body once again, still surrounded by Vulture Drones.
}
Something seems to be protecting the body - like a golden shimmer in the air above it. You squint, and even from this distance you can see a splotch of gold resting on the skull's forehead.

+ [Turn around and leave.] ->GOE_leave("mid")

* [Approach]
You take a few steps closer. As you do, you can feel something begin to vibrate in your clothes. Everyone in the crew feels it - clay weapons shaking as if an unknown hand gripped them, tools and devices beginning to glow as if struck by lightning.{companions?Barr: Barr cries out, dropping her clay-infused obsidian blade as if it burned her.} {companions?Valfrig: Valfrig brings a hand up to his face - his clay-infused tattoos glowing blue.} You reach inside and find your ombrascope; it is whirring and clicking, as if wanting to leap out of your grip.

And suddenly it does: it flies through the air and at the same time, the splotch of gold on the skull's forehead does too, jumping up to meet your ombrascope halfway. They freeze, improbably, mid-air, your ombrascope enveloped by what looks just like clay, except golden. It infiltrates every pore of the device, striating its surface with gold, while most of it takes refuge in the interior. It shakes, clay-light shining through the cracks.

After what feels like an eternity, the ombrascope drops down again, as if remembering what gravity is. You and your crew watch, stunned. And then the Vulture-drones go crazy, descending from all sides on you, on the corpse, and on the now-golden ombrascope.
* ->leave
- 
* [Run, leaving the Ombrascope.]->GOE_leave("lateLeave")

* [Take the ombrascope]
You cannot leave the ombrascope; you need it to navigate the City. You lunge forward and pick it up - it feels warm against your palm. Then you jump back just in time to dodge the Vulture-bots, who descend on the corpse and begin tearing it to pieces. {GiveReward(_courageXP, mediumReward)}

Catching your breath, you order a retreat. There is nothing more for you here. ->GOE_leave("lateTake")

=GOE_aftermath
{currentTime-battlefield_last_visit<dayLength:
You try to return, but the Vulture-drones descend on you almost immediately, barely letting you through the hole. You retreat - there will be no coming back here. Not for a while.
->leave
}
It takes you a long time to crawl back to where you found the Golden Ombrascope, and when you do, you find it considerably less populated. The Vulture-bots have nearly finished their work. Almost nothing remains but a few mishapen lumps.

You spend a moment to appreciate the relative serenity of the scene.

+ [Leave]
->leave

=GOE_leave(time)
{time:
-"mid":
{companions?Valfrig: Valfrig protests - something never before seen is happening here. But you grab him yourself and turn him around, dragging him away by force.} Your wercru follows you as you turn and make your escape. The moment you leave,  the Vulture-drones descend again, pecking and harassing whatever force it is that is keeping them away.
->save_and_leave(->finalLevel.body)
-"lateLeave":
You give the order to retreat. You know you need the ombrascope to navigate the City, but you would rather take your chances.

~temp deadCompanion = ()
{companions?Valfrig:
Valfrig looks at you, eyes wide. 
->Say("'We cannot leave it to the Vultures!' He cries out, and jumps towards the corpse.", Valfrig)->
Just as his hand closes on the ombrascope, the Vulture-drones descend, cutting and biting. He tries to protect himself, but more than that, he tries to protect the ombrascope.
~deadCompanion = Valfrig
- else:
{companions?Fayni:
->Say("Fayni curses, and jumps forward. 'We can't leave without the ombrascope! We need it!'", Fayni)->
With single-minded focus, she grabs the device - only for the Vulture-drones to descend on her. She screams as they begin cutting.
~deadCompanion = Fayni
- else:
{companions?Barr:
->Say("'Not without the ombrascope.' Barr growls.", Barr)->
She rushes forward and collects it, rolling out of the way just as the Vulture-drones descend, inexplicably aggressive. To her surprise, they all turn on her. Moments later, they've drawn blood.
~deadCompanion = Barr
- else:
{companions?Chi:
You see to your surprise none other than Chi breaking ranks and rushing towards the ombrascope. She gives no explanation as to why. For a moment, it looks as if she is going to get away with it - she picks it up, places it in her satchel...and then the Vulture-drones descend, an angry swarm. Chi screams.
~deadCompanion = Chi
- else:
{companions?Jaerd:
->Say("'No!' Jaerd jumps forward, despite your attempt to stop him. 'That is golden clay. I know it is! We have to save it!'", Jaerd)->
He reaches the corpse and picks up the ombrascope. He stops for one fatal moment to look at it, caressing the surface - and then the Vulture-drones descend. They cut into him, attacking without mercy.
~deadCompanion = Jaerd
- else:
You turn to run, but something has agitated the Vulture-drones. They descend like a buzzing, murderous swarm, blocking your path. You try to fight your way through, but there are too many - and you are all alone. Their char-beams cut into you, picking away pieces of you while you are still alive. You scream for help, but no-one hears you. ->death("vultureDrones")
}
}
}
}
}
You rush forward and grab them,  somehow fighting your way through the Vulture-drones. Once you are far enough away, they seem to lose interest, circling back to the site of the attack.
{deadCompanion:
- Valfrig:
Valfrig is on his last legs, grasping the ombrascope tightly. He gives it to you when you near, blood dripping from his hands. 
->Say("'Take care of this.' He gasps. 'I can sense a spirit in it. This could be the salvation of our people.'", Valfrig)-> 
There is nothing more to be done for him. He dies in your arms.
{KillCompanion(Valfrig)}
- Fayni:
Fayni is more blood and cut flesh than woman. She collapses, and the ombrascope falls from her hands. She is too weak for last words; she dies in your arms within minutes.
{KillCompanion(Fayni)}
- Barr:
At first, Barr seems like she is going to pull through. But then she falls to her knees, shoulders slumping. You kneel down next to her, and she gives you the ombrascope. It is filled with her blood. She smiles feebly. 
->Say("'Tell my story.'", Barr)->
Then she collapses.
{KillCompanion(Barr)}
- Chi:
Chi collapses on the ground, and manages to crawl for a few more yards, leaving a trail of blood, before she stops. You find the golden ombrascope in her satchel. What she inteded with it, you do not know. All you know is that she died for it.
{KillCompanion(Chi)}
- Jaerd:
The clayworker walks his last couple of steps with the golden ombrascope clutched against his breast like an infant. He collapses, a mess of blood and char, into your arms. When he sees you, his eyes take on a hint of desperation: 
->Say("'Protect the golden clay. Protect it, it is...' His voice fades, as does his life.", Jaerd)->
{KillCompanion(Jaerd)}
- else:
You gasp. The golden ombrascope is in your hand - safe, somehow.
}
{GiveReward(_failureXP, largeReward)}
-"lateTake":
More and more Vulture Bots are arriving - you have no doubt the whole place will be disassembled within minutes.
}
In your hand, the now-golden ombrascope. It looks much the same, except for the minute golden details in its inlay. Also, it is warm, and seems to hum with power. You will need to consider it later, when you are safe. [You can now study the Golden Ombrascope in your camp.]
~hasGoldenOmbrascope = true
{GiveReward(_pactmakerXP, largeReward)} {GiveReward(_warchiefXP, largeReward)}{GiveReward(_tricksterXP,largeReward)}{GiveReward(_courageXP, largeReward)}
+ [Leave]
->save_and_leave(->GOE_aftermath)

