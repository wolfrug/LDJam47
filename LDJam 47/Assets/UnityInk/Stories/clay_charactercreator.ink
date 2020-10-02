==Reset==
~trickster = 0
~warchief = 0
~pactmaker = 0
->->

==CharacterCreator()==
#characterCreationStart
#changeportrait
#spawn.background.corral
[Start Character Creation]
~temp points = 3
~temp characterChosen = ()
~temp defaultScionChosen = "none"

-(firstLoop)
{defaultScionChosen:
- "Warchief":
{PlayerPortrait()}
Warchiefs lead the tribe in war. They are strong combatants and leaders, honor-bound to protect their fellow tribesmen.
- "Pactmaker":
{PlayerPortrait()}
Pactmakers are diplomats and traders, capable of bridging the gap between people without resorting to violence.
- "Trickster":
{PlayerPortrait()}
A less traditional kind of leader, Tricksters go against the grain, coming up with novel solutions to old problems.
- else:
Create your Scion.
}
+ [A Warchief]
->Reset->
~xer = "his"
~Xer = "His"
~xim = "him"
~Xim = "Him"
~xe = "he"
~Xe = "He"
~playerPortrait = MalePortrait
{alter(_warchief, 2)}
{alter(_pactmaker, 1)}
~points = 0
~defaultScionChosen = "Warchief"
->firstLoop
+ [A Pactmaker]
->Reset->
~xer = "her"
~Xer = "Her"
~xim = "her"
~Xim = "Her"
~xe = "she"
~Xe = "She"
~playerPortrait = FemalePortrait
{alter(_pactmaker, 2)}
{alter(_trickster, 1)}
~points = 0
~defaultScionChosen = "Pactmaker"
->firstLoop
+ [A Trickster]
->Reset->
~xer = "they"
~Xer = "They"
~xim = "them"
~Xim = "Them"
~xe = "they"
~Xe = "They"
~playerPortrait = AndroPortrait
{alter(_trickster, 2)}
{alter(_warchief, 1)}
~points = 0
~defaultScionChosen = "Trickster"
->firstLoop
+ [Custom]
->loop
+ {defaultScionChosen != "none"} [Continue]->loop3
+ [Skip All (Debug)]
->Reset->
~xer = "they"
~Xer = "They"
~xim = "them"
~Xim = "Them"
~xe = "they"
~Xe = "They"
~playerPortrait = AndroPortrait
{alter(_trickster, 1)}
{alter(_warchief, 1)}
{alter(_pactmaker, 1)}
~companions+=Valfrig
~journal_allTasks+=Task_ValfrigRecruiting
~points = 0
~hasOmbrascope = true
~AddSigil(Corral)
{alter(_tribesmen, 5)}
{alter(_warriors, 5)}
{alter(_clayworker, 1)}
{alter(_shaman, 1)}
{alter(_food, 13)}
~home_recruitedTime = currentTime
~home_recruited = true
~home_resupplied = true

~journal_currentTaskText = "Your are an unknown in your tribe: your first task will be to build trust in your leadership. Lead a wercru, gather Tales of Bravery, and tell them to the Elders to build Trust!"
~journal_currentTaskVariableName = "courage"
~journal_currentTaskVariableReal = _courage
~journal_currentTaskVariableMaxName = ""
~journal_currentTaskGoal = 5
~journal_currentTaskIsFloat = false
~journal_currentTask = Task_MainStory00
~journal_recruiting_currentTribesmenBonus = smallAmount
~journal_recruiting_currentWarriorsBonus = smallAmount
~journal_recruiting_currentShamanBonus = smallAmount
~journal_recruiting_currentClayworkerBonus = smallAmount
{UpdateMainObjective(journal_currentTaskVariableName,journal_currentTaskVariableMaxName,journal_currentTaskIsFloat)}
#characterCreationEnd
#changeportrait
->home.options

-(loop)
{PlayerPortrait()}
Pick your pronouns ({xe}/{xim}) and portrait:
+ [She/her]
~xer = "her"
~Xer = "Her"
~xim = "her"
~Xim = "Her"
~xe = "she"
~Xe = "She"
->loop
+ [Portrait 1]
~playerPortrait = MalePortrait
->loop
+ [He/him]
~xer = "his"
~Xer = "His"
~xim = "him"
~Xim = "Him"
~xe = "he"
~Xe = "He"
->loop
+ [Portrait 2]
~playerPortrait = FemalePortrait
->loop
+ [They/them]
~xer = "they"
~Xer = "They"
~xim = "them"
~Xim = "Them"
~xe = "they"
~Xe = "They"
->loop
+ [Portrait 3]
~playerPortrait = AndroPortrait
->loop
+ [Confirm]
- (loop2)
Pick your skills:<> 
<br>Pactmaker: {pactmaker}<>
<br>Warchief: {warchief}<>
<br>Trickster: {trickster}
(Points left: {points})
+ [<color=green>Pactmaker+</color>]
{points>0:
{alter(_pactmaker, 1)}
~points--
}
->loop2
+ [<color=red>Pactmaker-</color>]
{pactmaker>0:
{alter(_pactmaker, -1)}
~points++
}
->loop2
+ [<color=green>Warchief+</color>]
{points>0:
{alter(_warchief, 1)}
~points--
}
->loop2
+ [<color=red>Warchief-</color>]
{warchief>0:
{alter(_warchief, -1)}
~points++
}
->loop2
+ [<color=green>Trickster+</color>]
{points>0:
{alter(_trickster, 1)}
~points--
}
->loop2
+ [<color=red>Trickster-</color>]
{trickster>0:
{alter(_trickster, -1)}
~points++
}
->loop2
+ [<color=yellow>Reset</color>]
{alter(_trickster, -trickster)}
{alter(_warchief, -warchief)}
{alter(_pactmaker, -pactmaker)}
~points = 3
->loop2
+ {points==0}[<color=green>Finish</color>]
#changeportrait
- (loop3)
{LIST_COUNT(characterChosen)==0:
Choose a starting Companion. [Companions are friends who will always follow you and who will give bonuses to stats. They all have their own stories as well. You can find more Companions during your story.]
}
{characterChosen:
-Fayni:
Fayni comes from a family of traders, and has always had a way with words. Like you, she has never left the Corral. [Pactmaker +1]
-Valfrig:
Valfrig is a Shaman; sages, scientists, teachers and storytellers. His speciality is cartography - a lost art in the City. [Shamans +1]
-Barr:
Barr is one of the best, and bravest, warriors in the Corral. She will be able to advice you in all matters pertaining to War. [Warchief +1]
-Chi:
Chi is a Wanderer; someone from outside the Elbéar tribe. Although a thief, she knows the world outside the Corral well. [Trickster +1]
-Jaerd:
Jaerd is a part of the Brotherhood of Clayworkers, capable of moulding and instructing Clay to do their bidding. [Clayworker + 1]
}
+ [Fayni, the Pactmaker]
#changeportrait
#spawn.portrait.fayni
~characterChosen = Fayni
->loop3
+ [Valfrig, the Shaman]
#changeportrait
#spawn.portrait.valfrig
~characterChosen = Valfrig
->loop3
+ [Barr, the Warrior]
#changeportrait
#spawn.portrait.barr
~characterChosen = Barr
->loop3
+ [Chi, the Trickster]
#changeportrait
#spawn.portrait.chi
~characterChosen = Chi
->loop3
+ [Jaerd, the Clayworker]
#changeportrait
#spawn.portrait.jaerd
~characterChosen = Jaerd
->loop3
+ {LIST_COUNT(characterChosen)>0}[Finish]
- (loop4)
{PlayerPortrait()}
Are you happy with your Scion?<br>Pronoun: {xe}/{xim}<br>Pactmaker: {pactmaker} <br>Warchief: {warchief} <br>Trickster: {trickster}<br>Companion: {characterChosen} {characterChosen:
    - Barr:
    <>the Warrior
    - Chi:
    <>the Trickster
    - Fayni:
    <>the Pactmaker
    - Jaerd:
    <>the Clayworker
    - Valfrig:
    <>the Shaman
    }

+ [<color=green>Finish</color>]
#characterCreationEnd
#changeportrait
~companions+=characterChosen
->->
+ [Customize]
->loop