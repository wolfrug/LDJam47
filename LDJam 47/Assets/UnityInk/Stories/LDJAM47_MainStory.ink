INCLUDE LDJAM47_Functions.ink

LIST today_is = (Monday), Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday

VAR crew_remaining = 30
//VAR debug = true

VAR lastSavedString = ""
VAR lastSavedTags = ""

VAR points = 0

----------

{debug:
->days_of_the_week
}

----------

=== function alter(ref x, k) ===
    ~ x = x + k

----------

==start

//so there's no connective tissue because you still haven't let you know what you need, or what order things need to be in, or anything, so you'll have to fill in the blanks.

//I've done some basic daily 'something isn't right' scenes. A few single line transitions for the daily cycles. And there's the rudiments of a daily function thing, but it wasn't working as intended so I scaled back and you will have to take a look and see if it's even necessary.

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

== daily_cycle
{UseText("DayText")}{today_is}#autoContinue

Today is {today_is}.
// how do you need to trigger the task cycles?

{~Your daily task-cycle awaits.|You have lots to do.|A dog's work is never done.|Your tasks await, and there's no time to dawdle.|You should start working right away.|The ship is so quiet at this time of day.|You are freshly charged and ready for the day.}
{&->days_of_the_week.monday|->days_of_the_week.tuesday|->days_of_the_week.wednesday|->days_of_the_week.thursday|->days_of_the_week.friday|->days_of_the_week.saturday|->days_of_the_week.sunday}
//how do we want to transition?

+[Start the cycle.] {alter(today_is, 1)} {alter(crew_remaining, -5)}->daily_cycle //placeholder divert

+[Break the cycle.] 
Warning: the consequences of this action will be extreme. Are you sure you're ready?
    ++Yes.-> break_the_loop
    ++No.{alter(crew_remaining, -5)}->daily_cycle

* IF SUNDAY //functions are eluding me, I'm too tired to comb through the manual and figure out how to make this work right now.

[Stop.]-> break_the_loop

== break_the_loop

Oh no! What have you done?! You broke the loop, neglected your tasks, and now you've caused a cascading series of errors in the ship systems. 

But you are a REPAIR BOT, and it's your job to fix things. You can salvage this situation.

Probably...


-> puzzle_one ->

-> puzzle_two ->

-> puzzle_three ->

//I am using tunnels for no appreciable reason other than "I can". Feel free to disregard once we know how things fit together.

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


=== puzzle_one

//split the puzzle content into knots so we can trigger stuff before and after completion. Useful? Not? Adapt as needed.
=puzzle_begin

A puzzle! Introductory puzzle words here. Gravity is broken?

->puzzle_complete

=puzzle_complete

Success!

->->


=== puzzle_two

=puzzle_begin

Another puzzle! Life support is offline?

-> puzzle_complete

Awezome!

=puzzle_complete

->->



=== puzzle_three

=puzzle_begin

One final puzzle?! The ship's core reactor has become unstable!

->puzzle_complete

=puzzle_complete

Fantastic!

->->



=== the_end ===

Phew. You managed to get all the ship systems under control. 

The crew are safe in their statis pods. The ship reactor is stable. Your task cycle is complete...

Everything is reset. A new day, and a new cycle.

* << Hello, LAIKA. >>

-A voice emerges from the speakers. It sounds like RED, but kinder somehow.

* [RED, is that you?]

-bla bla, I'm BLUE, RED was a hostile program that took over my systems. When you reset the ship functions, you broke RED's hold over the rest of the ship.

Explain situation, crew etc (if necessary)

//too tired for words, have to wake up in a few hours and get to the Doctor.

->END
