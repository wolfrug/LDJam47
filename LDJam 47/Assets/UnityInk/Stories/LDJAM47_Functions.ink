VAR debug = true

===function UseButton(buttonName)===
<>{not debug:
\[useButton.{buttonName}]
}
===function UseText(textName)===
<>{not debug:
\[useText.{textName}]
}

===function ReqS(currentAmount, requiredAmount, customString)===
// can be used for things that aren't resources - to be used in options! [{Req(stuffYouNeed, 10, "Stuffs")}!]
{currentAmount>=requiredAmount:<color=green>|<color=red>}
<>{not debug:
\[{currentAmount}/{requiredAmount}\ {customString}]</color>
- else:
({currentAmount}/{requiredAmount} {customString})</color>
}