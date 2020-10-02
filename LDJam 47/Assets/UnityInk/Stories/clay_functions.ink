// FUNCTIONS FOR CLAY GAME DEMO 

// player info
VAR playerName = ""
VAR xer = "his"
VAR Xer = "His"
VAR xe = "he"
VAR Xe = "He"
VAR xim = "him"
VAR Xim = "Him"

LIST playerPortrait = MalePortrait, FemalePortrait, (AndroPortrait)
// not relevant right now

// skills and resources are identical - just declare them here.
VAR testskill = 0

VAR _trickster = "Trickster"
VAR trickster = 0
VAR _warchief = "Warchief"
VAR warchief = 0
VAR _pactmaker = "Pactmaker"
VAR pactmaker = 0
VAR _scavenger = "Scavenge"
VAR scavenger = 0

VAR _tricksterXP = "Tale of Trickery"
VAR tricksterXP = 0
VAR tricksterXPNeeded = 5
VAR _warchiefXP = "Tale of Prowess"
VAR warchiefXP = 0
VAR warchiefXPNeeded = 5
VAR _pactmakerXP = "Tale of Insight"
VAR pactmakerXP = 0
VAR pactmakerXPNeeded = 5

VAR food = 0
VAR foodMax = 100
VAR _food = "Food"
VAR tribesmen = 0
VAR _tribesmen = "Tribesmen"
VAR warriors = 0
VAR _warriors = "Warriors"
VAR _clayworker = "Clayworkers"
VAR clayworker = 0
VAR _shaman = "Shamans"
VAR shaman = 0
VAR courage = 0
VAR _courage = "Courage"
VAR _courageXP = "Tale of Courage"
VAR courageXPNeeded = 5
VAR courageXP = 0
VAR _failureXP = "Tale of Ruin"
VAR failureXP = 0
VAR failureXPNeeded = 10
VAR clay = 0
VAR _clay = "Clay"
VAR clayScrap = 0.0
VAR _clayScrap = "Scrap"
VAR clayScrapMax = 10.0
VAR clayScrapPerClay = 3.0


VAR artifacts = 0

VAR hasOmbrascope = false
VAR hasGoldenOmbrascope = false

// Used for various difficulty checks
VAR easy = 2
VAR medium = 4
VAR hard = 6

// Used for various time-comparisons
VAR shortTime = 10
VAR mediumTime = 50
VAR longTime = 200

// Moods
VAR playful = false
VAR thoughtful = false
VAR honorable = false
VAR neutral = true

// Lists
LIST knownLocations = Bunker, WarGolem, EatingEngine, Disassembler, PowerPlant, CommandCenter, Battlefield
VAR finishedLocations = ()
LIST sigils = Corral, (Ruins), Ruins_Interior, Center, Shadows, Foundry, (Stacks),Stacks_Interior, (Jungle), FarHills, Sectariat
LIST rewards = tokenReward, smallReward, mediumReward, largeReward, storyReward
LIST resourceHelpAmounts = tokenAmount, smallAmount, mediumAmount, largeAmount, epicAmount

LIST exhaustionCounterWarning = (firstWarning),secondWarning,thirdWarning,finalWarning
VAR starvationCounterWarning = firstWarning

//specialists
LIST companions = Jaerd, Valfrig, Chi, Barr, Fayni
LIST NPCs = Claymancer, Baba, Pitchief, Quartermaster, Player, Watchman
VAR companionsDead = ()

//Time stuff
// these are set externally

VAR _time = "<size=30><sprite name=\"tmp_time\"></size>"
VAR currentTime = 0
VAR dayLength = 100
VAR timeSinceRest = 0
VAR timeUntilExhausted = 200
VAR timeUntilExhaustedDefault = 200
VAR timeSinceFood = 0
VAR foodChunkLeft = 5.0
VAR foodChunkDefault = 5.0
VAR foodPerTribesmanPerTime = 0.001
VAR foodPerTribesmanPerTimeDefault = 0.001
VAR foodPerSpecialistPerTime = 0.01
VAR foodPerSpecialistPerTimeDefault = 0.01
VAR daysSinceStart = 0
VAR nightTime = false
// this is set to false when the day passes
VAR rested = true
// this is set to true if rested is false and the day passes
VAR exhausted = false
// this is set to true when timeSinceFood is > daylength
VAR hungry = false
// this happens when hungry and timeSinceFOod > daylength *2
VAR starving = false
// this is upped every time you gather a new crew
VAR crewNumber = 0


VAR timeSinceVisited = 0
// these have to do with 'tasks', i.e. timer-related things
VAR task_timeNeeded = 0
VAR task_timeGot = 0
VAR task_name = ""
VAR task_success = false

// time-units until next encounter
VAR time_until_next_encounter = 100
// default time between encounters
VAR default_time_between_encounter = 100

//Saveables
VAR playerX = 0
VAR playerY = 0
VAR playerZ = 0

VAR daytime = 0 

VAR lastSavedString = ""
VAR lastSavedTags = ""

VAR sayStarted = false

// Useful thingies
VAR advanced_skillcheck_succeeded = false
VAR advanced_skillcheck_fumbled = false
VAR pickedRandomCrewMemberString = ""
VAR pickedRandomCrewMemberActual = ""

// Main story progression lists
LIST MainStoryProgress = (Start), EarlyGame, Early_MidGame, Late_MidGame, LateGame, EndGame, Game_Ended
// Main story progress variables
VAR mainStoryCurrentProgress = 0
VAR mainStoryCurrentMaxProgress = 1

// Character story progression lists
LIST character_story_progress = (Not_Found),Recruiting,StoryStart,Reveal,Arrival_Waiting,Arrival,Resolved_Good, Resolved_Bad

VAR Jaerd_Story = ()
~Jaerd_Story = (Not_Found)
VAR Fayni_Story = ()
~Fayni_Story = (Not_Found)
VAR Barr_Story = ()
~Barr_Story = (Not_Found)
VAR Chi_Story = ()
~Chi_Story = (Not_Found)
VAR Valfrig_Story = ()
~Valfrig_Story = (Not_Found)

// External functions
EXTERNAL PassInkTime(x)
EXTERNAL UpdateMainObjective(x,y,z)


===function UpdateMainObjective(inkVariableName, inkVariableMaxName, goal)===
[Updated main objective]

// TASK RELATED FUNCTIONS
==function taskPretext(task)==
{journal_currentTask == task:
(Current Task)
- else:
    {journal_doneTasks?task:
    (<color=green>Complete</color>)
    - else:
        {journal_failedTasks?task:
        (<color=red>Failed</color>)
        }
    }
}
==function isTaskFinished(task)
{journal_doneTasks?task:
~return true
}
{task==journal_currentTask:
~temp currentProgress = 0
{getSkill(journal_currentTaskVariableReal, currentProgress)}
    {currentProgress >= journal_currentTaskGoal:
    ~return true
    }
}
// You cannot succeed tasks that you haven't got selected
~return false
==function finishTask(task)
// Force-finishes the task
~journal_doneTasks+=task
~journal_allTasks-=task
{task==journal_currentTask:
~journal_currentTaskVariableName = ""
~journal_currentTaskVariableMaxName = ""
~journal_currentTaskVariableReal = ""
~journal_currentTaskGoal = 0
~journal_currentTaskIsFloat = false
~journal_currentTask = ()
{UpdateMainObjective("","",false)}
}

==function failTask(task)
//Force-fails the task
~journal_failedTasks+=task
{task==journal_currentTask:
~journal_currentTaskVariableName = ""
~journal_currentTaskVariableMaxName = ""
~journal_currentTaskVariableReal = ""
~journal_currentTaskGoal = 0
~journal_currentTaskIsFloat = false
~journal_currentTask = ()
{UpdateMainObjective("","",false)}
}

// END TASK RELATED FUNCTIONS

===function shamans===
~temp returnVar = shaman
{companions?Valfrig:
~returnVar--
}
~return returnVar

===function clayworkers===
~temp returnVar = clayworker
{companions?Jaerd:
~returnVar--
}
~return returnVar

===function ProgressMainStory()===
// progress actual progress variable
{MainStoryProgress<Game_Ended:
~MainStoryProgress++
}
// progress all companions in the 'StoryStart' stage to the 'Reveal' stage
{Jaerd_Story==StoryStart: 
~Jaerd_Story++
}
{Fayni_Story==StoryStart:
~Fayni_Story++
}
{Barr_Story==StoryStart:
~Barr_Story++
}
{Chi_Story==StoryStart:
~Chi_Story++
}
{Valfrig_Story==StoryStart:
~Valfrig_Story++
}
// Pick a random companion that is Not_Found to start their Recruiting storyline
~temp notFoundCompanions = ()
{Jaerd_Story==Not_Found:
~notFoundCompanions +=Jaerd
}
{Fayni_Story==Not_Found:
~notFoundCompanions +=Fayni
}
{Chi_Story==Not_Found:
~notFoundCompanions +=Chi
}
{Barr_Story==Not_Found:
~notFoundCompanions += Barr
}
{Valfrig_Story==Not_Found:
~notFoundCompanions += Valfrig
}
{LIST_COUNT(notFoundCompanions)>0:
~temp chosenCompanion = LIST_RANDOM(notFoundCompanions)
    {chosenCompanion:
    - Jaerd:
    ~Jaerd_Story++
    - Fayni:
    ~Fayni_Story++
    - Chi:
    ~Chi_Story++
    -Valfrig:
    ~Valfrig_Story++
    -Barr:
    ~Barr_Story++
    }
}

===function CreateClay(scrap)===
~temp guaranteedClay = INT(FLOOR(scrap/clayScrapPerClay))
{guaranteedClay>0:
    {alter(_clay, guaranteedClay)}
    {skillCheck(_clayworker, hard):
    Your clayworkers manage to wring the most out of the scrap.
    {alter(_clay, RANDOM(1,guaranteedClay))}
    {alter(_clayScrap, -clayScrap)}
    - else:
    {clayworker==0:
    You do what you can, but you cannot quite tease all of the Clay out of the scrap. You leave the leftovers for later.
    - else:
    Your Clayworkers do what they can, but much of  the Clay in the scrap remains untouched. Perhaps they can work on it again later.
    }
    {alter(_clayScrap, -(guaranteedClay*clayScrapPerClay))}
    }
- else:
There is not enough scrap to produce any Clay yet.
}

===function PassInkTime(time)===
// Passes ink time!
~currentTime+=time
~timeSinceRest+=time
~timeSinceFood+=time

===function UseButton(buttonName)===
<>{not debug:
\[useButton.{buttonName}]
}
===function UseText(textName)===
<>{not debug:
\[useText.{textName}]
}

===function Req(resourceN, requiredAmount)===
// required resource - to be used in options! [{Req(_tribesmen, 10)}]
~temp resourceString = 0
{getSkill(resourceN, resourceString)}
{resourceString>=requiredAmount:<color=green>|<color=red>}
<>{not debug:
\[{resourceString}/{requiredAmount}\ {resourceN}]</color>
- else:
({resourceString}/{requiredAmount} {resourceN})</color>
}
===function ReqS(currentAmount, requiredAmount, customString)===
// can be used for things that aren't resources - to be used in options! [{Req(stuffYouNeed, 10, "Stuffs")}!]
{currentAmount>=requiredAmount:<color=green>|<color=red>}
<>{not debug:
\[{currentAmount}/{requiredAmount}\ {customString}]</color>
- else:
({currentAmount}/{requiredAmount} {customString})</color>
}


===function GetRandomEncounter()===
// This function should be externalized to the quantum engine
~return RANDOM(0,10)

===function PlayerPortrait()===
#changeportrait
{playerPortrait:
- MalePortrait:
#spawn.portrait.player1
- FemalePortrait:
#spawn.portrait.player2
- AndroPortrait:
#spawn.portrait.player3
- else:
#spawn.portrait.portrait3
}

===function StartSay()===
#startSay
~sayStarted = true
<i></i>

===function EndSay()===
#endSay #changeportrait
~sayStarted = false
<b></b>

==Say(text, character)==
{not sayStarted: {StartSay()}}
#changeportrait
{character:
- Player:
{PlayerPortrait()}
- Valfrig:
#spawn.portrait.valfrig
- Jaerd:
#spawn.portrait.jaerd
- Chi:
#spawn.portrait.chi
- Barr:
#spawn.portrait.barr
- Fayni:
#spawn.portrait.fayni
- Claymancer:
#spawn.portrait.claymancer
- Baba:
#spawn.portrait.elder
- Pitchief:
// NEEDS OWN PORTRAIT
#spawn.portrait.npc
- Quartermaster:
#spawn.portrait.quartermaster
- Watchman:
#spawn.portrait.watchman

}
{character}: {text}
{EndSay()}
->->

==ScavengeFood==
->AdvancedSkillCheck(_scavenger, camp_zone_foodCoeff, 0, _tribesmen, tribesmen, mediumAmount, ->ScavengeFoodWin, ->ScavengeFoodLose)

==ScavengeFoodWin(fumbled)==
{alter(_food, RANDOM(1, camp_zone_foodCoeff*2))}
{fumbled:
->ScavengeFumbled->
->FinishScavenging("You grimly make note of the rations added.")
- else:
->FinishScavenging("You harvest the rich bounty of arrowroot and more.")
}

==ScavengeFoodLose(fumbled)==
{alter(_food, RANDOM(0, 1))}
{fumbled:
->ScavengeFumbled->
->FinishScavenging("What is worse, you find almost nothing to eat.")
-else:
->FinishScavenging("The pickings are slim.")
}

==ScavengeClay==
->AdvancedSkillCheck(_clayworker, camp_zone_clayCoeff, 0, _tribesmen, tribesmen, smallAmount, ->ScavengeClayWin, ->ScavengeClayLose)

==ScavengeClayWin(fumbled)==
{alter(_clayScrap, RANDOM(1, camp_zone_clayCoeff*2))}
{fumbled:
->ScavengeFumbled->
}
{clayScrap<clayScrapMax:
->FinishScavenging("Your tribesmen return with various bits and bobs, ready to be melted down for Clay.")
- else:
->FinishScavenging("Your tribesmen return with what they can carry, but you already have as much scrap as you can carry. [Turn your Scrap into Clay in your camp!].")
}
==ScavengeClayLose(fumbled)==
{alter(_clayScrap, RANDOM(0, 1))}
{fumbled:
->ScavengeFumbled->
}
->FinishScavenging("There is nothing there. Just dust and waste.")

==ScavengeFumbled==
Not everybody returns safely. {~You shout and look, but find no trace of them.|You find traces of blood and clothing, but no bodies.|They are gone. Perhaps they deserted?|You find them, dead, at the bottom of a cliff; an accident?|You look, but they have been swallowed - perhaps literally - by the City.} The City is dangerous, and a single lapse in concentration can spell your death.
{GiveReward(_failureXP, smallReward)}
->->

==ScavengePeople==
~temp shamanOrClayworker = _shaman
~temp skill = _pactmaker
~temp resource = _pactmakerXP
~pickedRandomCrewMemberActual = _tribesmen
{camp_zone_peopleCoeff:
- 1:
{~You {~find|come across} {~a small encampment of tribesmen|a few travellers|a small group|a handful of tribesmen}. They seem  {~friendly|curious|interested to meet you}.}
- 2:
{~You {~find|come across} {~an encampment|a caravan| a large group of travellers| another wercru}. They seem {~friendly|curious|interested to meet you}.}
- 3:
{~You {~find|come across} {~a semi-permanent village|a sizeable wercru| a group of pilgrims}. They seem {~friendly|curious|interested to meet you}.}
{RANDOM(0,1)>0:
~shamanOrClayworker=_clayworker
~skill = _trickster
~resource = _tricksterXP
}
}
+ [Convince the tribesmen to join your wercru.{displayAdvancedCheck(_courage, medium, _courageXP, 5, smallAmount)}]
~pickedRandomCrewMemberActual = _tribesmen
->AdvancedSkillCheck(_courage, medium, 0, _courageXP, 5, smallAmount, ->ScavengePeopleWin, ->ScavengePeopleLose)
+ {camp_zone_peopleCoeff>1}[Convince some of their warriors to join your wercru.{displayAdvancedCheck(_warchief, medium, _warchiefXP, 5, smallAmount)}]
~pickedRandomCrewMemberActual = _warriors
->AdvancedSkillCheck(_warchief, medium, 0, _warchiefXP, 5, smallAmount, ->ScavengePeopleWin, ->ScavengePeopleLose)
+ {camp_zone_peopleCoeff>2}[Convince one of their {shamanOrClayworker} to join you.{displayAdvancedCheck(skill, medium, resource, 5, smallAmount)}]
~pickedRandomCrewMemberActual = shamanOrClayworker
->AdvancedSkillCheck(skill, medium, 0, resource, 5, smallAmount, ->ScavengePeopleWin, ->ScavengePeopleLose)
+ [Leave them alone.]->FinishScavenging("You make your greetings and then part ways.")

==ScavengePeopleWin(fumbled)==
~temp randomNr = RANDOM(1,camp_zone_peopleCoeff)
{pickedRandomCrewMemberActual == _shaman || pickedRandomCrewMemberActual == _clayworker:
~randomNr = 1
}
{alter(pickedRandomCrewMemberActual, randomNr)}
->FinishScavenging("Your new crewmembers join you, eager to be on their way.")

==ScavengePeopleLose(fumbled)==
{alter(_tribesmen, RANDOM(0, 1))}
->FinishScavenging("Few seem interested, despite your best attempts.")

==FinishScavenging(message)
#finishScavenging
{message}
->DONE

===AssignWorkers(ref resourceN, ref outVar, stringDescription, maxAddable, amountDecreased)===
#characterCreationStart
[Worker assignment]
~temp resourcesUsed = 0
~temp resourcesMax = 0
{getSkill(resourceN, resourcesMax)}
~temp actualSkill = 0
- (loop)
[Added {GetIcon(resourceN)}: {resourcesUsed}]
[Effect: + {amountDecreased * resourcesUsed} {stringDescription}]
+ [Add {GetIcon(resourceN)} ({resourcesUsed}/{maxAddable})]
{resourcesUsed<resourcesMax && resourcesUsed<maxAddable:
~resourcesUsed++
}
->loop
+ [Remove {GetIcon(resourceN)}]
{resourcesUsed>0:
~resourcesUsed--
}
->loop
+ [Add max ({resourcesMax-resourcesUsed})]
~temp maxResourcesToAdd = maxAddable-resourcesUsed
{maxResourcesToAdd>resourcesMax:
~resourcesUsed = resourcesMax
- else:
~resourcesUsed+=maxResourcesToAdd
}
->loop
+ [Remove All ({resourcesUsed})]
~resourcesUsed=0
->loop
+ [Finish]
~outVar = resourcesUsed
#characterCreationEnd
[Resource Assignment Ended]
->->

==AdvancedSkillCheck(ref skillN, difficulty, addedFumbleChance, ref resourceN, maxAddable, resourceHelpAmount, ->success, ->failure)
#advancedSkillCheck
[Advanced Skill Check]
// the ->success and ->failure can accept a boolean true/false for fumbling.
~temp bonus = 0
~temp base = 0
~temp resourcesUsed = 0
~temp resourcesMax = 0
{getSkill(resourceN, resourcesMax)}
{resourcesMax<maxAddable:
~maxAddable = resourcesMax
}
~temp actualSkill = 0
{getSkill(skillN, actualSkill)}
- (loop)
{getSkillSuccessChance(actualSkill, difficulty, base)}
[Total Bonus: + {bonus} %]
[{displayFumbleChance(addedFumbleChance)}]
[Added {GetIcon(resourceN)}: {resourcesUsed} ({resourcesMax})]
+ {resourcesUsed<resourcesMax && resourcesUsed<maxAddable} [Add {GetIcon(resourceN)} ({resourcesUsed}/{maxAddable})]
~resourcesUsed++
{ResourceHelp(bonus, resourceHelpAmount, 1)}
->loop
+ {resourcesUsed<resourcesMax && resourcesUsed<maxAddable} [Add max ({maxAddable-resourcesUsed})]
~temp maxResourcesToAdd = maxAddable-resourcesUsed
~resourcesUsed+=maxResourcesToAdd
{ResourceHelp(bonus, resourceHelpAmount, maxResourcesToAdd)}
->loop
+ [Perform check({displayCheckWithBonus(skillN, difficulty, bonus)})]
#endAdvSkillCheck
[Advanced Skill Check Ended]

{skillCheckWithBonus(skillN, difficulty, bonus):
    {not fumbleCheck(addedFumbleChance):
    ~advanced_skillcheck_succeeded = true
    ~advanced_skillcheck_fumbled = false
    ->success(false)
    - else:
        {resourcesUsed > 0:
        {resourceN !=_shaman && resourceN !=_clayworker:
            {alter(resourceN, -RANDOM(1, resourcesUsed/2))}
            ~advanced_skillcheck_succeeded = true
            ~advanced_skillcheck_fumbled = true
            [Fumbled! {displayFumbleChance(addedFumbleChance)}]
            ->success(true)
            - else:
            // Used clayworker or shaman, meaning we need to check for our dudes.
            {companions?Valfrig && resourceN == _shaman && shaman > 1:
                {alter(_shaman, -1)}
                ~advanced_skillcheck_succeeded = true
                ~advanced_skillcheck_fumbled = true
                [Fumbled! {displayFumbleChance(addedFumbleChance)}]
                ->success(true)
                - else:
                ~advanced_skillcheck_succeeded = false
                ~advanced_skillcheck_fumbled = false
                ->failure(false)
            }
            {companions?Jaerd && resourceN == _clayworker && clayworker > 1:
                {alter(_clayworker, -1)}
                ~advanced_skillcheck_succeeded = true
                ~advanced_skillcheck_fumbled = true
                [Fumbled! {displayFumbleChance(addedFumbleChance)}]
                ->success(true)
                - else:
                ~advanced_skillcheck_succeeded = false
                ~advanced_skillcheck_fumbled = false
                ->failure(false)
            }
        }
        - else:
        ~advanced_skillcheck_succeeded = false
        ~advanced_skillcheck_fumbled = false
        ->failure(false)
        }
    }
- else:
    {not fumbleCheck(addedFumbleChance):
    ~advanced_skillcheck_succeeded = false
    ~advanced_skillcheck_fumbled = false
    ->failure(false)
    - else:
        {alter(resourceN, -RANDOM(0, resourcesUsed))}
        ~advanced_skillcheck_succeeded = false
        ~advanced_skillcheck_fumbled = true
        [Fumbled! {displayFumbleChance(addedFumbleChance)}]
        ->failure(true)
    }
}

===function UpdateMood()===
~playful = false
~honorable = false
~thoughtful = false
~neutral = true
{trickster>warchief && trickster > pactmaker:
    ~playful = true
    ~neutral = false
}
{warchief > trickster && warchief > pactmaker:
~honorable = true
~neutral = false
}
{pactmaker > trickster && pactmaker > warchief:
~thoughtful = true
~neutral = false
}

===function ResourceHelp(ref outValue, amount, timesToApply)===
{timesToApply > 0:
{amount:
- tokenAmount:
~outValue += RANDOM(3,3)
- smallAmount:
~outValue += RANDOM(6,6)
- mediumAmount:
~outValue += RANDOM(11,11)
- largeAmount:
~outValue += RANDOM(16,16)
- epicAmount:
~outValue += RANDOM(20,20)
}
~timesToApply--
{ResourceHelp(outValue, amount, timesToApply)}
}

===function GetMaxResourceHelpAmount(amount)===
~temp outValue = 0
{amount:
- tokenAmount:
~outValue += 3
- smallAmount:
~outValue += 6
- mediumAmount:
~outValue += 11
- largeAmount:
~outValue += 16
- epicAmount:
~outValue += 20
}
~return outValue

===function KillCompanion(companion)===
{companions?companion:
    {companion:
    - Jaerd:
        {alter(_clayworker, -1)}
    - Valfrig:
        {alter(_shaman, -1)}
    }
    ~companions-=companion
}

{not (companionsDead?companion):
~companionsDead+=companion
[{companion} has died!]
}

===function RemoveRandomCrewMember(useCompanions)===
// Future proofing
{KillRandomCrewMember(useCompanions)}

===function KillRandomCrewMember(useCompanions)===
~temp randomCivString = "tribesman"
~temp randomCivActual = _tribesmen
{PickRandomCrewMember(randomCivString, randomCivActual, useCompanions)}
{randomCivString != "companion":
{alter(randomCivActual, -1)}
- else:
{KillCompanion(randomCivActual)}
}

===function RemoveRandomCivilian(useCompanions)===
// future-proofing, in case we want to make a difference between kill and leave
{KillRandomCivilian(useCompanions)}

===function KillRandomCivilian(useCompanions)===
{partySize(useCompanions)>warriors+1:
~temp randomCivString = ""
~temp randomCivActual = ""
~temp actualClayworkers = clayworker
{companions?Jaerd && actualClayworkers>0:
~actualClayworkers--
}
~temp actualShamans = shaman
{companions?Valfrig && actualShamans>0:
~actualShamans--
}

~temp refValue1 = RANDOM(tribesmen,tribesmen*2)
~temp refValue3 = 0
~temp refValue4 = RANDOM(actualClayworkers, actualClayworkers*2)
~temp refValue5 = RANDOM(actualShamans, actualShamans*2)
~temp refValue6 = 0
~temp returnString1 = ""
~temp returnVal1 = _tribesmen
~temp returnString2 = ""
~temp returnVal2 = _shaman

~returnString1 = "tribesman"
~returnVal1 = _tribesmen
~refValue3 = refValue1

{refValue4 > refValue5:
    ~returnString2 = "clayworker"
    ~returnVal2 = _clayworker
    ~refValue6 = refValue4
- else:
    ~returnString2 = "shaman"
    ~returnVal2 = _shaman
    ~refValue6 = refValue5
}
{refValue3>refValue6:
    ~randomCivString = returnString1
    ~randomCivActual = returnVal1
    ~refValue6 = refValue3
- else:
    ~randomCivString = returnString2
    ~randomCivActual = returnVal2
}
{useCompanions && LIST_COUNT(companions) > 0:
~temp refValue7 = RANDOM(LIST_COUNT(companions), LIST_COUNT(companions)*2)
{refValue7>refValue6:
    ~randomCivString = "companion"
    ~randomCivActual = companions(RANDOM(1, LIST_COUNT(companions)))
}
}
~pickedRandomCrewMemberString = randomCivString
~pickedRandomCrewMemberActual = randomCivActual

    {randomCivString != "companion" && randomCivString !="":
        {alter(randomCivActual, -1)}
        - else:
        {KillCompanion(randomCivActual)}
    }
}

===function PickRandomCrewMemberF(useCompanions)===
// A quick version that just uses the default values
{PickRandomCrewMember(pickedRandomCrewMemberString, pickedRandomCrewMemberActual, useCompanions)}
===function PickRandomCrewMember(ref outValString, ref outValActual, useCompanions)===
~temp actualClayworkers = clayworker
{companions?Jaerd && actualClayworkers>0:
~actualClayworkers--
}
~temp actualShamans = shaman
{companions?Valfrig && actualShamans>0:
~actualShamans--
}

~temp refValue1 = RANDOM(tribesmen,tribesmen*2)
~temp refValue2 = RANDOM(warriors,warriors*2)
~temp refValue3 = 0
~temp refValue4 = RANDOM(actualClayworkers, actualClayworkers*2)
~temp refValue5 = RANDOM(actualShamans, actualShamans*2)
~temp refValue6 = 0
~temp returnString1 = ""
~temp returnVal1 = _tribesmen
~temp returnString2 = ""
~temp returnVal2 = _shaman
{refValue1 < refValue2:
    ~returnString1 = "warrior"
    ~returnVal1 = _warriors
    ~refValue3 = refValue2
- else:
    ~returnString1 = "tribesman"
    ~returnVal1 = _tribesmen
    ~refValue3 = refValue1
}
{refValue4 > refValue5:
    ~returnString2 = "clayworker"
    ~returnVal2 = _clayworker
    ~refValue6 = refValue4
- else:
    ~returnString2 = "shaman"
    ~returnVal2 = _shaman
    ~refValue6 = refValue5
}
{refValue3>refValue6:
    ~outValString = returnString1
    ~outValActual = returnVal1
    ~refValue6 = refValue3
- else:
    ~outValString = returnString2
    ~outValActual = returnVal2
}
{useCompanions && LIST_COUNT(companions) > 0:
~temp refValue7 = RANDOM(LIST_COUNT(companions), LIST_COUNT(companions)*2)
{refValue7>refValue6:
    ~outValString = "companion"
    ~outValActual = companions(RANDOM(1, LIST_COUNT(companions)))
}
}
~pickedRandomCrewMemberString = outValString
~pickedRandomCrewMemberActual = outValActual


===function GiveReward(resource, reward)===
~temp changeValue = 0
{reward:
- tokenReward:
~changeValue = RANDOM(0,1)
- smallReward:
~changeValue = RANDOM(1,2)
- mediumReward:
~changeValue = RANDOM(2,4)
- largeReward:
~changeValue = RANDOM(4,6)
- storyReward:
~changeValue = RANDOM(8,10)
}
{alter(resource, changeValue)}

===function AddSigil(sigil)===
{not (sigils?sigil):
~sigils+=sigil
#updateLocationVisibility
}

===function displayTime(time)===
// Change the size. Also remember to adjust it for the final sprite(s)
({GetIcon(_time)} {time})

// does a skillcheck and returns either true or false. Does not change the skill's value
// use (name of skill, difficulty of challenge)
/*
{skillCheck(mettle, 6):
    good stuff
-else:
    bad stuff
}
*/
===function skillCheck(ref skillN, requiredskill)===
#autoContinue
~temp skill = 0
{getSkill(skillN, skill)}
~temp success = false
~temp percentageNeeded = 1
{skill > 0:
{getSkillSuccessChance(skill, requiredskill, percentageNeeded)}
}
{percentageNeeded < 1:
// Change this to 1 or whatever if we want there to be a minimum...
~percentageNeeded = 0
}
{skill >= requiredskill:
    ~percentageNeeded = 100
    ~success = true
- else:
    ~temp randomValue = RANDOM(1,100)
        {randomValue <= percentageNeeded:
            ~success = true
        }
}
{success:
    <><color=green>Success {GetIcon(skillN)}! ({percentageNeeded} %)</color><>
- else:
    <><color=red>Failure {GetIcon(skillN)}! ({percentageNeeded} %)</color><>
}
~return success

===function skillCheckWithBonus(ref skillN, requiredskill, bonus)===
#autoContinue
~temp skill = 0
{getSkill(skillN, skill)}
~temp success = false
~temp percentageNeeded = 1
{skill > 0:
{getSkillSuccessChance(skill, requiredskill, percentageNeeded)}
}
~percentageNeeded +=bonus
{percentageNeeded < 1:
~percentageNeeded = 0
}
{skill >= requiredskill:
    ~percentageNeeded = 100
    ~success = true
- else:
    ~temp randomValue = RANDOM(1,100)
        {randomValue <= percentageNeeded:
            ~success = true
        }
}
{success:
    <color=green>Success {GetIcon(skillN)}! ({percentageNeeded} %)</color>
- else:
    <color=red>Failure {GetIcon(skillN)}! ({percentageNeeded} %)</color>
}
~return success

===function fumbleCheck(addedChance)==
// Checks for fumble
~temp fumbleChance = 0
~temp success = false
{getFumbleChance(addedChance, fumbleChance)}
~temp randomValue = RANDOM(1,100)
{randomValue <= fumbleChance:
~success = true
}
~return success
==function displayFumbleChance(addedChance)==
~temp fumbleChance = 0
{getFumbleChance(addedChance, fumbleChance)}
{fumbleChance < 0:
~fumbleChance = 0
}
Fumble Risk: <>
{fumbleChance <= 0:
<color=green><>
- else:
{fumbleChance > 30:
<color=red><>
- else:
<color=yellow><>
}
}
{fumbleChance}</color> %

==function getFumbleChance(addedChance, ref outvalue)==
~temp fumbleChance = addedChance
{rested:
~fumbleChance -=25
}
{exhausted:
~fumbleChance +=25
}
{hungry:
~fumbleChance +=10
}
{starving:
~fumbleChance +=15
}
~outvalue = fumbleChance

==resourceCheck(ref skillN, target, ->success, ->fail)
//
~temp addedResources = 0
~temp resources = 0
{getSkill(skillN, resources)}
- (loop)
+ {resources > addedResources} [Add {skillN}]
~addedResources++
->loop
+ [Attempt ({displayCheck(addedResources, target)})]
{skillCheck(addedResources, target):
->success(addedResources)
- else:
->fail(addedResources)
}

===function getSkill(ref skillN, ref outVar)===
~temp returnVar = 0
{skillN:
- _shaman:
~returnVar = shaman
- _trickster:
~returnVar = trickster
- _warchief:
~returnVar = warchief
- _pactmaker:
~returnVar = pactmaker
- _clayworker:
~returnVar = clayworker
- _tribesmen:
~returnVar = tribesmen
- _warriors:
~returnVar = warriors
- _clay:
~returnVar = clay
- _food:
~returnVar = food
- _courage:
~returnVar = courage
- _courageXP:
~returnVar = courageXP
- _failureXP:
~returnVar = failureXP
- _pactmakerXP:
~returnVar = pactmakerXP
- _warchiefXP:
~returnVar = warchiefXP
- _tricksterXP:
~returnVar = tricksterXP
- _scavenger:
~returnVar = scavenger
- _clayScrap:
~returnVar = clayScrap
- else:
~returnVar = skillN
}
~outVar = returnVar

===function getSkillSuccessChance(skill, difficulty, ref outValue)===
{skill > 0 && difficulty > 0:
~outValue = (skill*100) / difficulty
- else:
~outValue = 0
}

===function setResource(ref resourceN, change)
~temp outMin = 0
~temp outMax = 1000
{resourceN:
- _food:
~outMax = foodMax
{alterValue(food, change, 0, outMax, _food)}
- _clay:
~outMax = 200
{alterValue(clay, change, 0, outMax, _clay)}
- _tribesmen:
~outMax = 500
{alterValue(tribesmen, change, 0, outMax, _tribesmen)}
- _warriors:
~outMax = 500
{alterValue(warriors, change, 0, outMax, _warriors)}
- _clayworker:
~outMax = 500
{alterValue(clayworker, change, 0, outMax, _clayworker)}
- _shaman:
~outMax = 500
{alterValue(shaman, change, 0, outMax, _shaman)}
- _courage:
~outMax = 100
{alterValue(courage, change, 0, outMax, _courage)}
- _warchief:
~outMax = 6
{companions?Barr: 
~outMax++
}
{alterValue(warchief, change, 0, outMax, _warchief)}
- _trickster:
~outMax = 6
{companions?Chi: 
~outMax++
}
{alterValue(trickster, change, 0, outMax, _trickster)}
- _pactmaker:
~outMax = 6
{companions?Fayni: 
~outMax++
}
{alterValue(pactmaker, change, 0, outMax, _pactmaker)}
- _courageXP:
{alterValue(courageXP, change, 0, outMax, _courageXP)}
- _pactmakerXP:
{alterValue(pactmakerXP, change, 0, outMax, _pactmakerXP)}
- _warchiefXP:
{alterValue(warchiefXP, change, 0, outMax, _warchiefXP)}
- _tricksterXP:
{alterValue(tricksterXP, change, 0, outMax, _tricksterXP)}
- _failureXP:
{alterValue(failureXP, change, 0, outMax, _failureXP)}
- _clayScrap:
~outMax = clayScrapMax
{alterValue(clayScrap, change, 0, outMax, _clayScrap)}
- else:
~outMax = 1000
}
{UpdateMood()}

===function displayCheck(ref skillN, requiredskill)===
~temp skill = 0
~temp chanceOfSuccess = 0
{getSkill(skillN, skill)}
{skill>0:
{getSkillSuccessChance(skill, requiredskill, chanceOfSuccess)}
}
{chanceOfSuccess > 100:
~chanceOfSuccess = 100
}
{chanceOfSuccess == 0:
~chanceOfSuccess = 1
}
Chance of Success ({GetIcon(skillN)}): <>
{chanceOfSuccess > 60:
<color=green><>
- else:
{chanceOfSuccess < 30:
<color=red><>
- else:
<color=yellow><>
}
}
{chanceOfSuccess}</color> %
===function displayCheckWithBonus(ref skillN, requiredskill, bonus)
~temp skill = 0
~temp chanceOfSuccess = 0
{getSkill(skillN, skill)}
{skill>0:
{getSkillSuccessChance(skill, requiredskill, chanceOfSuccess)}
}
{chanceOfSuccess == 0:
~chanceOfSuccess = 1
}
~chanceOfSuccess +=bonus
{chanceOfSuccess > 100:
~chanceOfSuccess = 100
}

Chance of Success ({GetIcon(skillN)}): <>
{chanceOfSuccess > 60:
<color=green><>
- else:
{chanceOfSuccess < 30:
<color=red><>
- else:
<color=yellow><>
}
}
{chanceOfSuccess}</color> %

===function displayAdvancedCheck(ref skillN, difficulty, ref resourceN, maxAddable, resourceHelpAmount)
// First simply check what the % is with -no- added stuff
~temp skill = 0
~temp chanceOfSuccess = 0
{getSkill(skillN, skill)}
{skill>0:
{getSkillSuccessChance(skill, difficulty, chanceOfSuccess)}
}
{chanceOfSuccess > 100:
~chanceOfSuccess = 100
}
{chanceOfSuccess == 0:
~chanceOfSuccess = 1
}
// then see what the max bonus would be from the extra resource, max addable, and resource help resourceHelpAmounts
~temp maxRewardPerResource = GetMaxResourceHelpAmount(resourceHelpAmount)
~temp maxResources = 0
{getSkill(resourceN, maxResources)}
{maxResources > maxAddable:
~maxResources = maxAddable
}
~maxRewardPerResource = maxRewardPerResource * maxResources
~temp chanceOfSuccessMax = chanceOfSuccess + maxRewardPerResource
{chanceOfSuccessMax>100:
~chanceOfSuccessMax=101
}
Chance of Success ({GetIcon(skillN)}): <>
{chanceOfSuccessMax > 60:
<color=green><>
- else:
{chanceOfSuccessMax < 30:
<color=red><>
- else:
<color=yellow><>
}
}
{chanceOfSuccess}-{chanceOfSuccessMax} </color> % 


===function GetIcon(ref skillN)===
{skillN:
- _food:
~return "<size=30><sprite name=\"food\"></size>"
- _clay:
~return "<size=30><sprite name=\"clay\"></size>"
- _tribesmen:
~return "<size=30><sprite name=\"tribesmen\"></size>"
- _warriors:
~return "<size=30><sprite name=\"warriors\"></size>"
- _clayworker:
~return "<size=30><sprite name=\"clayworker\"></size>"
- _shaman:
~return "Shamans"
//~return "<size=30><sprite name=\"shaman\"></size>"
-_warchief:
~return "<size=30><sprite name=\"warchief\"></size>"
-_trickster:
~return "<size=30><sprite name=\"trickster\"></size>"
-_pactmaker:
~return "<size=30><sprite name=\"pactmaker\"></size>"
-_courage:
~return "<size=30><sprite name=\"courage\"></size>"
- _time:
~return "Time"
//~return "<size=30><sprite name=\"tmp_time\"></size>"
- else:
~return skillN
}

// convenience function that assumes min 0 and max 1000 on any value
===function alter(ref valueN, change)===

{setResource(valueN, change)}
// if you need to alter values of things outside of checks, use this instead of directly changing them
// use (variable, change (can be negative), minimum (0) maximum (1000...or more).
// {alterValue(coins, 25, 0, 1000)

===function alterValue(ref value, newvalue, min, max, ref valueN) ===
~temp finalValue = value + newvalue
~temp change = newvalue
{finalValue > max:
{value !=max: 
    ~change = finalValue-max
- else:
    ~change = 0
}
    ~value = max
- else: 
    {finalValue < min:
    ~change = -value
    ~value = min
- else:
    ~value = value + newvalue
    }
}
~temp changePositive = change*-1
{change!=0:
#autoContinue
{change > 0:
        <i><color=yellow>Gained {print_num(change)} {print_var(valueN, change, false)}.</color></i>
    -else:
        <i><color=yellow>Lost {print_num(changePositive)} {print_var(valueN, change, false)}.</color></i>
}
}

==function partySize(countcompanions)===
~temp returnVal = 1
{not countcompanions:
    {companions?Valfrig:
        ~returnVal--
    }
    {companions?Jaerd:
        ~returnVal--
    }
}
~returnVal +=tribesmen+warriors+shaman+clayworker
~return returnVal

===function percentileLevel(value)===

~temp outValue = 0
{value < 0:
~outValue = -1
}
{value > 0:
~outValue = 1
}
{value > 100:
~outValue = 2
}
{value > 200:
~outValue = 3
}
{value > 300:
~outValue = 4
}
{value > 400:
~outValue = 5
}
{value > 500:
~outValue = 6
}
{value > 600:
~outValue = 7
}
{value > 700:
~outValue = 8
}
{value > 800:
~outValue = 9
}
{value > 900: 
~outValue = 10
}
~return outValue

==function changeReadinessLevel(input, type)===
{input > 0:
~temp addAmount = 0
{type==0:
//Food
~home_readinessLevel += input
{alterByPercentage(addAmount, 5, input)}
{addAmount > 0:
    {alter(_courageXP, addAmount)}
}
}
{type==1:
// Clay
~home_readinessLevel +=input*2
{alterByPercentage(addAmount, 10, input*2)}
{alter(_courageXP, addAmount)}
}
{type==2:
// Tribesmen
//~home_readinessLevel +=input*2
~home_tribesmen += input
{alterByPercentage(addAmount, 20, input)}
{alter(_courageXP, addAmount)}
}
}

===function changeCourage===
{failureXP > 0:
    {skillCheck(_failureXP, hard):
    The stories of your misfortunes are soon spread through the Corral. Although no-one expects you to succeed at everything you do, your actions are closely scrutinized.
    {alter(_courage, -RANDOM(1,3))}
    {alter(_failureXP, -failureXP)}
    This time, you did not make a good impression.
    - else:
    The stories of your misfortunes mix with the stories of your bravery and leadership, and in the end the bad and the good become nearly interchangeable.
    ~temp randomNr = RANDOM(1,failureXP)
    {alter(_failureXP, -courageXP)}
    {alter(_courageXP, -randomNr)}
    Although in the process, some of your acts of bravery are also forgotten.
    }
}
===function resetCrew===
~temp shamansToRemove = shaman
{companions?Valfrig:
~shamansToRemove--
}
~temp clayworkerstoremove = clayworker
{companions?Jaerd:
~clayworkerstoremove--
}
~temp tribesmentoremove = tribesmen
~temp warriorstoremove = warriors
{alter(_shaman, -shamansToRemove)}
{alter(_clayworker, -clayworkerstoremove)}
{alter(_tribesmen, -tribesmentoremove)}
{alter(_warriors, -warriorstoremove)}

===function alterByPercentage(ref value, percentage, amount)===
// For every 1 "amount" have a percentage change to alter value
{amount > 0:
~temp roll = RANDOM(0,100)
//{roll}
{roll <= percentage:
~value++
}
~amount--
{alterByPercentage(value, percentage, amount)}
}

===function startTimer(startAmount, targetAmount, timerName)
~task_timeNeeded = targetAmount
~task_timeGot = startAmount
~task_name = timerName
#start.timer

==doEncounter==
->simulateEncounter(->leave)
=leave
->DONE

==function print_var(ref varN, amount, capital)==
{amount<0:
// Make amount always positive, in case it's a negative amount.
~amount = amount * -1
}
{varN:
-_tribesmen:
{amount==1:
    {capital:
    ~return "Tribesman"
    - else:
    ~return "tribesman"
    }
- else:
    {capital:
    ~return "Tribesmen"
    - else:
    ~return "tribesmen"
    }
}
-_warriors:
{amount==1:
    {capital:
    ~return "Warrior"
    - else:
    ~return "warrior"
    }
- else:
    {capital:
    ~return "Warriors"
    - else:
    ~return "warriors"
    }
}
-_clayworker:
{amount==1:
    {capital:
    ~return "Clayworker"
    - else:
    ~return "clayworker"
    }
- else:
    {capital:
    ~return "Clayworkers"
    - else:
    ~return "clayworkers"
    }
}
-_shaman:
{amount==1:
    {capital:
    ~return "Shaman"
    - else:
    ~return "shaman"
    }
- else:
    {capital:
    ~return "Shamans"
    - else:
    ~return "shaman"
    }
}
-_food:
{amount==1:
    {capital:
    ~return "Food"
    - else:
    ~return "food"
    }
- else:
    {capital:
    ~return "Food"
    - else:
    ~return "food"
    }
}
-_clay:
{amount==1:
    {capital:
    ~return "Clay"
    - else:
    ~return "clay"
    }
- else:
    {capital:
    ~return "Clay"
    - else:
    ~return "clay"
    }
}
-_clayScrap:
{amount==1:
    {capital:
    ~return "Piece of Scrap"
    - else:
    ~return "piece of Scrap"
    }
- else:
    {capital:
    ~return "Pieces of Scrap"
    - else:
    ~return "pieces of Scrap"
    }
}
-_courage:
{amount==1:
    {capital:
    ~return "Trust"
    - else:
    ~return "Trust"
    }
- else:
    {capital:
    ~return "Trust"
    - else:
    ~return "Trust"
    }
}
-_courageXP:
{amount==1:
    {capital:
    ~return "Tale of Bravery"
    - else:
    ~return "Tale of Bravery"
    }
- else:
    {capital:
    ~return "Tales of Bravery"
    - else:
    ~return "Tales of Bravery"
    }
}
-_failureXP:
{amount==1:
    {capital:
    ~return "Tale of Ruin"
    - else:
    ~return "Tale of Ruin"
    }
- else:
    {capital:
    ~return "Tales of Ruin"
    - else:
    ~return "Tales of Ruin"
    }
}
-_pactmakerXP:
{amount==1:
    {capital:
    ~return "Tale of Insight"
    - else:
    ~return "Tale of Insight"
    }
- else:
    {capital:
    ~return "Tales of Insight"
    - else:
    ~return "Tales of Insight"
    }
}
-_warchiefXP:
{amount==1:
    {capital:
    ~return "Tale of Prowess"
    - else:
    ~return "Tale of Prowess"
    }
- else:
    {capital:
    ~return "Tales of Prowess"
    - else:
    ~return "Tales of Prowess"
    }
}
-_tricksterXP:
{amount==1:
    {capital:
    ~return "Tale of Trickery"
    - else:
    ~return "Tale of Trickery"
    }
- else:
    {capital:
    ~return "Tales of Trickery"
    - else:
    ~return "Tales of Trickery"
    }
}
- else:
~return ""
}

// prints a number as pretty text
=== function print_num(x) ===
// print_num(45) -> forty-five
{ 
    - x >= 1000:
        {print_num(x / 1000)} thousand { x mod 1000 > 0:{print_num(x mod 1000)}}
    - x >= 100:
        {print_num(x / 100)} hundred { x mod 100 > 0:and {print_num(x mod 100)}}
    - x == 0:
        zero
    - else:
        { x >= 20:
            { x / 10:
                - 2: twenty
                - 3: thirty
                - 4: forty
                - 5: fifty
                - 6: sixty
                - 7: seventy
                - 8: eighty
                - 9: ninety
            }
            { x mod 10 > 0:<>-<>}
        }
        { x < 10 || x > 20:
            { x mod 10:
                - 1: one
                - 2: two
                - 3: three
                - 4: four        
                - 5: five
                - 6: six
                - 7: seven
                - 8: eight
                - 9: nine
            }
        - else:     
            { x:
                - 10: ten
                - 11: eleven       
                - 12: twelve
                - 13: thirteen
                - 14: fourteen
                - 15: fifteen
                - 16: sixteen      
                - 17: seventeen
                - 18: eighteen
                - 19: nineteen
            }
        }
}
// prints a number as pretty text
=== function print_Num(x) ===
// print_num(45) -> forty-five
{ 
    - x >= 1000:
        {print_num(x / 1000)} thousand { x mod 1000 > 0:{print_num(x mod 1000)}}
    - x >= 100:
        {print_num(x / 100)} hundred { x mod 100 > 0:and {print_num(x mod 100)}}
    - x == 0:
        zero
    - else:
        { x >= 20:
            { x / 10:
                - 2: Twenty
                - 3: Thirty
                - 4: Forty
                - 5: Fifty
                - 6: Sixty
                - 7: Seventy
                - 8: Eighty
                - 9: Ninety
            }
            { x mod 10 > 0:<>-<>}
        }
        { x < 10 || x > 20:
            { x mod 10:
                - 1: One
                - 2: Two
                - 3: Three
                - 4: Four        
                - 5: Five
                - 6: Six
                - 7: Seven
                - 8: Eight
                - 9: Nine
            }
        - else:     
            { x:
                - 10: Ten
                - 11: Eleven       
                - 12: Twelve
                - 13: Thirteen
                - 14: Fourteen
                - 15: Fifteen
                - 16: Sixteen      
                - 17: Seventeen
                - 18: Eighteen
                - 19: Nineteen
            }
        }
}