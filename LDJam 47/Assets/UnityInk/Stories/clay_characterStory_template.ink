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
VAR character_story_progress_counter = 0

==character_addStoryProgress(task, progress)==
// Use this for story progress logic in whatever way needed
{task==journal_currentTask:
~character_story_progress_counter += progress
}
->->

==character_startCompanionStory
// Put in the 'start companion story' here
Start companion story.
->->

// Change this to the character in question _storyPicker
==character_storyPicker
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

==Character_Story_Task_Recruiting
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

==Character_Story_Task_Start
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

==Character_Story_Task_Main
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