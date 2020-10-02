// Comments by companions go here to avoid clogging up the main story thread

/* Convenience copy & paste
// Every companion
{companions?Fayni:
->Say("", Fayni)->
}
{companions?Valfrig:
->Say("", Valfrig)->
}
{companions?Barr:
->Say("", Barr)->
}
{companions?Chi:
->Say("", Chi)->
}
{companions?Jaerd:
->Say("", Jaerd)->
}

// Only one companion
~temp randomCompanion = LIST_RANDOM(companions)
{randomCompanion:
- Fayni:
->Say("", Fayni)->
- Valfrig:
->Say("", Valfrig)->
- Barr:
->Say("", Barr)->
- Chi:
->Say("", Chi)->
- Jaerd:
->Say("", Jaerd)->
}
*/

==comp_home_leaving==
{companions?Fayni:
->Say("'Let's get some supplies from the Quartermaster first.' Fayni says. 'And then maybe we can get the sigil for the Corral from the Gatekeeper.'", Fayni)->
}
{companions?Valfrig:
->Say("'This is so exciting. I want to watch the ombrascope learning the sigil for the Corral! Let's go to the gate and talk to the Gatekeeper.' He pauses for a moment. 'And then we should probably get some food from the Quartermaster.", Valfrig)->
}
{companions?Barr:
->Say("'We can't march on an empty stomach. Let's get supplies from the Quartermaster.' Barr looks eagerly at the gate. 'And then we can get the sigil and get out of here.'", Barr)->
}
{companions?Chi:
->Say("'Well that was fun.' She looks uncomfortable. 'Let's grab some supplies from the Quartermaster and then teach the ombrascope the sigil at the gate. And then leave.'", Chi)->
}
{companions?Jaerd:
->Say("'You know the Pitmaster's tablet has memories of every wercru since the Hunger? Incredible.' He pauses. 'Right. We should get some food from the Quartermaster, and then learn the sigil from the Gatekeeper so we can start.'", Jaerd)->
}
->->

==comp_corral_hk_comment1==
~temp randomCompanion = LIST_RANDOM(companions)
{randomCompanion:
- Fayni:
->Say("'Shit!' Fayni's voice trembles. 'I've never seen one up so close. They're <i>huge</i>!'", Fayni)->
->Say("'I'm glad it wasn't looking for us.'", Fayni)->
- Valfrig:
->Say("'By the Ancestors.' Valfrig scrambles to his feet. He looks elated. 'Did you <i>see</i> that?'", Valfrig)->
->Say("'How does it stay afloat? It's so...massive.' He stares after it, almost longingly.", Valfrig)->
- Barr:
->Say("Barr swears. 'We're lucky it wasn't looking for us, or we'd already be a dark stain on the ground.' She grumbles as she gets up.", Barr)->
->Say("She frowns. 'It seems to be on a mission. Not good news, this close to the Corral.'", Barr)->
- Chi:
->Say("'FUCK!' Chi shouts.", Chi)->
->Say("'Shit, fuck.' She adds after a moment, her voice lower. 'I thought you didn't <i>have</i> these fuckers out here.'", Chi)->
- Jaerd:
->Say("'Bozes preserve us.' Jaerd gasps. 'How did we not hear it?'", Jaerd)->
->Say("'I'm just glad it wasn't looking for us.' He adds, still on the ground. 'They say their voice alone is enough to turn a warrior to liquid.'", Jaerd)->
}
->->

==comp_corral_hk_comment2==
~temp randomCompanion = LIST_RANDOM(companions)
{randomCompanion:
- Fayni:
->Say("'I don't like this. I don't like this at all.' Fayni wraps her arms around herself.", Fayni)->
->Say("'We should go. What if the City thinks we did this?'", Fayni)->
- Valfrig:
->Say("'These are not the City's glitches.' Valfrig says, pointing at a strange jutting wall.", Valfrig)->
->Say("'Something else made these. The City did not <i>want</i> to move this way.'", Valfrig)->
- Barr:
->Say("'Weird. I dont' see any char-gun marks on these sec-bots. Or signs of spear-penetration.' She frowns.", Barr)->
->Say("'This is wrong, boss. Our people didn't kill these boze-bots.'", Barr)->
- Chi:
->Say("'Whoa. We should probably hurry up.' Chi heads towards the closest bot.", Chi)->
->Say("'Come on. We can strip at least a few of these before we we have to run.' She looks at you hopefully.", Chi)->
- Jaerd:
->Say("'Look at these structures...' Jaerd touches one of the weird glitch-structures. 'It's...dead.'", Jaerd)->
->Say("'That's impossible.' He breathes. 'Nothing can kill this much of the City at once.'", Jaerd)->
}
->->

==comp_corral_hk_comment3==
~temp randomCompanion = LIST_RANDOM(companions)
{randomCompanion:
- Valfrig:
->Say("'Vulture-drones in this number are rare. We should investigate. What if they are destroying something valuable?' He seems agitated.", Valfrig)->
- Fayni:
->Say("'Some of the more valuable scavenging finds have been snatched from the jaws of Vulture-drones.' Fayni remarks, sounding hopeful.", Fayni)->
- Barr:
->Say("'Vulture-drones are sent in after the Hunter-Killers, to clean up. And they are not aggressive. I bet this has something to do with that H-K we saw earlier.' Barr looks eager. ", Barr)->
- Chi:
->Say("'When I was a wanderer, Vulture-drones almost always lead you to treasure. If you can get to it before them. And they’re not dangerous.' She glances at you hopefully.", Chi)->
- Jaerd:
->Say("'As long as you don’t interfere with them, I hear Vulture-drones will let you collect anything, even clay, from right underneath them.' He remarks.", Jaerd)->
}
->->

==comp_corral_battlefield_comment1==
~temp randomCompanion = LIST_RANDOM(companions)
{randomCompanion:
- Fayni:
->Say("'I don't want to see this.' Fayni turns away, tears in her eyes.", Fayni)->
- Valfrig:
->Say("'Strange. The Vulture-drones haven't consumed it.' Valfrig's voice is low, reverent.", Valfrig)->
- Barr:
->Say("'The Vultures are behaving oddly around it. Look, it's like they're...repulsed.' Barr narrows her eyes.", Barr)->
- Chi:
->Say("'If it wouldn't kill us to try to harvest it, there's a small fortune here.' Chi looks hungrily at the dead bots all around.", Chi)->
- Jaerd:
->Say("'Rest in peace, brother. Or sister.' Jaerd sighs.", Jaerd)->
}
->->