// Keep this include while working/testing, I will comment out when integrating
//INCLUDE clay_functions.ink
// Change the 'locationName' of all of these to correspond to the knot name below
// Set in the 'leave' stitch
VAR parkFarm_last_visit = -1
// this is set to true when the location is spawned. Needs to be set to false manually
VAR parkFarm_new = true
// this is set when spawned.
VAR parkFarm_creationTime = 0
// this is set when the object is very close to the edge
VAR parkFarm_dangerClose = false
// set this to true if you want it to be hidden
VAR parkFarm_hidden = true


==parkFarm
{parkFarm == 1:
The walls of the City fall away around you as you emerge into the park. For once, the sun can shine unimpeded from a clear sky, and as the members of your tribe pour out of the urban tunnels, each stops for a moment to take in the view. Your feet sink into the soft ground.

Ahead of you lies the vine-jungle; calcified trees strangled by glowing genmod plants, reaching for the life-giving sun above. Deeper in lie the fertile Farms, where the Mealfruit grow, and the soft banks of the Anahita river, with its sweet waters.
}
{parkFarm_new && currentTime-parkFarm_creationTime < 2:
You are early: the vine-jungle stands like a wall before you, blocking your path.
- else:
{parkFarm_dangerClose:
You are, however, already too late; the park is closed. Attendants buzz around, tending to the cut vines. One flies up to you, already flashing its warning message in glyphs. You cannot enter.

{knownLocations == EatingEngine && finishedLocations != EatingEngine:
The Eating Engine would simply have to wait.
}
- else:
There are already paths cut through them, made by others who came before you.
~parkFarm_new = false
}
}

{knownLocations == EatingEngine && not parkFarm_dangerClose && finishedLocations != EatingEngine:
And somewhere in here lies the Eating Engine, and its cult. You just have to find it.
}

{not parkFarm_dangerClose:
{parkFarm_new:
+ [Cut your way into the Vine-Jungle]->vineJungleNoPaths
- else:
+ [Enter the Vine-Jungle]->vineJunglePaths
}
}
+ [Leave] ->leave

=vineJungleNoPaths
Your tribesmen eagerly set to work cutting a path through the jungle. Being here this early means access to the sweetest fruit and the most unspoilt waters.
->vineJungleEncounters(RANDOM(1,2))

=vineJunglePaths
You soon find a path left by another caravan of similar size to yours, and set down it.
->vineJungleEncounters(RANDOM(0,1))

=vineJungleEncounters(danger)
The smell of the City disappears almost entirely in the jungle, replaced instead with the unfamiliar: bark, mulch, wet, rot. {~Apis the size of your fist cluster around the pungent-smelling flowers above your head, their wings beating faster than the eye can see.|Likewise, the sound of the Wind itself is muffled between the living-dead trees, replaced with the rustle of vine-leaves.}

{danger>1:
// Danger 2, basically
{~You hear a sudden cry of pain; a tribesman falls back from the side of the path, covered in his own blood. You never see what cut him, but by the time a healer reaches him he's already gone. {alter(_tribesmen,-1)}{alter(_courage,-1)}|A scout calls out the command to stop, and the whole caravan does. Something lumbers by, unseen, but not unheard; a Custodian, perhaps, or something else.{alter(_courage, -1)}}
// Danger 1
- else:
{danger>0:
{~The silence is interrupted by the sudden buzz of a hundred Apis, disturbed in their nests. They sweep down over the caravan, hard shells hitting like rocks. They are soon chased off, but not without leaving some bruises.{alter(_courage, -1)}|You stay alert as you walk through the vine-jungle. You never know what might be out there. But nothing happens. Luckily.}
}
}
Soon enough, you pass through the vine-jungle out into one of the clearings around the river Anahita.->hub

=hub
{~A Custodian lumbers by on the opposite side of the river, ignoring you.|You see a clutch of Mealfruit bushes, just about to push themselves free of the ground.}

+ [Leave]->leave


=leave
// always use this when finishing
// this sets the last visit time to current time, if this is needed for checks
~parkFarm_last_visit = currentTime
{debug:
->debugTravelOptions
-else:
->DONE
}