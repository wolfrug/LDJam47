// Random encounters!

==cannotEnter
You cannot enter here [Demo]
->doneCannotEnter
=loc_Corral
You need to get the Sigil from the gate first!
->doneCannotEnter

=loc_Ruins_Interior
As you attempt to enter, walls spring out of nowhere, blocking your path. A clay-light appears, waiting for a sigil that you do not have.
->doneCannotEnter
=loc_Stacks_Interior
As you attempt to enter, walls spring out of nowhere, blocking your path. A clay-light appears, waiting for a sigil that you do not have.
->doneCannotEnter

=loc_Ruins
This is a test! Omg.
->doneCannotEnter

=loc_Center
A wall of turrets pops up in front of you. Best not risk it.
->doneCannotEnter

=doneCannotEnter
{debug:
->debugTravelOptions
-else:
->DONE
}

==encounter
Nothing happens.
->leave

=danger
->genericBackgroundDescription->
// We generate an event based on its level...
{camp_zone_dangerCoeff:
- 1:
->dangerhuman
- 2:
->dangerhuman
- 3:
->dangercity
- else:
->dangerbig
}

=dangerhuman
~temp dangerLevel = RANDOM(1,3)
// Low-level danger events, usually based on people, solved with one of the skills
You come across a {~small band of|a group of|a few} {~outcasts|fanatics|desperate people|strangers|outsiders}. <>
{~->warchiefCheck|->tricksterCheck|->pactmakerCheck}
- (warchiefCheck)
They give you no time to parlay and attack!
->AdvancedSkillCheck(_warchief, dangerLevel, 0, _warriors, warriors, smallAmount, ->dangerhumanWinWarchief, ->dangerhumanLoseWarchief)
- (tricksterCheck)
You tell your warriors to act as scouts to help everyone sneak past them safely.
->AdvancedSkillCheck(_trickster, dangerLevel, 0, _warriors, warriors, smallAmount, ->dangerhumanWinTrickster, ->dangerhumanLoseTrickster)
- (pactmakerCheck)
You decide to attempt to parlay; albeit carrying a big stick.
->AdvancedSkillCheck(_pactmaker, dangerLevel, 0, _warriors, warriors, smallAmount, ->dangerhumanwinPactmaker, ->dangerhumanlosePactmaker)

=dangerhumanWinTrickster(fumbled)
{not fumbled:
You manage to sneak past them without alerting them to your presence.
{GiveReward(_tricksterXP, smallReward)}
{GiveReward(_courageXP, smallReward)}
-else:
A call goes up from the group! You order everyone to run. Did everyone make it...?
{GiveReward(_tricksterXP, smallReward)}
} 
->FinishScavenging("Time to go.")
=dangerhumanLoseTrickster(fumbled)
A call goes up from the group! You order everyone to run <>
{food > 0 || clay > 0:
while you drop some supplies to distract them
{alter(_food, -RANDOM(1,2))}
{alter(_clay, -RANDOM(1,2))}
- else:
    {partySize(false)>1:
        but not everyone is fast enough
        {KillRandomCrewMember(false)}
        {GiveReward(_failureXP, smallReward)}
    }
}<>. 
{GiveReward(_tricksterXP, smallReward)}

->FinishScavenging("You later regroup, out of breath, but safe. ")

=dangerhumanWinWarchief(fumbled)
{GiveReward(_warchiefXP, smallReward)}
{GiveReward(_courageXP, smallReward)}
You {~chase them away|repel their attack|defend yourself successfully} {fumbled: with some effort| with ease.}
->FinishScavenging("Time to go.")
=dangerhumanLoseWarchief(fumbled)
During the fight, some of their number slip past your defences and <>
{food > 0 || clay > 0:
steal some of your supplies.
{alter(_food, -RANDOM(1,2))}
{alter(_clay, -RANDOM(1,2))}
- else:
    {partySize(false)>warriors+1:
        attack your civilians!
        {KillRandomCivilian(false)}
        {GiveReward(_failureXP, smallReward)}
    - else:
        attack you in the back!
        {KillRandomCrewMember(false)}
        {GiveReward(_failureXP, smallReward)}
    }
}
 <> 
{GiveReward(_warchiefXP, smallReward)}
->FinishScavenging("Afterwards, they quickly make their escape.")

=dangerhumanwinPactmaker(fumbled)
{not fumbled:
You manage to convince them you are not worth the fight, and your two parties part way peacefully.
{GiveReward(_courageXP, smallReward)}
- else:
In the middle of the talk someone throws a rock, and it sudenly turns into a scuffle - several heads bashed in later, you mutually back away.
}
{GiveReward(_pactmakerXP, smallReward)}
->FinishScavenging("Time to go.")

=dangerhumanlosePactmaker(fumbled)
~temp dangerLevel = RANDOM(1,3)
Despite your best attempt, the confrontation turns hostile!
->AdvancedSkillCheck(_warchief, dangerLevel, 0, _warriors, warriors, smallAmount, ->dangerhumanWinWarchief, ->dangerhumanLoseWarchief)

// More dangerous, city-based encounters.
=dangercity
~temp dangerLevel = RANDOM(2,5)
A {~patrol-bot|swarm of Vulture-drones|automated turret|glitch-structure|broken Hunter-Killer} appears. <>
{~->warchiefCheck|->tricksterCheck|->pactmakerCheck}
- (warchiefCheck)
It notices you, and attacks without mercy.
->AdvancedSkillCheck(_warchief, dangerLevel, 0, _warriors, warriors, smallAmount, ->dangercityWinWarchief, ->dangercityLoseWarchief)
- (tricksterCheck)
You can create an interference shield from Clay - provided you have enough...and enough Clayworkers.
~temp amountAdded = tokenAmount
{clayworker:
- 0:
~amountAdded = tokenAmount
- 1:
~amountAdded = smallAmount
- 2:
~amountAdded = mediumAmount
- else:
~amountAdded = largeAmount
}
->AdvancedSkillCheck(_trickster, dangerLevel, 0, _clay, clay, amountAdded, ->dangercityWinTrickster, ->dangercityLoseTrickster)
- (pactmakerCheck)
You attempt to parlay, your shamans acting as interpreters.
->AdvancedSkillCheck(_pactmaker, dangerLevel, 0, _shaman, shaman, largeAmount, ->dangercityWinPactmaker, ->dangercityLosePactmaker)

=dangercityWinWarchief(fumbled)
It is a hard fight, {fumbled:and you end up taking losses.|but you and your warriors come out of it mostly intact.}
{GiveReward(_warchiefXP, mediumReward)}
{GiveReward(_courageXP, mediumReward)}
->FinishScavenging("Now to escape before the City sends out its Hunter-Killers.")

=dangercityLoseWarchief(fumbled)
You fight, but you sustain losses. 
{warriors>0: {alter(_warriors, -RANDOM(1,2))}|{KillRandomCrewMember(false)}} 
{GiveReward(_warchiefXP, mediumReward)}
{GiveReward(_courageXP, smallReward)}
{GiveReward(_failureXP, mediumReward)}
->FinishScavenging("You do not have time to bury your dead after.")

=dangercityWinTrickster(fumbled)
Your ploy works; the City's eye passes over you - and then beyond. You wait under your shields for a while, and then continue; {fumbled && clay > 0: although not all the Clay could be re-used.|the Clay used reconstituted safely.}
{fumbled && clay > 0: {alter(_clay, -RANDOM(1,2))}}
{GiveReward(_tricksterXP, mediumReward)}
{GiveReward(_courageXP, mediumReward)}
->FinishScavenging("Time go go.")

=dangercityLoseTrickster(fumbled)
The ploy almost works, but then the City's agents see through your shields. You order everyone to run. {not fumbled: Luckily, the City seems more interested in observing the shields you left behind.|Unfortunately, not everyone is fast enough.}
{not fumbled:
{GiveReward(_failureXP, smallReward)}
- else:
{KillRandomCrewMember(false)}
{KillRandomCrewMember(false)}
}
{alter(_clay, -RANDOM(2,4))}
{GiveReward(_failureXP, mediumReward)}
{GiveReward(_tricksterXP, mediumReward)}
{GiveReward(_courageXP, smallReward)}
->FinishScavenging("You escape somewhere safer, regrouping as best you can.")
=dangercityWinPactmaker(fumbled)
{not fumbled: You present the correct permits, or quickly manufacture them on the spot. The City scans you with its clay-light, and then, to your relief, leaves.|The City looks at your united front and - for a second - seems to give you the green light. And then, the bloodshed starts. You run.}
{not fumbled: {GiveReward(_courageXP, mediumReward)}}
{GiveReward(_pactmakerXP, mediumReward)}
->FinishScavenging("You eventually get far enough away for the City to forget you.")
=dangercityLosePactmaker(fumbled)
~temp dangerLevel = RANDOM(3,5)
You attempt to present the permits, but every word you speak and sigil you display seems to anger the City more. Shrill warning sirens follow red clay-light. {fumbled: A shaman disappears in a shower of red, and the attack is on.|The attack comes as a complete surprise.}
->AdvancedSkillCheck(_warchief, dangerLevel, 0, _warriors, warriors, smallAmount, ->dangercityWinWarchief, ->dangercityLoseWarchief)

=dangerbig
->dangercity

=eventgeneric
{partySize(false)>1:
//->genericBackgroundDescription->
#spawn.background.example
{camp_zone == "Corral": ->evts_corral}
{~->dangerhuman|->dangercity}
- else:
Lacking a wercru, you keep entirely to yourself, not risking as much as meeting a fellow traveller. You will need to get back and find a new wercru soon.
{GiveReward(_failureXP, tokenReward)}
}
->leave

=genericBackgroundDescription

{camp_zone:
- "Corral":
#spawn.background.grassland
- "Ruins":
#spawn.background.desert
//Grassland farms.
- "Ruins_Interior":
#spawn.background.desert
//Desert.
- "Stacks":
#spawn.background.stacks
//Regular forest.
- "FOREST_STACKS":
#spawn.background.event.forest
//Stack forest.
- "HILLS":
#spawn.background.event.hills
//Hills.
- "JUNGLE":
#spawn.background.event.jungle
//Jungle.
- "CITY_RUINS":
#spawn.background.event.city
//City ruins.
- "CITY_BUILT":
#spawn.background.event.city
//City built.
- "CITY_CENTER":
#spawn.background.event.city
//City center.
- "SPECIAL":
//Special [not in use]
- "SPECIAL_CORRAL":
#spawn.background.event.home
//Corral.
- "SPECIAL_JUNGLE":
#spawn.background.event.jungle
//Special jungle.
- "SPECIAL_STACKS":
#spawn.background.event.stacks
//Special stacks.
- "SPECIAL_RUINS":
#spawn.background.event.city
//Special ruins.
- "SPECIAL_CENTER":
#spawn.background.event.city
//Special center.
- "SPECIAL_BUNKER":
#spawn.background.event.bunker
//Special bunker.
- "SPECIAL_WARGOLEM":
#spawn.background.event.golem
//Special wargolem.
- "SPECIAL_FOUNDRY":
#spawn.background.event.foundry
//Special foundry.
- else:
#spawn.background.example
}

->->

//=evt_gen_storypick1


=eventgeneric_1
You spot a dot in the sky, heralding the arrival of one of the City's Overseers. This is an old one, covered in mossbeard and mold. It has not yet seen you.

+ [Order your wercru to lay low and hide.]
{not fumbleCheck(0):
You find a crevice between two buildings where everyone fits. The old Overseer circles the area in a lazy patrol, before leaving.
{GiveReward(_tricksterXP, smallReward)}
- else:
You do not do a very good job of finding cover, your limbs heavy and your minds clouded. The Overseer very nearly catches you, despite being old and decripit, its light-of-challenge flickers on and off intermittently. After a long time, it finally leaves, and you breathe a sigh of relief.
{GiveReward(_failureXP, smallReward)}
{GiveReward(_tricksterXP, tokenReward)}
}
+ [Prepare to recite the Words of Notice.{displayCheck(_pactmaker, easy)}]
You stand tall as the Overseer circles. It takes a moment for it to spot you. When it does, it lowers itself in front of you, unsteady, and turns on its light-of-challenge. In the language of the Bozes, it shouts a challenge at you.
{skillCheck(_pactmaker, easy):
{not fumbleCheck(0):
You calmly recite the standard reply. The Overseer wobbles in the air for a moment, before shutting off its light and hovering off. Your crew waits until it is gone before cheering.
{GiveReward(_pactmakerXP, mediumReward)}
- else:
You attempt to recite the standard reply: you know it, by heart. But a fog of exhaustion makes the words stumble out of your mouth. The Overseer wobbles. Then it shouts its challenge again, its eye turning red. Fear makes you concentrate, and you repeat yourself, louder, even as the Overseer rises above you, its challenge-light hopping from crew-member to crew-member. After a heart-stopping second, it accepts your words. It turns off its light and hovers off.
{GiveReward(_failureXP, smallReward)}
{GiveReward(_pactmakerXP, tokenReward)}
}
- else:
You recite the words as you learned them, your voice breaking slightly. The Overseer wobbles. Then it shouts its challenge again, its eye turning red. You repeat yourself, louder, even as the Overseer rises above you, its challenge-light hopping from crew-member to crew-member. After a heart-stopping second, it accepts youe words. It turns off its light and hovers off.
{GiveReward(_failureXP, smallReward)}
{GiveReward(_pactmakerXP, tokenReward)}
}

+ [Lay low, but prepare your weapons]
The Overseer is old; it may not respond to the Words of Notice as expected. {warriors>0: Your warriors prepare their weapons.} The goal is to destroy it before it can inform the Bozes, if it comes to it.
{not fumbleCheck(0):
The Overseer circles your position a few times, but it does not notice you. After a tense few minutes, it flies off.
    {GiveReward(_warchiefXP, tokenReward)}
- else:
As the old Overseer circles, time and again, your attention wanes; exhaustion overtakes you, and you close your eyes. For just a second. When your wercru wakes you, the Overseer is gone; and so is their respect.
{GiveReward(_failureXP, smallReward)}
{GiveReward(_warchiefXP, tokenReward)}
}
- The Overseer finally gone, you continue on your way.
->leave

=eventgeneric_2
// Only occurs if you have a tribesman to sacrifice
{warriors+tribesmen+clayworker+shaman<1:
->eventgeneric
}
A sudden sound of something cracking, followed by a yelp and a thud interrupts your walk. A hole has suddenly appeared in the pavement, a clean crack that leads down into some unknown area underneath. And one of your wercru has fallen in.
~temp fallInType = "tribesman"
~temp fallinTypeReal = _tribesmen
{PickRandomCrewMember(fallInType, fallinTypeReal, false)}
You hurry up to the crack, carefully crawling the last bit to look down. The face of a {fallInType} looks up at you. They report being mostly unharmed, but it is clear there is no way to climb up easily.
{alter(fallinTypeReal, -1)}
+ {clay>0 && clayworker > 0}[Have your Clayworkers fashion a quick rescue rope. ({displayCheck(_clayworker, easy)})]
{skillCheck(_clayworker, easy):
{not fumbleCheck(0):
It does not take long to fashion a rope out of Clay. It is thin, but can easily carry a man. Together, you brace as the {fallInType} climbs out. Afterwards, most of the clay in the rope is reused.
{alter(_clay, -1)}
{alter(fallinTypeReal, 1)}
{GiveReward(_tricksterXP, smallReward)}
{GiveReward(_courageXP, smallReward)}
- else:
Your clayworker, in a haze of exhaustion, finally finishes the rope. It looks thin - too thin. But the clayworker assures you it will hold. You drop it down and brace, but halfway up the rope snaps! You rush to the edge, but you can immediately tell your {fallInType} was not as lucky this time.
{GiveReward(_failureXP, mediumReward)}
}
- else:
Your clayworker finishes the rope after some time. It seems thick and sturdy, but for some reason your clayworker is not happy. You drop the rope down and brace. It holds well, and after a moment your {fallInType} is back on solid ground. A few moments later, the claywork rope begins to harden, turning into a brittle, dusty substance. The clayworker in charge curses under his breath.
{alter(_clay, -2)}
{alter(fallinTypeReal, 1)}
{GiveReward(_tricksterXP, tokenReward)}
{GiveReward(_courageXP, smallReward)}
}
+ [Fashion a rope out of whatever material you find handy.]
It takes a bit of time, but soon you have a sturdy enough rope. You drop it into the hole.
{not fumbleCheck(10):
Your {fallInType} soon finishes climbing up the hole. You haul them up the last bit yourself. They dust themselves off, thanking you for your help.
{alter(fallinTypeReal, 1)}
{GiveReward(_courageXP, smallReward)}
- else:
Your {fallInType} is nearly at the top when their hand slips off the rope material. Or perhaps they were too tired to hold on. You rush to the edge of the hole and look down. Your {fallInType} lies sprawled in an unnatural angle, neck broken.
{GiveReward(_failureXP, mediumReward)}
}

+ [Tell them you will send someone else to get them. ({displayCheck(_pactmaker, hard)})]
{partySize(false)>0:
Your wercru immediately protests. You do not leave your own behind. You can sense real anger in their eyes.
{skillCheck(_pactmaker, hard):
You explain the urgency of your mission; why there is no time to waste. They do not like what they hear, but they grudgingly accept it.
{GiveReward(_failureXP, smallReward)}
{GiveReward(_pactmakerXP, mediumReward)}
- else:
{PickRandomCrewMember(fallInType, fallinTypeReal, false)}
You try to explain to them why there is no time to waste - when that fails, you resort to the law of the wercru. You are the leader, they must listen to you. Despite that, a {fallInType} says they will stay behind just in case. There is nothing you can do to convince them otherwise.
{GiveReward(_failureXP, mediumReward)}
{GiveReward(_pactmakerXP, smallReward)}
{alter(fallinTypeReal, -1)}
}
}
- 
->leave

=eventgeneric_3
{partySize(false)<2:
->eventgeneric
}
You take a short break in the shadow of a building, careful not to touch it but enjoying the shade it provides. As you do, you notice two of your crew members cannot stop arguing; you cannot decide if they are siblings, lovers, former lovers, great friends, terrible friends, or utter strangers to one another - but their mutual sniping is beginning to grate. And not just on you.

+ [Listen to both, and try to figure out a compromise. ({displayCheck(_pactmaker, hard)})]
Compromise, as the Elders say, means finding a solution where everyone is equally miserable. You listen to both of them. {~They are siblings, fighting over some obscure old slight from when they were both toddlers.|They are former lovers, rekindling an old argument.|They are good friends but incredibly thick-headed, and their good-natured argument risks going sour.|They are lovers, both angry that the other one decided to volunteer.|They pretend friendship, yet they clearly detest one another.|They slept together last night, and now neither can decide if that was a mistake or not.|They are natural grumps, attracted to each other like Vultures to scrap.}
{skillCheck(_pactmaker, hard):
    {not fumbleCheck(0):
Somehow, you manage to make them bridge their differences, joining together in a mutual dislike of you instead. Success?
{GiveReward(_pactmakerXP, largeReward)}
- else:
Half-way through your talk, you lose your line of thought. So do they. Soon, they return to their bickering, except they seem even more entrenched than before.
{GiveReward(_failureXP, smallReward)}
{GiveReward(_pactmakerXP, smallReward)}
}
- else:
You try to get them to compromise, but your efforts lead to nothing but their fighting becoming more intense, somehow both of them being sure you are on their side. Finally, you have to physically separate them.
{fumbleCheck(10):
~temp pickedMember = ""
~temp realPickedMember = ""
{PickRandomCrewMember(pickedMember, realPickedMember, false)}
When it is time to go again, one of the two - a {pickedMember} - is nowhere to be found, their pack gone. You wait for a while, but it is clear they are not coming back. At least your crew is now quiet.
    {alter(realPickedMember, -1)}
    {GiveReward(_failureXP, mediumReward)}
- else:
The physical fight seems to have been catharsis of a kind at least, and for the first time in a while they are quiet. But the mood in the wercru is not wonderful.
{GiveReward(_failureXP, smallReward)}
{GiveReward(_pactmakerXP, smallReward)}
}
}

+ [Listen to both and determine who is right and who is wrong. ({displayCheck(_pactmaker, medium)})]
You let each of them air their grievances to you. {~They are siblings, fighting over some obscure old slight from when they were both toddlers.|They are former lovers, rekindling an old argument.|They are good friends but incredibly thick-headed, and their good-natured argument risks going sour.|They are lovers, both angry that the other one decided to volunteer.|They pretend friendship, yet they clearly detest one another.|They slept together last night, and now neither can decide if that was a mistake or not.|They are natural grumps, attracted to each other like Vultures to scrap.}
{skillCheck(_pactmaker, medium):
    {not fumbleCheck(0):
Acting like a neutral arbiter, you determine who is more correct. The winner gloats over the loser; but at least the camp is quiet again.
{GiveReward(_pactmakerXP, mediumReward)}
- else:
Half-way through your attempted arbitration, you lose your line of thought. So do they. Soon, they return to their bickering, except they seem even more entrenched than before.
{GiveReward(_failureXP, smallReward)}
{GiveReward(_pactmakerXP, tokenReward)}
}
- else:
After listening to them, you determine they are both idiots. Telling them this does little for their mood.
{fumbleCheck(0):
{PickRandomCrewMember(pickedMember, realPickedMember, false)}
When it is time to go again, one of the two - a {pickedMember} - is nowhere to be found, their pack gone. You wait for a while, but it is clear they are not coming back. At least your crew is now quiet.
    {alter(realPickedMember, -1)}
    {GiveReward(_failureXP, mediumReward)}
- else:
The one good thing is that they are now both united in their dislike of you, and thus, for the moment, quiet. You feel them staring daggers in your back as you give the order to move.
{GiveReward(_failureXP, tokenReward)}
{GiveReward(_pactmakerXP, tokenReward)}
}
}

+ [Ask them to keep their rivalry to themselves while on the road. ({displayCheck(_pactmaker, easy)})]
These kinds of arguments do not belong on the road. There are other, more important things that you should focus on.
{skillCheck(_pactmaker, easy):
{not fumbleCheck(0):
The two shut up when you bark at them, and for the moment, that seems to be enough. The rest of your crew look at you appreciatively.
{GiveReward(_pactmakerXP, smallReward)}
- else:
You're not sure if it's from being hungry, or tired, or what exactly, but you come off as a little too sharp when you tell them to shut up, your voice echoing off the side of the building. They look at you with daggers in their eyes.
{GiveReward(_failureXP, smallReward)}
{GiveReward(_pactmakerXP, tokenReward)}
}
-else:
You try your best to be diplomatic, but it has little effect. You sigh, deciding it is best to simply ignore them. You watch as other members of the crew get up and move away from them.
{GiveReward(_pactmakerXP, tokenReward)}
}
 - 
->leave

=crisisexhaustion
{~Your wercru walks {~feet dragging|with heavy steps}, barely able to put one foot in front of the other.|Everyone is beyond {~exhausted|tired}.|Even you are feeling the effects of the march.} Isn't it time to rest?

[Exhaustion increases the risk to Fumble any skill check, turning a success into a failure or a failure into a critical failure. Rest either at a safe location or by setting up camp (by pressing the Camp button).]
{exhaustionCounterWarning:
- firstWarning:
No one says anything. {~They assume you have a good reason to keep going.|Not yet.|You hear some grumbling though.}
~exhaustionCounterWarning++
- secondWarning:
A forced march is a sign of bad planning. Your wercru grumbles, but keeps walking. {GiveReward(_failureXP, tokenReward)}
~exhaustionCounterWarning++
- thirdWarning:
It is clear your crew is all but ready to give up. If you don't stop soon, they will. {GiveReward(_failureXP, smallReward)}
~exhaustionCounterWarning++
- finalWarning:
You doggedly keep moving. You don't even notice your crew is dropping off behind you. {KillRandomCrewMember(false)}.{GiveReward(_failureXP, smallReward)}
}
->leave

=crisispanic
Criris: low courage.
->leave

=crisisstarvation
{starvationCounterWarning == firstWarning:You stop to dole out the rations, but there are no rations to dole out. You need to find more food, soon, before hunger - or starvation - strikes.|Your wercru is starving.}
[Starvation increases your risk to Fumble any skill check, turning a success into a failure or a failure into a critical failure. Find more food by scavenging, through events, or other methods.]
{starvationCounterWarning:
- firstWarning:
The Elbéar are no strangers to hunger. Your wercru walks on, in silence.
~starvationCounterWarning++
- secondWarning:
Even the last scraps of dried meat and hidden snacks have gone. Only gnawing hunger remains.
{GiveReward(_failureXP, smallReward)}
~starvationCounterWarning++
- thirdWarning:
The Pitchief's words echo in your head: you promised to feed all who join your crew. They will talk of this. {GiveReward(_failureXP, mediumReward)}
~starvationCounterWarning++
- finalWarning:
You doggedly keep moving. Your crew, however, is slipping away from you. {KillRandomCrewMember(false)}.{GiveReward(_failureXP, mediumReward)}
}


->leave

=leave
{debug:
->->
-else:
->DONE
}

// EXAMPLE 1 //////////////////////////
=example1
{->part1|->part2|->part3}
->evts_corral
- (part1)
Part one example1

* [Option 1]->option1
* [Option 2]->option2
- (option1)
Option 1
{debug:
->debugRetry
-else:
->evts_corral_done
}
- (option2)
Option 2
{debug:
->debugRetry
-else:
->evts_corral_done
}
- (part2)
Part two example1
{debug:
->debugRetry
-else:
->evts_corral_done
}
- (part3)
{encounter.example1.part3>1: ->finished}
Part three example1

* [Option 3]->option3
* [Option 4]->option4

- (option3)
Option 3.
{debug:
->debugRetry
- else:
->evts_corral_done
}
- (option4)
Option 4
{debug:
->debugRetry
- else:
->evts_corral_done
}

- (finished)
Finished pactmaker2
{debug:
->debugRetry
- else:
->evts_corral_done
}
