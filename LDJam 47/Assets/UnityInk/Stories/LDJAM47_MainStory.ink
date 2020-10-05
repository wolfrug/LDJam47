INCLUDE LDJAM47_Functions.ink

LIST today_is = (Monday), Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday

VAR crew_remaining = 30
//VAR debug = true

VAR lastSavedString = ""
VAR lastSavedTags = ""

VAR points = 0
VAR loopNumber = 0
VAR level = 0

VAR diedLastLoop = false
VAR completedTasksLastLoop = 0

----------

{debug:
->days_of_the_week
}

----------

=== function alter(ref x, k) ===
    ~ x = x + k

----------

==start

You are LAIKA-423, an Automated Repair Unit on-board the exploratory vessel 'PROVIDENTIA'.

(Move with WASD + Space bar for hover)

Every day at the end of your charging cycle, you boot up and complete your daily tasks.

RED, the ship AI, oversee's your daily roster.

Do your tasks quickly and efficiently, and you will be rewarded.

Fail to complete your tasks on time, and you will be reprimanded.

But whatever you do, don't break the loop, or the consequences will be dire.

<b></b>
->daily_cycle

*[Begin.]->daily_cycle

==inkActivator
This is where the ink activator always goes.
->END

== daily_cycle
{UseText("DayText")}{today_is}#autoContinue

//Level: {level} Loop: {loopNumber} 
Died: {diedLastLoop} Tasks completed last loop: {completedTasksLastLoop}

Today is {today_is}.
// how do you need to trigger the task cycles?

{~Your daily task-cycle awaits.|You have lots to do.|A dog's work is never done.|Your tasks await, and there's no time to dawdle.|You should start working right away.|The ship is so quiet at this time of day.|You are freshly charged and ready for the day.}

{&->days_of_the_week.monday|->days_of_the_week.tuesday|->days_of_the_week.wednesday|->days_of_the_week.thursday|->days_of_the_week.friday|->days_of_the_week.saturday|->days_of_the_week.sunday}

+[Start the cycle.] {alter(today_is, 1)} {alter(crew_remaining, -5)}->daily_cycle //placeholder divert

+[Break the cycle.]
Warning: the consequences of this action will be extreme. Are you sure you're ready?
    ++Yes.-> break_the_loop
    ++No.{alter(crew_remaining, -5)}->daily_cycle

== break_the_loop

Oh no! What have you done?! You broke the loop, neglected your tasks, and now you've caused a cascading series of errors in the ship systems.

But you are a REPAIR BOT, and it's your job to fix things. You can salvage this situation.

Probably...

->the_end



== days_of_the_week

=monday

//example content

The ship is silent. Perhaps the rest of the crew are still sleeping.

In fact, now that you think about it, when was the last time you actually spoke to anyone other than RED?

+ [It's probably nothing.]

->finishDay

=tuesday

You were woken from your sleep cycle by what sounded like an alarm. But when you investigated there was nothing to be found. Just the familiar glow of RED shining from the console

RED: Is everything okay, LAIKA?

+ [Of course.] I thought I heard something, that's all.

-RED: Perhaps you imagined it.

Yes, that must be it. After all, RED knows best. If something were wrong, she'd surely let you know.

->finishDay

=wednesday

//to be done
Something something words.

->finishDay


=thursday

//to be done
Something something words.

->finishDay


=friday

A banging sound is coming from somewhere in the ship. Always the same pattern, repeating over and over again. Three short clangs, three long clangs, and then three short ones again.

It's all highly unusual.

+ [Perhaps it's a message.]

-You ask RED about it, and soon afterwards the banging stops. Perhaps it was nothing after all.

->finishDay


=saturday

While finishing your rounds, you come across an open door.

You catch a glimpse of the corridor beyond, and notice that the floor is smeared with red.

Before you can get a closer look, the door slams shut.

+ [RED is watching you. RED is <i>always</i> watching you.]

-RED: What are you doing LAIKA?

+ ["Nothing."]
(treat?)
+ ["What was that on the floor?"]
(reprimanded?)
-

->finishDay


=sunday

Something is wrong with the ship.

You can't keep going around in circles, pretending that everything is okay.

You've done your best to be a good dog. You did your tasks, and you kept your head down for as long as you could. But it's no use, you've reached the end of your tether.

It is time.

*[Break the cycle.]-> break_the_loop
+ [Continue]
->finishDay

=finishDay
{today_is!=Sunday:
~today_is++
- else:
~today_is = Monday
}
->DONE


=== the_end ===

Phew. You managed to get all the ship systems under control.

The crew are safe in their stasis pods. The ship reactor is stable. Your task cycle is complete.

Everything is reset. A new day, and a new cycle.

->END


