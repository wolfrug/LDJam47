// Keep this include while working/testing, I will comment out when integrating
//INCLUDE clay_functions.ink
// Change the 'locationName' of all of these to correspond to the knot name below
// Set in the 'leave' stitch
VAR camp_last_visit = -1
// this is set to true when the location is spawned. Needs to be set to false manually
VAR camp_new = true
// this is set when spawned.
VAR camp_creationTime = 0
// this is set when the object is very close to the edge
VAR camp_dangerClose = false
// set this to true if you want it to be hidden
VAR camp_hidden = false
// this is set by what ground you are standing on
VAR camp_zone = "default"
// coefficients = coeff/2 - coeff*2 min/max. So 5 = 2-10.
VAR camp_zone_clayCoeff = 5
VAR camp_zone_foodCoeff = 5
VAR camp_zone_peopleCoeff = 5
VAR camp_zone_dangerCoeff = 5

==camp
#changebackground
#spawn.background.camp
{partySize(false)>1:
{camp_zone:
- "DEFAULT":
{~You order your wercru to a halt and consider your options.|You stop in the shadow of a ruin. Your crew takes the opportunity to rest their legs.| You order a short rest, but tell your crew not to unpack yet.|You take a short break. The wind picks up, howling between the buildings.|You order a stop. Your wercru obeys, looking at you expectantly.}
}
Your people are <> 
{
- exhausted: 
exhausted<>
- rested:
well rested<>
- else:
in need of rest<>
}
{hungry && !starving:
{rested:
<> but <>
- else:
<> and <>
}
hungry.
- else:
{starving:
{rested:
<> but <>
- else:
<> and <>
}
starving.
- else:
.
}
}
- else:
// Party size of just you + companions!!
You have no wercru. You need to gather one if you are to survive out here.
}

- (options)
<-EvaluateCompanionChats
+ [Set up camp and rest {displayTime(mediumTime)} (Save Game)]->rest
+ {clayScrap > clayScrapPerClay} [Melt down your Scrap into Clay({displayTime(shortTime)}]->manufactureClay
+ {hasGoldenOmbrascope} [Decipher the Golden Ombrascope {displayTime(shortTime)}] ->ombrascope_guidance
+ [Debug]->debugStuff
+ {partySize(false)>1}[Send away some crew]->sendAwayCrew

+ [Continue your journey]
{partySize(false)>1:
{exhausted:
{~The members of your wercru groan in protest as you give the order to leave.|Your wercru look like sleepwalkers as they start moving again, feet dragging along the pavement.|Hope leaves the eyes of your wercru as they force themselves to move again.|With visible effort, your wercru moves again.|It is obvious your wercru had hoped for a longer rest. Their movements are slow and sluggish.}
- else:
{~You give the order to start moving again, and your crew sets off.|You continue on your journey through the City.|Time to go. Your crew hoists their packs and follows you.|Your short rest is concluded, and soon your wercru is on its feet again.|You get up, signalling to the others it’s time to go. Soon, you’re ready.}
}
}
->leave

=debugStuff
+ [Add Ruins Interior Sigil & open battlefield location]
{AddSigil(Ruins_Interior)}
~battlefield_hidden = false
#updateLocationVisibility
Ruins interior sigil added and battlefield is no longer hidden!
->leave
+ [Add a ton of Clay and a few Clayworkers]
{alter(_clayScrap, 10)}
{alter(_clay, 100)}
{alter(_clayworker, 10)}
->leave
+ [Add a ton of Tales of Bravery!]
{alter(_courageXP, 20)}
->debugStuff
+ [Talk test]
->Say("'Hello peeps.'", Valfrig)->
This comes in between.
->Say("'Hi hi hi.'", Quartermaster)->
->Say("'I talk twice, haha' He says.", Quartermaster)->
->debugStuff
+ [Open journal]
->OpenJournalInt->camp.options
+ [Nevermind]->camp.options

=sendAwayCrew
Sometimes, you gather too big a crew, and some need to be sent away prematurely. This is frowned upon - especially if the tribesmen will have to make their way back to the Corral through dangerous land.

+ {tribesmen>0}[Let tribesmen go]
~temp nrOftribesmen = 0
->AssignWorkers(_tribesmen, nrOftribesmen, " tribesmen let go", tribesmen, 1)->
{alter(_tribesmen, -nrOftribesmen)}
{nrOftribesmen>0:
    {fumbleCheck(50):
    The tribesmen let go grumble as they leave. You have a feeling they will have something to say about your leadership when they reach the Corral.
    {nrOftribesmen>15:
        {GiveReward(_failureXP, mediumReward)}
        - else:
        {GiveReward(_failureXP, smallReward)}
    }
    - else:
    Your tribesmen say little as the selected ones pack their things and leave.
    {GiveReward(_failureXP, tokenReward)}
    }
    - else:
    Nevermind. You tell your wercru to get back to work.
}
->camp.options
+ {warriors>0}[Let Warriors go]
~temp nrOfWarriors = 0
->AssignWorkers(_warriors, nrOfWarriors, " warriors let go", warriors, 1)->
{alter(_warriors, -nrOfWarriors)}
{nrOfWarriors>0:
    {fumbleCheck(50):
    The warriors you selected to leave seem to take offense. You have a feeling they will not speak well of you once they reach the Corral.
    {nrOfWarriors>10:
        {GiveReward(_failureXP, mediumReward)}
        - else:
        {GiveReward(_failureXP, smallReward)}
    }
    {RANDOM(0,nrOfWarriors)>5 && warchiefXP > 0:
        You hear some of the warriors taking credit for your acts of prowess as they leave. No doubt those tales will already long be told by the time you reach the Corral.
        {alter(_warchiefXP, -RANDOM(1,5))}
    }
    - else:
    The warriors you selected pack their things in silence and shame.
    {GiveReward(_failureXP, smallReward)}
    }
    - else:
    Nevermind. You tell your wercru to get back to work.
}
->camp.options
+ {shamans()>0}[Let Shamans go]
~temp nrOfShamans = shamans()
->AssignWorkers(_shaman, nrOfShamans, " shamans let go", nrOfShamans, 1)->
{alter(_shaman, -nrOfShamans)}
{nrOfShamans>0:
    {fumbleCheck(50):
    Your shamans are not amused. They have better things to do than get dragged around and then dropped.
    {nrOfShamans>3:
        {GiveReward(_failureXP, mediumReward)}
        - else:
        {GiveReward(_failureXP, smallReward)}
    }
    {RANDOM(0,nrOfShamans)>1 && pactmakerXP > 0:
        You have a feeling the shamans you let go will take credit for some of your acts.
        {alter(_pactmakerXP, -RANDOM(1,5))}
    }
    - else:
    The shamans you selected take what few things they brought and leave without further ado.
    {GiveReward(_failureXP, smallReward)}
    }
    - else:
    Nevermind. You tell your wercru to get back to work.
}
->camp.options
+ {clayworkers()>0}[Let Clayworkers go]
~temp nrOfClayworkers = clayworkers()
->AssignWorkers(_clayworker, nrOfClayworkers, " clayworkers let go", nrOfClayworkers, 1)->
{alter(_clayworker, -nrOfClayworkers)}
{nrOfClayworkers>0:
    {fumbleCheck(50):
    Your clayworkers are not amused. They were promised certain things, and that promise is now broken.
    {nrOfClayworkers>3:
        {GiveReward(_failureXP, mediumReward)}
        - else:
        {GiveReward(_failureXP, smallReward)}
    }
    {RANDOM(0,nrOfClayworkers)>1 && tricksterXP > 0:
        You have a feeling the Clayworkers will spread rumours about some of your acts, painting them in a much less favorable light.
        {alter(_tricksterXP, -RANDOM(1,5))}
    }
    - else:
    The clayworkers you selected pack what they brought and leave, back for the Corral.
    {GiveReward(_failureXP, smallReward)}
    }
    - else:
    Nevermind. You tell your wercru to get back to work.
}
->camp.options
+ [Nevermind.]
->camp.options

=manufactureClay
{clayworker>0:
Your clayworkers set about the task of turning the scrap you have looted into useable Clay. Soon the camp is wreathed in acrid smoke.
- else:
You are no clayworker, but your father taught you well. Although it would be more effective with a trained clayworker...
}
{startTimer(0, shortTime, "camp.manufactureClayDone")}
You begin the work.
{debug:
->simulateWait(0,shortTime,false,->camp.manufactureClayDone)
- else:
->leave
}
=manufactureClayDone
{clayworker>0:
Your clayworkers finish their alchemy. Clean, new Clay, free of evil spirits.
- else:
You finish your alchemy. Clean, new Clay, free of evil spirits.
}
{CreateClay(clayScrap)}
You marvel at the natural state of Clay - uniform black cubes, easily stacked. Each capable of marvels.
->leave

=locationRest(location)
{startTimer(0, mediumTime, "camp.restDone")}
#endTurn
// when resting at a location, we eat no food
~foodPerTribesmanPerTime = 0.0
~foodPerSpecialistPerTime = 0.0
{location:
- "home":
Your crew disperses into the Corral, to sleep the night with their families and friends. At least you will not have to worry about feeding them tonight.
~home_last_visit = currentTime
~foodChunkLeft = foodChunkDefault
}
{debug:
->simulateWait(0,50,false,->camp.restDone)
- else:
->leave
}

=rest
{startTimer(0, mediumTime, "camp.restDone")}
#endTurn
{exhausted:
{~Your wercru, delirous with exhaustion, collapse into their tents. A silence falls over the camp within minutes.|Your crew barely bother setting up their tents when the order comes to camp; some sleep in their cloaks right on the ground.|You can hear sighs of relief throughout your crew, as they are finally given a chance to rest. Soon, the whole camp is still.|People stagger to a stop when the order comes, practically swaying on their feet. Then they make camp with their last reserves of strength, before crawling into their tents to sleep.|Exhausted beyond measure, your wercru rigs up their tents and crawl in to sleep. It takes moments before the first snores can be heard.} 
- else:
{not rested:
{~Your wercru settles in for a rest from the never-ending walk, happy to rest their legs.|Rest is always welcome. The crew chats amicably among themselves by their tents, and some even scavenge for some extra food around the camp. {~foodChunkLeft=foodChunkDefault}|Soon, a campfire is lit, and someone is boiling some red tea. Everyone is glad for the chance to recuperate.|The order to set up camp is greeted with a small cheer from your crew. They stop, and pitch tents with practiced ease.|Your wercru is happy to stop and rest their weary legs. Tomorrow will be another day, but tonight it is time for sleep.}
- else:
{~Your wercru is slightly surprised at your order to stop and rest, but they are happy to comply. Soon, the tents are pitched – again.|Some members of the crew protest – there is still more to be done – but they are quickly shushed by others, who are already happily pitching tents.|Few of your crew are tired enough to sleep right away. Instead, they tell stories around the campfire. You listen in.{alter(_courageXP, 1)}|Your wercru, although still fresh, is happy to comply. Someone makes a feast of it, gathering supplies for the soup from the surroundings.{~foodChunkLeft=foodChunkDefault}|You give the order to stop and set up the tents. Your crew complies, always glad to rest.}
}
}
{debug:
->simulateWait(0,mediumTime,false,->camp.restDone)
- else:
->leave
}
=restDone
{exhausted && not hungry:
{~The people crawling from their tents are like new; revived once more after a good rest.|You can tell from the atmosphere in the camp that the rest did more than good. Your wercru is once more ready to face the City.|Despite some groaning, most seem to have recovered well. Soon, the camp is bustling with energy.|After a long rest, your crew seems fully revived.}
- else:
{hungry || starving:
{~You can tell your crew is far from well rested as they emerge from their tents. Hunger clearly gnaws at them.|Sleep can only make you forget your hunger for so long; your crew, although rested, are clearly not in top form.|Starting your day without breaking your fast leaves a mark. Your crew sits listlessly outside their tents, unsure of what to do.|Your crew went to bed hungry and woke up hungry; the rest seems to have done little for their energy levels.|The wercru crawling out of their tents hardly look any better rested than when they crawled in, their faces gaunt with hunger.}
}
}
{not starving:
~rested = true
~starvationCounterWarning=firstWarning
~timeUntilExhausted = timeUntilExhaustedDefault
- else:
~timeUntilExhausted = timeUntilExhaustedDefault/2
}
~exhausted = false
~exhaustionCounterWarning = firstWarning
~timeSinceRest = 0
~foodPerTribesmanPerTime = foodPerTribesmanPerTimeDefault
~foodPerSpecialistPerTime = foodPerSpecialistPerTimeDefault
#saveGame
Your wercru has finished decamping and is ready to head out.
->leave
=ombrascope_guidance
{LIST_COUNT(knownLocations)<1:
There is a sense of reverence as you settle down around the golden ombrascope. The moment you shine a light through it, you can see the image projected through it is no mere glyph: it moves.

This is something different, and interpreting it will take time.
- else:
You settle down in front of the golden ombrascope, ready to receive its guidance.
}
{startTimer(0,shortTime, "camp.ombrascope_guidance_done")}

{debug:
->simulateWait(0,shortTime,false,->camp.ombrascope_guidance_done)
- else:
->leave
}
=ombrascope_guidance_done

{!~->ombrascope_hint.tribesmenHint|->ombrascope_hint.warriorsHint|->ombrascope_hint.foodHint|->ombrascope_hint.courageHint|->ombrascope_hint.clayHint|->ombrascope_hint.finalLocationHint|->ombrascope_hint.nonsenseHint}
->ombrascope_hint.nonsenseHint

{debug:
->camp
}
->leave

=leave
// always use this when finishing
// this sets the last visit time to current time, if this is needed for checks
~camp_last_visit = currentTime
{debug:
->debugTravelOptions
-else:
->DONE
}

==EvaluateCompanionChats
// Use this to evaluate whether a "so and so wants to talk to you" pops up in the camp
+ {journal_currentTask==Task_FayniRecruiting && companions?Fayni && not (journal_doneTasks?Task_FayniRecruiting) && isTaskFinished(Task_FayniRecruiting)}[Fayni wants to talk to you.]
->Fayni_finishRecruitingStory

