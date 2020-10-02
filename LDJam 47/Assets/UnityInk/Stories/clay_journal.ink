VAR mainJournalText = "Starting journal text"
VAR journal_variableNameString = ""
VAR journal_variableNameReal = ""
VAR journal_variableNameMaxString = ""
VAR journal_variableIsFloat = false
VAR journal_task_suggested_goal = 0
VAR journal_taskVariable = ()

VAR journal_recruiting_tribesmenBonus = tokenAmount
VAR journal_recruiting_warriorsBonus = tokenAmount
VAR journal_recruiting_clayWorkersBonus = tokenAmount
VAR journal_recruiting_shamansBonus = tokenAmount

VAR journal_standardItemsText = "Items you carry with you."
VAR journal_standardCrewText = "Your wercru."
VAR journal_standardTasksText = "Your goals."
VAR isJournalOpen = false
VAR journal_last_open_tab = ->Journal.Tasks

VAR journal_currentTaskText = ""
VAR journal_currentTaskVariableName = ""
VAR journal_currentTaskVariableReal = ""
VAR journal_currentTaskVariableMaxName = ""
VAR journal_currentTaskGoal = 0
VAR journal_currentTaskIsFloat = false

VAR journal_recruiting_currentTribesmenBonus = tokenAmount
VAR journal_recruiting_currentWarriorsBonus = tokenAmount
VAR journal_recruiting_currentShamanBonus = tokenAmount
VAR journal_recruiting_currentClayworkerBonus = tokenAmount

LIST journal_allTasks = (Task_MainStory00), Task_MainStoryFallback, Task_FayniRecruiting, Task_BarrRecruiting, Task_ValfrigRecruiting, Task_ChiRecruiting, Task_JaerdRecruiting, Task_Test00, Task_Test01
VAR journal_currentTask = ()
VAR journal_doneTasks = ()
VAR journal_failedTasks = ()

// Cannot quit until a task has been picked
VAR journal_forceTaskPick = false

==OpenJournalExt==
// This is called externally, and ends with a ->DONE
// We close it if it is already open
{not isJournalOpen:
#openJournal
~isJournalOpen = true
<i></i>
->Journal->
#closeJournal
~isJournalOpen = false
<i></i>
->DONE
- else:
#closeJournal
~isJournalOpen = false
<i></i>
->DONE
}

==OpenJournalInt==
// This is called internally, and ends with a tunnel
#openJournal
~isJournalOpen = true
<i></i>
->Journal->
#closeJournal
~isJournalOpen = false
<i></i>
->->

==CloseJournal(continue)
#closeJournal
~isJournalOpen = false
<i></i>
{continue:
->->
- else:
->DONE
}

==Journal
// OPENING THE JOURNAL TO LAST SAVED SPOT
~journal_variableNameString = ""
~journal_variableNameMaxString = ""
~journal_variableIsFloat = false
~journal_task_suggested_goal = 0
//~journal_taskVariable = ()
->journal_last_open_tab

=Tasks
<-navigation
{UseText("journal_description")}{mainJournalText}<>
{journal_currentTaskVariableName !="" && journal_currentTask == journal_taskVariable:
    ~temp progressCurrent = 0
    {getSkill(journal_currentTaskVariableReal, progressCurrent)}
    {isTaskFinished(journal_currentTask): <color=green>|<color=yellow> <>}
    {print_var(journal_currentTaskVariableReal, progressCurrent, false) != "":
        Progress: {progressCurrent} / {journal_currentTaskGoal} {print_var(journal_currentTaskVariableReal, progressCurrent, false)}
    - else:
    {isTaskFinished(journal_currentTask):
    READY
    - else:
    IN PROGRESS
    }
    }<></color>
}
// START ENTRIES
<-EvaluateTask(Task_MainStory00)
<-EvaluateTask(Task_MainStoryFallback)
<-EvaluateTask(Task_FayniRecruiting)
<-EvaluateTask(Task_ValfrigRecruiting)

+ {journal_currentTask!=journal_taskVariable && journal_allTasks?journal_taskVariable && journal_variableNameString !=""} [Change Task]
<-navigation
{journal_currentTaskVariableName !="":
{UseText("journal_description")}<color=red>Warning: Changing tasks before finishing one is usually not well received.</color>
}
++ [Confirm]
//{journal_currentTaskVariableName !="":
//{GiveReward(_failureXP, smallReward)}
//}
~journal_currentTaskText = mainJournalText
~journal_currentTaskVariableName = journal_variableNameString
~journal_currentTaskVariableReal = journal_variableNameReal
~journal_currentTaskVariableMaxName = journal_variableNameMaxString
~journal_currentTaskGoal = journal_task_suggested_goal
~journal_currentTaskIsFloat = journal_variableIsFloat
~journal_currentTask = journal_taskVariable
~journal_recruiting_currentTribesmenBonus = journal_recruiting_tribesmenBonus
~journal_recruiting_currentWarriorsBonus = journal_recruiting_warriorsBonus
~journal_recruiting_currentShamanBonus = journal_recruiting_shamansBonus
~journal_recruiting_currentClayworkerBonus = journal_recruiting_clayWorkersBonus
{UpdateMainObjective(journal_currentTaskVariableName,journal_currentTaskVariableMaxName,journal_currentTaskIsFloat)}
->Tasks
++ [Cancel]
->Tasks

=Items
<-navigation
{UseText("journal_description")}{mainJournalText}
// START ENTRIES

// OMBRASCOPE
+ {hasOmbrascope} [an Ombrascope]
<-navigation
~mainJournalText = ""
A strange claywork device, used to communicate with the City through Sigils of light and shadow.
++ [Sigils]
<-navigation
{UseText("journal_description")}Your Ombrascope can gain you access to:

{sigils?Corral: - The Corral.}
{sigils?Ruins_Interior: - The interior of the ruins dotted around the City.}
+++[Back]
~mainJournalText = journal_standardItemsText
->Items
++ [Back]
~mainJournalText = journal_standardItemsText
->Items
// END OMBRASCOPE

// SCRAP
+ {clayScrap>0} [{print_Num(INT(clayScrap))} {print_var(_clayScrap, clayScrap,false)}]
<-navigation
Pieces of strange machinery; their purpose unknown. All that matters is the useable clay inside.
++ [{Req(_clayScrap, clayScrapPerClay)} Melt it down into Clay]
->CloseJournal(true)->camp.manufactureClay
++ [Back]
~mainJournalText = journal_standardItemsText
->Items
// END SCRAP

// FINAL ENTRY
- ->Items

=Crew
<-navigation
{UseText("journal_description")}{mainJournalText}

// START ENTRIES
+ {tribesmen>0} [{print_Num(tribesmen)} {print_var(_tribesmen, tribesmen, false)}]
#changeportrait
#spawn.portrait.npc
~mainJournalText = "Hardy workers, capable of following instructions but no use in a fight. Needed to scavenge for food and Clay."
+ {warriors>0} [{print_Num(warriors)} {print_var(_warriors, warriors, false)}]
#changeportrait
#spawn.portrait.warrior_npc
~mainJournalText = "Fighters and braves, armed with the skills and tools to fight both man and golem. Used to protect against danger."
+ {shamans()>0} [{print_Num(shamans())} {print_var(_shaman, shamans(), false)}]
#changeportrait
#spawn.portrait.npc
~mainJournalText = "Specialists used to interpret the City and its secrets. Always try to have at least one Shaman with you."
+ {clayworkers()>0} [{print_Num(clayworkers())} {print_var(_clayworker, clayworkers(), true)}]
#changeportrait
#spawn.portrait.npc
~mainJournalText = "Specialists that mold Clay to do your bidding. Needed to turn Scrap into Clay, and for many other tasks in the City. Try to always have one with you."
+ {companions?Fayni} [Fayni, the Pactmaker]
#changeportrait
#spawn.portrait.fayni
~mainJournalText = "Fayni comes from a family of traders, and has always had a way with words. Like you, she has never left the Corral. [Pactmaker +1]"
+ {companions?Valfrig} [Valfrig, the Shaman]
#changeportrait
#spawn.portrait.valfrig
~mainJournalText = "Valfrig is a Shaman; sages, scientists, teachers and storytellers. His speciality is cartography - a lost art in the City. [Shamans +1]"
+ {companions?Barr} [Barr, the Warrior]
#changeportrait
#spawn.portrait.barr
~mainJournalText = "Barr is one of the best, and bravest, warriors in the Corral. She will be able to advice you in all matters pertaining to War. [Warchief +1]"
+ {companions?Jaerd} [Jaerd, the Clayworker]
#changeportrait
#spawn.portrait.jaerd
~mainJournalText = "Jaerd is a part of the Brotherhood of Clayworkers, capable of moulding and instructing Clay to do their bidding. [Clayworker + 1]"
+ {companions?Chi} [Chi, the Trickster]
#changeportrait
#spawn.portrait.chi
~mainJournalText = "Chi is a Wanderer; someone from outside the Elbéar tribe. Although a thief, she knows the world outside the Corral well. [Trickster +1]"

// FINAL ENTRY
- ->Crew

=navigation

+ [{UseButton("journal_tasks")}Tasks]
#changeportrait
~mainJournalText = journal_currentTaskText
~journal_last_open_tab = ->Journal.Tasks
->Tasks
+ [{UseButton("journal_items")}Items]
#changeportrait
~mainJournalText = journal_standardItemsText
~journal_last_open_tab = ->Journal.Items
->Items
+ [{UseButton("journal_crew")}Crew]
#changeportrait
~mainJournalText = journal_standardCrewText
~journal_last_open_tab = ->Journal.Crew
->Crew
+ [{UseButton("journal_quit")}Close]
#changeportrait
{journal_forceTaskPick && journal_currentTaskVariableName == "":
{UseText("journal_description")}<color=red>You must pick a Task before continuing!</color>
->Tasks
- else:
->closeJournal
}

=closeJournal
{UseText("journal_description")} <br>
->->

==ExternalTestTask
// Tasks can be placed wherever, they don't need to be defined here.
+ {journal_allTasks?Task_Test01} [{taskPretext(Task_Test01)} Task 01]
~mainJournalText = "This on the other hand is test 01"
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

==EvaluateTask(task)
//<-Journal.navigation
{task:
- Task_MainStory00:
+ [{taskPretext(task)} Build Trust]
#spawn.portrait.elder
~mainJournalText = "Your are an unknown in your tribe: your first task will be to build trust in your leadership. Lead a wercru, gather Tales of Bravery, and tell them to the Elders to build Trust!"
~journal_variableNameString = "courage"
~journal_variableNameReal = _courage
~journal_variableNameMaxString = ""
~journal_task_suggested_goal = 5
~journal_variableIsFloat = false
~journal_taskVariable = task

~journal_recruiting_tribesmenBonus = smallAmount
~journal_recruiting_warriorsBonus = smallAmount
~journal_recruiting_clayWorkersBonus = smallAmount
~journal_recruiting_shamansBonus = smallAmount
->Journal.Tasks
- Task_MainStoryFallback:
+ {journal_allTasks?Task_MainStoryFallback} [{taskPretext(task)} Build Trust (Eternal)]
~mainJournalText = "Build your legend until you are truly legendary!"
~journal_variableNameString = "courage"
~journal_variableNameReal = _courage
~journal_variableNameMaxString = ""
~journal_task_suggested_goal = 99
~journal_variableIsFloat = false
~journal_taskVariable = task

~journal_recruiting_tribesmenBonus = smallAmount
~journal_recruiting_warriorsBonus = smallAmount
~journal_recruiting_clayWorkersBonus = smallAmount
~journal_recruiting_shamansBonus = smallAmount
->Journal.Tasks
// FAYNI
- Task_FayniRecruiting:
<-Fayni_Story_Task_Recruiting
// VALFRIG
- Task_ValfrigRecruiting:
<-Valfrig_Story_Task_Recruiting
}

