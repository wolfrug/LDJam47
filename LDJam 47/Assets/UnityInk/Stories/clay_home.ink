// Keep this include while working/testing, I will comment out when integrating
//INCLUDE clay_functions.ink
// Change the 'locationName' of all of these to correspond to the knot name below
// Set in the 'leave' stitch
VAR home_last_visit = -1
// this is set to true when the location is spawned. Needs to be set to false manually
VAR home_new = true
// this is set when spawned.
VAR home_creationTime = 0
// this is set when the object is very close to the edge
VAR home_dangerClose = false
// set this to true if you want it to be hidden
VAR home_hidden = false
VAR home_description = "The Corral"

VAR home_recruited = false
VAR home_recruitedTime = 0
// This is to prevent you from recruiting tribesmen then dropping them off
VAR home_recruitmentsLeft = 0
VAR home_recruitingType = ""
VAR home_resupplied = false
VAR home_readinessLevel = 20.0
VAR home_tribesmen = 1000
==home
// Reset recruited and resupply, and last visit.
{currentTime>home_last_visit+longTime:
//~home_last_visit = currentTime
~home_tribesmen += RANDOM(5,10)
}
{home_new && home == 1:
You take a final look at your home of the last nearly two decades. It is the only place you have ever known. Beyond the chain-link fence lies the City, in all its mystery and awe. To survive it will require everything you have learned.
~home_new = false
}
{currentTime>(home_recruitedTime + (dayLength*7)):
Your arrival causes a stir through the Corral. Everyone is eager to hear about your adventures.

+ {partySize(false)>1}[Tell your crew they can return to their families. (You must reform your crew before leaving)]
{changeCourage()}
{resetCrew()}
~home_recruited = false
~home_resupplied = false
->options
+ {partySize(false)>1 && courage > 0}[Tell your crew to wait outside; you are only visiting briefly. (-1 {GetIcon(_courage)}))]
You are the crew chief – they must do what you ask. But there is grumbling; this is highly irregular. {alter(_courage, -1)}
->options
+ {partySize(false)==1}[You come home without a crew.]
They look at you as you enter through the Corral gates, mumbling and talking amongst themselves. What happened to your crew?
->DissolveCrew->
->options
-else:
{partySize(false)<2:
They look at you as you enter through the Corral gates, mumbling and talking amongst themselves. What happened to your crew? And so soon? Whatever the truth, it sets people talking.
}
->options
}

=options
{~The main 'street' of the Corral is blocked by a couple arguing about whose cow should back off first.|A litter of kids run out between two tents, laughing and hitting each other with sticks.|A group of children are listening to a Shaman telling the oral history of the tribe.|It is nearly time for dinner. The smell of baking root-bread drifts through the air and makes your mouth water.|A Clayworker is entertaining some farmers on a break with a puppet show. You're not sure what the plot is, but the farmers laugh.}

There are currently {print_num(home_tribesmen)} tribesmen in the Corral.
+ [Find volunteers for your crew.]
->recruiting
+ [Find supplies for your crew.]
->supplies
+ [Speak to the Elders.]
->elders
+ {sigils?Corral} [Rest {displayTime(mediumTime)} (Save Game)]
->camp.locationRest("home")
+ {sigils?Corral}[Leave]->leave
+ {not (sigils?Corral) && hasOmbrascope}[Go to the gate]->start.GetCorralSigil
+ {not(sigils?Ruins_Interior) && cannotEnter.loc_Ruins_Interior>0} [Visit the Watchman]->GetRuins_InteriorSigil

=recruiting
~temp randomNr = 0
{recruiting == 1 && not home_recruited:
->firstRecruitementStart
}
{not home_recruited:
There is a crowd in the Crupit again, although you feel there are fewer who are simply curious, and more who are serious – if they can be convinced.
~home_recruitmentsLeft = RANDOM(2,3)+(courage/2)
->recruitLoopStart
- else:
{partySize(false)==1:
The Pitchief looks at you - crew-less - and frowns. Not even a week has passed since you last stood inside the Crupit, yet here you are without a single tribesman left in your crew?

+ [Beg to be allowed to re-form a crew.]->reformcrewEarly

+ [Slink away.]->options

- else:
You enter the Crupit again, but the Pitchief chases you out.

->Say("You have your wercru. Come back after you’ve done your <i>work</i>.", Pitchief)->
->options
}
}

=reformcrewEarly
{GiveReward(_failureXP, smallReward)}
The Pitchief sighs. ->Say("Very well. But wercrus are not disposable things: as cruchief you have a <i>responsibility.</i>.", Pitchief)->

{resetCrew()}
~home_recruited = false
~home_resupplied = false
~home_recruitmentsLeft = RANDOM(1,2)+(courage/2)
->recruitLoopStart

=recruitLoopStart
~temp randomNr = 0
~temp fumbleChance = 0
~temp targetFumbleChance = 20
{getFumbleChance(0, fumbleChance)}
{fumbleChance > 0:
~fumbleChance = targetFumbleChance - fumbleChance
- else:
    {fumbleChance < 0:
    ~fumbleChance = (fumbleChance * -1) + targetFumbleChance
        - else:
        {fumbleChance == 0:
        ~fumbleChance = targetFumbleChance
        }
    }
}
{journal_currentTaskVariableName == "":
->Say("'First, you must tell us what you intend to do.'", Pitchief)->
~journal_forceTaskPick = true
->OpenJournalInt->
#changebackground
#spawn.background.corral
<b></b>
~journal_forceTaskPick = false
- else:
->Say("'Still working on the same thing, hm? Better luck this  time, I suppose...'", Pitchief)->
}

- (recruitLoop)
{home_recruitmentsLeft:
- 3:
The throng of interested fill up the crupit with the hum of talk.
- 2:
A fair crowd remains in the crupit.
- 1:
Only a few clumps of interested remain.
- 0:
The crupit is practically empty.
- else:
There is a real crowd in the crupit, all here to hear your words.
}

+ {home_recruitmentsLeft > 0} [Recruit Tribesmen {displayAdvancedCheck(_courage, medium, _courageXP, 5, journal_recruiting_currentTribesmenBonus)}]
~home_recruitingType = _tribesmen
->AdvancedSkillCheck(_courage, medium, fumbleChance, _courageXP, 5, journal_recruiting_currentTribesmenBonus, ->home.recruitingSuccess, ->recruitingFailed)
->recruitLoop
+ {home_recruitmentsLeft > 0} [Recruit Warriors {displayAdvancedCheck(_warchief, medium, _warchiefXP, 5, journal_recruiting_currentWarriorsBonus)}]
~home_recruitingType = _warriors
->AdvancedSkillCheck(_warchief, medium, fumbleChance, _warchiefXP, 5, journal_recruiting_currentWarriorsBonus, ->home.recruitingSuccess, ->recruitingFailed)
->recruitLoop
+ {home_recruitmentsLeft > 0} [Recruit a Shaman {displayAdvancedCheck(_pactmaker, medium, _pactmakerXP, 5, journal_recruiting_currentShamanBonus)}]
~home_recruitingType = _shaman
->AdvancedSkillCheck(_pactmaker, medium, fumbleChance, _pactmakerXP, 5, journal_recruiting_currentShamanBonus, ->home.recruitingSuccess, ->recruitingFailed)
->recruitLoop
+ {home_recruitmentsLeft > 0} [Recruit a Clayworker {displayAdvancedCheck(_trickster, medium, _tricksterXP, 5, journal_recruiting_currentClayworkerBonus)}]
~home_recruitingType = _clayworker
->AdvancedSkillCheck(_trickster, medium, fumbleChance, _tricksterXP, 5, journal_recruiting_currentClayworkerBonus, ->home.recruitingSuccess, ->recruitingFailed)
->recruitLoop

+ [Finish forming your wercru]
{recruiting == 1:
->firstRecruitementEnd->
}
~home_recruited = true
~crewNumber++
~home_recruitedTime = currentTime
->options

=recruitingSuccess(fumbled)
~home_recruitmentsLeft--
~temp randomNr = 0
{home_recruitingType:
- _tribesmen:
It is not hard to find volunteers, despite the dangers. Soon, you have a selection of fine young tribesmen, ready to head out.
~randomNr = RANDOM(4,8)
- _warriors:
The young braves jostle each other in their eagerness to be first in line.
~randomNr = RANDOM(2,4)
- _clayworker:
The gathered clayworkers discuss, and then one steps forward as a volunteer.
~randomNr = 1
- _shaman:
One shaman steps up, convinced by your speech.
~randomNr = 1
}
{fumbled:
The tales told to entice them, however, you will not get back.
}
{alter(home_recruitingType, randomNr)}
~home_tribesmen -=randomNr
->recruitLoop

=recruitingFailed(fumbled)
{RANDOM(0,1)>0 || fumbled:
    ~home_recruitmentsLeft--
}
~temp randomNr = 0
{home_recruitingType:
- _tribesmen:
Despite your best efforts, the tribesmen do not seem convinced, although some do sign up.
~randomNr = RANDOM(2,4)
- _warriors:
Your words are clearly not impressing the young braves. Most turn away.
~randomNr = RANDOM(1,2)
- _clayworker:
None of the clayworkers seem convinced. One by one, they turn away.
~randomNr = 0
- _shaman:
The shamans listen politely, but when all is said and done, no-one seems interested in joining.
~randomNr = 0
}
{fumbled:
The worst part is, the tales you told you entice them were not even believed.
}
{alter(home_recruitingType, randomNr)}
->recruitLoop

=supplies
{supplies==1:
Every wercru is given enough supplies for a few days, in whatever form is the easiest to carry. Dried rootbread, beef jerky, sunfruit, sunfruit seeds…whatever is in season, and whatever the Quartermasters can spare.
}
{not home_resupplied:
+ [Ask for your rations]
{not home_recruited:
The Quartermaster gives you a confused look. 
->Say("'Unless you have a wercru, I can’t give you your wercu rations.'", Quartermaster)->
You leave, embarrassed. 
->options
}
->Say("'No exceptions just because of your blood.' The quartermaster says. 'And no more than your need.' He begins a headcount.", Quartermaster)->
~temp foodneeded = partySize(true)-food
//[Debug: {partySize()} - {food}]
{foodneeded>0:
//~food = 0
{alter(_food, foodneeded)}
~home_resupplied = true
Under his watchful eyes, your whole party is soon resupplied. You are last. As you leave, he wishes you a quiet ‘good luck’.
- else:
The quartermaster eyes your already-bulging stocks. ->Say("'You’ve enough already, I should think.' He sends out away without further ceremony.", Quartermaster)->
}
->options
- else:
The quartermaster turns you away. You have already received your rations.
->options
}

+ [Return] ->options

=elders
You head to the Elders' tent. {~They sit outside, chatting amicably.|You catch your grandmother at the tail-end of a dirty joke.|There seems to be no-one there, until you realize they are all napping behind the benches.|They look up as you arrive, smiling.} ->elderOptions
=elderOptions
+ [{Req(_courageXP, courageXPNeeded)}Tell Tales of Courage (+{_courage})]
You sit down and share the stories of your exploits. The Elders listen attentively. You know they will spread them onwards.
{alter(_courageXP, -courageXPNeeded)} {alter(_courage, 1)}
+ {trickster<6}[{Req(_tricksterXP, tricksterXPNeeded)}Tell Tales of Trickery (+{_trickster})]
The Elders laugh. They gasp. They cheer. Everyone loves a story where a good trick wins the day.
{alter(_tricksterXP, -tricksterXPNeeded)} {alter(_trickster, 1)}
~tricksterXPNeeded +=5
+ {warchief<6}[{Req(_warchiefXP, warchiefXPNeeded)}Tell Tales of Prowess (+{_warchief})]
The Elders listen quietly. Afterwards they mumble and nod amongst themselves. You can see your grandmother nod proudly at you.
{alter(_warchiefXP, -warchiefXPNeeded)} {alter(_warchief, 1)}
~warchiefXPNeeded +=5
+ {pactmaker<6}[{Req(_pactmakerXP, pactmakerXPNeeded)}Tell Tales of Insight (+{_pactmaker})]
The Elders cannot help but nod along, impressed despite themselves at your feats of diplomacy and wordcraft.
{alter(_pactmakerXP, -pactmakerXPNeeded)} {alter(_pactmaker, 1)}
~pactmakerXPNeeded+=5
+ {isTaskFinished(journal_currentTask)} [Report your success]
You return with tidings of your most recent successes.
{journal_currentTask:
- Task_MainStory00:
->MainStory00Success
}

+ [Return] ->options
- ->elderOptions

=DissolveCrew
{changeCourage()}
{resetCrew()}
~home_recruited = false
~home_resupplied = false
->->

=leave
// always use this when finishing
// this sets the last visit time to current time, if this is needed for checks
~home_last_visit = currentTime
#changeportrait
#changebackground
{debug:
->debugTravelOptions
-else:
->DONE
}
