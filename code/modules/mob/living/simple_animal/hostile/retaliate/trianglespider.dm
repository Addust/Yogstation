/mob/living/simple_animal/hostile/retaliate/triangle
	name = "triangle spider"
	desc = "A creepy geometric spider. When it stares at you, you get the feeling it's trying to triangulate your position."
	icon = 'icons/mob/triangle.dmi'
	icon_state = "triangle"
	icon_living = "triangle"
	icon_dead = "triangle_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BUG
	emote_hear = list("chitters")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 10
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab/spider = 2, /obj/item/reagent_containers/food/snacks/spiderleg = 6)
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "hits"
	maxHealth = 60
	health = 60
	obj_damage = 20
	melee_damage_lower = 16
	melee_damage_upper = 18
	faction = list("spiders")
	pass_flags = PASSTABLE
	move_to_delay = 3
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'
	unique_name = 1
	gold_core_spawnable = HOSTILE_SPAWN
