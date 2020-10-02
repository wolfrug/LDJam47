VAR evts_corral_advanced_success = false
VAR evts_corral_advanced_fumbled = false
VAR evts_corral_creatureDead = false

==evts_corral
->encounter.genericBackgroundDescription->
{~->pactmaker1|->pactmaker2|->warchief1|->trickster1|->pactmaker1|->pactmaker2|->warchief1|->trickster1|->pactmaker1|->pactmaker2|->warchief1|->trickster1|->plot1|->plot1|->plot1}

// BATTLEFIELD UNLOCK EVENT ///
=plot1
{->part1|->part2|->part3->evts_corral}
- (part1)
You never even see the Hunter-Killer before it is already above you, a shadow of death momentarily blotting out the sun. You hit the grass, praying to the Ancestors it is not looking for you. It passes you by with the roar of a dragon, its wings laden with death.

->comp_corral_hk_comment1->

You get up after you are sure it really is not turning around for you. You make note of the direction it was headed. Hunter-Killers are very rare this close to the Corral. There are only a few reasons why one would be sent here by the City...none of them good.
{GiveReward(_courageXP, smallReward)}
{debug:
->debugRetry
- else:
->evts_corral_done
}
- (part2)
You come across a very strange scene. Broken drones lie amidst a glitch-chaos of broken City architecture. Everything feels wrong; you are not sure why, but it feels like a violation took place here, a violation of the City that even the dozen sec-bots lying around could not stop.

->comp_corral_hk_comment2->

This must have happened relatively recently. You think of the Hunter-Killer you saw earlier. Could they be connected, somehow? This <i>was</i> the direction it had headed in...

* [Scavenge the sec-bots for Clay.{displayCheck(_clayworker, easy)}]->option1
* [Scour the area for more clues.{displayCheck(_shaman, medium)}]->option2

- (option1)
You organize your teams as usual, ordering everyone to scavenge what they can. While they work, you take note of the geography of the site. Somehow, it feels like you are getting closer to something big. Whoever did this must be close.
~camp_zone_clayCoeff = 5
->ScavengeClay

- (option2)
{shaman>1: Your shamans come back more confused than they were when they started.|Your shaman comes back more confused than he was when he started.}

{skillCheck(_shaman, medium) && not fumbleCheck(0):
Your instinct - that a violation had occurred - is almost certainly correct. It is as if the City was forced against its own will to form shields and weapons for some unknown assailant, which were then wielded with sudden and deadly force against the sec-bots.

They point out the ossified spears holding a pierced bot mid-air; another bot smothered as if the ground itself rose to swallow it. Scorch-marks from the sec-bots' char-guns scouring a wall, hastily raised from the ground.
{GiveReward(_courageXP, mediumReward)}
- else:
{shaman>1:They hem and haw|He hems and haws} over the strange structures, but the conclusions are confused and run counter to one another. The idea that <i>someone</i> or <i>something</i> else could control the very fabric of the City is, of course, madness.

Yet when you look at the ossified spear that seems to have pierced a bot mid-air, the strange walls peppered with char-ray marks, the only other explanation would be that the City - for some reason - is at war with itself.
{GiveReward(_courageXP, smallReward)}
}

You take note of the geography of the site. Somehow, it feels like you are getting closer to something big. Whoever did this must be close.

{debug:
->debugRetry
- else:
->evts_corral_done
}

- (part3)
Your scout stops you and points to the sky down a street. You squint; several City-drones are converging, small pinpricks circling and diving. <i>Vulture-drones.</i> Whatever it is that attracted them will soon be gone, cut into pieces and carried away to the City’s incinerators.

{playful: You feel a surge of excitement. Whatever they are circling, it must be recent. Who knows what treasure there is to be found?}{thoughtful: There are many stories of Vulture-drones. In most of them, the drones are indifferent to humans; in some, it is suggested humans and Vulture-drones share a common task, and the Vulture-drones are happy to let humans scavenge instead of them.}{honorable: Vulture-drones could mean a battle, or it could mean a piece of wall has collapsed. The only way to find out is to investigate.} 

{evts_corral.plot1.option2:
For some reason you have an inkling this has something to do with the strange battlefield you found earlier; and perhaps the Hunter-Killer from before.
}

->comp_corral_hk_comment3->

You determine that the Vulture-drones are convering somewhere a little distance Crescent-wards from the Corral. ->battlefield.SetHide(false)->

{debug:
->debugRetry
- else:
->evts_corral_done
}
// PACTMAKER 1 //////////////////////////
=pactmaker1
{->part1|->part2|->part3}
->evts_corral
- (part1)
You come across a woman travelling alone, and stop to exchange stories. She claims to be a healer from a nearby settlement, recently dislodged by the City. She carries a staff and her robes, and little else.

* {not starving}[Rest and share a meal together.{displayTime(10)}]->option1
* [Tell her how to get to the Corral, where it is safe.]->option2

- (option1)
{food>0:
As you sit down to eat, she calls into a nearby copse of trees. Out walks an entire row of emaciated children of all ages, dirty-faced and clearly hungry.
{alter(_food, -1)}
The children gather around the woman, and she tells them - and you - stories while they eat. Once they are done, they thank you and quietly leave.
{GiveReward(_courageXP, smallReward)}
{GiveReward(_pactmakerXP, smallReward)}
- else:
You have little food to share, but you share what you can. The woman does not complain. You notice her shaking her head several times at a nearby copse of trees, and that she eats less than she squirrels away into her robes.

She tells you stories of her craft and of the City while you eat what little you have to share. She thanks you and quietly leaves afterwards, pockets filled with scraps.
{GiveReward(_courageXP, tokenReward)}
{GiveReward(_pactmakerXP, smallReward)}
}
{PassInkTime(10)}
{debug:
->debugRetry
- else:
->evts_corral_done
}
- (option2)
You give her the instructions and she listens patiently, but you sense she already knows perfectly well where the Corral is. She leaves in the direction of a small copse of trees, and you think you see a face of someone watching you from among the trees.
{GiveReward(_pactmakerXP, smallReward)}
{debug:
->debugRetry
 - else:
 ->evts_corral_done
}
- (part2)
You spot a familiar figure standing on top of a large rock, watching your crew. It is the healer {evts_corral.pactmaker1.option1: you shared a meal with.|you gave instructions to on how to get to the Corral.} She raises her staff above her head and moves it in a pattern you do not recognize but is reminiscent of a shaman-dance. You feel uneasy.
~temp difficulty = medium
{evts_corral.pactmaker1.option1: 
~difficulty = easy
}
{skillCheck(_shaman, medium):
A shaman confirms your suspicion; but hers is a Boze-dance, forbidden in the Corral. He cannot say if it's a curse or a blessing. Your wercru mutters among themselves until you tell them to be calm. 
{GiveReward(_courageXP, smallReward)}
- else:
You are not sure what you are looking at, but it does not look like any shaman-dance you have ever seen. A curse? Or a blessing? Your wercru senses your unease.
}

She finishes her dance and disappears, too far away for you to give chase. A most curious tale.
{GiveReward(_pactmakerXP, smallReward)}
{debug:
->debugRetry
}
->evts_corral_done
- (part3)
{evts_corral.pactmaker1.part3>1:->finished}
You come across a strange sigil you do not at first recognize, carved into a tree. Soon, you come across another, a trail leading deeper into the woods. 

{skillCheck(_shaman, easy):
A shaman ponders it for a moment, then declares they are Boze-sigils, although he does not know which Boze exactly.
}

The sigils lead to a hidden clearing with a half-buried stack covered in moss and a firepit. Surrounding the clearing are poles carved with sigils and topped with animal bones. A woman emerges from the doorway to the stack: it is the healer you saw cursing - or blessing - you from the rock. Behind her, cowering inside the stack, are several children of various ages, dirty and thin. You ask her to explain herself.

She offers to share a meal with you, promising this clearing is safe, and to tell you her story. You accept, noting she has food this time.

She was cast out from her community for her Boze-worship, despite being their only Shaman. The children were her former students who had come to look for her: she was escorting them back to the village when she found it had been swallowed whole by the City after they tore down her protective sigils. Since then she has wandered, finding food for the children where she can.

* [Convince her to return to the Corral with the children {displayCheck(_pactmaker, hard)}.]->option3

* [Let her speak of her faith.]->option4
* ->finished
- (option3)
{skillCheck(_pactmaker, hard) && (not fumbleCheck(0)):
You talk to her about her faith and her sense of duty. The Bozes are real, she says, and their power - although limited compared to the City - should not be disregarded. You explain to her Boze-worship is widespread in the Corral; it is only the rituals that are forbidden. Whether or not she herself wants to return for good, she should at least bring the children back. You guarantee their safety. She listens and nods.
{GiveReward(_pactmakerXP, largeReward)}
{GiveReward(_courageXP, smallReward)}
- else:
You give your best attempt at convincing her the children would be safer - and better fed - in the Corral, and that she herself would not be turned away just for her beliefs, but you do not have the energy to argue with her about the finer points of ritual and faith. In the end, you tell her, it is her own decision. She listens and nods, but you sense she is unconvinced.
{GiveReward(_pactmakerXP, mediumReward)}
}
~foodChunkLeft=foodChunkDefault
You finish your meal and leave, the healer promising once more to consider your words. You wonder if you will meet them again.
{debug:
->debugRetry
- else:
->evts_corral_done
}
- (option4)
The healer talks about her faith, how she was given the rituals by her mother, and she from hers. How Boze-worship is older than the Hunger, and how in the days before the ombrascopes only shamans like her mother and grandmother before her could guarantee the safety of the tribe. You and your wercru listen politely. She explains that she will teach the children her ways, and that way, they too will be safe, and the old ways preserved. The children listen to her every word, hanging by her knees.

You finish your meal and leave the little coven, wondering if you will come across them again in the future.
{GiveReward(_pactmakerXP, mediumReward)}
{GiveReward(_courageXP, smallReward)}
{debug:
->debugRetry
- else:
->evts_corral_done
}
- (finished)
You come across some familiar-looking sigils again: Boze-sigils. {evts_corral.pactmaker1.option3: You follow them into a glen, but aside from an old fire, you find no trace of the healer or her charges. You hope they made it to the Corral safely.|You follow them for a while, but they only lead to a recently-abandoned campsite. It seems they are avoiding you.} 
{GiveReward(_courageXP, tokenReward)}
{debug:
->debugRetry
- else:
->evts_corral_done
}

// PACTMAKER 2 //////////////////////////
=pactmaker2
{->part1|->part2|->part3}
->evts_corral
- (part1)
You follow a small stream for a while, looking for a place to ford it, when you come across a group of cattle herders taking a break by the water. You stop to ask for directions, which they are happy to give. You notice some of them looking at you strangely though, and whispering to one another. You think you catch the phrase 'false heir'.

* [Delicately try to find out more {displayCheck(_pactmaker, easy)}]->option1
* [Ignore it]->option2
- (option1)
{skillCheck(_pactmaker, easy) && not fumbleCheck(0):
You segue into talking of their herd, noting the fine quality and health of their animals, and wondering if there is something you could do better than your father. After a moment's hesitation, the cattle herders talk your ear off. At the end, one of the ones whispering takes you aside and tells you there has been talk among the people that you are not the legitimate heir. When you ask where that rumour started, he shrugs.
{GiveReward(_pactmakerXP, smallReward)}
-else:
You attempt to keep the conversation going for a bit longer, but the cattle herders do not seem interested - which in itself is slightly odd. They politely repeat their directions, and wish you well. As you leave, you feel their eyes in your neck.
{GiveReward(_pactmakerXP, tokenReward)}
}
{GiveReward(_courageXP, smallReward)}
{debug:
->debugRetry
-else:
->evts_corral_done
}
- (option2)
You know who you are. Your father warned you there would be people out there doubting your legitimacy. There always are. That is part of what being a chieftain is. {playful: As you leave, you make a joke about not all the cows being branded correctly, and watch as the cattle-herders suddenly scramble to check. So much for 'false heir'.}{honorable: Before you leave you make sure to assure them you will look out for their interests as well as your father did. They nod quietly.}{thoughtful: Cattle-herding is part of the common good, and much of what the herders do comes under the direct purvey of the chieftain. You understand how important it is for them that the chieftain is a good one.}{neutral: That is why you are out here, after all - to gain their trust. One step at a time.}
{GiveReward(_pactmakerXP, smallReward)}
{debug:
->debugRetry
-else:
->evts_corral_done
}
- (part2)
You come across a well-visited pillar-of-messages, its clay surface infused with hundreds of letters, greetings, warnings, gossip and advertisements from the surrounding settlements and passing travellers such as yourself. {partySize(false)>0: Some from your wercru goes up to the post and speak their name or a pass-phrase, and if a message waits for them the post displays it.|There are some travellers standing around it, and you watch as they speak their name or a pass-phrase to make any messages for them appear on the surface of the pillar.}

You decide to try it too, wondering if perhaps your Baba has some news. Although you doubt it; the couriers that update the pillars do not come by that often. To your surprise, you do find a message left for you, however not one you expected.

It is a long diatribe, accusing your father of infidelity, deception and misrule, claiming you are a fraud and the false heir, and that in truth your father never sired anyone as his balls are as frigid as your mother's womb. The message goes on for some time, and is signed 'Truthseeker'. You wipe the surface clean, {evts_corral.pactmaker2.option1:wondering if this is where the rumour the cattle-herders were talking about started.|still determined to ignore nonsense such as this.}
{GiveReward(_pactmakerXP, smallReward)}
{debug:
->debugRetry
-else:
->evts_corral_done
}
- (part3)
{evts_corral.pactmaker2.part3>1: ->finished}
You overtake a man on the road, heading in a particular direction. When you ask him about his goal, he says a man calling himself the 'Truthseeker' is speaking at a public gathering. Remembering the message from a 'Truthseeker', you decide to follow. You tell your wercru to hold back slightly and then accompany the man.

You soon arrive at a clearing where half-built glitch-structures rise out of the grass, providing seating for the dozen or so people listening to the orator, a grey-bearded man standing on top of a cracked dome, shouting at the tribesmen who have gathered to listen to him.

He does not notice you at first, letting you hear what he has to say. Most of it is a rehash of what you read on the pillar-of-messages, but with more spittle. You look around: no-one seems especially impressed, but you do know you cannot let this stand. 

* [Engage the Truthseeker in a debate {displayCheck(_pactmaker, hard)}.]->option3
* [Wait until he is done and then confront him.]->option4

- (option3)
{skillCheck(_pactmaker, hard) && not fumbleCheck(0):
Public speaking is a time-honored tradition among the Elbéar, and anyone who commands the attention of more than one should expect to have their message questioned. You start with innocuous questions like 'when was the last time you saw the chieftain's balls' and observations like 'if one old man ranting is proof then the ranting of all the Elders should be multiple times that proof'.

Eventually you go on to the more important questions, such as his own motivations for making these claims, and where exactly he is getting his information from.

The man splutters and attempts his best to answer, but you run oratorial circles around him in short order. His audience becomes your audience, and you make them laugh until he is boo'd off the stage. As he makes to slink away with his tail between his legs you intercept him - the rest of your wercru arriving as you do, disinclining any attempts at physical violence.

Now that you have him alone, he explains - red-faced and embarrassed - that your father threw him out of the Corral many, many years ago, when you were but an infant, for 'injust reasons' - although you doubt it. Your father is many things, but injust is not one of them.

When he heard your father was dying he decided to celebrate it, and in a moment of drunken bravado claimed your father was dry-balled. When asked to explain you, he had to start inventing the entire conspiracy of the 'false heir' in order to save face. From there, it spiralled.

You tell him to stop spreading lies and send him on your way, although you have a feeling it wouldn't even be necessary. His audience will spread the story of what happened here far and wide, and even if this 'Truthseeker' made another attempt on your name he'd simply be laughed out.
{GiveReward(_pactmakerXP, largeReward)}
{GiveReward(_courageXP, largeReward)}
-else:
Public speaking is a time-honored tradition among the Elbéar, and anyone who commands the attention of more than one should expect to have their message questioned. You interrupt him time and again with questions, questions he angrily answers - to your chagrin with practiced ease. Clearly he is used to some push-back from the audience.

When it becomes clear he will not be ushered off his stage with words you decide to instead wait until he is done and confront him then. 
{GiveReward(_failureXP, smallReward)} 
->option4
}
{debug:
->debugRetry
- else:
->evts_corral_done
}
- (option4)
During the talk you keep a close eye on the audience. Most seem unimpressed, but you do worry some will take his words to heart and spread them to their own families and friends. Despite the best efforts of Shamans everywhere, some Elbéar will believe anything anyone tells them.

Once he is done he motions at a bowl and encourages those moved by his words to leave a little something for him to eat, as he spends every moment occupied with seeking the truth. A few charitable souls leave a morsel or two, which he eyes hungrily. Before he has time to collect his gains, you intercept him.

The rest of the audience having largely dispersed, it is just you and your wercru. {warriors>1: He eyes your warriors with especial worry.} When he realizes who you are, all of his previous bravado melts away.

He explains that your father threw him out of the Corral many, many years ago, when you were but an infant, for 'injust reasons' - although you doubt it. Your father is many things, but injust is not one of them.

When he heard your father was dying he decided to celebrate it, and in a moment of drunken bravado claimed your father was dry-balled. When asked to explain you, he had to start inventing the entire conspiracy of the 'false heir' in order to save face. From there, it spiralled.

You send him on his way with promises to stop, and you have a feeling he will. You can only hope you nipped it in the bud early enough, and that it will not come back to haunt you later, when you are chieftain.
{GiveReward(_pactmakerXP, mediumReward)}
{GiveReward(_courageXP, mediumReward)}
{debug:
->debugRetry
- else:
->evts_corral_done
}

- (finished)
You come across a fellow traveller and, for a lark, ask if they have ever heard of the 'false heir' or the 'Truthseeker'. 
{evts_corral.pactmaker2.option4: 
The traveller shakes her head, but hesitates a second before doing so. Perhaps she recognized you? Hmm.
- else:
The traveller laughs and says she has - and of the thorough thrashing said Truthseeker received from the supposed 'false heir'. You smile.
{GiveReward(_courageXP, tokenReward)}
}
{debug:
->debugRetry
- else:
->evts_corral_done
}
// WARCHIEF 1 //////////////////////////
=warchief1
~temp fallInType = "tribesman"
~temp fallInTypeReal = _tribesmen
{->part1|->part2|->part3}
->evts_corral
- (part1)
Your father, being a clayworker, taught you about Clay from an early age. He said: 'Clay can be dormant. Clay can be curious. Clay can be angry.' But, he added: 'The anger in the Clay is more ancient than mankind itself; it is the hate of aeons. Neither time, nor words, nor sacrifice will lessen it.' 

How he knew these things you do not know; he spent his life communing with the spirits in the Clay and his warnings did not fall on deaf ears. You always knew you might one day encounter such angry Clay.

Today is not that day for you; but it was for someone else. The bodies are barely recognizable as such, cut into ribbons with excessive, hateful force. Travellers, probably. Their sacks are full of food-stuff, left entirely unmolested.

{companions?Barr: ->Say("'We have to track down whatever did this and put it down. It is too close to the Corral.' She says, gripping her weapon with white knuckles.", Barr)->} It was quite some time since you last heard of an attack by the Swarm this close to the Corral; {companions?Barr: Barr is right:|You sigh:} you have to do something.

You bury the dead, collecting their food with thanks to their spirits. Then you begin scouting. 
{alter(_food, 1)}.
{debug:
->debugRetry
-else:
->evts_corral_done
}
- (part2)
{evts_corral.warchief1.part2>1:
You come across the tracks of the Clay-monster again. Your wercru looks to you, unsure of how to proceed this time. Are you ready?
- else:
Tracking a Clay-monster is no easy feat. Their tracks are unlike any left, but can also suddenly stop or disappear as they scale a cliff or a tree, or become a bird and fly away - or so some of the warriors claim. Nonetheless, you have been able to narrow down the rough area it is moving in; it kills randomly, without any apparent goals or aims beyond slaughter. So far it hasn't found the Corral, at least.
}
* [Continue tracking it. You will find it soon.]->option1
+ [Leave the tracks for now. You will need to prepare better first.]->option2

- (option1)
You tell your crew to be on the lookout. Tense nods all around. It won't be long now. [Warning: trying to fight without warriors is not advisable, so be sure to always have warriors in your wercru until you find the creature!] 
{GiveReward(_warchiefXP, mediumReward)}
{debug:
->debugRetry
-else:
->evts_corral_done
}
- (option2)
You tell your crew to be on the lookout - in order to avoid meeting it. Your party is not prepared for a fight - not yet. Some in your wercru look relieved, others less than impressed. 
{GiveReward(_failureXP, tokenReward)}
{debug:
->debugRetry
-else:
->evts_corral_done
}
- (part3)
{evts_corral.warchief1.option1<1:->part2}
{evts_corral_creatureDead: ->finished}
{evts_corral.warchief1.option4<1:
You have finally found it. You had hoped to get to decide when and where, but these are not things you can decide. All you can do is get ready for a fight.

Tendons of Clay snake their way, low, over the ground, changing shape every moment with dizzying speed, like mobile spider's web. Things cling to it; pieces of rusted metal, twigs and leaves, and bones. It stops, as if to survey the area, building itself up and up - a face appears, with two malevolent red eyes that sweep left and right. Then it sees you.
- else:
It's here. Again. The creature from your nightmares. The Clay-beast. It is larger now. The bones that make up its body as it assembles itself to look seem human. It balances on them, the pulsating black clay between a mockery of life.
}
+ {warriors>0} [Get ready to fight. {displayAdvancedCheck(_warchief, hard, _warriors, warriors, mediumAmount)}]->option3
+ [Run]->option4

- (option3)
It shrieks; a sound between a person being crushed alive and a broken drone voice-box, and then charges.

->AdvancedSkillCheck(_warchief, hard, 0, _warriors, warriors, mediumAmount, ->evts_corral_advancedCheckSuccess, ->evts_corral_advancedCheckFail)->

{evts_corral_advanced_success:
You organize your warriors and meet the creature's attack head-on. The fight is intense, if brief. Your warriors have trained for this, their weapons Clayworker-forged for this express purpose. {not evts_corral_advanced_fumbled: Afterwards, you count your wounded and dead. Not bad.|You grimly count your wounded and dead afterwards.} Wherever it came from, it won't hurt anyone else.
{GiveReward(_warchiefXP, largeReward)}
- else:
{fumbleCheck(0):
You barely have time to get out a single word before it is already on top of you. Your orders to attack turn into orders to run.->option3
}
You and your warriors do your best to keep the creature contained, but every time you get in a hit it seems to split, abandoning parts of itself. It moves with unnatural speed, turning itself into a spear or a scythe that can slice through metal.

    {tribesmen>0:
        One of your tribesmen is caught in its path before you can stop it, and is cut down with a blood-curdling scream. 
        {alter(_tribesmen, -1)}
        {GiveReward(_failureXP, smallReward)}
        - else:
        {partySize(false)>0:
            {PickRandomCrewMember(fallInType, fallInTypeReal, false)}
            A {fallInType} is caught in its path and mercilessly cut down.
            {GiveReward(_failureXP, smallReward)}
        }
    }
    
While the creature is distracted for a moment, you manage to get in a hit with your weapon. The clay freezes and cracks and is finally still.
{GiveReward(_warchiefXP, mediumReward)}
}
{GiveReward(_courageXP, mediumReward)}
You make sure there are no more in the area before moving on.
~evts_corral_creatureDead = true
{debug:
->debugRetry
-else:
->evts_corral_done
}
- (option4)
The creature is too fast, its hate too burning.
// BARR KILLS IT
{companions?Barr:
Barr turns back towards it, despite shouting at her not to. 
->Say("'Run.'", Barr)-> 
Her weapon spools up as she shouts a challenge at it. You do as she says, and run.

{RANDOM(0,1)>0:
A while later, she comes limping back to you, covered in cuts and blood but otherwise alive.
->Say("'It's dead.' She says, simply.", Barr)->
{GiveReward(_warchiefXP, smallReward)}
{GiveReward(_courageXP, smallReward)}
- else:
You wait for her, but she doesn't show up. Neither does the creature. After a while you leave. 
{KillCompanion(Barr)}
{GiveReward(_failureXP, largeReward)}
}
~evts_corral_creatureDead = true
->evts_corral_done
}
// END OF BARR KILLS IT - START OF IT KILLING A RANDOM CREW MEMBER
{partySize(true)>1:
{PickRandomCrewMember(fallInType, fallInTypeReal, true)}
You run, but there is no way to outrun the thing. Someone is caught. Luckily, the creature is so absorbed by its hate it stays, tearing the unlucky soul limb from limb while you make your escape.
{fallInType != "companion":
 <> Later, you find it was a {fallInType}. 
 {alter(fallInTypeReal, -1)}
{GiveReward(_warchief, tokenReward)}
{GiveReward(_failureXP, smallReward)}
- else:
<> After, you realize the one caught was {fallInTypeReal}. You reel, for a moment, but there is nothing you can do any longer. 
{KillCompanion(fallInTypeReal)}
{GiveReward(_failureXP, largeReward)}
}
- else:
You run, but you are not fast enough. Not by far. It catches you, its limbs liquid and obsidian-sharp all at once. It cuts into you, stabbing, slicing. You try to grab it and it turns into spikes or melts away. You fall into the dirt and, mercifully, it cuts your throat. Even as you bleed out, it continues its attack on your soon-limp body.
->death("claymonster")
}
{debug:
->debugRetry
- else:
->evts_corral_done
}

- (finished)
You meet a woman on the road, who, when she sees you, immediately runs to your feet, kneeling down and thanking you profusely. When you ask her what for, she explains the Clay-monster had killed her son, and you had killed it. You tell her it was simply your duty, but when she leaves you feel a warm little buzz in your heart.
{GiveReward(_warchiefXP, tokenReward)}
{debug:
->debugRetry
- else:
->evts_corral_done
}
// TRICKSTER 1 //////////////////////////
=trickster1
{->part1|->part2|->part3}
->evts_corral
- (part1)
You find yourself in an area where old stonework peeks out from underneath vines and moss, the structures oddly ignored by the City. You sense these were ruins long before the Hunger.

{companions?Valfrig: Valfrig touches the stonework. ->Say("'These were built by humans. Not the City.' He says, wistful. 'Once upon a time we were the Builders. Not It.'", Valfrig)->} Distracted, you do not notice the drone before it is too late.

It is a Custodian-bot, moss-bearded and cranky, hovering on three engines. You stand frozen while it belts out loud commands in the language of the Bozes. {skillCheck(_shaman, easy): A shaman helpfully interprets: 'It wants you to follow it.'|It does not take a shaman to understand what it wants: to follow it.}

{companions?Chi: Chi tugs your sleeve. ->Say("'Don't even try to follow it. These things can lead you through swamp-lands for days if you let them. Just try to slip away.'", Chi)->|You wonder if it's worth it to follow it. You've heard stories of Custodian bots like these stringing wercrus along for days.}

* {clay>0 && clayworker>0} [Instruct a Clayworker to weave a buzzle-blanket.{displayCheck(_clayworker, easy)}]->option1
* [Attempt to sneak away at the earliest convenient moment. {displayCheck(_trickster, medium)}] ->option2
- (option1)
~temp reward = smallReward
While you walk behind the bot, a Clayworker slips to the side to create the buzzle-blanket. <>
{skillCheck(_clayworker, easy) && not fumbleCheck(0):
 You do not get far before he catches up to you, in his hands a shroud of sheer black that crackles every time it touches skin.
 {alter(_clay, -1)}
- else:
You walk for quite a distance before he finally catches up to you, panting. In his hands is what looks like just a black blanket, not the shroud of electrified black you were expecting. You don't ask. 
{alter(_clay, -2)}
{PassInkTime(5)}
~reward = tokenReward
}
You throw the blanket yourself over the back of the bot as it dips down a hill, and then you run! A cacophony of angry buzzing follows you, but luckily nothing else.
{GiveReward(_tricksterXP, reward)}
{debug:
->debugRetry
- else:
->evts_corral_done
}

- (option2)
{skillCheck(_trickster, medium) && not (fumbleCheck(0)):
You let the bot round a corner and then tell everyone to stop. Peering through some vines you wait until the moment the bot notices you are gone, and then lob a rock through an open window. The bot buzzes after the sound, and you quietly make your escape. 
{GiveReward(_tricksterXP, mediumReward)}
-else:
{PassInkTime(10)}
It takes you some time to find an opportune moment to slip away. When the moment comes, it is accompanied by a lot of running through the underbrush and an uncomfortably long time spent hiding inside a tunnel, half-submerged, while the Custodian-bot looks for you. But you did get away.
{GiveReward(_tricksterXP, smallReward)}
}
{debug:
->debugRetry
- else:
->evts_corral_done
}

- (part2)
You crest a hill just when you hear the sound of a bot somewhere ahead. You quickly order your wercru to hide while you keep watch yourself. When the bot appears, you nearly gasp in surprise.  It is the Custodian-bot you gave the slip to earlier. {evts_corral.trickster1.option1: It is still trailing remnants of the black buzzle-blanket, causing it to list terribly.| It looks angry and a bit dustier and more scratched than before.} It is clearly on the hunt. You stay quiet until you are sure it has disappeared, feeling a knot of worry form in your stomach. Can bots carry grudges?
{GiveReward(_tricksterXP, smallReward)}
{debug:
->debugRetry
}
->evts_corral_done
- (part3)
{evts_corral.trickster1.part3>1:->finished}
When you hear the sound of a drone buzzing, you half-panic when you recognize the cadence of its motors. But you have no time to escape: the green-tinted, moss-covered, scratched old Custodian-bot almost flies right into you, its clay-light an angry red. You stand still like children scolded by their parents, wondering how you will get away this time. After a moment, the bot turns again - it wants you to follow.

#changebackground
#spawn.background.fountain
You arrive at your destination before you have time to consider a new plan to slip away. It is an open space, with stonework pavements and a large, round, water-filled basin in the center. You cannot imagine what the Ancients used it for. You immediately notice that the space is taken care of: bushes and grass pruned, trees killed before they grow too big. There are cats everywhere, enjoying the sun-warmed stone.

You soon realize the cats are the problem. The Custodian-bot buzzes up to them, but the cats seem to have gotten used to the bot, and barely budge when it tries to chase them away. They look at you, newcomers, with suspicious eyes. The Custodian-bot returns to you and shouts some more commands. Then it sees a weed pushing its way through a crack and moves to interecept.

Your wercru looks at you, at a total loss. This is new.

* [Organize a humane kitten-removal project {displayAdvancedCheck(_trickster, hard, _tribesmen, tribesmen, smallAmount)}]->option3
* [Put the bot out of its misery]->option4

- (option3)
->AdvancedSkillCheck(_trickster, hard, -25, _tribesmen, tribesmen, smallAmount,->evts_corral_advancedCheckSuccess, ->evts_corral_advancedCheckFail)->
{evts_corral_advanced_success && not evts_corral_advanced_fumbled:
Somehow, you do it. You organize your tribesmen to gather the cats one by one while you keep the bot busy. The cats soon wisen up to your cat-stealing ways and begin slipping away, but you capture as many as you can. Bags and arms and everything that can hold an angry feral cat is employed to keep them in check. Finally, with most of them gathered, you escape. If you didn't know any better, the bot almost looks pleased. 
{GiveReward(_tricksterXP, largeReward)}

You let the cats go some distance away, knowing they will probably make their way back to the square sooner rather than later. You just hope the bot will have forgotten you by then.
- else:
You do your very best to herd to cats, but whatever you do more and more of them slip away from you. More cats appear, as if curious to find out what you are doing. Somehow, it seems, your presence has made things <i>worse</i>. There is meowing. There is scratching. You think you might have misplaced some of your tribesmen in the horde of cats.

The Custodian-bot, finally, flies up above the whole square and surveys the situation. Perhaps seeing the impossibility of it, you watch as it turns around slowly, turning off its clay-light, and buzzing away, finally abandoning its post. You drop the cats you managed to catch and sneak away. 
{GiveReward(_tricksterXP, mediumReward)}
}
{debug:
->debugRetry
- else:
->evts_corral_done
}

- (option4)
This bot clearly has no way of communicating with the City, or if it does, the City does not listen to it. You do not have time to herd cats, or to act its servant. But you cannot risk it chasing after you across the whole City either.

You consider simply attacking it, but then you notice some of the cats seem to enjoy hunting the bot, even as it tries to do its job. {evts_corral.trickster1.option1: The small bits of buzzle-blanket that still cling to it gives you the idea.| A small flower stuck between two metal plates that attracts the attention of one rumbunctious cat gives you an idea.}

You collect some string and fashion a simple cat-toy out of it. Some of the younger kittens immediately seem interested. You wait until the bot is still, pruning a bit of weed with its barely-functional heat-ray, and carefully bind the string to its rear motor, and then step back.

With something to actually grab on to, the cats immediately begin to play. Cat after cat swipes after the bot as it sweeps past. A fat tabby jumps up and grabs the string with all four paws, and the bot crashes to the ground. The cat escapes at the last moment. The drone does not get back up. You gather your wercru and leave, leaving the square to the cats.
{GiveReward(_tricksterXP, mediumReward)}
{debug:
->debugRetry
- else:
->evts_corral_done
}

- (finished)
{evts_corral.trickster1.option3:
#changebackground
#spawn.background.fountain
You see a cat following you, and wonder briefly it's one of the ones from the square with the cats and the Custodian-bot. You try to lure it over, but it hisses at you and runs off. Fair. 
{GiveReward(_courageXP, tokenReward)}
- else:
You hear the sound of a drone buzzing, and for a moment you think you recognize the cadence; but then it fades away. You wonder if the bot was ever repaired. You hope not.
{GiveReward(_courageXP, tokenReward)}
}
{debug:
->debugRetry
- else:
->evts_corral_done
}
==debugRetry
+ [Retry]
->evts_corral

==evts_corral_done
->DONE

==evts_corral_advancedCheckSuccess(fumbled)==
~evts_corral_advanced_success = true
~evts_corral_advanced_fumbled = fumbled
->->
==evts_corral_advancedCheckFail(fumbled)==
~evts_corral_advanced_success = false
~evts_corral_advanced_fumbled = fumbled
->->