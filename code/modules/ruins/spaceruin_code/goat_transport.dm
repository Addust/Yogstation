///////////	goat transport ship thingies

/obj/item/paper/crumpled/bloody/goattransport
	name = "bloody note"
	desc = "It seems to have been written in great haste."
	info = "This is Captain John Lamario of Goat Tech transport vessel 8. I'm under attack by some sort of robed goats. They're currently trying to force the door. I don't think anyone else is left... <br> <br> They are almost through the door. I dont know how they got on the ship! They just somehow teleported on... I bet the Animal Rights Consortium has something to do with this... <br> <br> oh nononono. please. if you're reading this. tell my wife I lov- <i> The writing cuts off here covered in blood... </i>"
	infolang = /datum/language/common

/obj/machinery/computer/terminal/goat_transport
	name = "goat transport ship helm console"
	desc = "The helm console of a once-prestigious ship. Seems to have locked down."
	upperinfo = "Nanotrasen Secure Flight Console"
	content = list("ALERT! ALERT!","The system has been locked down due to a Code Red alert level being maintained for more than 5 hours.","To unlock, please scan your provided override card.")

/obj/machinery/computer/terminal/goat_transport/manifest
	name = "cargo manifest console"
	desc = "A terminal used to keep track of the manifest of biological cargo transport vessels."
	upperinfo = "TRANSPORT 8 CARGO MANIFEST"
	content = list("oops i forgot to file the manifest. please report this as an issue on github. im dumb.")
