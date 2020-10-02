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
VAR valfrig_story_progress_counter = 0

==valfrig_addStoryProgress(task, progress)==
// Use this for story progress logic in whatever way needed
{task==journal_currentTask:
~valfrig_story_progress_counter += progress
}
->->

==valfrig_startCompanionStory
// Put in the 'start companion story' here
Start companion story.
->->

==valfrig_recruitingStoryEvent
{valfrig_story_progress_counter:
- 0:
You take a short break next to one of the half-disassembled buildings that dot The Ruin. Valfrig comes up to you, map-tablet in hand. You see he has been sketching your path through the Ruin.
->Say("'Thank you for bringing me here. I've already found some hints.'", Valfrig)->
->Say("'I know <i>randomly wandering</i> seems like a strange way to progress, but trust me...it works.'", Valfrig)->
->valfrig_addStoryProgress(Task_ValfrigRecruiting, 1)->
You suppose wandering around a dangerous wasteland while Valfrig sketches on his tablet is one way to occupy a wercru. Soon, you head out again.
{GiveReward(_courageXP, smallReward)}
- 1:
Valfrig comes up to you as you walk, a frown marring his handsome face.
->Say("'It doesn't make sense. It should be here. I followed all the signs...except none of the streets are where they were.", Valfrig)->
You stop, and togeher you look around. Dead ground. Half-un-finished buildings, their empty eyes staring down at you. Of course nothing is the same. The City never stops moving.
->Say("'But maybe if...yes...look. There are constants. Like the river. Things the City does not touch.'", Valfrig)->
He shows something on his tablet, but you cannot decipher the shaman-sigils, except for the shape of the river and the symbol for the Corral.
->Say("'I can use them to...Yes...", Valfrig)->
->valfrig_addStoryProgress(Task_ValfrigRecruiting, 1)->
He walks away, frowning and making changes with his stylus. You shrug and move on.
{GiveReward(_courageXP, smallReward)}
- 2:
The crackling red claylights of a forbidden zone blocks your path ahead. It seems clear you will need to turn around, when Valfrig rushes up to you, tablet in hand.
->Say("'I got it! It's through here! I found it - I'm sure of it!'", Valfrig)->
He moves forward, as if not seeing the claylight boundary at all. You only just manage to catch him before he passes through. Valfrig gives a frustrated grunt.
->Say("'It's fine! Most of these aren't real. They're just...memories. They don't protect anything.'", Valfrig)->
->Say("'Please. We've come so far.'", Valfrig)->
->valfrig_addStoryProgress(Task_ValfrigRecruiting, 1)->
* [Not until you are better prepared.]
{honorable: Being brave does not mean being stupid.}{thoughtful: You are responsible for more people than just the two of you.}{playful: As the old saying goes: if you're going to throw a rock at a bot, you better be prepared for a zap.}{neutral: You shake your head. You are not ready.} Even if Valfrig is right, you cannot risk it.

Valfrig sighs.
->Say("'It won't be there any more when we come back. We'll have to find it again.'", Valfrig)->
But then he brightens.
->Say("'Although I think I've figured out the trick to finding it now.'", Valfrig)->
You leave the ominous, crackling barrier of red behind. For now.
->valfrig_storyPicker.leave
* [Cross the boundary.]
You hesitate for a moment, and then nod at your wercru to follow you. Valfrig smiles at you gratefully. He is the first to step across the light. Nothing happens, and you let out a sigh of relief.
->valfrig_recruitingStoryEvent_finish

- 3:
You have found another road, blocked by the red claylight marking a forbidden zone. Valfrig comes up to you, giving you a nod. He wasn't joking when he said he'd figured out how to find it.
+ [Leave it for now.]
Valfrig looks frustrated.
->Say("'If you do not want me to look for it, you will have to give the crew some other task.'", Valfrig)->
->Say("'Otherwise I will always lead us back to it.'", Valfrig)->
[You can change tasks in the Journal if you no longer want this event.]
->valfrig_storyPicker.leave
* [Cross the boundary.]
You hesitate for a moment, and then nod at your wercru to follow you. Valfrig smiles at you gratefully. He is the first to step across the light. Nothing happens, and you let out a sigh of relief.
->valfrig_recruitingStoryEvent_finish

}
->valfrig_storyPicker.leave

==valfrig_recruitingStoryEvent_finish
You edge forward, eyeing the empty windows around you for ambushes. You have never seen what lies beyond the forbidden zones, and despite your apprehension you are also curious.

Valfrig seems to share the sentiment. Soon, you enter an open area, surrounded on all sides by walls yet open to the air. Benches line the edges of it, and the floor is smooth. Weirdly, you hear the sound of birds, yet there are no nests, no droppings.
->Say("'There! There it is, look!'", Valfrig)->
You look where he points: a massive screen covers one of the walls, its clay animating a strange picture indeed. Glyphs and sigils run along the bottom and top, framing what must be the map Valfrig is looking for.
->Say("'Incredible. They must have come here, the Ancients, when they were lost.'", Valfrig)->
->Say("'A place of pilgrimage, maybe. See that red circle? That is where we are.'", Valfrig)->
You are just about to look, when you hear the tell-tale screech of a Warden-bot noticing something is amiss. With an ominous rumble, a wall comes alive. Features you thought were glitch-added turn and twist into the shape of a massive and mishapen golem.

Valfrig, however, looks strangely calm - as if was expecting it.
->Say("'Let me calm it. Please.'", Valfrig)->

* [Let him try. {displayCheck(_shaman, easy)}]
{skillCheck(_shaman, easy):
Success!
- else:
Faaail.
}
* [Order your warriors to attack! {displayAdvancedCheck(_warchief, medium, _warriors, warriors, smallAmount)}]


// Change this to the character in question _storyPicker
==valfrig_storyPicker
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

==Valfrig_Story_Task_Recruiting
// Story tasks for the character for the various stages 
+ {journal_allTasks?Task_ValfrigRecruiting} [{taskPretext(Task_ValfrigRecruiting)} Find Map for Valfrig]
~mainJournalText = "Valfrig is convinced there is an ancient map of the City somewhere in The Ruins (east of the Corral); he would like to make a copy of it."
~journal_variableNameString = "valfrig_story_progress_counter"
~journal_variableNameReal = valfrig_story_progress_counter
~journal_variableNameMaxString = ""
~journal_task_suggested_goal = 3
~journal_variableIsFloat = false
~journal_taskVariable = Task_ValfrigRecruiting

~journal_recruiting_tribesmenBonus = smallAmount
~journal_recruiting_warriorsBonus = smallAmount
~journal_recruiting_clayWorkersBonus = smallAmount
~journal_recruiting_shamansBonus = largeAmount
->Journal.Tasks

==Valfrig_Story_Task_Start
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

==Valfrig_Story_Task_Main
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