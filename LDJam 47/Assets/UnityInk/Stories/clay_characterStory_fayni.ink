// CHARACTER STORY TEMPLATE
/*
Companions story is tied to the main story progress and does not progress from Start->Reveal until main story progresses once. Once in Reveal, the next part triggers on Arrival, after which the event is finished with either Resolved_Good or Resolved_Bad.

The default state is Not_Found. Your Starting Companion jumps directly to StartStory
At the start of every Main Story time slot, a random companion enters the "Recruiting" stage, meaning they make themselves available for recruitment.
All companions go to "Start" as soon as they join, including your starting companion.
All companions in 'Start' go to 'Reveal' when Main Story progresses.
Companions go from 'Reveal' to 'Arrival' when they reach the biome in question and rest.
Resolution happens when the final event is triggered and resolved (unique for most companions)

Note: companions who are only Recruited when flipping to EndGame will never reach the Reveal stage :( Thus -> no Recruiting->Start possible in EndGame?
*/

// Use this one for story tasks.
VAR fayni_story_progress_counter = 0

==Fayni_addStoryProgress(task, progress)==
// Use this for story progress logic in whatever way needed
{task==journal_currentTask:
~fayni_story_progress_counter += progress
}
->->

==Fayni_startCompanionStory
// Put in the 'start companion story' here
Start companion story.
->->

==Fayni_finishRecruitingStory
Fayni comes up to you, looking excited. She has a piece of Scrap in her hands, scavenged from some ruin. You're not sure what it is, exactly - all the tools of the Ancients look equally weird to you.
->Say("'There's so much of it! Thank you, thank you, thank you!'", Fayni)->
She hesitates for a second.
->Say("'It <i>is</i> is for me, right? The Clayworkers can melt down what's left when I'm done, but...'", Fayni)->
She trails off, looking at you hopefully. You have a feeling the moment you give the go-ahead she'll sit down and start working on it, and that not all of it is likely to be useable any more afterwards.
* [Assure her it's all for her (Complete task) {displayTime(shortTime)}]
{startTimer(0, shortTime, "Fayni_finishRecruitingStory.finished")}
->Say("'Great! Come on, help me unload this stuff...'", Fayni)->
{finishTask(Task_FayniRecruiting)}
->camp.leave

+ [Tell her to wait for now.]
Fayni sighs, looking at the thing in her hand. Then she shrugs and goes to return it to the sled, albeit somewhat reluctantly.
->camp.options

=finished
#spawn.background.camp
{alter(_clayScrap, -RANDOM(1,5))}
You spend hours sifting through the piles of Scrap, emerging from it graphite-blackened and sore-muscled. The rest of your wercru tries their best to ignore you: playing with the toys of the Ancients is something children do; and they are soon told to stop, lest they lose a finger or an eye.

But you did find a pattern. The devices lay around you, neatly gathered. A good dozen or so. Fayni picks one of them up; unwieldy and strange, with dark screens no doubt rich in Clay.
->Say("'I had no idea they were so common...there would be so few coming into the shop every year.'", Fayni)->
She'd explained as you worked what she was looking for. A flat, rectangular depression, usually with a specific sigil on top of it or close by. Sometimes it would be a slit instead, with a similar - but slightly different - sigil.

You'd never paid attention before, but now that it lay before you, it was obvious it was important.
->Say("'This is the sigil for our debt. Debt. Or wealth. I'm not sure.'", Fayni)->
She speaks quietly, not wanting to be heard. She glances at you, then away, as if ashamed.
->Say("'I'm not a believer. Not like my parents. But if Life-Debt is real, then this...", Fayni)->
Fayni looks at your haul, clearly frustrated.
->Say("'It's all connected somehow. Maybe they paid their debt to these machines, or...maybe this was how they accrued it?'", Fayni)->
She throws the piece of Scrap back into the pile with a frustrated grunt.
->Say("'If only I understood how it worked. I think there's some kind of...tool. A key to unlock it. I just don't know what.'", Fayni)->
You look at the collection of Scrap sadly, willing it to give up its secrets. But they do not. After a while, Fayni smiles at you.
->Say("'Thanks Chief. I'll keep plugging away at it. I'm just glad to have my suspicions confirmed.'", Fayni)->
You haul most of the scrap back to the sleds, but you notice Fayni keeps some of the pieces, those smaller and eaier to carry. Usually also the ones with the most Clay in them. You let her.
{GiveReward(_courageXP, smallReward)}
->camp.leave

// Change this to the character in question _storyPicker
==Fayni_storyPicker
// What bit of story are we doing?
{character_story_progress:
- Recruiting:
->recruiting
- StoryStart:
->storystart
- Reveal:
->reveal
- Arrival_Waiting:
->arrival_waiting
- Arrival:
->arrival
-Resolved_Good:
->resolved_good
-Resolved_Bad:
->resolved_bad
- else:
->none
}
=none
If none of the other picks work, this would be the one to go to.
->leave
=recruiting
Storyline that triggers during the recruiting phase. Should end with going on to 'start'.
->leave

=storystart
Storyline that starts the personal quest, but does not yet reveal the exact biome it pertains to. The progress to the next stage happens when the main story progresses.
->leave
=reveal
The companion tells the player what they want and where it can be had. The player needs to travel to the specified biome to proceed.
->leave
=arrival_waiting
This plays while the companion is waiting for the player to arrive at the specified biome (can be a repeatable 'talk with in camp' type thing, in case the player needs to be reminded where to go).
->leave
=arrival
The player has finally arrived at the biome/location they need to go to! Usually triggered in the style of character_story_progress = arrival + character_storyPicker. Arrival is probably the biggest slot as now we resolve things.
->leave
=resolved_good
This is the (possibly repeatable) piece of content that happens if the resolution was more good than bad.
->leave
=resolved_bad
This is the corresponding piece of content for a more bad than good resolution. What this actually means is up to the companion in question.
->leave

=leave
->DONE

==Fayni_Story_Task_Recruiting
// Story tasks for the character for the various stages 
+ {journal_allTasks?Task_FayniRecruiting} [{taskPretext(Task_FayniRecruiting)} Gather Scrap for Fayni]
#spawn.portrait.fayni
~mainJournalText = "[Fayni's notes] The Clay hidden inside the Scrap already had a use when the Ancients put it in there, and sometimes the Scrap...does things. I must find out more."
~journal_variableNameString = "clayScrap"
~journal_variableNameReal = _clayScrap
~journal_variableNameMaxString = "clayScrapMax"
~journal_task_suggested_goal = 10
~journal_variableIsFloat = true
~journal_taskVariable = Task_FayniRecruiting

~journal_recruiting_tribesmenBonus = smallAmount
~journal_recruiting_warriorsBonus = smallAmount
~journal_recruiting_clayWorkersBonus = mediumAmount
~journal_recruiting_shamansBonus = smallAmount
->Journal.Tasks

==Fayni_Story_Task_Start
// Story tasks for the character for the various stages 
+ {journal_allTasks?Task_Test01} [{taskPretext(Task_Test01)} Task 01]
~mainJournalText = "Main text for the the character task"
~journal_variableNameString = "food"
~journal_variableNameReal = _food
~journal_variableNameMaxString = ""
~journal_task_suggested_goal = 10
~journal_variableIsFloat = false
~journal_taskVariable = Task_Test01

~journal_recruiting_tribesmenBonus = smallAmount
~journal_recruiting_warriorsBonus = smallAmount
~journal_recruiting_clayWorkersBonus = largeAmount
~journal_recruiting_shamansBonus = smallAmount
->Journal.Tasks

==Fayni_Story_Task_Main
// Story tasks for the character for the various stages 
+ {journal_allTasks?Task_Test01} [{taskPretext(Task_Test01)} Task 01]
~mainJournalText = "Main text for the the character task"
~journal_variableNameString = "food"
~journal_variableNameReal = _food
~journal_variableNameMaxString = ""
~journal_task_suggested_goal = 10
~journal_variableIsFloat = false
~journal_taskVariable = Task_Test01

~journal_recruiting_tribesmenBonus = smallAmount
~journal_recruiting_warriorsBonus = smallAmount
~journal_recruiting_clayWorkersBonus = largeAmount
~journal_recruiting_shamansBonus = smallAmount
->Journal.Tasks