/obj/vehicle/ridden/wheelchair/motorized
	name = "motorized wheelchair"
	desc = "A chair with big wheels. It seems to have a motor in it."
	icon_state = "mwheelchair"
	max_integrity = 150
	var/speed = 2
	var/power_efficiency = 1
	var/power_usage = 25
	var/panel_open = FALSE
	var/list/required_parts = list(/obj/item/stock_parts/manipulator, 
									/obj/item/stock_parts/manipulator,
									/obj/item/stock_parts/capacitor)
	var/obj/item/stock_parts/cell/power_cell

/obj/vehicle/ridden/wheelchair/motorized/CheckParts(list/parts_list)
	. = ..()
	refresh_parts()

/obj/vehicle/ridden/wheelchair/motorized/proc/refresh_parts()
	speed = 1 // Should never be under 1
	for(var/obj/item/stock_parts/manipulator/M in contents)
		speed += M.rating
	for(var/obj/item/stock_parts/capacitor/C in contents)
		power_efficiency = C.rating
	var/datum/component/riding/D = GetComponent(/datum/component/riding)
	D.vehicle_move_delay = round(CONFIG_GET(number/movedelay/run_delay) * movedelay) / speed

/obj/vehicle/ridden/wheelchair/motorized/proc/drop_contents()
	var/turf/T = get_turf(src)
	for(var/atom/movable/A in contents)
		A.forceMove(T)
		if(isliving(A))
			var/mob/living/L = A
			L.update_mobility()
		if(power_cell)
			power_cell.update_appearance(UPDATE_ICON)
	refresh_parts()

/obj/vehicle/ridden/wheelchair/motorized/obj_destruction(damage_flag)
	drop_contents()
	. = ..()

/obj/vehicle/ridden/wheelchair/motorized/driver_move(mob/living/user, direction)
	if(istype(user))
		if(!canmove)
			return FALSE
		if(!power_cell)
			to_chat(user, span_warning("There seems to be no cell installed in [src]."))
			canmove = FALSE
			addtimer(VARSET_CALLBACK(src, canmove, TRUE), 2 SECONDS)
			return FALSE
		if(power_cell.charge < power_usage / max(power_efficiency, 1))			
			to_chat(user, span_warning("The display on [src] blinks 'Out of Power'."))
			canmove = FALSE
			addtimer(VARSET_CALLBACK(src, canmove, TRUE), 2 SECONDS)
			return FALSE
		if(user.get_num_arms() < arms_required)
			to_chat(user, span_warning("You don't have enough arms to operate the motor controller!"))
			canmove = FALSE
			addtimer(VARSET_CALLBACK(src, canmove, TRUE), 2 SECONDS)
			return FALSE
		power_cell.use(power_usage / max(power_efficiency, 1))
	return ..()

/obj/vehicle/ridden/wheelchair/motorized/set_move_delay(mob/living/user)
	return

/obj/vehicle/ridden/wheelchair/motorized/post_buckle_mob(mob/living/user)
	. = ..()
	density = TRUE

/obj/vehicle/ridden/wheelchair/motorized/post_unbuckle_mob()
	. = ..()
	density = FALSE

/obj/vehicle/ridden/wheelchair/motorized/attack_hand(mob/living/user)
	if(power_cell && panel_open)
		power_cell.update_appearance(UPDATE_ICON)
		user.put_in_hands(power_cell)
		to_chat(user, span_notice("You remove the [power_cell] from [src]."))
		power_cell = null
		return
	return ..()
	
/obj/vehicle/ridden/wheelchair/motorized/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		I.play_tool_sound(src)
		panel_open = !panel_open
		user.visible_message(span_notice("[user] [panel_open ? "opens" : "closes"] the maintenance panel on [src]."), span_notice("You [panel_open ? "open" : "close"] the maintenance panel."))
		return
	if(panel_open)
		if(istype(I, /obj/item/stock_parts/cell))
			if(power_cell)
				to_chat(user, span_warning("There is a power cell already installed."))
			else
				I.forceMove(src)
				power_cell = I
				to_chat(user, span_notice("You install the [I]."))
			refresh_parts()
			return
		if(istype(I, /obj/item/stock_parts))
			var/obj/item/stock_parts/newpart = I
			var/P
			for(var/obj/item/stock_parts/oldpart in contents)
				for(var/D in required_parts)
					if(ispath(oldpart.type, D))
						P = D
						break
				if(istype(newpart, P) && istype(oldpart, P))
					if(newpart.get_part_rating() > oldpart.get_part_rating())
						newpart.forceMove(src)
						user.put_in_hands(oldpart)
						user.visible_message(span_notice("[user] replaces [oldpart] with [newpart] in [src]."), span_notice("You replace [oldpart] with [newpart]."))
						break
			refresh_parts()
			return
	return ..()

/obj/vehicle/ridden/wheelchair/motorized/wrench_act(mob/living/user, obj/item/I)
	to_chat(user, span_notice("You begin to detach the wheels..."))
	if(I.use_tool(src, user, 4 SECONDS, volume = 50))
		to_chat(user, span_notice("You detach the wheels and deconstruct the chair."))
		new /obj/item/stack/rods(drop_location(), 8)
		new /obj/item/stack/sheet/metal(drop_location(), 10)
		drop_contents()
		qdel(src)
	return TRUE

/obj/vehicle/ridden/wheelchair/motorized/examine(mob/user)
	. = ..()
	if((obj_flags & EMAGGED) && panel_open)
		. += "There is a bomb under the maintenance panel."
	. += "There is a small screen on it, [(in_range(user, src) || isobserver(user)) ? "[power_cell ? "it reads:" : "but it is dark."]" : "but you can't see it from here."]"
	if(!power_cell || (!in_range(user, src) && !isobserver(user)))
		return
	. += "Speed: [speed]"
	. += "Energy efficiency: [power_efficiency]"
	. += "Power: [power_cell.charge] out of [power_cell.maxcharge]"

/obj/vehicle/ridden/wheelchair/motorized/Bump(atom/movable/M)
	. = ..()
	// Here is the shitty emag functionality.
	if(obj_flags & EMAGGED && (isclosedturf(M) || isliving(M)))
		explosion(src, -1, 1, 3, 2, 0)
		visible_message(span_boldwarning("[src] explodes!!"))
		return
	// If the speed is higher than what delay_multiplier used to be throw the person on the wheelchair away
	if(isclosedturf(M) && speed > 6.7 && has_buckled_mobs())
		var/mob/living/H = buckled_mobs[1]
		var/atom/throw_target = get_edge_target_turf(H, pick(GLOB.cardinals))
		unbuckle_mob(H)
		H.throw_at(throw_target, 2, 3)
		H.Knockdown(10 SECONDS)
		H.adjustStaminaLoss(40)
		if(isliving(M))
			var/mob/living/D = M
			throw_target = get_edge_target_turf(D, pick(GLOB.cardinals))
			D.throw_at(throw_target, 2, 3)
			D.Knockdown(8 SECONDS)
			D.adjustStaminaLoss(35)
			visible_message(span_danger("[src] crashes into [M], sending [H] and [D] flying!"))
		else
			visible_message(span_danger("[src] crashes into [M], sending [H] flying!"))
		playsound(src, 'sound/effects/bang.ogg', 50, TRUE)
		
/obj/vehicle/ridden/wheelchair/motorized/emag_act(mob/user)
	if((obj_flags & EMAGGED) || !panel_open)
		return
	to_chat(user, span_warning("A bomb appears in [src], what the fuck?"))
	obj_flags |= EMAGGED
