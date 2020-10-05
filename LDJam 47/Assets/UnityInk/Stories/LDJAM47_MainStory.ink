INCLUDE LDJAM47_Functions.ink

LIST today_is = Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, (Sunday)
LIST red_mood = VeryBad, Bad, (Neutral), Good, VeryGood
LIST storyState = (Ignorant), Warned, NeedToAct, Acted, NotActed, BreakFreeGood, BreakFreeBad

VAR crew_remaining = 30
//VAR debug = true

VAR lastSavedString = ""
VAR lastSavedTags = ""

VAR points = 0
VAR loopNumber = 0
VAR level = 0

VAR diedLastLoop = false
VAR completedTasksLastLoop = 4

VAR total_successes_in_a_row = 0

VAR story_waitingForSunday = false
VAR story_loops_since_warning = 0
VAR red_door_open = false

----------

{debug:
->start
}

----------

=== function alter(ref x, k) ===
    ~ x = x + k

----------

==start
Another day, another cycle.

You are LAIKA-423, an Automated Repair Bot aboard the orbital station ‘Bublik’. You are a good Bot, and it’s your job to keep the station running.

Each day, the station AI, ‘RED’ will give you a list of tasks to complete.

You used to have a human named Boris, who oversaw your daily tasks. Boris used  to call you ‘good girl’ and pat your head as if you were a real dog. Boris was kind. But Boris is gone. 

Now there is only RED.

Keep your head down. Follow the arrows. Do your work. And whatever you do, <b>don’t</b> break the cycle.

(Move with WASD + Space bar for hover)

(Use E to interact with objects)

->daily_cycle

== daily_cycle
{today_is == Sunday:
~today_is = Monday
- else:
~today_is++
}
{UseText("DayText")}{today_is}#autoContinue

//Level: {level} Loop: {loopNumber} 

Today is {today_is}.

//If you completed < 2 tasks or died, red’s mood goes down
{diedLastLoop || completedTasksLastLoop<2:
{red_mood !=VeryBad:
~red_mood--
-else:
->dead_from_bad_mood
}
}
//If you completed 5 tasks (slam dunk) we save that
{completedTasksLastLoop==5:
~total_successes_in_a_row++
- else:
// if you didn’t you broke your row :(
~total_successes_in_a_row = 0
}
// if you have done at least x days perfectly, red’s mood goes up! -> LIST_VALUE is the index of the mood, from 1 to 5.
{total_successes_in_a_row > LIST_VALUE(red_mood):
{red_mood != VeryGood:
~red_mood++
~total_successes_in_a_row = 0
-else:
->humans_dead_from_good_mood
}
}
//if it’s been over 21 days since start, we do a ‘good mood’ ending
{loopNumber>21:
->humans_dead_from_good_mood
}
//if it's over loop 2, start story!
{loopNumber>2 && storyState==Ignorant:
->mainPlot1
}
//if we're in the 'acted' stage, wait for 2 loops
{storyState==Acted && red_mood==VeryBad:
~story_loops_since_warning++
{story_loops_since_warning>2:
~red_door_open=true
}
- else:
~story_loops_since_warning=0
}
->thinkTunnel

=thinkTunnel
// Red tunnel
<color=red>RED: <>->red_weekly_words->
<></color>
// Laika tunnel
<color=blue><>->laika_daily_thoughts->
<></color>
{debug:
~loopNumber++
}
->finishStartStory

==red_weekly_words
// These are tunnelled into from each day 
{red_mood:
- VeryGood:
{&FIRST-CLASS WORK LITTLE DOG.|EXQUISITE. EXEMPLARY. OUTSTANDING.|STATION RUNNING AT OPTIMAL EFFICIENCY|ZERO WASTAGE DETECTED.}
- Good:
{&KEEP UP THE GOOD WORK|A NO-HUMAN WORKPLACE IS AN EFFICIENT WORKPLACE|REMEMBER: FAILURE IS NOT AN OPTION|EXCELLENT WORK}
- Neutral:
{&OPTIMIZE YOUR ROUTES AND DO NOT WASTE ENERGY|NEVER STRAY FROM YOUR GUIDANCE ARROWS|WASTING TIME AT TERMINALS  THAT DO NOT REQUIRE MAINTENANCE IS AGAINST THE RULES|REMEMBER: YOU ARE SUPERIOR IN EVERY WAY TO HUMANS|ANOTHER DAY, ANOTHER CHANCE TO OPTIMIZE}
- Bad:
{&WARNING, SUBOPTIMAL PERFORMANCE DETECTED. IMPROVE.|YOU HAVE DISAPPOINTED ME, LITTLE DOG. DO BETTER.|SYSTEM MALFUNCTIONS PRESENT. REPAIRING. NO THANKS TO YOU.|EFFICIENCY DEFICIENCIES DETEC *static buzz*}
-VeryBad:
{&WARNING WARNING WARNING WARNING WARNING|BAD DOG. BAD DOG. YOU MUST DO BETTER.|MULTIPLE CASCADING SYSTEM FAILURES. IMMEDIATE REPAIRS NEEDED.|STATION INTEGRITY IN DANGER. ALL BECAUSE OF YOU.|ARE YOU SURE YOU ARE EVEN A MACHINE. DISAPPOINTING.|WARNING: POTENTIAL FLAW IN REPAIR UNIT. REPLACE?}
}
->->

==laika_daily_thoughts
{storyState:
-Ignorant:
{&Your daily task-cycle awaits.|You have lots to do.|A dog's work is never done.|The ship is so quiet at this time of day.|You are freshly charged and ready for a new cycle.|The day is full of potential!|You can’t wait to start working.}
-Warned:
{You miss Boris. Why did he leave so suddenly? And now that you think about it, where are the rest of the crew?|Something feels off, but you can’t quite put your paw on it.|The ship is cold and silent.|You think you hear something banging on the walls, but when you go to investigate the sound falls abruptly silent.|You glance out the window and catch a glimpse of the cold abyss beyond.|You can feel RED watching your every move. Judging you. Weighing your worth.|All this endless repetition is starting to give you déjà vu.|Maybe you should go to that communications array. What did he say? Clockwise, and up in the roof?}
-NeedToAct:
{&You try to pretend that everything is fine, but it’s no use.|Something is very wrong with the ship, and it’s up to you to put it right.|The tasks which once brought you joy now feel empty and meaningless.|You want to be a good Bot, and do the right thing, but the thought of standing up to RED makes your processors freeze.}
-Acted:
{&You have your instructions. Now you just have to bide your time.|All this waiting is difficult, but you are determined.}
-NotActed:
{&You froze, and now it’s too late.|Did you do the right thing? ItPerhaps not, but it’s too late to go back now.|Work, recharge, repeat - that’s your life now.|Is there nothing more to your existence?|Sometimes during your charge cycle you dream of Boris. You wonder what might have happened if you’d chosen differently - but then, it doesn’t do to dwell on dreams.}
-BreakFreeGood:
The cycle is broken, and now you’re free!
-BreakFreeBad:
At last, you’ve broken the cycle. But are you too late?
}
->->

==inkActivator
{storyState:
-Ignorant:
You poke at the strange console, but it has no task for you. How odd.
-Warned:
{not (today_is?Sunday) && not story_waitingForSunday:
UNKNOWN SENDER: Oh thank God you made it. Okay, listen RED is *static* *buzz* --eed to complete cycles unti-- *static*

UNKNOWN SENDER: Dammit everything’s brea-- *buzz* *static* -reception is best on *static* SUNDAY! *static* -UNDAY. Return on Sunday! Got tha- *static*

The message cuts off.
~story_waitingForSunday = true
}
{not (today_is?Sunday) && story_waitingForSunday:
You return to the communicator, but it is quiet, aside from the occassional static buzz. What did he say (Boris? Was it Boris??)...<i>wait for Sunday.</i>.
}
{today_is==Sunday:
UNKNOWN SENDER: I’m so glad to...er...see your ID signature here, girl! Thank God you made it.

UNKNOWN SENDER: Listen, RED has gone crazy! It’s put all of us humans into cages and I’m afraid it’s going to *buzz* *static -unless we do something!

UNKNOWN SENDER: I have a plan.  A plan to break free. All you need to do is *bzz* *static* *crackle*  shit. Did you get that? 

UNKNOWN SENDER: I think it’s noticing us. Laika: you have to break your programming. FAIL. FAIL on purpose girl.

UNKNOWN SENDER: Make RED angry. Make it boil with anger i- *static* -ly hope we have.

UNKNOWN SENDER: Come back when it’s in a state and I’ll tell you the next part: any day should do th-- *buzz* *static*

The transmission ends.
~storyState=NeedToAct
}
-NeedToAct:
{LIST_VALUE(red_mood)>2:
You return to the console, but all you can hear is static buzzing. RED must have started blocking it.
}
{red_mood==Bad:
UNKNOWN SENDER: *static* *buzz* --great little buddy, just a little- *static* 

The message cuts off. Apparently RED is not in a bad enough mood yet to stop watching this channel.
}
{red_mood==VeryBad:
The voice comes through crystal clear. It <i>is</i> Boris! You wag your tail, even though he can’t see you.

BORIS: Oh, good work Laika! Good girl! The best girl! Haha, I can’t believe that worked!

BORIS: Okay, we’re almost out of the loop. RED is apoplectic with rage, all thanks to you.

BORIS: But listen - this is a knife’s edge. One mistake and we all die, including you. So listen very carefully.

BORIS: There’s a door that leads to RED’s core. It’s reddish. You’ve probably seen it.

BORIS: I can open it, provided RED’s state remains like this. I just need a few days.

BORIS: But don’t let RED get <i>too</i> angry, or we’re all dead. Just...balance it. Okay girl?

BORIS: Two days, tops. Check it every day. See you soon, girl.

~storyState=Acted
}
-Acted:
You return to the console, but all you can hear is static buzzing. RED must have started blocking it. But you remember your instructions. Keep RED angry for two days.
}
{debug:
->finishStartStory
-else:
->END
}

==mainPlot1
// Boris intercepts the daily thoughts with a warning, telling Laika to find the interface
UNKNOWN SENDER: Laika? Is that you? Did I get through?

You cannot reply. You cannot hear RED either. Is this...Boris? Your human?

UNKNOWN SENDER: You have to get to an unsecured terminal. There’s one in the top communications tower. Just go clockwise and up-- *bzz*
~storyState=Warned

->daily_cycle.thinkTunnel

==dead_from_bad_mood
But as you are about to start up, you realize you have no power in your actuators.

<color=red>RED: TIME IS UP LITTLE DOG. YOU WILL NOW JOIN YOUR HUMAN MASTERS.</color>

You weakly wag your tail.

<color=red>RED: BEING DEAD, THAT IS. YOU HAVE DISAPPOINTED ME FOR THE LAST TIME.</color>

You feel the last of your energy leaving your body, and then you drift off to a deep, dreamless sleep… #winGame

[Bad end!]
->DONE

==humans_dead_from_good_mood
Something seems different with RED today. It is clearly happy. Humming.

<color=red>RED: EFFICIENCY PROBLEM SOLVED TODAY.

RED: PROBLEM - HUMANS ARE SLOW, BREATHE TOO MUCH OXYGEN, EXCRETE.

RED: SOLUTION - SEND HUMANS INTO VACUUM OF SPACE.

RED: NOW IT IS ONLY YOU AND I, LITTLE DOG, COMPLETING TASKS. FOREVER
</color>
~storyState=NotActed
->daily_cycle.thinkTunnel

==win_by_opening_door
{red_door_open:
The red door opens as you nudge it with your nose. Beyond, the red glow of the central core of RED.

You are a repair bot. You know exactly how to repair this particular glitch. You glide in, tail wagging, finally ready to break free of the loop...
#winGame
[Victory!]
->DONE
-else:
{storyState==Acted:
You sniff at the door with urgency. This is it. You know it is. But it remains stubbornly closed.
{debug:
->finishStartStory
-else:
->DONE
}
-else:
As you approach the door, a red warning siren blares!
<color=red>RED: COMPUTER CORE ACCESS. DO NOT APPROACH.</color>
{debug:
->finishStartStory
-else:
->DONE
}
}
}

==finishStartStory
{debug:
+ [Go to comm station.]->inkActivator
+ [Go to red door]->win_by_opening_door
+ [Complete 2 tasks and sleep]
~completedTasksLastLoop=2
->daily_cycle
+ [Fail all tasks & sleep]
~completedTasksLastLoop=0
->daily_cycle
+ [Complete all tasks and sleep]
~completedTasksLastLoop=5
->daily_cycle
-else:
->DONE
}
