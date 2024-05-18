//Outfits meant for admin-run events
//Specifically for those that don't fit elsewhere, mainly here to reduce risk of conflicts

/datum/outfit/syndicate_empty/icemoon_base/captain/event_rockandahardplace
	name = "EVENT - Syndicate Envoy"
	mask = /obj/item/clothing/mask/chameleon //NO GPS to avoid nanotrasen being cheeky bastards
	suit_store = null //empty because mateba spawns in locker
	implants = list(/obj/item/implant/weapons_auth) //remove recall implant to prevent my dumb ass from getting spaced
	uniform = /obj/item/clothing/under/syndicate/camo //drip
	id = /obj/item/card/id/syndicate/nuke_leader
	backpack_contents = list(
		/obj/item/modular_computer/tablet/preset/syndicate=1,
		/obj/item/melee/classic_baton/telescopic=1
		)

/datum/outfit/syndicate_empty/icemoon_base/captain/event_rockandahardplace/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	H.ignores_capitalism = TRUE // begone capitalist pigdog!!!
	H.faction |= ROLE_SYNDICATE
	H.grant_language(/datum/language/codespeak, TRUE, TRUE, LANGUAGE_MIND)

/datum/outfit/syndicate_empty/icemoon_base/captain/event_rockandahardplace/prearmed
	name = "EVENT - Syndicate Envoy - Extra Gun"
	suit_store = /obj/item/gun/ballistic/revolver/mateba //extra gun
	backpack_contents = list(
		/obj/item/modular_computer/tablet/preset/syndicate=1,
		/obj/item/ammo_box/m44=2,
		/obj/item/melee/classic_baton/telescopic=1
		)

/datum/outfit/rockandahardplace_nanotrasenguy
	name = "EVENT - Nanotrasen Envoy" //Nanotrasen Envoy

	implants = list(/obj/item/implant/mindshield)
	box = /obj/item/storage/box/survival

	uniform = /obj/item/clothing/under/rank/centcom/commander
	suit = /obj/item/clothing/suit/armor/vest/capcarapace/centcom
	shoes = /obj/item/clothing/shoes/sneakers/brown
	gloves = /obj/item/clothing/gloves/color/captain/centcom
	ears = /obj/item/radio/headset/headset_cent/commander
	glasses = /obj/item/clothing/glasses/sunglasses
	head = /obj/item/clothing/head/centhat
	neck = /obj/item/clothing/neck/pauldron
	belt = /obj/item/gun/energy/e_gun
	r_pocket = /obj/item/lighter
	l_pocket = /obj/item/melee/classic_baton/telescopic
	back = /obj/item/storage/backpack/satchel/leather
	id = /obj/item/card/id/centcom/silver
	backpack_contents = list(/obj/item/restraints/handcuffs/cable/zipties=1)

/datum/outfit/rockandahardplace_nanotrasenguy/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/centcom/silver/W = H.wear_id
	W.icon = 'icons/obj/card.dmi'
	W.icon_state = "centcom_silver" //Neither does this guy
	W.access = get_all_accesses()
	W.access += get_centcom_access("CentCom Official")
	W.assignment = "Nanotrasen Envoy"
	W.originalassignment = "Nanotrasen Envoy"
	W.registered_name = H.real_name
	W.update_label()

	H.ignores_capitalism = TRUE // Yogs -- Lets Centcom guys buy a damned smoke for christ's sake

/datum/outfit/rockandahardplace_syndicate_infiltrator
	name = "EVENT - Syndicate Infiltrator"
	uniform = /obj/item/clothing/under/syndicate/sniper
	head = /obj/item/clothing/head/HoS/beret/syndicate
	back = /obj/item/storage/backpack/satchel
	suit = /obj/item/clothing/suit/armor/vest
	belt = /obj/item/storage/belt/chameleon
	mask = /obj/item/clothing/mask/gas/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/radio/headset/syndicate/alt
	id = /obj/item/card/id/syndicate/anyone
	l_pocket = /obj/item/flashlight/seclite
	r_pocket = /obj/item/kitchen/knife/combat/survival
	implants = list(/obj/item/implant/weapons_auth)
	box = /obj/item/storage/box/survival/syndie
	backpack_contents = list(
		/obj/item/modular_computer/tablet/preset/syndicate=1,
		/obj/item/gun/ballistic/automatic/pistol/suppressed=1,
		/obj/item/storage/box/syndie_kit/pistolammo=1,
		/obj/item/ammo_box/magazine/m10mm/cs=2,
		/obj/item/ammo_box/magazine/m10mm/sp=1
		)

/datum/outfit/rockandahardplace_syndicate_infiltrator/post_equip(mob/living/carbon/human/H)
	H.faction |= ROLE_SYNDICATE
	H.ignores_capitalism = TRUE // yarggghhhh im going to STEAL im going to INFILTRATE im going to INTRUDE
	H.grant_language(/datum/language/codespeak, TRUE, TRUE, LANGUAGE_MIND)

/datum/outfit/rockandahardplace_nanotrasen_infiltrator
	name = "EVENT - Nanotrasen Infiltrator" //Nanotrasen Envoy

	implants = list(/obj/item/implant/mindshield)
	box = /obj/item/storage/box/survival/security/radio

	uniform = /obj/item/clothing/under/rank/centcom/officer
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/headset_cent/bowman
	glasses = /obj/item/clothing/glasses/sunglasses
	head = /obj/item/clothing/head/beret/sec/centcom
	belt = /obj/item/gun/energy/e_gun
	l_pocket = /obj/item/melee/classic_baton/telescopic
	back = /obj/item/storage/backpack/satchel/leather
	id = /obj/item/card/id/centcom
	backpack_contents = list(/obj/item/restraints/handcuffs/cable/zipties=1)

/datum/outfit/rockandahardplace_nanotrasen_infiltrator/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/centcom/W = H.wear_id
	W.access = get_all_accesses()
	W.access += get_centcom_access("CentCom Official")
	W.assignment = "Nanotrasen Security Detail"
	W.originalassignment = "Nanotrasen Security Detail"
	W.registered_name = H.real_name
	W.update_label()

	H.ignores_capitalism = TRUE // Yogs -- Lets Centcom guys buy a damned smoke for christ's sake
