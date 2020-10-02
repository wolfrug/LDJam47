// Functions etc
INCLUDE clay_functions.ink
INCLUDE clay_debugs.ink
INCLUDE clay_locationTemplate.ink
INCLUDE clay_characterCreator.ink
INCLUDE clay_journal.ink
// Locations
INCLUDE clay_camp.ink
INCLUDE clay_parkfarms.ink
INCLUDE clay_factory.ink
INCLUDE clay_center.ink
INCLUDE clay_financial.ink
INCLUDE clay_home.ink
INCLUDE clay_wargolem.ink
INCLUDE clay_offices.ink
INCLUDE clay_fillerDistrict.ink
// Encounters
INCLUDE clay_mainEncounters.ink
INCLUDE clay_ombrascope.ink
INCLUDE clay_events_corral.ink

// Dungeons
INCLUDE clay_dungeonTemplate.ink
INCLUDE clay_battlefield.ink

// Companions
INCLUDE clay_companions.ink
INCLUDE clay_characterStory_template.ink
INCLUDE clay_characterStory_fayni.ink
INCLUDE clay_characterStory_valfrig.ink





VAR random_encounter_last_visit = -1
VAR random_encounter_new = true
VAR random_encounter_creationTime = 0
VAR random_encounter_hidden = false
VAR debug = true
{debug:
~trickster = 1
~warchief = 1
~pactmaker = 1
~clay = 19
~food = 50
~tribesmen = 7
~warriors = 5
~shaman = 0
~clayworker = 4
~courageXP = 7
~companions+=Fayni
//~companions+=Jaerd
~companions+=Chi
~companions+=Valfrig
~hasOmbrascope = true
~sigils+=Ruins_Interior
~sigils+=Corral
~clayScrap = 7.5

// Make Fayni later
~Fayni_Story=StoryStart
~journal_allTasks +=Task_FayniRecruiting
{displayAdvancedCheck(_courage, hard, _courageXP, 10, smallAmount)}
->AdvancedSkillCheck(_courage, hard, 0, _courageXP, 10, smallAmount, ->printVarTest, ->story_progress_test)

->camp
}

==printVarTest
{warchief}
{alter(_warchief, -2)}
{warchief}
+ [Try again]->printVarTest
->DONE

==story_progress_test
Current story progress: {MainStoryProgress}
Companion story progresses:
Jaerd: {Jaerd_Story}
Chi: {Chi_Story}
Fayni: {Fayni_Story}
Barr: {Barr_Story}
Valfrig: {Valfrig_Story}

+ [Progress story.]
{ProgressMainStory()}
->story_progress_test
+ [Finish all companions' Recruiting stage]
{Jaerd_Story==Recruiting: 
~Jaerd_Story++
}
{Fayni_Story==Recruiting:
~Fayni_Story++
}
{Barr_Story==Recruiting:
~Barr_Story++
}
{Chi_Story==Recruiting:
~Chi_Story++
}
{Valfrig_Story==Recruiting:
~Valfrig_Story++
}
->story_progress_test

==deathNoReason
->death("none")

==death(reason)
You are dead, and your story ends here.
#endgame
The end.
->END


==start
#spawn.background.corral
You are the scion of the Elbéar tribe and your father, the chieftain, is dying. He has led the tribe through a period of unprecedented prosperity and safety, and with his impending death, the Shamans are auguring the end of an era. The Elders look to you, his only child, for new leadership.

->CharacterCreator()->

{playful: You, too, have felt the wind changing, and despite the circumstances you feel excitement stir in you.}{thoughtful: Becoming chieftain is a heavy burden, especially considering the circumstances. But in your heart of hearts, you have looked forward to it.}{honorable: Your father was blessed to live in uninteresting times; you doubt the same will be true of your reign.}{neutral: It is something you have been groomed for your entire life; you simply did not expect it so soon.}

You are not chieftain yet, however, and you will have a long way to go before you earn the Elbéar’s trust. To earn it, you must leave the Corral and make a name for yourself in the City. ->loop

=loop
* [The Elders wish to speak to you.]
Their tent is stitched of ancient cloth; each patch taken from the clothes of an Elder after they pass away.->elderTalk
* [An old friend has sent a message.] ->friendMessage

*{hasOmbrascope} [Time to leave, then.] ->prepareLeave

=elderTalk
#changebackground
#spawn.background.tent
{playful: After an Elder dies, their family gets to squabble over which piece of cloth is donated to the tent. You wonder how many strips of loincloth it contains.} {thoughtful: Somewhere in the middle remains the cloak of the First Elders; the material so strong it has never been replaced. Or so they say.}{honorable: An old axiom says: all is well as long as the Elders complain of a lack of room in the tent. A people where none have time to grow old is not a people that will survive long.}{neutral: You wonder if it is really true; wouldn’t cloth make terrible tent-material? Still, it is a good story.}

Inside, you are met with a cacophony of voices. {playful: Like brushfowl during mating season; except mating season is long passed for these birds.}{thoughtful: The Elders are long past caring about pomp and ceremony, which is refreshing in its own way.}{honorable: You stop at the entrance, feeling awkward. The Elders ignore you.}{neutral: Few pay attention to your arrival.}

Your baba escapes a clutch of chatting elders and approaches you.
->Say("'Finally, you are here.' She says.", Baba)->
{playful: She pinches your cheek; a pre-emptive punishment, she says, for whatever you’ve done or are about to do.}{thoughtful: She looks serious.}{honorable: She frowns and shakes her head when she sees you.}{neutral: She smiles when she sees you, but you sense something is off.}

She shushes the other Elders; as they quiet down, you realize your baba is probably the most powerful person in the Tribe right now. Every one of the Elders in this tent are the matriarchs and patriarchs of their own little clans; and they all listen to your baba.

->Say("If you are to become chieftain, you will have to work for it.", Baba)->
->Say("You have lived your whole life here in the safety of the Corral: not once have you left beyond its gates. When the time comes – and by the Bozes it will – the people will not follow you.", Baba)->
{playful: You want to protest: it wasn’t for a lack of trying that you stayed in the Corral; but that will only earn your ears a boxing, so you look down instead and shrug.}{thoughtful: You bristle a bit: there are few things you would have wanted more than to go explore, but you were forbidden.}{honorable: Your ears grow red with shame, but the injustice of it also stings: you did what was expected of you, and that was to stay here, in safety.}{neutral: A pit opens in your stomach – it is truly happening. The responsibility suddenly feels overwhelming.}
->Say("'Trust. Trust is the most important thing you have. Your every action must build trust.' She continues, her eyes hard as battle-spoken Clay.", Baba)->
->Say("Especially if the augurs are correct.", Baba)->
 ->elderLoop
=elderLoop
* [Ask what you can do to build trust.]
->Say("'Lead a wercru. Gather the members yourself and go out into the world. Your every action will be watched. When you return here, the tales of your deeds – good and bad – will spread among the people. A wercru is small…but it is a good start.'", Baba)->
->elderLoop
* [Ask about the augurs.]
->Say("She shakes her head. 'The Crescent-Lights can mean anything. There is no need to spread fear. Not yet. Not now.'", Baba)->
 {playful: You shrug. The Crescent-Lights seem to mean different things to every Shaman anyway, and frequently and miraculously changed meaning before and after dinner.}{thoughtful: You frown. The Crescent-Lights could predict many things: disease, storms, death. What were they predicting now?}{honorable: You nod. If you are not meant to know yet, then you are not meant to know. You trust the wise men and women to tell you when the time comes.}{neutral: You feel a stir of worry; it is not like your baba to hide unpleasant news. But these are uncommon times.}
->elderLoop
* [Thank her and leave.]
->Say("'Hold on a second.' Your baba stops you. 'You think you can just walk out of the Corral? Here.'", Baba)->
#spawn.image.ombrascope
 She gives you a small, palm-sized claywork device.
 #anim.ombrascope.show
->Say("'This will open the gate for you and your wercru.'", Baba)-> 
You look at it; an ombrascope – a tool used by the Tribe to communicate with the City through shadows and light.
->Say("'This one is virginal.  You will need to teach it our sigils.'", Baba)->

{playful: You can barely suppress a grin of excitement. Having an ombrascope opens up the whole city to adventure – not just the Corral and its environs. But then your grin freezes; your baba would not give this away unless the situation truly is as serious as she says.}{thoughtful: You hold up the ombrascope to the light, seeing through it the intricate claywork that would duplicate the glyphs that bound the City. They were rare – and immensely powerful. Your baba’s gift was no toy.}{honorable: The ombrascope feels heavy in your hand; solid. You recognize it for what it is: a weapon against a capricious and cruel City. A way to open paths and assert control.}{neutral: You accept the gift, with some measure of surprise. Ombrascopes are rare, rare and powerful. Your baba giving you one is both a sign of trust – and a sign that the time to hide from your responsibilities truly is past.}
#anim.ombrascope.hide
You thank her.
#changebackground
#spawn.background.corral

With the ombrascope in hand, you duck out of the tent, back into the light. You will need to teach it the sigils for the Corral entrance; the gatekeeper would know them.
~hasOmbrascope = true
->loop

=friendMessage
{companions?Fayni:
You meet Fayni behind her family’s shop, where they keep the bric-a-brac that even Fayni’s parents couldn’t trade. Normally the image of calm, she looks uncommonly antsy. {playful: You consider asking her if she’s found another ‘Shadow’ stealing, but decide against it. She might just punch you this time.}{thoughtful: You nod at her, giving her a moment to collect her thoughts.}{honorable: You tense up when you see her expression.}{neutral: You decide not to pay any attention to it, greeting her as casually as you can.}

Fayni smiles when she sees you.
->Say("'I heard you are leaving the Corral. I want to come with you. Please?'", Fayni)->
 You are surprised: the Vender family never seems to run out of things for Fayni to do, whether it’s manning the trading stall, doing endless inventory on their stores, or negotiating deals with anyone walking in through the Corral gates. It seems unlikely they’d be able to spare her. You tell her as much, and she gives you an annoyed glare.
->Say("'I’m done being an errand girl. I will never learn anything about the real City unless I leave. I am joining your wercru, whether you’ll have me or not.'", Fayni)->
 That’s not really how that works, but you’ve known each other since you were children; she will not be denied.

Fayni turns serious.
->Say("'There's something else too. You know how we trade in stuff the scavengers bring in? Scrap, the Clayworkers call it.'", Fayni)->
->Say("'I noticed something about the Scrap. But I need more of it to be...to be sure.'", Fayni)->
->Say("'And the only place to find Scrap is out there. So...if you have the time for it...'", Fayni)->
Curious. If there is anyone who is not a Clayworker yet knows something about Scrap, it would be Fayni and her family. It sounds like a task for a wercru, either way.
->Say("'I'll give you a tablet with what I know when we leave.'", Fayni)->
She smiles.
->Say("'But I'm coming no matter what, just so you know.'", Fayni)->

{playful: You immediately give her the role of quartermaster, in charge of inventorying the stores. ->Say("She rolls her eyes at you. 'I was going to do that anyway, kuratz.'", Fayni)->}{thoughtful: You welcome her with open arms. Fayni always understood you. She will be a valuable ally.}{honorable: You hesitate, but only for a moment. Fayni is not like other hawkers; she has honor.}{neutral: Fayni is one of your oldest friends – travelling with her will be like bringing a bit of the Corral with you.}

She says she’ll get her things and wait for you at the Corral gate. 

As you leave you see her take a deep breath, hardening herself for the conversation she is going to have with her parents.
}
{companions?Valfrig:
Valfrig meets you near the entrance to the Shaman’s enclave. Just a tenday ago he got his marks, and you can tell his face is still sore. But the tattoos are healing nicely. {playful: You know half the unmarried women (and some of the married) in the Corral felt a sting of desperation when Valfrig finally took his Shaman vows. Celibacy, and all that.}{thoughtful: You are happy for him, and a little jealous. As a Shaman, his main task will now be the gathering, dissemination and interpretation of knowledge.}{honorable: Despite knowing him half your life, his transition into the full mysteries of Shamanhood makes you feel slightly uneasy in his presence.}{neutral: You wonder if you should treat him differently now; but it is hard to see past the boy you grew up with, even if he is no longer a boy}

->Say("'You are putting together a wercru, yes?' He says, excitement shining in his eyes. 'I have to come. The Council is handing out assignments, and there is an open position for ‘Cartographer’. Please?'", Valfrig)->

{playful: It is impossible to say no to him when he looks at you with those hopeful eyes.}{thoughtful: You were hoping to get at least one Shaman to join your wercru: Valfrig would make an excellent addition.}{honorable: To go outside the Corral without a Shaman is like walking backwards into a fight. Having a shaman is like walking backwards into a fight, except someone telling you it is a good idea.}{neutral: Having an old friend like Valfrig along, especially with his skills, would be invaluable.}

You accept, and he lights up and gives you a fierce hug before you have time to protest.

->Say ("'Now: I know the Elders probably have a task for you, but hear me out.'", Valfrig)->
He looks excited.
->Say ("'The Loretellers speak of a place in the ruins that contains a map of the City as it existed before the Hunger.'", Valfrig)->
->Say ("'It is the size of a wall, and protected by a fierce guardian.'", Valfrig)->
He grabs you by the shoulders.
->Say ("'I must see if it is true. I must make a copy of it. Please - if you find the time...'", Valfrig)->
You are not really sure what the use of an ancient map of the City might be, but Valfrig sounds so excited that you can do little but nod.
->Say ("'Thank you! I will give you the details when we head out!'", Valfrig)->

Then he rushes off – to tell the Council, to pack his things. You shout after him to meet you at the Corral gates. You hope he heard.
}
{companions?Barr:
You find Barr at the training grounds. She is in the middle of a shouting match with a man two heads taller than her, who visibly shrinks away from her words. Nearby, a young boy is rubbing his head, a healer kneeling next to him. The other braves have all stopped their training, watching the exchange. It seems the warrior had been a bit too rough when training with the boy, and accidentally hit him on the head, knocking him out for a moment. Barr is giving him a piece of her mind.

{playful: You chuckle and lean against a well-worn training pole, enjoying the show.}{thoughtful: While Barr rightfully hides the warrior, you check with the healer. A blow to the head can be very dangerous. Luckily, the boy seems all right, although he will need to be kept under guard.}{honorable: You restrain yourself from joining in: Barr can handle herself; if she needed your help, she would ask.}{neutral: You stay on the sidelines and wait. When Barr gets going, she will not be stopped.}

The warrior finally escapes when the training master comes over, even if he simply keeps berating him. Barr comes over, her stride purposeful as always. ->Say("'I heard you are putting together a wercru – I want in.' She says, matter-of-factly. 'It is a dangerous City. You will need a good blade by your side.'", Barr)->
{playful: As children, you would attempt to scale the walls and escape at least once a week. This time, you could simply walk through the gate.}{thoughtful: You frown. Barr is known for her recklessness. But then, every wecru does need warriors.}{honorable: You feel a surge of pride: that Barr, one of the tribe’s best young braves, would pledge herself to your crew? It was a good feeling.}

You bump elbows on it, and Barr promises to meet you at the gate before you leave. She tries to hide it, but you can tell from the smile tugging at her mouth she is genuinely excited.
}
{companions?Chi:
When you arrive at the latrines, Chi is at first nowhere to be found. The stink is what alerts you to her presence. She was caught a season ago, stealing from a caravan; her punishment was predictable, if awful. {playful: You always felt sorry for her; like a fly accidentally caught in shit. But despite her predicament, she is always full of funny stories.}{thoughtful: Outsiders are technically outlaws; outside of the rules that govern crime and punishment in the tribe. The caravan master could have killed her on the spot – latrine duty was a mercy.}{honorable: You have to admit however she has performed her new duties without too many complaints; as far as you are concerned, she has paid her dues.}

->Say("'I heard you are leaving.' Under the dirt and sweat shines a desperation. 'Please – take me with you. I know what it is like out there, I can help you. If I have to fill in one more hole…'", Chi)->

You know she is technically free; her debt has been paid. But in the Corral she gets meals, companionship, safety – even if the only way she currently has to pay for it is by shovelling shit. Joining a wercru, no matter how dangerous, would be a vast improvement. And she is the only one you know who has actually been outside…

You tell her to clean up, and meet you by the gate. She lights up. ->Say("'I’d hug you, but…you know.'", Chi)->
}
{companions?Jaerd:
You cause a stir as you enter the Clayworker enclave; the workers stop what they are doing, touching their foreheads lightly in respect. Your father was one of them, and is dying like one of them. {playful: In other words, like a fool. Few Clayworkers live to be older than fifty seasons.}{thoughtful: You appreciate the thought, but you cannot help but feel there is something wrong with a profession that kills all of its workers.} {honorable: You feel a swell of emotion constrict your throat, and nod back, like your father taught you.}{neutral: You look down and hurry your steps. You did not come here to think of your father.}

Jaerd is by his worktable. In front of him is a coin of black clay that he is manipulating with a long caliper. When he sees you coming he stops and gets up, removing his eye-glass and gloves to elbow-bump you.

->Say("'I heard you are putting together a wercru. I was hoping to join.' Jaerd smells of vitriol and sprit of niter. His skin glows with particulate matter. 'I need to replenish my stores of Clay.'", Jaerd)->

You wonder if the Order will allow him to leave, but he assures you he has already been given the permission. Clayworkers, like Shamans, function under different hierarchies. You are familiar to some of them, through your father, but you have come to view them as even more arcane than the Council’s.

He agrees to meet you by the Corral gate, together with all of his equipment.->Say("'I will need a cart for my chemicals.' He adds.", Jaerd)->
}
- ->loop

=prepareLeave
{companions?Fayni:
Fayni catches up with you as you head towards the gate. The dark look on her face discourages any further questions, but she does hand you a tablet with some notes. A potential wercru task?
~journal_allTasks += Task_FayniRecruiting
[Fayni is a Pactmaker – as long as she is with you, she will boost your Pactmaker skill.] {alter(_pactmaker, 1)}
}
{companions?Valfrig:
Valfrig is already waiting for you as you leave, wearing a heavy traveller’s robe, satchel full of maps by his side. He excitedly begins telling you about all the places he wants to go to first.
~journal_allTasks += Task_ValfrigRecruiting
[Valfrig is a Shaman – someone who knows the secrets of the City. He will join your other Shamans whenever they are needed.] {alter(_shaman, 1)}
}
{companions?Barr: Barr saunters up to you as you prepare to leave; obsidian blade at her belt, forklance on her back, all lamellar and war paint. [Barr is a warrior and tactician – while she is with you she will boost your Warchief skill.] {alter(_warchief, 1)}}
{companions?Chi: Chi catches up to you, blissfully clean. She looks ready for a long journey, and excited to leave. [Chi is a wanderer. Her advice will help you find unconventional solutions to problems, boosting your Trickster skill.]{alter(_trickster, 1)}}
{companions?Jaerd: When Jaerd sees you he hoists his pack up – laden with all the tools of his trade. He wobbles a little. [Jaerd is a Clayworker – skilled with manipulating and working clay.]{alter(_clayworker, 1)}}

Your first order of business will be gathering the rest of your wercru. You head for the Crupit. ->home.recruiting

=GetCorralSigil
#spawn.image.ombrascope
#anim.ombrascope.show
You head to the gate with your ombrascope. The Watchman greets you somberly, and takes your ombrascope. Teaching claywork is usually the purvey of Clayworkers, but ombrascopes are different; if a crew leader should come across a new sigil in the City, it is vital they can record it even if they do not have a Clayworker with them. The Watchman speaks the words, and the ombrascope clicks to life, a beam of claylight that flickers a pattern of light on every surface it can find.

 {playful: Somehow you feel its curiosity; like a child, prodding and pressing at something new, and then learning to mimic it.}{thoughtful: You marvel at the intricacy involved in the process, the endlessly complex machinations inside the small device that, somehow, ca capture patterns and light for later use.}{honorable: You are intensely aware of the honor being bestowed upon you; ombrascopes are a rare and valuable tool, handed down from the ancients, and every new one created – like this one – is the result of countless weeks of toil by dozens of Clayworkers.}{neutral: You stare in fascination at the flickering lights;  they change and adapt to every crevice and crease in your clothes, trying to find the glyph-patterns it was meant to absorb and learn.} The Watchman brings out a small, simple, smooth rock – a keystone –  upon which has been carved the sigil that opens the Corral. He lets the ombrascope’s light caress it until it seems to somehow ‘find’ it – focusing its beam more and more until the shadow-and-light from the ombrascope correspond entirely to the glyph on the keystone. Then he whispers one more command, and the ombrascope freezes for a moment – and then it shuts off. 
 {AddSigil(Corral)}
#anim.ombrascope.hide
The Watchman puts away the keystone and hands you back your ombrascope.
->Say("'It is your duty to gather any sigils you can find – remember that. Bring them back to us – they may one day save the whole tribe.'", Watchman)->

* [Ask if he can teach your ombrascope additional sigils.]
The Watchman chuckles. 
->Say("'Yes, but my oma told me not to. She said you need to prove yourself. All you get for free is the one that gets you out of the gate.'", Watchman)-> 
He glances at the small crowd of people who seem to be following you wherever you go. ->Say("'Get going.'", Watchman)->

{playful: You have a feeling you might be able to wrangle something from him if you come back later, with less of an audience.} You thank him and leave.
->home.options
* [Thank him and leave]->home.options

==firstRecruitementStart
You have never completed the wercru recruiting ceremony yourself, but you have watched it many times. You look now for the first time from the platform as the Crupit slowly fills with those who are interested; many more than usual, but then you know many of them are only there to watch, with no intention of joining.

The Pitchief stands up and, with a booming voice, declares a new wercru is being formed, and that it is looking for volunteers. ->Say("'The crew lead promises to feed all who join!' The Pitchief declares, to scattered applause. 'But what do they promise to pay?'", Pitchief)->

You step forward, and the Crupit goes quiet. {playful: You strike a pose; this part is a performance, a show; they look at you, ready to be entertained enough to risk their lives for you.}{thoughtful: You look at the faces below – your people – in awe of the fact that so many have shown up, ready to consider risking their lives for you.}{honorable: How many times haven’t you stood down there, wishing you would be allowed to volunteer? You swell with pride, seeing how many of your people have shown up, ready to risk their lives.}
~home_recruitmentsLeft = 4
->home.recruitLoopStart
==firstRecruitementEnd
You tell your story as best you can: who you are, where you came from, who your father and mother are, and what you intend. It is a good story, a rare story. Many listen with rapt attention. But many, you notice, are less than impressed. You are young, you are unproven, your story – although heartfelt – is like the story of a child. An invention, a fantasy. Payment is traditionally in stories, or the promise thereof, and yours is sorely lacking.

Nonetheless, once you finish, a sizeable number of tribesmen remain, making a line towards the Pitchief. She marks down their names and occupation symbolically, erasing each name from the tablet as she finishes. When she is done, she hands you the tablet, and you erase the last name on it and write your own. Then you note the number of your crew, and hand it back to her.

For the first time, you have a wercru. They look at you with eager eyes, ready to leave at once. You return to the main street of the Corral, considering your next move.
    ->comp_home_leaving->
->->

==GetRuins_InteriorSigil
{GetRuins_InteriorSigil<2:
You head back to the Watchman, finding him in much the same place you saw him last. This time, you do not have a crowd following you, and he seems less reserved.

->Say("'Let me guess. The City is not letting you in.' He chuckles.", Watchman)->

->Say("'There is a set of Sigils we usually teach all new ombrascopes. One of them will let you enter the City's white ruins and plunder their riches.'", Watchman)->

{companions?Chi: ->Say("'But you're not going to give it away for free, are you?' Chi mutters, loud enough for you to hear.", Chi)->|You look at him expectantly.}

->Say("'I just need a little something in exchange. My oma will never let me hear the end of it otherwise.'", Watchman)->

You ask him what he wants.

->Say("'You have a wercru, yes? I happen to need some work done. I'll need ten strong backs for the whole day.'", Watchman)->
->loop
- else:
    {GiveTribesmen:
    You return to find your tribesmen all waiting patiently for you, next to a beaming Watchman. {alter(_tribesmen, 10)}
    ->Say("'They did an excellent job, much obliged.' He looks pleased. 'Follow me.'", Watchman)->
    ->Success
    - else:
    You head back to the Watchman. After a brief chat it becomes apparent he still needs those ten men.
    ->loop
    }
}
- (loop)

* [{Req(_tribesmen, 10)} Lend him ten tribesmen for a day {displayTime(50)}]->GiveTribesmen
* {not GiveTribesmen}[Try to appeal to him {displayCheck(_pactmaker, medium)}]
{skillCheck(_pactmaker, medium):
You appeal to his sense of decency, the urgency and importance of your mission, and {playful: throw in the suggestion your baba could make his oma's life very uncomfortable.}{thoughtful: remind him of what he said about the Sigils being a common good.}{honorable: urge him to keep the common good of the tribe in mind.}
{GiveReward(_pactmakerXP, smallReward)}
He sighs. ->Say("'Fine. You've convinced me. She'll just have to make do...'", Watchman)->
->Success
- else:
He listens to you, but none of your arguments seem to make a dent.
->loop
}
+ [Leave]->home.options

=GiveTribesmen
{alter(_tribesmen, -10)}
The tribesmen trudge up to the Watchman, clearly a little disappointed their work does not extend to outside the Corral today. You tell the rest of your wercru to take the day off.
->camp.locationRest("home")

=Success
The Watchman leads you into his stack, cool compared to the outside. Few choose to live inside, but the Watchman is different. He meets every day with the Boze-bots in his tower after all; some say he even speaks their language.

You glance around. Dirty clothes, dishes, wicker chairs and an old carved-wooden table. The den of a bachelor. He is digging through an old-world chest, hard metal.
#spawn.image.ombrascope
#anim.ombrascope.show
After a moment, he finds the keystone he was looking for. He brings it to you and you show it to your ombrascope. The light searches the groves on the keystone, memorizing the sigil. You thank him and leave.
#anim.ombrascope.hide
{AddSigil(Ruins_Interior)}

{GiveTribesmen: You ask your tribesmen afterwards what he wanted done. They tell you they spent the day raising a greenhouse for the Watchman's oma. {GiveReward(_courageXP, smallReward)}}
->home.options

==MainStory00Success
Your baba emerges from the crowd of Elders, a smile on her wrinkled face.
->Say("'You've kept busy. Good.'", Baba)->
She frowns.
->Say("'But don't get complacent. This is only the beginning.'", Baba)->
{GiveReward(_courageXP, largeReward)}
You return to your crew and tell them they can return to their families - for now.
->home.DissolveCrew->
[End of demo]
{finishTask(Task_MainStory00)}
~journal_allTasks+=Task_MainStoryFallback
->home.options
