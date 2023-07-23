
/obj/item/bodybag
	name = "body bag"
	desc = "A folded bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bodybag_folded"
	var/unfoldedbag_path = /obj/structure/closet/body_bag
	w_class = WEIGHT_CLASS_SMALL

/obj/item/bodybag/attack_self(mob/user)
	deploy_bodybag(user, user.loc)

/obj/item/bodybag/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(proximity)
		if(isopenturf(target))
			deploy_bodybag(user, target)

/obj/item/bodybag/proc/deploy_bodybag(mob/user, atom/location)
	var/obj/structure/closet/body_bag/R = new unfoldedbag_path(location)
	R.open(user)
	R.add_fingerprint(user)
	R.foldedbag_instance = src
	moveToNullspace()

/obj/item/bodybag/suicide_act(mob/user)
	if(isopenturf(user.loc))
		user.visible_message(span_suicide("[user] is crawling into [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
		var/obj/structure/closet/body_bag/R = new unfoldedbag_path(user.loc)
		R.add_fingerprint(user)
		qdel(src)
		user.forceMove(R)
		playsound(src, 'sound/items/zip.ogg', 15, 1, -3)
		return (OXYLOSS)
	..()

// Bluespace bodybag

/obj/item/bodybag/bluespace
	name = "bluespace body bag"
	desc = "A folded bluespace body bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bluebodybag_folded"
	unfoldedbag_path = /obj/structure/closet/body_bag/bluespace
	w_class = WEIGHT_CLASS_SMALL
	item_flags = NO_MAT_REDEMPTION

/obj/item/bodybag/bluespace/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ATOM_CANREACH, PROC_REF(CanReachReact))

/obj/item/bodybag/bluespace/examine(mob/user)
	. = ..()
	if(contents.len)
		var/s = contents.len == 1 ? "" : "s"
		. += span_notice("You can make out the shape[s] of [contents.len] object[s] through the fabric.")

/obj/item/bodybag/bluespace/Destroy()
	for(var/atom/movable/A in contents)
		A.forceMove(get_turf(src))
		if(isliving(A))
			to_chat(A, span_notice("You suddenly feel the space around you torn apart! You're free!"))
	return ..()

/obj/item/bodybag/bluespace/proc/CanReachReact(atom/movable/source, list/next)
	return COMPONENT_BLOCK_REACH

/obj/item/bodybag/bluespace/deploy_bodybag(mob/user, atom/location)
	var/obj/structure/closet/body_bag/R = new unfoldedbag_path(location)
	for(var/atom/movable/A in contents)
		A.forceMove(R)
		if(isliving(A))
			to_chat(A, span_notice("You suddenly feel air around you! You're free!"))
	R.open(user)
	R.add_fingerprint(user)
	R.foldedbag_instance = src
	moveToNullspace()

/obj/item/bodybag/bluespace/container_resist(mob/living/user)
	if(user.incapacitated())
		to_chat(user, span_warning("You can't get out while you're restrained like this!"))
		return
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	to_chat(user, span_notice("You claw at the fabric of [src], trying to tear it open..."))
	to_chat(loc, span_warning("Someone starts trying to break free of [src]!"))
	if(!do_after(user, 5 SECONDS, src, stayStill = FALSE))
		to_chat(loc, span_warning("The pressure subsides. It seems that they've stopped resisting..."))
		return
	loc.visible_message(span_warning("[user] suddenly appears in front of [loc]!"), span_userdanger("[user] breaks free of [src]!"))
	qdel(src)

/obj/item/bodybag/environmental
	name = "environmental protection bag"
	desc = "A folded, reinforced bag designed to protect against exoplanetary environmental storms."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "envirobag_folded"
	unfoldedbag_path = /obj/structure/closet/body_bag/environmental
	w_class = WEIGHT_CLASS_NORMAL //It's reinforced and insulated, like a beefed-up sleeping bag, so it has a higher bulkiness than regular bodybag
	resistance_flags = ACID_PROOF | FIRE_PROOF | FREEZE_PROOF

/obj/item/bodybag/environmental/nanotrasen
	name = "elite environmental protection bag"
	desc = "A folded, heavily reinforced, and insulated bag, capable of fully isolating its contents from external factors."
	icon_state = "ntenvirobag_folded"
	unfoldedbag_path = /obj/structure/closet/body_bag/environmental/nanotrasen
	resistance_flags = ACID_PROOF | FIRE_PROOF | FREEZE_PROOF | LAVA_PROOF

/obj/item/bodybag/environmental/prisoner
	name = "prisoner transport bag"
	desc = "Intended for transport of prisoners through hazardous environments, this folded environmental protection bag comes with straps to keep an occupant secure."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "prisonerenvirobag_folded"
	unfoldedbag_path = /obj/structure/closet/body_bag/environmental/prisoner

/obj/item/bodybag/environmental/prisoner/syndicate
	name = "syndicate prisoner transport bag"
	desc = "An alteration of Nanotrasen's environmental protection bag which has been used in several high-profile kidnappings. Designed to keep a victim unconscious, alive, and secured until they are transported to a required location."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "syndieenvirobag_folded"
	unfoldedbag_path = /obj/structure/closet/body_bag/environmental/prisoner/syndicate
	resistance_flags = ACID_PROOF | FIRE_PROOF | FREEZE_PROOF | LAVA_PROOF
	var/killing = FALSE
	var/obj/structure/closet/body_bag/environmental/prisoner/syndicate/deployed_bag

/obj/item/bodybag/environmental/prisoner/syndicate/deploy_bodybag(mob/user, atom/location)
	deployed_bag = new unfoldedbag_path(location)
	deployed_bag.open(user)
	deployed_bag.add_fingerprint(user)
	deployed_bag.foldedbag_instance = src
	moveToNullspace()

/obj/item/syndicate_prisoner_remote
	name = "syndicate prisoner remote"
	desc = "A wireless remote that will toggle the lethality of a linked syndicate prisoner transport bag."
	icon = 'icons/obj/device.dmi'
	icon_state = "gangtool-red"
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	var/obj/item/bodybag/environmental/prisoner/syndicate/bag

/obj/item/syndicate_prisoner_remote/attack_self(mob/user)
	. = ..()
	if(!bag)
		to_chat(user, span_warning("The link to the bag has been broken!"))
		return
	
	bag.killing = !bag.killing
	if(bag.deployed_bag)
		bag.deployed_bag.update_appearance(UPDATE_ICON)
	to_chat(user, span_notice("\The [bag] is now set to [bag.killing ? "LETHAL" : "NON-LETHAL"]."))
