// Debug functions that simulates the entire game
VAR currentDistrict = ->district1

LIST allDistricts = d0, (d1),(d2),(d3),(d4),(d5),(d6),(d7),(d8),(d9)

/* District layout & travel lines
3(D)-4(F)-7()
| | |
2(P)-5(C)-8(W)
| | |
1(H)-6()-9(Dg)
*/

==debugTravelOptions
You are now in {currentDistrict}
You prepare to leave once more. Where do you go?

+ [Make camp] ->camp
+ {currentDistrict == ->district1 && !home_hidden} [Enter the main camp] ->home
+ {currentDistrict == ->district2 && !parkFarm_hidden} [Enter the park] ->parkFarm
+ {currentDistrict == ->district3 && !offices_hidden} [Enter the office park] ->offices
+ {currentDistrict == ->district4 && !factory_hidden} [Enter the factory] ->factory
+ {currentDistrict == ->district5 && !center_hidden} [Enter the HQ] ->center
+ {currentDistrict == ->district6 && !fillerDistrict_hidden} [Enter the district] ->fillerDistrict
+ {currentDistrict == ->district7 && !fillerDistrict_hidden} [Enter the area] ->fillerDistrict
+ {currentDistrict == ->district8 && !wargolem_hidden} [Find the war golem] ->wargolem
+ {currentDistrict == ->district9 && !financial_hidden} [Enter the dig] ->financial
+ [Try to enter a ruin]->cannotEnter.loc_Ruins_Interior
+ [Travel] ->currentDistrict

==district1==
[Home] Your home. A place of safety and community for everyone in the Tribe.
~currentDistrict = ->district1
+ [Stop] ->debugTravelOptions
+ {allDistricts?d2}[Travel north] ->simulateTravel(50, ->district2)
+ {allDistricts?d6}[Travel east] ->simulateTravel(50, ->district6)

==district2
[Park/Engine] A lush park, overgrown with vines. 
~currentDistrict = ->district2
+ [Stop] ->debugTravelOptions
+ {allDistricts?d3}[Travel north] ->simulateTravel(50, ->district3)
+ {allDistricts?d5}[Travel east] ->simulateTravel(50, ->district5)
+ {allDistricts?d1}[Travel south] ->simulateTravel(50, ->district1)

==district3
[Disassembler] The home of the Drones, who live inside the buildings.
~currentDistrict = ->district3
+ [Stop] ->debugTravelOptions
+ {allDistricts?d4}[Travel east] ->simulateTravel(50, ->district4)
+ {allDistricts?d2}[Travel south] ->simulateTravel(50, ->district2)

==district4
[Factory]An industrial district. In the middle squats massive building surrounded on all sides by walls.
~currentDistrict = ->district4
+ [Stop] ->debugTravelOptions
+ {allDistricts?d3}[Travel west] ->simulateTravel(50, ->district3)
+ {allDistricts?d7}[Travel east] ->simulateTravel(50, ->district7)
+ {allDistricts?d5}[Travel south] ->simulateTravel(50, ->district5)

==district5
[Final] The ugly heart of the City. Avoid.
~currentDistrict = ->district5
+ [Stop] ->debugTravelOptions
+ {allDistricts?d4}[Travel north] ->simulateTravel(50, ->district4)
+ {allDistricts?d8}[Travel east] ->simulateTravel(50, ->district8)
+ {allDistricts?d6}[Travel south] ->simulateTravel(50, ->district6)
+ {allDistricts?d2}[Travel west] ->simulateTravel(50, ->district2)

==district6
[Filler] A residential district.
~currentDistrict = ->district6
+ [Stop] ->debugTravelOptions
+ {allDistricts?d9}[Travel east] ->simulateTravel(50, ->district9)
+ {allDistricts?d5}[Travel north] ->simulateTravel(50, ->district5)
+ {allDistricts?d1}[Travel west] ->simulateTravel(50, ->district1)

==district7
[Filler] A district of endless stacks.
~currentDistrict = ->district7
+ [Stop] ->debugTravelOptions
+ {allDistricts?d8}[Travel south] ->simulateTravel(50, ->district8)
+ {allDistricts?d4}[Travel west] ->simulateTravel(50, ->district4)

==district8
[War Golem] A former battlefield - a blasted place that no-one goes to.
~currentDistrict = ->district8
+ [Stop] ->debugTravelOptions
+ {allDistricts?d7}[Travel north] ->simulateTravel(50, ->district7)
+ {allDistricts?d9}[Travel south] ->simulateTravel(50, ->district9)
+ {allDistricts?d5}[Travel west] ->simulateTravel(50, ->district5)

==district9
[The Dig] The financial district, filled with massive, collapsed skyscrapers.
~currentDistrict = ->district9
+ [Stop] ->debugTravelOptions
+ {allDistricts?d8}[Travel north] ->simulateTravel(50, ->district8)
+ {allDistricts?d6}[Travel west] ->simulateTravel(50, ->district6)


==simulateWait(startTime, endTime, randomEncounter, ->goal)==
// Stuff!
//You wait for {endTime}. The time is now {currentTime}.
~currentTime += endTime-startTime
// Randomness is dependant on the time it takes right?
{randomEncounter:
    {RANDOM(0, 100) < (endTime-startTime):
        ->simulateEncounter(goal)
    -else:
        ->goal
    }
-else:
    ->goal
}

==simulateTravel(distance, ->goal)==
// Stuff will happen here!
You travel for a distance of {distance}.
// We use the wait for encounter stuff
->simulateWait(0, distance, true, goal)

==simulateEncounter(->continuepoint)==
// Bunch of math to simulate what kind of encounter we're having
// Is it a dangerous encounter?
~temp dangerous = false
~temp crisis_starvation = false
~temp crisis_exhaustion = false
~dangerous = RANDOM(0, camp_zone_dangerCoeff) > 0
// if not dangerous, are we having a crisis?
{not dangerous:
{starving:
~crisis_starvation = RANDOM(0,1) > 0
}
{exhausted:
~crisis_exhaustion = RANDOM(0,1) > 0
}
}
// JUST DO GENERIC ENCOUNTERS UNLESS STARVATION/EXHAUSTION
// Get some random people, clay and food numbers
//~temp peoplenr = RANDOM(0, camp_zone_peopleCoeff)
//~temp claynr = RANDOM(0, camp_zone_clayCoeff)
//~temp foodnr = RANDOM(0, camp_zone_foodCoeff)
//Peoplenr: {peoplenr} ClayNr: {claynr} Foodnr: {foodnr} Danger: {dangerous}
// temp goto variable
~temp gotovar = ->encounter.eventgeneric
// If it's a 0 all around, do a generic encounter, unless it's crisis time!
//{peoplenr + claynr + foodnr + dangerous == 0:
    {crisis_starvation:
        ->encounter.crisisstarvation->continuepoint
    - else:
    {crisis_exhaustion:
        ->encounter.crisisexhaustion->continuepoint
    }
//    }
->gotovar->continuepoint
}
/*
// How many percentage bigger does it need to be to count as an actual specified thing?
~temp compvar = 1
{dangerous: 
~gotovar = ->encounter.dangergeneric
}
// which is the biggest?
{peoplenr > claynr:
    {peoplenr > foodnr:
        // People is biggest!
        {dangerous:
        ~gotovar = ->encounter.dangerhuman
        -else:
        ~gotovar = ->encounter.eventpeople
        }
    -else:
        // Food is biggest!
        {dangerous:
        ~gotovar = ->encounter.dangerfood
        -else:
        ~gotovar = ->encounter.eventfood
        }
    }
-else:
    {claynr > foodnr:
        // Clay is biggest!
        {dangerous:
        ~gotovar = ->encounter.dangerclay
        -else:
        ~gotovar = ->encounter.eventclay
        }
    -else:
        // Food is biggest!
        {dangerous:
        ~gotovar = ->encounter.dangerfood
        -else:
        ~gotovar = ->encounter.eventfood
        }
    }
}
->gotovar->continuepoint
*/