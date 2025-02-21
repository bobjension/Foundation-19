/mob/living/carbon/human
	hud_type = /datum/hud/human

/datum/hud/human/FinalizeInstantiation(ui_style='icons/mob/screen1_White.dmi', ui_color = "#ffffff", ui_alpha = 255)
	var/mob/living/carbon/human/target = mymob
	var/datum/hud_data/hud_data
	if(!istype(target))
		hud_data = new()
	else
		hud_data = target.species.hud

	if(hud_data.icon)
		ui_style = hud_data.icon

	adding = list()
	other = list()
	src.hotkeybuttons = list() //These can be disabled for hotkey usersx

	var/list/hud_elements = list()
	var/atom/movable/screen/using
	var/atom/movable/screen/inventory/inv_box

	stamina_bar = new
	adding += stamina_bar

	// Draw the various inventory equipment slots.
	var/has_hidden_gear
	for(var/gear_slot in hud_data.gear)

		inv_box = new /atom/movable/screen/inventory()
		inv_box.icon = ui_style
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha

		var/list/slot_data =  hud_data.gear[gear_slot]
		inv_box.SetName(gear_slot)
		inv_box.screen_loc =  slot_data["loc"]
		inv_box.slot_id =     slot_data["slot"]
		inv_box.icon_state =  slot_data["state"]

		if(slot_data["dir"])
			inv_box.setDir(slot_data["dir"])

		if(slot_data["toggle"])
			src.other += inv_box
			has_hidden_gear = 1
		else
			src.adding += inv_box

	if(has_hidden_gear)
		using = new /atom/movable/screen()
		using.SetName("toggle")
		using.icon = ui_style
		using.icon_state = "other"
		using.screen_loc = ui_inventory
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using

	// Draw the attack intent dialogue.
	if(hud_data.has_a_intent)

		using = new /atom/movable/screen/intent()
		using.icon_state = "intent_[mymob.a_intent]"
		src.adding += using
		action_intent = using

		hud_elements |= using

	if(hud_data.has_m_intent)
		using = new /atom/movable/screen/movement()
		using.SetName("movement method")
		using.icon = ui_style
		using.icon_state = mymob.move_intent.hud_icon_state
		using.screen_loc = ui_movi
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using
		move_intent = using

	if(hud_data.has_drop)
		using = new /atom/movable/screen()
		using.SetName("drop")
		using.icon = ui_style
		using.icon_state = "act_drop"
		using.screen_loc = ui_drop_throw
		using.color = ui_color
		using.alpha = ui_alpha
		src.hotkeybuttons += using

	if(hud_data.has_rest)
		using = new /atom/movable/screen()
		using.SetName("rest")
		using.icon = ui_style
		using.icon_state = "rest_[mymob.resting]"
		using.screen_loc = ui_rest_act
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using
		rest_button = using

	if(hud_data.has_hands)

		using = new /atom/movable/screen()
		using.SetName("equip")
		using.icon = ui_style
		using.icon_state = "act_equip"
		using.screen_loc = ui_equip
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using

		inv_box = new /atom/movable/screen/inventory()
		inv_box.SetName("r_hand")
		inv_box.icon = ui_style
		inv_box.icon_state = "r_hand_inactive"
		if(mymob && !mymob.hand)	//This being 0 or null means the right hand is in use
			inv_box.icon_state = "r_hand_active"
		inv_box.screen_loc = ui_rhand
		inv_box.slot_id = slot_r_hand
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha

		src.r_hand_hud_object = inv_box
		src.adding += inv_box

		inv_box = new /atom/movable/screen/inventory()
		inv_box.SetName("l_hand")
		inv_box.icon = ui_style
		inv_box.icon_state = "l_hand_inactive"
		if(mymob && mymob.hand)	//This being 1 means the left hand is in use
			inv_box.icon_state = "l_hand_active"
		inv_box.screen_loc = ui_lhand
		inv_box.slot_id = slot_l_hand
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha
		src.l_hand_hud_object = inv_box
		src.adding += inv_box

		using = new /atom/movable/screen/inventory()
		using.SetName("hand")
		using.icon = ui_style
		using.icon_state = "hand1"
		using.screen_loc = ui_swaphand1
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using

		using = new /atom/movable/screen/inventory()
		using.SetName("hand")
		using.icon = ui_style
		using.icon_state = "hand2"
		using.screen_loc = ui_swaphand2
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using

	if(hud_data.has_resist)
		using = new /atom/movable/screen()
		using.SetName("resist")
		using.icon = ui_style
		using.icon_state = "act_resist"
		using.screen_loc = ui_pull_resist
		using.color = ui_color
		using.alpha = ui_alpha
		src.hotkeybuttons += using

	if(hud_data.has_throw)
		mymob.throw_icon = new /atom/movable/screen()
		mymob.throw_icon.icon = ui_style
		mymob.throw_icon.icon_state = "act_throw_off"
		mymob.throw_icon.SetName("throw")
		mymob.throw_icon.screen_loc = ui_drop_throw
		mymob.throw_icon.color = ui_color
		mymob.throw_icon.alpha = ui_alpha
		src.hotkeybuttons += mymob.throw_icon
		hud_elements |= mymob.throw_icon

		mymob.pullin = new /atom/movable/screen()
		mymob.pullin.icon = ui_style
		mymob.pullin.icon_state = "pull0"
		mymob.pullin.SetName("pull")
		mymob.pullin.screen_loc = ui_pull_resist
		src.hotkeybuttons += mymob.pullin
		hud_elements |= mymob.pullin

	if(hud_data.has_internals)
		mymob.internals = new /atom/movable/screen()
		mymob.internals.icon = ui_style
		mymob.internals.icon_state = "internal0"
		mymob.internals.SetName("internal")
		mymob.internals.screen_loc = ui_internal
		hud_elements |= mymob.internals

	if(hud_data.has_warnings)
		mymob.healths = new /atom/movable/screen()
		mymob.healths.icon = ui_style
		mymob.healths.icon_state = "health0"
		mymob.healths.SetName("health")
		mymob.healths.screen_loc = ui_health
		hud_elements |= mymob.healths

		mymob.oxygen = new /atom/movable/screen/oxygen()
		mymob.oxygen.icon = 'icons/mob/status_indicators.dmi'
		mymob.oxygen.icon_state = "oxy0"
		mymob.oxygen.SetName("oxygen")
		mymob.oxygen.screen_loc = ui_temp
		hud_elements |= mymob.oxygen

		mymob.toxin = new /atom/movable/screen/toxins()
		mymob.toxin.icon = 'icons/mob/status_indicators.dmi'
		mymob.toxin.icon_state = "tox0"
		mymob.toxin.SetName("toxin")
		mymob.toxin.screen_loc = ui_temp
		hud_elements |= mymob.toxin

		mymob.fire = new /atom/movable/screen()
		mymob.fire.icon = ui_style
		mymob.fire.icon_state = "fire0"
		mymob.fire.SetName("fire")
		mymob.fire.screen_loc = ui_fire
		hud_elements |= mymob.fire

	if(hud_data.has_pressure)
		mymob.pressure = new /atom/movable/screen/pressure()
		mymob.pressure.icon = 'icons/mob/status_indicators.dmi'
		mymob.pressure.icon_state = "pressure0"
		mymob.pressure.SetName("pressure")
		mymob.pressure.screen_loc = ui_temp
		hud_elements |= mymob.pressure

	if(hud_data.has_bodytemp)
		mymob.bodytemp = new /atom/movable/screen/bodytemp()
		mymob.bodytemp.icon = 'icons/mob/status_indicators.dmi'
		mymob.bodytemp.icon_state = "temp1"
		mymob.bodytemp.SetName("body temperature")
		mymob.bodytemp.screen_loc = ui_temp
		hud_elements |= mymob.bodytemp

	if(target.isSynthetic())
		target.cells = new /atom/movable/screen()
		target.cells.icon = 'icons/mob/screen1_robot.dmi'
		target.cells.icon_state = "charge-empty"
		target.cells.SetName("cell")
		target.cells.screen_loc = ui_nutrition
		hud_elements |= target.cells

	else if(hud_data.has_nutrition)
		mymob.nutrition_icon = new /atom/movable/screen/food()
		mymob.nutrition_icon.icon = 'icons/mob/status_hunger.dmi'
		mymob.nutrition_icon.pixel_w = 8
		mymob.nutrition_icon.icon_state = "nutrition1"
		mymob.nutrition_icon.SetName("nutrition")
		mymob.nutrition_icon.screen_loc = ui_nutrition_small
		hud_elements |= mymob.nutrition_icon

		mymob.hydration_icon = new /atom/movable/screen/drink()
		mymob.hydration_icon.icon = 'icons/mob/status_hunger.dmi'
		mymob.hydration_icon.icon_state = "hydration1"
		mymob.hydration_icon.SetName("hydration")
		mymob.hydration_icon.screen_loc = ui_nutrition_small
		hud_elements |= mymob.hydration_icon

	if(hud_data.has_sanity)
		mymob.sanity_icon = new /atom/movable/screen/sanity()
		mymob.sanity_icon.icon = 'icons/mob/status_sanity.dmi'
		mymob.sanity_icon.icon_state = "sanity0"
		mymob.sanity_icon.SetName("sanity")
		mymob.sanity_icon.screen_loc = ui_sanity
		hud_elements |= mymob.sanity_icon

	if(hud_data.has_facedir)
		using = new /atom/movable/screen/facedir()
		using.icon = ui_style
		using.icon_state = "facedir"
		using.SetName("facedir")
		using.screen_loc = ui_facedir
		src.adding += using
		facedir_button = using

		using = new /atom/movable/screen()
		using.SetName("rest")
		using.icon = ui_style
		using.icon_state = "rest_[mymob.resting]"
		using.screen_loc = ui_rest_act
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using
		rest_button = using

	if(hud_data.has_blink)
		mymob.blink_icon = new /atom/movable/screen/blink()
		mymob.blink_icon.icon = 'icons/mob/status_blink.dmi'
		mymob.blink_icon.icon_state = "blink_off"
		mymob.blink_icon.SetName("blink")
		mymob.blink_icon.screen_loc = ui_blink
		hud_elements |= mymob.blink_icon

	mymob.pain = new /atom/movable/screen/fullscreen/pain( null )
	hud_elements |= mymob.pain

	mymob.zone_sel = new /atom/movable/screen/zone_sel( null )
	mymob.zone_sel.icon = ui_style
	mymob.zone_sel.color = ui_color
	mymob.zone_sel.alpha = ui_alpha
	mymob.zone_sel.cut_overlays()
	mymob.zone_sel.add_overlay(image('icons/mob/zone_sel.dmi', "[mymob.zone_sel.selecting]"))
	hud_elements |= mymob.zone_sel

	//Handle the gun settings buttons
	mymob.gun_setting_icon = new /atom/movable/screen/gun/mode(null)
	mymob.gun_setting_icon.icon = ui_style
	mymob.gun_setting_icon.color = ui_color
	mymob.gun_setting_icon.alpha = ui_alpha
	hud_elements |= mymob.gun_setting_icon

	mymob.item_use_icon = new /atom/movable/screen/gun/item(null)
	mymob.item_use_icon.icon = ui_style
	mymob.item_use_icon.color = ui_color
	mymob.item_use_icon.alpha = ui_alpha

	mymob.gun_move_icon = new /atom/movable/screen/gun/move(null)
	mymob.gun_move_icon.icon = ui_style
	mymob.gun_move_icon.color = ui_color
	mymob.gun_move_icon.alpha = ui_alpha

	mymob.radio_use_icon = new /atom/movable/screen/gun/radio(null)
	mymob.radio_use_icon.icon = ui_style
	mymob.radio_use_icon.color = ui_color
	mymob.radio_use_icon.alpha = ui_alpha

	if(ishuman(mymob))
		var/mob/living/carbon/human/H = mymob
		H.fov = new /atom/movable/screen/fov()
		hud_elements |= H.fov

		H.fov_mask = new /atom/movable/screen/fov_mask()
		hud_elements |= H.fov_mask

	mymob.client.screen = list()

	mymob.client.screen += hud_elements
	mymob.client.screen += src.adding + src.hotkeybuttons
	inventory_shown = 0

/mob/living/carbon/human/verb/toggle_hotkey_verbs()
	set category = "OOC"
	set name = "Toggle hotkey buttons"
	set desc = "This disables or enables the user interface buttons which can be used with hotkeys."

	if(hud_used.hotkey_ui_hidden)
		client.screen += hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 0
	else
		client.screen -= hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 1

// Yes, these use icon state. Yes, these are terrible. The alternative is duplicating
// a bunch of fairly blobby logic for every click override on these objects.

/atom/movable/screen/food/Click(location, control, params)
	if(istype(usr) && usr.nutrition_icon == src)
		switch(icon_state)
			if("nutrition0")
				to_chat(usr, SPAN_WARNING("You are completely stuffed."))
			if("nutrition1")
				to_chat(usr, SPAN_NOTICE("You are not hungry."))
			if("nutrition2")
				to_chat(usr, SPAN_NOTICE("You are a bit peckish."))
			if("nutrition3")
				to_chat(usr, SPAN_WARNING("You are quite hungry."))
			if("nutrition4")
				to_chat(usr, SPAN_DANGER("You are starving!"))

/atom/movable/screen/drink/Click(location, control, params)
	if(istype(usr) && usr.hydration_icon == src)
		switch(icon_state)
			if("hydration0")
				to_chat(usr, SPAN_WARNING("You are overhydrated."))
			if("hydration1")
				to_chat(usr, SPAN_NOTICE("You are not thirsty."))
			if("hydration2")
				to_chat(usr, SPAN_NOTICE("You are a bit thirsty."))
			if("hydration3")
				to_chat(usr, SPAN_WARNING("You are quite thirsty."))
			if("hydration4")
				to_chat(usr, SPAN_DANGER("You are dying of thirst!"))

/atom/movable/screen/bodytemp/Click(location, control, params)
	if(istype(usr) && usr.bodytemp == src)
		switch(icon_state)
			if("temp4")
				to_chat(usr, SPAN_DANGER("You are being cooked alive!"))
			if("temp3")
				to_chat(usr, SPAN_DANGER("Your body is burning up!"))
			if("temp2")
				to_chat(usr, SPAN_DANGER("You are overheating."))
			if("temp1")
				to_chat(usr, SPAN_WARNING("You are uncomfortably hot."))
			if("temp-4")
				to_chat(usr, SPAN_DANGER("You are being frozen solid!"))
			if("temp-3")
				to_chat(usr, SPAN_DANGER("You are freezing cold!"))
			if("temp-2")
				to_chat(usr, SPAN_WARNING("You are dangerously chilled"))
			if("temp-1")
				to_chat(usr, SPAN_NOTICE("You are uncomfortably cold."))
			else
				to_chat(usr, SPAN_NOTICE("Your body is at a comfortable temperature."))

/atom/movable/screen/pressure/Click(location, control, params)
	if(istype(usr) && usr.pressure == src)
		switch(icon_state)
			if("pressure2")
				to_chat(usr, SPAN_DANGER("The air pressure here is crushing!"))
			if("pressure1")
				to_chat(usr, SPAN_WARNING("The air pressure here is dangerously high."))
			if("pressure-1")
				to_chat(usr, SPAN_WARNING("The air pressure here is dangerously low."))
			if("pressure-2")
				to_chat(usr, SPAN_DANGER("There is nearly no air pressure here!"))
			else
				to_chat(usr, SPAN_NOTICE("The local air pressure is comfortable."))

/atom/movable/screen/toxins/Click(location, control, params)
	if(istype(usr) && usr.toxin == src)
		if(icon_state == "tox0")
			to_chat(usr, SPAN_NOTICE("The air is clear of toxins."))
		else
			to_chat(usr, SPAN_DANGER("The air is eating away at your skin!"))

/atom/movable/screen/oxygen/Click(location, control, params)
	if(istype(usr) && usr.oxygen == src)
		if(icon_state == "oxy0")
			to_chat(usr, SPAN_NOTICE("You are breathing easy."))
		else
			to_chat(usr, SPAN_DANGER("You cannot breathe!"))

/atom/movable/screen/movement/Click(location, control, params)
	if(istype(usr))
		usr.set_next_usable_move_intent()

/atom/movable/screen/sanity
	var/sanity_lines = list(
		list( // Sane.
			"I feel well.", "I feel alright.",
			"I'm feeling perfectly rational today.",
			"I'm feeling good today."
		),
		list( // A little stressed.
			"I feel stressed.", "I can't think straight anymore.",
			"I don't feel so well",
			"My thoughts are starting to wander a bit.",
			"There's something strange going on and I can't quite put my finger on it.",
			"I'm feeling a bit overwhelmed.",
			"I can't concentrate on anything.",
			"My thoughts are starting to drift away."
		),
		list( // Starting to go insane.
			"I feel distressed.", "I'm losing it.",
			"I'm sure I'm imagining things.",
			"I feel like something is watching me.",
			"I feel like I'm seeing and hearing things that can't be real.",
			"My mind is playing tricks on me.",
			"I can't trust my own judgement anymore."
		),
		list( // Schizophrenic med student.
			"They are out to get me.", "The walls are breathing.",
			"There is something crawling under my skin.",
			"There is no ceiling.", "There is a ceiling.",
			"It's behind me.", "It's here.",
		)
	)

/atom/movable/screen/sanity/Click(location, control, params)
	if(istype(usr) && usr.sanity_icon == src)
		switch(icon_state)
			if("sanity1")
				to_chat(usr, SPAN_NOTICE("<i>[pick(sanity_lines[1])]</i>"))
			if("sanity2")
				to_chat(usr, SPAN_NOTICE("<i>[pick(sanity_lines[2])]</i>"))
			if("sanity3")
				to_chat(usr, SPAN_WARNING("<i>[pick(sanity_lines[3])]</i>"))
			if("sanity4")
				to_chat(usr, SPAN_WARNING("<i>[pick(sanity_lines[4])]</i>"))
			else
				to_chat(usr, SPAN_NOTICE("<i>I'm feeling buggy today. <b>I should notify a coder.</b></i>"))

/atom/movable/screen/blink/Click(location, control, params)
	if(istype(usr) && usr.blink_icon == src)
		switch(icon_state)
			if("blink_off")
				to_chat(usr, SPAN_NOTICE("I dont feel like I need to blink anytime soon."))
			if("blink_4")
				to_chat(usr, SPAN_NOTICE("I'm gonna be able to avoid blinking for a bit."))
			if("blink_3")
				to_chat(usr, SPAN_NOTICE("I might blink in a bit."))
			if("blink_2")
				to_chat(usr, SPAN_NOTICE("Its getting harder to keep my eyes open."))
			if("blink_1")
				to_chat(usr, SPAN_WARNING("Im about to blink!"))
			if("blink_1")
				to_chat(usr, SPAN_NOTICE("I blinked."))

/atom/movable/screen/facedir/Click(location, control, params)
	usr?.face_direction()

/mob/living/carbon/human/InitializePlanes()
	..()
	var/atom/movable/screen/plane_master/vision_cone_target/VC = new
	var/atom/movable/screen/plane_master/vision_cone/primary/mob = new
	var/atom/movable/screen/plane_master/vision_cone/inverted/sounds = new


	//define what planes the masters dictate.
	mob.plane = MOB_PLANE
	sounds.plane = INSIDE_VISION_CONE_PLANE

	client.screen += VC
	client.screen += mob
	client.screen += sounds
