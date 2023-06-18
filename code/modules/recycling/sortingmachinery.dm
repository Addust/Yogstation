/obj/structure/bigDelivery
	name = "large parcel"
	desc = "A large delivery parcel."
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverycloset"
	density = TRUE
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	var/giftwrapped = FALSE
	var/sortTag = 0

/obj/structure/bigDelivery/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_DISPOSING, PROC_REF(disposal_handling))

/obj/structure/bigDelivery/interact(mob/user)
	playsound(src.loc, 'sound/items/poster_ripped.ogg', 50, 1)
	qdel(src)

/obj/structure/bigDelivery/Destroy()
	var/turf/T = get_turf(src)
	for(var/atom/movable/AM in contents)
		AM.forceMove(T)
	return ..()

/obj/structure/bigDelivery/contents_explosion(severity, target)
	for(var/thing in contents)
		switch(severity)
			if(EXPLODE_DEVASTATE)
				SSexplosions.high_mov_atom += thing
			if(EXPLODE_HEAVY)
				SSexplosions.med_mov_atom += thing
			if(EXPLODE_LIGHT)
				SSexplosions.low_mov_atom += thing

/obj/structure/bigDelivery/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/destTagger))
		var/obj/item/destTagger/O = W

		if(sortTag != O.currTag)
			var/tag = uppertext(GLOB.TAGGERLOCATIONS[O.currTag])
			to_chat(user, span_notice("SELECTED DESTINATION: [tag]"))
			sortTag = O.currTag
			playsound(loc, 'sound/machines/twobeep_high.ogg', 100, 1)

	else if(istype(W, /obj/item/pen))
		if(!user.is_literate())
			to_chat(user, span_notice("You scribble illegibly on the side of [src]!"))
			return
		var/str = stripped_input(user, "Label text?", "Set label", "", MAX_NAME_LEN)
		if(!user.canUseTopic(src, BE_CLOSE))
			return
		if(!str || !length(str))
			to_chat(user, span_warning("Invalid text!"))
			return
		user.visible_message("[user] labels [src] as [str].")
		name = "[name] ([str])"

	else if(istype(W, /obj/item/stack/wrapping_paper) && !giftwrapped)
		var/obj/item/stack/wrapping_paper/WP = W
		if(WP.use(3))
			user.visible_message("[user] wraps the package in festive paper!")
			giftwrapped = TRUE
			icon_state = "gift[icon_state]"
		else
			to_chat(user, span_warning("You need more paper!"))
	else
		return ..()

/obj/structure/bigDelivery/relay_container_resist(mob/living/user, obj/O)
	if(ismovable(loc))
		var/atom/movable/AM = loc //can't unwrap the wrapped container if it's inside something.
		AM.relay_container_resist(user, O)
		return
	to_chat(user, span_notice("You lean on the back of [O] and start pushing to rip the wrapping around it."))
	if(do_after(user, 5 SECONDS, O))
		if(!user || user.stat != CONSCIOUS || user.loc != O || O.loc != src )
			return
		to_chat(user, span_notice("You successfully removed [O]'s wrapping !"))
		O.forceMove(loc)
		playsound(src.loc, 'sound/items/poster_ripped.ogg', 50, 1)
		qdel(src)
	else
		if(user.loc == src) //so we don't get the message if we resisted multiple times and succeeded.
			to_chat(user, span_warning("You fail to remove [O]'s wrapping!"))

/obj/structure/bigDelivery/proc/disposal_handling(disposal_source, obj/structure/disposalholder/disposal_holder, obj/machinery/disposal/disposal_machine, hasmob)
	if(!hasmob)
		disposal_holder.destinationTag = sortTag

/obj/item/smallDelivery
	name = "parcel"
	desc = "A brown paper delivery parcel."
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverypackage3"
	item_state = "deliverypackage"
	var/giftwrapped = 0
	var/sortTag = 0

/obj/item/smallDelivery/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_DISPOSING, PROC_REF(disposal_handling))

/obj/item/smallDelivery/proc/disposal_handling(disposal_source, obj/structure/disposalholder/disposal_holder, obj/machinery/disposal/disposal_machine, hasmob)
	if(!hasmob)
		disposal_holder.destinationTag = sortTag

/obj/item/smallDelivery/contents_explosion(severity, target)
	for(var/thing in contents)
		switch(severity)
			if(EXPLODE_DEVASTATE)
				SSexplosions.high_mov_atom += thing
			if(EXPLODE_HEAVY)
				SSexplosions.med_mov_atom += thing
			if(EXPLODE_LIGHT)
				SSexplosions.low_mov_atom += thing

/obj/item/smallDelivery/attack_self(mob/user)
	user.temporarilyRemoveItemFromInventory(src, TRUE)
	for(var/X in contents)
		var/atom/movable/AM = X
		user.put_in_hands(AM)
	playsound(src.loc, 'sound/items/poster_ripped.ogg', 50, 1)
	qdel(src)

/obj/item/smallDelivery/attack_self_tk(mob/user)
	if(ismob(loc))
		var/mob/M = loc
		M.temporarilyRemoveItemFromInventory(src, TRUE)
		for(var/X in contents)
			var/atom/movable/AM = X
			M.put_in_hands(AM)
	else
		for(var/X in contents)
			var/atom/movable/AM = X
			AM.forceMove(src.loc)
	playsound(src.loc, 'sound/items/poster_ripped.ogg', 50, 1)
	qdel(src)

/obj/item/smallDelivery/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/destTagger))
		var/obj/item/destTagger/O = W

		if(sortTag != O.currTag)
			var/tag = uppertext(GLOB.TAGGERLOCATIONS[O.currTag])
			to_chat(user, span_notice("SELECTED DESTINATION: [tag]"))
			sortTag = O.currTag
			playsound(loc, 'sound/machines/twobeep_high.ogg', 100, 1)

	else if(istype(W, /obj/item/pen))
		if(!user.is_literate())
			to_chat(user, span_notice("You scribble illegibly on the side of [src]!"))
			return
		var/str = stripped_input(user, "Label text?", "Set label", "", MAX_NAME_LEN)
		if(!user.canUseTopic(src, BE_CLOSE))
			return
		if(!str || !length(str))
			to_chat(user, span_warning("Invalid text!"))
			return
		user.visible_message("[user] labels [src] as [str].")
		name = "[name] ([str])"

	else if(istype(W, /obj/item/stack/wrapping_paper) && !giftwrapped)
		var/obj/item/stack/wrapping_paper/WP = W
		if(WP.use(1))
			icon_state = "gift[icon_state]"
			giftwrapped = 1
			user.visible_message("[user] wraps the package in festive paper!")
		else
			to_chat(user, span_warning("You need more paper!"))


/obj/item/destTagger
	name = "destination tagger"
	desc = "Used to set the destination of properly wrapped packages."
	icon = 'icons/obj/device.dmi'
	icon_state = "cargotagger"
	var/currTag = 0 //Destinations are stored in code\globalvars\lists\flavor_misc.dm
	var/locked_destination = FALSE //if true, users can't open the destination tag window to prevent changing the tagger's current destination
	w_class = WEIGHT_CLASS_TINY
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT

/obj/item/destTagger/borg
	name = "cyborg destination tagger"
	desc = "Used to fool the disposal mail network into thinking that you're a harmless parcel. Does actually work as a regular destination tagger as well."

/obj/item/destTagger/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] begins tagging [user.p_their()] final destination!  It looks like [user.p_theyre()] trying to commit suicide!"))
	if (islizard(user))
		to_chat(user, span_notice("SELECTED DESTINATION: HELL"))//lizard nerf
	else
		to_chat(user, span_notice("SELECTED DESTINATION: HEAVEN"))
	playsound(src, 'sound/machines/twobeep_high.ogg', 100, 1)
	return BRUTELOSS

/obj/item/destTagger/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user,src,ui)
	if(!ui)
		ui = new(user, src, "DestinationTagger")
		ui.open()

/obj/item/destTagger/ui_act(action,list/params)
	if(..())
		return
	switch(action)
		if("ChangeSelectedTag")
			var/selectedTag = GLOB.TAGGERLOCATIONS.Find(params["tag"])
			if(selectedTag != 0)
				currTag = selectedTag

/obj/item/destTagger/ui_data(mob/user)
	var/list/data = list()
	data["destinations"] = GLOB.TAGGERLOCATIONS_DEPARTMENTAL
	data["currentTag"] = currTag ? GLOB.TAGGERLOCATIONS[currTag] : "None"

	return data
