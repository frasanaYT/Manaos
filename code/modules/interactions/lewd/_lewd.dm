#define CUM_TARGET_MOUTH "mouth"
#define CUM_TARGET_THROAT "throat"
#define CUM_TARGET_VAGINA "vagina"
#define CUM_TARGET_ANUS "anus"
#define CUM_TARGET_HAND "hand"
#define CUM_TARGET_BREASTS "breasts"
#define CUM_TARGET_FEET "feet"
#define CUM_TARGET_EYES "eyes"

#define GRINDING_FACE_WITH_ANUS "faceanus"
#define GRINDING_FACE_WITH_FEET "facefeet"
#define GRINDING_MOUTH_WITH_FEET "mouthfeet"
#define THIGH_SMOTHERING "thigh_smother"
#define NUTS_TO_FACE "nut_face"

#define NORMAL_LUST 10
#define LOW_LUST 1

#define REQUIRE_NONE 0
#define REQUIRE_EXPOSED 1
#define REQUIRE_UNEXPOSED 2
#define REQUIRE_ANY 3


/mob/living/carbon/proc/is_groin_exposed(list/L)
	if(!L)
		L = get_equipped_items()
	for(var/A in L)
		var/obj/item/I = A
		if(I.body_parts_covered & LOWER_TORSO)
			return FALSE
	return TRUE

/mob/living/carbon/proc/is_chest_exposed(list/L)
	if(!L)
		L = get_equipped_items()
	for(var/A in L)
		var/obj/item/I = A
		if(I.body_parts_covered & UPPER_TORSO)
			return FALSE
	return TRUE

/*--------------------------------------------------
  -------------------MOB STUFF----------------------
  --------------------------------------------------
*/
//I'm sorry, lewd should not have mob procs such as life() and such in it. //NO SHIT IT SHOULDNT I REMOVED THEM

/proc/playlewdinteractionsound(turf/turf_source, soundin, vol as num, vary, extrarange as num ,frequency, falloff, channel = 0, pressure_affected = TRUE, sound/S, envwet = -10000, envdry = 0, manual_x, manual_y)
	var/list/hearing_mobs
	for(var/mob/H in hear(4, turf_source))
		LAZYADD(hearing_mobs, H)
	for(var/mob/H in hearing_mobs)
		H.playsound_to(turf_source, soundin, vol, vary, frequency, falloff)

/mob/living
	var/has_penis = FALSE
	var/has_vagina = FALSE
	var/has_breasts = FALSE
	var/last_partner
	var/last_orifice
	var/lastmoan
	var/sexual_potency =  15
	var/lust_tolerance = 100
	var/lastlusttime = 0
	var/lust = 0
	var/multiorgasms = 1
	var/refractory_period = 0
	var/last_interaction_time = 0
	var/datum/interaction/lewd/last_lewd_datum //Recording our last lewd datum allows us to do stuff like custom cum messages.
	//											Yes i feel like an idiot writing this.
	var/cleartimer //Timer for clearing the "last_lewd_datum". This prevents some oddities.

/mob/living/proc/clear_lewd_datum()
	last_lewd_datum = null

/mob/living/Initialize()
	. = ..()
	sexual_potency =  rand(10,25)
	lust_tolerance = rand(75,200)

/mob/living/proc/get_refraction_dif()
	var/dif = (refractory_period - world.time)
	if(dif < 0)
		return 0
	else
		return dif

/mob/living/proc/add_lust(add)
	var/cur = src.get_lust() //GetLust handles per-time lust loss
	if((cur + add) < 0) //in case we retract lust
		lust = 0
	else
		lust = cur + add


/mob/living/proc/get_lust()
	var/curtime = world.time
	var/dif = (curtime - lastlusttime)/10 //how much lust would we lose over time
	if((lust - dif) < 0)
		lust = 0
	else
		lust = lust - dif

	lastlusttime = world.time
	return lust

/mob/living/proc/set_lust(num)
	lust = num
	lastlusttime = world.time

/mob/living/proc/has_penis(var/nintendo = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(istype(C))
		var/obj/item/organ/peepee = C.organs_by_name[BP_GROIN]
		if(peepee && (gender == MALE || gender == PLURAL))
			switch(nintendo)
				if(REQUIRE_ANY)
					return TRUE
				if(REQUIRE_EXPOSED)
					if(C.is_groin_exposed())
						return TRUE
					else
						return FALSE
				if(REQUIRE_UNEXPOSED)
					if(!C.is_groin_exposed())
						return TRUE
					else
						return FALSE
				else
					return TRUE
	return FALSE

/mob/living/proc/has_balls(var/nintendo = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(istype(C))
		var/obj/item/organ/peepee = C.organs_by_name[BP_GROIN]
		if(peepee && (gender == MALE || gender == PLURAL))
			switch(nintendo)
				if(REQUIRE_ANY)
					return TRUE
				if(REQUIRE_EXPOSED)
					if(C.is_groin_exposed())
						return TRUE
					else
						return FALSE
				if(REQUIRE_UNEXPOSED)
					if(!C.is_groin_exposed())
						return TRUE
					else
						return FALSE
				else
					return TRUE
	return FALSE

/mob/living/proc/has_vagina(var/nintendo = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(istype(C))
		var/obj/item/organ/peepee = C.organs_by_name[BP_GROIN]
		if(peepee && (gender == FEMALE || gender == PLURAL))
			switch(nintendo)
				if(REQUIRE_ANY)
					return TRUE
				if(REQUIRE_EXPOSED)
					if(C.is_groin_exposed())
						return TRUE
					else
						return FALSE
				if(REQUIRE_UNEXPOSED)
					if(!C.is_groin_exposed())
						return TRUE
					else
						return FALSE
				else
					return TRUE
	return FALSE

/mob/living/proc/has_breasts(var/nintendo = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(istype(C))
		var/obj/item/organ/peepee = C.organs_by_name[BP_CHEST]
		if(peepee && (gender == FEMALE || gender == PLURAL))
			switch(nintendo)
				if(REQUIRE_ANY)
					return TRUE
				if(REQUIRE_EXPOSED)
					if(C.is_chest_exposed())
						return TRUE
					else
						return FALSE
				if(REQUIRE_UNEXPOSED)
					if(!C.is_chest_exposed())
						return TRUE
					else
						return FALSE
				else
					return TRUE
	return FALSE

/mob/living/proc/has_anus(var/nintendo = REQUIRE_ANY)
	switch(nintendo)
		if(REQUIRE_EXPOSED)
			if(is_bottomless())
				return TRUE
			else
				return FALSE
		if(REQUIRE_ANY)
			return TRUE
		if(REQUIRE_UNEXPOSED)
			if(!is_bottomless())
				return TRUE
			else
				return FALSE
		else
			return TRUE

/mob/living/proc/has_hand(var/nintendo = REQUIRE_ANY)
	if(iscarbon(src))
		var/mob/living/carbon/C = src
		var/handcount = 0
		var/covered = 0
		var/iscovered = FALSE
		if(C.organs_by_name[BP_L_ARM])
			handcount++
		if(C.organs_by_name[BP_R_ARM])
			handcount++
		if(C.get_equipped_item(slot_l_hand))
			var/obj/item/clothing/gloves/G = C.get_equipped_item(slot_l_hand)
			covered = G.body_parts_covered
		else if(C.get_equipped_item(slot_r_hand))
			var/obj/item/clothing/gloves/G = C.get_equipped_item(slot_r_hand)
			covered = G.body_parts_covered
		if(covered & HANDS)
			iscovered = TRUE
		switch(nintendo)
			if(REQUIRE_ANY)
				return handcount
			if(REQUIRE_EXPOSED)
				if(iscovered)
					return FALSE
				else
					return handcount
			if(REQUIRE_UNEXPOSED)
				if(!iscovered)
					return FALSE
				else
					return handcount
			else
				return handcount
	return FALSE

/mob/living/proc/has_feet(nintendo = REQUIRE_ANY)
	if(iscarbon(src))
		var/mob/living/carbon/C = src
		var/feetcount = 0
		var/covered = 0
		var/iscovered = FALSE
		if(C.organs_by_name[BP_L_LEG])
			feetcount++
		if(C.organs_by_name[BP_R_LEG])
			feetcount++
		if(C.get_equipped_item(slot_shoes))
			var/obj/item/clothing/shoes/S = C.get_equipped_item(slot_shoes)
			covered = S.body_parts_covered
		if(covered & FEET)
			iscovered = TRUE
		switch(nintendo)
			if(REQUIRE_ANY)
				return feetcount
			if(REQUIRE_EXPOSED)
				if(iscovered)
					return FALSE
				else
					return feetcount
			if(REQUIRE_UNEXPOSED)
				if(!iscovered)
					return FALSE
				else
					return feetcount
			else
				return feetcount
	return FALSE

/mob/living/proc/get_num_feet()
	return has_feet(REQUIRE_ANY)

/mob/living/proc/has_eyes_lewd(var/nintendo = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(istype(C))
		var/obj/item/organ/peepee = C.internal_organs_by_name[BP_EYES]
		if(peepee)
			switch(nintendo)
				if(REQUIRE_ANY)
					return TRUE
				if(REQUIRE_EXPOSED)
					if(C.get_equipped_item(slot_glasses))
						return FALSE
					else
						return TRUE
				if(REQUIRE_UNEXPOSED)
					if(!C.get_equipped_item(slot_glasses))
						return FALSE
					else
						return TRUE
				else
					return TRUE
	return FALSE

/mob/living/proc/has_eyesockets(var/nintendo = REQUIRE_ANY)
	var/mob/living/carbon/C = src
	if(istype(C))
		var/obj/item/organ/peepee = C.internal_organs_by_name[BP_EYES]
		if(!peepee)
			switch(nintendo)
				if(REQUIRE_ANY)
					return TRUE
				if(REQUIRE_EXPOSED)
					if(get_equipped_item(slot_glasses))
						return FALSE
					else
						return TRUE
				if(REQUIRE_UNEXPOSED)
					if(!get_equipped_item(slot_glasses))
						return FALSE
					else
						return TRUE
				else
					return TRUE
	return FALSE


/mob/living/proc/is_topless()
	if(istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		if((!(H.wear_suit) || !(H.wear_suit.body_parts_covered & UPPER_TORSO)) && (!(H.w_uniform) || !(H.w_uniform.body_parts_covered & UPPER_TORSO)))
			return TRUE
	else
		return TRUE

/mob/living/proc/is_bottomless()
	if(istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		if((!(H.wear_suit) || !(H.wear_suit.body_parts_covered & LOWER_TORSO)) && (!(H.w_uniform) || !(H.w_uniform.body_parts_covered & LOWER_TORSO)))
			return TRUE
	else
		return TRUE

/proc/cum_splatter(target, var/mob/living/user) // Like blood_splatter(), but much more questionable on a resume.
	if(user.has_penis() && !user.has_vagina())
		new /obj/effect/decal/cleanable/semen(get_turf(target))
	else if(user.has_vagina() && !user.has_penis())
		new /obj/effect/decal/cleanable/femcum(get_turf(target))
	else if(user.has_vagina() && user.has_penis())
		new /obj/effect/decal/cleanable/femcum(get_turf(target))
		new /obj/effect/decal/cleanable/semen(get_turf(target))
	//var/obj/effect/decal/cleanable/cum/C = (get_turf(target))
	//C.add_blood_DNA(list(data["blood_DNA"] = data["blood_type"]))

/mob/living/proc/moan()
	if(!(prob(get_lust() / lust_tolerance * 65)))
		return
	var/moan = rand(1, 7)
	if(moan == lastmoan)
		moan--
	if(!is_muzzled())
		visible_message(message = "<font color=purple><B>\The [src]</B> [pick("moans", "moans in pleasure")].</font>", ignored_mobs = get_unconsenting())
		//playsound(get_turf(src), "code/game/lewd/sound/interactions/moan_[gender == FEMALE ? "f" : "m"][rand(1, 7)].ogg", 70, 1, 0)
	if(is_muzzled())//immursion
		visible_message("<font color=purple><B>[src]</B> [pick("mimes a pleasured moan","moans in silence")].</font>")
	lastmoan = moan

/mob/living/proc/cum(mob/living/partner, target_orifice)
	var/message
	if(src != partner)
		if(has_penis())
			if(!istype(partner))
				target_orifice = null

			switch(target_orifice)
				if(CUM_TARGET_MOUTH)
					if(partner.has_mouth() && partner.mouth_is_free())
						message = "cums right in \the <b>[partner]</b>'s mouth."
						partner.reagents.add_reagent(/datum/reagent/drink/semen, rand(8,13))
					else
						message = "cums on \the <b>[partner]</b>'s face."
				if(CUM_TARGET_THROAT)
					if(partner.has_mouth() && partner.mouth_is_free())
						message = "shoves deep into \the <b>[partner]</b>'s throat and cums."
						partner.reagents.add_reagent(/datum/reagent/drink/semen, rand(9,15))
					else
						message = "cums on \the <b>[partner]</b>'s face."
				if(CUM_TARGET_VAGINA)
					if(partner.is_bottomless() && partner.has_vagina())
						message = "cums in \the <b>[partner]</b>'s pussy."
						partner.reagents.add_reagent(/datum/reagent/drink/semen, rand(8,12))
					else
						message = "cums on \the <b>[partner]</b>'s belly."
				if(CUM_TARGET_ANUS)
					if(partner.is_bottomless() && partner.has_anus())
						message = "cums in \the <b>[partner]</b>'s asshole."
						partner.reagents.add_reagent(/datum/reagent/drink/semen, rand(8,12))
					else
						message = "cums on \the <b>[partner]</b>'s backside."
				if(CUM_TARGET_HAND)
					if(partner.has_hand())
						message = "cums in \the <b>[partner]</b>'s hand."
					else
						message = "cums on \the <b>[partner]</b>."
				if(CUM_TARGET_BREASTS)
					if(partner.is_topless() && partner.has_breasts())
						message = "cums onto \the <b>[partner]</b>'s breasts."
					else
						message = "cums on \the <b>[partner]</b>'s BP_CHEST and neck."
				if(NUTS_TO_FACE)

					if(partner.has_mouth() && partner.mouth_is_free())

						message = "vigorously ruts their nutsack into \the <b>[partner]</b>'s mouth before shooting their thick, sticky jizz all over their eyes and hair."

				if(THIGH_SMOTHERING)
					if(src.has_penis()) //it already checks for the cock before, why the hell would you do this redundant shit

						message = "keeps \the <b>[partner]</b> locked in their thighs as their cock throbs, dumping its heavy load all over their face."

					else

						message = "reaches their peak, locking their legs around \the <b>[partner]</b>'s head extra hard as they cum straight onto the head stuck between their thighs"
				if(CUM_TARGET_FEET)
					if(!last_lewd_datum.require_target_num_feet)
						if(partner.has_feet())
							message = "cums on \the <b>[partner]</b>'s [partner.has_feet() == 1 ? pick("foot", "sole") : pick("feet", "soles")]."
						else
							message = "cums on the floor!"
					else
						if(partner.has_feet())
							message = "cums on \the <b>[partner]</b>'s [last_lewd_datum.require_target_feet == 1 ? pick("foot", "sole") : pick("feet", "soles")]."
						else
							message = "cums on the floor!"
				//weird shit goes here
				if(CUM_TARGET_EYES)
					if(partner.has_eyes_lewd())
						message = "cums on \the <b>[partner]</b>'s eyeball."
						partner.reagents.add_reagent(/datum/reagent/drink/semen, rand(8,12))
					else
						message = "cums inside \the <b>[partner]</b>'s eyesocket."
						partner.reagents.add_reagent(/datum/reagent/drink/semen, rand(8,12))
				//

				else
					message = "cums on the floor!"
		else if(has_vagina())
			if(!istype(partner))
				target_orifice = null

			switch(target_orifice)
				if(CUM_TARGET_MOUTH)
					if(partner.has_mouth() && partner.mouth_is_free())
						message = "squirts right in \the <b>[partner]</b>'s mouth."
						partner.reagents.add_reagent(/datum/reagent/drink/femcum, rand(8,13))
					else
						message = "squirts on \the <b>[partner]</b>'s face."
				if(CUM_TARGET_THROAT)
					if(partner.has_mouth() && partner.mouth_is_free())
						message = "rubs their vagina against \the <b>[partner]</b>'s mouth and cums."
						partner.reagents.add_reagent(/datum/reagent/drink/femcum, rand(9,15))
					else
						message = "squirts on \the <b>[partner]</b>'s face."
				if(CUM_TARGET_VAGINA)
					if(partner.is_bottomless() && partner.has_vagina())
						message = "squirts on \the <b>[partner]</b>'s pussy."
					else
						message = "squirts on \the <b>[partner]</b>'s belly."
				if(CUM_TARGET_ANUS)
					if(partner.is_bottomless() && partner.has_anus())
						message = "squirts on \the <b>[partner]</b>'s asshole."
						partner.reagents.add_reagent(/datum/reagent/drink/femcum, rand(8,12))
					else
						message = "squirts on \the <b>[partner]</b>'s backside."
				if(CUM_TARGET_HAND)
					if(partner.has_hand())
						message = "squirts on \the <b>[partner]</b>'s hand."
					else
						message = "squirts on \the <b>[partner]</b>."
				if(CUM_TARGET_BREASTS)
					if(partner.is_topless() && partner.has_breasts())
						message = "squirts onto \the <b>[partner]</b>'s breasts."
					else
						message = "squirts on \the <b>[partner]</b>'s BP_CHEST and neck."
				if(NUTS_TO_FACE)

					if(partner.has_mouth() && partner.mouth_is_free())

						message = "vigorously ruts their clit into \the <b>[partner]</b>'s mouth before shooting their femcum all over their eyes and hair."

				if(THIGH_SMOTHERING)
					message = "keeps \the <b>[partner]</b> locked in their thighs as they orgasm, squirting over their face."

				if(CUM_TARGET_FEET)
					if(!last_lewd_datum.require_target_num_feet)
						if(partner.has_feet())
							message = "squirts on \the <b>[partner]</b>'s [partner.has_feet() == 1 ? pick("foot", "sole") : pick("feet", "soles")]."
						else
							message = "squirts on the floor!"
					else
						if(partner.has_feet())
							message = "squirts on \the <b>[partner]</b>'s [last_lewd_datum.require_target_feet == 1 ? pick("foot", "sole") : pick("feet", "soles")]."
						else
							message = "squirts on the floor!"
				//weird shit goes here
				if(CUM_TARGET_EYES)
					if(partner.has_eyes_lewd())
						message = "squirts on \the <b>[partner]</b>'s eyeball."
						partner.reagents.add_reagent(/datum/reagent/drink/semen, rand(8,12))
					else
						message = "squirts on \the <b>[partner]</b>'s eyesocket."
						partner.reagents.add_reagent(/datum/reagent/drink/semen, rand(8,12))
				//

				else
					message = "squirts on the floor!"

		else
			message = pick("orgasms violently!", "twists in orgasm.")
	else //todo: better self cum messages
		message = "cums all over themselves!"
	if(gender == MALE)
		playlewdinteractionsound(loc, pick('sound/interactions/final_m1.ogg',
							'sound/interactions/final_m2.ogg',
							'sound/interactions/final_m3.ogg',
							'sound/interactions/final_m4.ogg',
							'sound/interactions/final_m5.ogg'), 90, 1, 0)//, pitch = get_age_pitch())
	else if(gender == FEMALE)
		playlewdinteractionsound(loc, pick('sound/interactions/final_f1.ogg',
							'sound/interactions/final_f2.ogg',
							'sound/interactions/final_f3.ogg'), 70, 1, 0)//, pitch = get_age_pitch())
	else
		playlewdinteractionsound(loc, pick('sound/interactions/final_f1.ogg',
							'sound/interactions/final_f2.ogg',
							'sound/interactions/final_f3.ogg'), 70, 1, 0)//, pitch = get_age_pitch())
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	multiorgasms += 1

	/*if(multiorgasms == 1)
		add_logs(partner, src, "came on")*/

	if(multiorgasms > (sexual_potency * 0.34)) //AAAAA, WE DONT WANT NEGATIVES HERE, RE
		refractory_period = world.time + rand(300, 900) - sexual_potency//sex cooldown
		src.druggy += rand(20, 30)
	else
		refractory_period = world.time + rand(300, 900) - sexual_potency
		src.druggy += rand(5, 10)
	set_lust(0)

/mob/living/cum(mob/living/partner, target_orifice)
	if(multiorgasms < sexual_potency)
		cum_splatter((partner ? partner : src), src)
	. = ..()

/mob/living/proc/is_fucking(mob/living/partner, orifice)
	if(partner == last_partner && orifice == last_orifice)
		return TRUE
	return FALSE

/mob/living/proc/set_is_fucking(mob/living/partner, orifice)
	last_partner = partner
	last_orifice = orifice

/mob/living/proc/do_fucking_animation(fuckdir) // Today I wrote 'var/fuckdir' with a straight face. Not a milestone I ever expected to pass. dont worry, we dont use heretic proc/name(var/dir)
	if(!fuckdir)
		return

	dir = fuckdir
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/final_pixel_y = initial(pixel_y)

	if(fuckdir & NORTH)
		pixel_y_diff = 8
	else if(fuckdir & SOUTH)
		pixel_y_diff = -8

	if(fuckdir & EAST)
		pixel_x_diff = 8
	else if(fuckdir & WEST)
		pixel_x_diff = -8

	if(pixel_x_diff == 0 && pixel_y_diff == 0)
		pixel_x_diff = rand(-3,3)
		pixel_y_diff = rand(-3,3)
		animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
		animate(pixel_x = initial(pixel_x), pixel_y = initial(pixel_y), time = 2)
		return

	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
	animate(pixel_x = initial(pixel_x), pixel_y = final_pixel_y, time = 2)

/*--------------------------------------------------
  ---------------LEWD PROCESS DATUM-----------------
  --------------------------------------------------
 */

/mob/living/proc/do_oral(mob/living/partner, var/fucktarget = "penis")
	var/message
	var/lust_increase = NORMAL_LUST

	if(partner.is_fucking(src, CUM_TARGET_MOUTH))
		if(prob(partner.sexual_potency))
			if(istype(src, /mob/living)) // Argh.
				var/mob/living/H = src
				H.adjustOxyLoss(3)
			message = "goes in deep on \the <b>[partner]</b>."
			lust_increase += 5
		else
			var/improv = FALSE
			switch(fucktarget)
				if("vagina")
					if(partner.has_vagina())
						message = pick(
							"licks \the <b>[partner]</b>'s pussy.",
							"runs their tongue up the shape of \the <b>[partner]</b>'s pussy.",
							"traces \the <b>[partner]</b>'s slit with their tongue.",
							"darts the tip of their tongue around \the <b>[partner]</b>'s clit.",
							"laps slowly at \the <b>[partner]</b>.",
							"kisses \the <b>[partner]</b>'s delicate folds.",
							"tastes \the <b>[partner]</b>.",
						)
					else
						improv = TRUE
				if("penis")
					if(partner.has_penis())
						message = pick(
							"sucks \the <b>[partner]</b>'s off.",
							"runs their tongue up the shape of \the <b>[partner]</b>'s cock.",
							"traces \the <b>[partner]</b>'s cock with their tongue.",
							"darts the tip of their tongue around tip of \the <b>[partner]</b>'s cock.",
							"laps slowly at \the <b>[partner]</b>'s shaft.",
							"kisses the base of \the <b>[partner]</b>'s shaft.",
							"takes \the <b>[partner]</b> deeper into their mouth.",
						)
					else
						improv = TRUE
			if(improv)
				// get confused about how to do the sex
				message = pick(
					"licks \the <b>[partner]</b>.",
					"looks a little unsure of where to lick \the <b>[partner]</b>.",
					"runs their tongue between \the <b>[partner]</b>'s legs.",
					"kisses \the <b>[partner]</b>'s thigh.",
					"tries their best with \the <b>[partner]</b>.",
				)
	else
		var/improv = FALSE
		switch(fucktarget)
			if("vagina")
				if(partner.has_vagina())
					message = pick(
						"buries their face in \the <b>[partner]</b>'s pussy.",
						"nuzzles \the <b>[partner]</b>'s wet sex.",
						"finds their face caught between \the <b>[partner]</b>'s thighs.",
						"kneels down between \the <b>[partner]</b>'s legs.",
						"grips \the <b>[partner]</b>'s legs, pushing them apart.",
						"sinks their face in between \the <b>[partner]</b>'s thighs.",
					)
				else
					improv = TRUE
			if("penis")
				if(partner.has_penis())
					message = pick(
						"takes \the <b>[partner]</b>'s cock into their mouth.",
						"wraps their lips around \the <b>[partner]</b>'s cock.",
						"finds their face between \the <b>[partner]</b>'s thighs.",
						"kneels down between \the <b>[partner]</b>'s legs.",
						"grips \the <b>[partner]</b>'s legs, kissing at the tip of their cock.",
						"goes down on \the <b>[partner]</b>.",
					)
				else
					improv = TRUE
		if(improv)
			message = pick(
				"begins to lick \the <b>[partner]</b>.",
				"starts kissing \the <b>[partner]</b>'s thigh.",
				"sinks down between \the <b>[partner]</b>'s thighs.",
				"briefly flashes a puzzled look from between \the <b>[partner]</b>'s legs.",
				"looks unsure of how to handle \the <b>[partner]</b>'s lack of genitalia.",
				"seems like they were expecting \the <b>[partner]</b> to have a cock or a pussy or ... something.",
			)
		partner.set_is_fucking(src, CUM_TARGET_MOUTH)

	playlewdinteractionsound(get_turf(src), pick(	'sound/interactions/bj1.ogg',
									'sound/interactions/bj2.ogg',
									'sound/interactions/bj3.ogg',
									'sound/interactions/bj4.ogg',
									'sound/interactions/bj5.ogg',
									'sound/interactions/bj6.ogg',
									'sound/interactions/bj7.ogg',
									'sound/interactions/bj8.ogg',
									'sound/interactions/bj9.ogg',
									'sound/interactions/bj10.ogg',
									'sound/interactions/bj11.ogg'), 50, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	partner.handle_post_sex(lust_increase, CUM_TARGET_MOUTH, src)
	partner.dir = get_dir(partner,src)
	do_fucking_animation(get_dir(src, partner))
	lust_increase = NORMAL_LUST //RESET IT REE

/mob/living/proc/do_facefuck(mob/living/partner, var/fucktarget = "penis")
	var/message
	var/retaliation_message = FALSE

	if(is_fucking(partner, CUM_TARGET_MOUTH))
		var/improv = FALSE
		switch(fucktarget)
			if("vagina")
				if(has_vagina())
					message = pick(
						"grinds their pussy into \the <b>[partner]</b>'s face.",
						"grips the back of \the <b>[partner]</b>'s head, forcing them onto their pussy.",
						"rolls their pussy against \the <b>[partner]</b>'s tongue.",
						"slides \the <b>[partner]</b>'s mouth between their legs.",
						"looks \the <b>[partner]</b>'s in the eyes as their pussy presses into a waiting tongue.",
						"sways their hips, pushing their sex into \the <b>[partner]</b>'s face.",
						)
					if(partner.a_intent == I_HURT)
						// src.adjustBruteLoss(5)
						retaliation_message = pick(
							"looks deeply displeased to be there.",
							"struggles to escape from between \the [src]'s thighs.",
						)
				else
					improv = TRUE
			if("penis")
				if(has_penis())
					message = pick(
						"roughly fucks \the <b>[partner]</b>'s mouth.",
						"forces their cock down \the <b>[partner]</b>'s throat.",
						"pushes in against \the <b>[partner]</b>'s tongue until a tight gagging sound comes.",
						"grips \the <b>[partner]</b>'s hair and draws them to the base of the cock.",
						"looks \the <b>[partner]</b>'s in the eyes as their cock presses into a waiting tongue.",
						"rolls their hips hard, sinking into \the <b>[partner]</b>'s mouth.",
						)
					if(partner.a_intent == I_HURT)
						// src.adjustBruteLoss(5)
						retaliation_message = pick(
							"stares up from between \the [src]'s knees, trying to squirm away.",
							"struggles to escape from between \the [src]'s legs.",
						)
				else
					improv = TRUE
		if(improv)
			message = pick(
				"grinds against \the <b>[partner]</b>'s face.",
				"feels \the <b>[partner]</b>'s face between bare legs.",
				"pushes in against \the <b>[partner]</b>'s tongue.",
				"grips \the <b>[partner]</b>'s hair, drawing them into the strangely sexless spot between their legs.",
				"looks \the <b>[partner]</b>'s in the eyes as they're caught beneath two thighs.",
				"rolls their hips hard against \the <b>[partner]</b>'s face.",
				)
			if(partner.a_intent == I_HURT)
				// src.adjustBruteLoss(5)
				retaliation_message = pick(
					"stares up from between \the [src]'s knees, trying to squirm away.",
					"struggles to escape from between \the [src]'s legs.",
				)
	else
		var/improv = FALSE
		switch(fucktarget)
			if("vagina")
				if(has_vagina())
					message = "forces \the <b>[partner]</b>'s face into their pussy."
				else
					improv = TRUE
			if("penis")
				if(has_penis())
					if(is_fucking(partner, CUM_TARGET_THROAT))
						message = "retracts their cock from \the <b>[partner]</b>'s throat"
					else
						message = "shoves their cock into \the <b>[partner]</b>'s mouth"
				else
					improv = TRUE
		if(improv)
			message = "shoves their crotch into \the <b>[partner]</b>'s face."
		set_is_fucking(partner , CUM_TARGET_MOUTH)

	playlewdinteractionsound(loc, pick('sound/interactions/oral1.ogg',
						'sound/interactions/oral2.ogg'), 70, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	if(retaliation_message)
		visible_message(message = "<font color=red><b>\The <b>[partner]</b></b> [retaliation_message]</font>", ignored_mobs = get_unconsenting())
	handle_post_sex(NORMAL_LUST, CUM_TARGET_MOUTH, partner)
	partner.dir = get_dir(partner,src)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/thigh_smother(mob/living/partner, var/fucktarget = "penis")

	var/message
	var/lust_increase = 1

	if(is_fucking(partner, THIGH_SMOTHERING))
		var/improv = FALSE
		switch(fucktarget)
			if("vagina")
				if(has_vagina())
					message = pick(list(
						"presses their weight down onto \the <b>[partner]</b>'s face, blocking their vision completely.",
						"rides \the <b>[partner]</b>'s face, grinding their wet pussy all over it."))
				else
					improv = TRUE
			if("penis")
				if(has_penis())
					message = pick(list("presses their weight down onto \the <b>[partner]</b>'s face, blocking their vision completely.",
						"forces their dick and nutsack into \the <b>[partner]</b>'s face as they're stuck locked in between their thighs.",
						"slips their cock into \the <b>[partner]</b>'s helpless mouth, keeping their shaft pressed hard into their face."))
				else
					improv = TRUE

		if(improv)
			message = "rubs their BP_GROIN up and down \the <b>[partner]</b>'s face."

	else
		var/improv = FALSE
		switch(fucktarget)
			if("vagina")
				if(has_vagina())
					message = pick(list(
						"clambers over \the <b>[partner]</b>'s face and pins them down with their thighs, their moist slit rubbing all over \the <b>[partner]</b>'s mouth and nose.",
						"locks their legs around \the <b>[partner]</b>'s head before pulling it into their mound."))
				else
					improv = TRUE

			if("penis")
				if(has_penis())
					message = pick(list(
						"clambers over \the <b>[partner]</b>'s face and pins them down with their thighs, then slowly inching closer and covering their eyes and nose with their leaking erection.",
						"locks their legs around \the <b>[partner]</b>'s head before pulling it into their fat package, smothering them."))
				else
					improv = TRUE

		if(improv)
			message = "deviously locks their legs around \the <b>[partner]</b>'s head and smothers it in their thighs."

		set_is_fucking(partner , THIGH_SMOTHERING)




	var file = pick('sound/interactions/bj10.ogg',
					'sound/interactions/bj3.ogg',
					'sound/interactions/foot_wet1.ogg',
					'sound/interactions/foot_dry3.ogg')

	playlewdinteractionsound(loc, file, 70, 1, -1)

	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())

	handle_post_sex(lust_increase, THIGH_SMOTHERING, partner)

	partner.dir = get_dir(partner,src)

	do_fucking_animation(get_dir(src, partner))





	playlewdinteractionsound(loc, pick('sound/interactions/oral1.ogg',
						'sound/interactions/oral2.ogg'), 70, 1, -1)


	handle_post_sex(NORMAL_LUST, CUM_TARGET_MOUTH, partner)

	partner.dir = get_dir(partner,src)

	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/do_throatfuck(mob/living/partner)
	var/message
	var/retaliation_message = FALSE

	if(is_fucking(partner, CUM_TARGET_THROAT))
		message = "[pick(
			"brutally shoves their cock into  \the <b>[partner]</b>'s throat to make them gag.",
			"chokes \the <b>[partner]</b> on their dick, going in balls deep.",
			"slams in and out of \the <b>[partner]</b>'s mouth, their balls slapping off their face.")]"
		if(rand(3))
			partner.emote("chokes on \The [src]")
			if(prob(1) && istype(partner, /mob/living))
				var/mob/living/H = partner
				H.adjustOxyLoss(5)
				//add_logs(src, partner, "attacked", src) //cmon, it's 1 in 100. how can it spam logs
		if(partner.a_intent == I_HURT)
			// src.adjustBruteLoss(5)
			retaliation_message = pick(
				"stares up from between \the [src]'s knees, trying to squirm away.",
				"struggles to escape from between \the [src]'s legs.",
			)
	else if(is_fucking(partner, CUM_TARGET_MOUTH))
		message = "thrusts deeper into \the <b>[partner]</b>'s mouth and down their throat."

	else
		message = "forces their dick deep down \the <b>[partner]</b>'s throat"
		set_is_fucking(partner , CUM_TARGET_THROAT)

	playlewdinteractionsound(loc, pick('sound/interactions/oral1.ogg',
						'sound/interactions/oral2.ogg'), 70, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	if(retaliation_message)
		visible_message(message = "<font color=red><b>\The <b>[partner]</b></b> [retaliation_message]</font>", ignored_mobs = get_unconsenting())
	handle_post_sex(NORMAL_LUST, CUM_TARGET_THROAT, partner)
	partner.dir = get_dir(partner,src)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/nut_face(var/mob/living/partner)

	var/message

	var/lust_increase = 1

	if(is_fucking(partner, NUTS_TO_FACE))
		message = pick(list(
			"grabs the back of <b>[partner]</b>'s head and pulls it into their crotch.",
			"jams their nutsack right into <b>[partner]</b>'s face.",
			"roughly grinds their fat nutsack into <b>[partner]</b>'s mouth.",
			"pulls out their saliva-covered nuts from <b>[partner]</b>'s violated mouth and then wipes off the slime onto their face."))
	else
		message = pick(list("wedges a digit into the side of <b>[partner]</b>'s jaw and pries it open before using their other hand to shove their whole nutsack inside!", "stands with their BP_GROIN inches away from [partner]'s face, then thrusting their hips forward and smothering [partner]'s whole face with their heavy ballsack."))
		set_is_fucking(partner , NUTS_TO_FACE)

	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	handle_post_sex(lust_increase, CUM_TARGET_MOUTH, partner)
	partner.dir = get_dir(partner,src)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/do_anal(mob/living/partner)
	var/message

	if(is_fucking(partner, CUM_TARGET_ANUS))
		message = "[pick(
			"thrusts in and out of \the <b>[partner]</b>'s ass.",
			"pounds \the <b>[partner]</b>'s ass.",
			"slams their hips up against \the <b>[partner]</b>'s ass hard.",
			"goes balls deep into \the <b>[partner]</b>'s ass over and over again.")]"
	else
		message = "[pick(
			"works their cock into \the <b>[partner]</b>'s asshole.",
			"grabs the base of their twitching cock and presses the tip into \the <b>[partner]</b>'s asshole.",
			"shoves their dick deep inside of \the <b>[partner]</b>'s ass, making their rear jiggle.")]"
		set_is_fucking(partner, CUM_TARGET_ANUS)

	playlewdinteractionsound(loc, pick('sound/interactions/bang1.ogg',
						'sound/interactions/bang2.ogg',
						'sound/interactions/bang3.ogg'), 70, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	handle_post_sex(NORMAL_LUST, CUM_TARGET_ANUS, partner)
	partner.handle_post_sex(NORMAL_LUST, null, src)
	partner.dir = get_dir(src, partner)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/do_vaginal(mob/living/partner)
	var/message

	if(is_fucking(partner, CUM_TARGET_VAGINA))
		message = "[pick(
			"pounds \the <b>[partner]</b>'s pussy.",
			"shoves their dick deep into \the <b>[partner]</b>'s pussy",
			"thrusts in and out of \the <b>[partner]</b>'s cunt.",
			"goes balls deep into \the <b>[partner]</b>'s pussy over and over again.")]"
	else
		message = "slides their cock into \the <b>[partner]</b>'s pussy."
		set_is_fucking(partner, CUM_TARGET_VAGINA)

	playlewdinteractionsound(loc, pick('sound/interactions/champ1.ogg',	'sound/interactions/champ2.ogg'), 50, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	handle_post_sex(NORMAL_LUST, CUM_TARGET_VAGINA, partner)
	partner.handle_post_sex(NORMAL_LUST, null, src)
	partner.dir = get_dir(partner,src)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/do_mount(mob/living/partner)
	var/message

	if(partner.is_fucking(src, CUM_TARGET_VAGINA))
		message = "[pick("rides \the <b>[partner]</b>'s dick.",
			"forces <b>[partner]</b>'s cock on their pussy")]"
	else
		message = "slides their pussy onto \the <b>[partner]</b>'s cock."
		partner.set_is_fucking(src, CUM_TARGET_VAGINA)
	playlewdinteractionsound(loc, pick('sound/interactions/bang1.ogg',
						'sound/interactions/bang2.ogg',
						'sound/interactions/bang3.ogg'), 70, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_VAGINA, src)
	handle_post_sex(NORMAL_LUST, null, partner)
	partner.dir = get_dir(partner,src)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/do_mountass(mob/living/partner)
	var/message

	if(partner.is_fucking(src, CUM_TARGET_ANUS))
		message = "[pick("rides \the <b>[partner]</b>'s dick.",
			"forces <b>[partner]</b>'s cock on their ass")]"
	else
		message = "lowers their ass onto \the <b>[partner]</b>'s cock."
		partner.set_is_fucking(src, CUM_TARGET_ANUS)
	playlewdinteractionsound(loc, pick('sound/interactions/bang1.ogg',
						'sound/interactions/bang2.ogg',
						'sound/interactions/bang3.ogg'), 70, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_ANUS, src)
	handle_post_sex(NORMAL_LUST, null, partner)
	partner.dir = get_dir(partner,src)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/do_tribadism(mob/living/partner)
	var/message

	if(partner.is_fucking(src, CUM_TARGET_VAGINA))
		message = "[pick("grinds their pussy against \the <b>[partner]</b>'s cunt.",
			"rubs their cunt against \the <b>[partner]</b>'s pussy.",
			"thrusts against \the <b>[partner]</b>'s pussy.",
			"humps \the <b>[partner]</b>, their pussies grinding against each other.")]"
	else
		message = "presses their pussy into \the <b>[partner]</b>'s own."
		partner.set_is_fucking(src, CUM_TARGET_VAGINA)
	playlewdinteractionsound(loc, pick('sound/interactions/squelch1.ogg',
						'sound/interactions/squelch2.ogg',
						'sound/interactions/squelch3.ogg'), 70, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_VAGINA, src)
	handle_post_sex(NORMAL_LUST, null, partner)
	partner.dir = get_dir(partner,src)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/do_fingering(mob/living/partner)
	visible_message(message = "<font color=purple><b>\The [src]</b> [pick("fingers \the <b>[partner]</b>.",
		"fingers \the <b>[partner]</b>'s pussy.",
		"fingers \the <b>[partner]</b> hard.")]</font>", ignored_mobs = get_unconsenting())
	playlewdinteractionsound(loc, 'sound/interactions/champ_fingering.ogg', 50, 1, -1)
	partner.handle_post_sex(NORMAL_LUST, null, src)
	partner.dir = get_dir(partner, src)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/do_fingerass(mob/living/partner)
	visible_message(message = "<font color=purple><b>\The [src]</b> [pick("fingers \the <b>[partner]</b>.",
		"fingers \the <b>[partner]</b>'s asshole.",
		"fingers \the <b>[partner]</b> hard.")]</font>", ignored_mobs = get_unconsenting())
	playlewdinteractionsound(loc, 'sound/interactions/champ_fingering.ogg', 50, 1, -1)
	partner.handle_post_sex(NORMAL_LUST, null, src)
	partner.dir = get_dir(partner, src)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/do_rimjob(mob/living/partner)
	visible_message(message = "<font color=purple><b>\The [src]</b> licks \the <b>[partner]</b>'s asshole.</font>", ignored_mobs = get_unconsenting())
	playlewdinteractionsound(loc, 'sound/interactions/champ_fingering.ogg', 50, 1, -1)
	partner.handle_post_sex(NORMAL_LUST, null, src)
	partner.dir = get_dir(src, partner)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/do_handjob(mob/living/partner)
	var/message

	if(partner.is_fucking(src, CUM_TARGET_HAND))
		message = "[pick("jerks \the <b>[partner]</b> off.",
			"works \the <b>[partner]</b>'s shaft.",
			"wanks \the <b>[partner]</b>'s cock hard.")]"
	else
		message = "[pick("wraps their hand around \the <b>[partner]</b>'s cock.",
			"starts playing with \the <b>[partner]</b>'s cock")]"
		partner.set_is_fucking(src, CUM_TARGET_HAND)

	playlewdinteractionsound(src, pick('sound/interactions/bang1.ogg',
						'sound/interactions/bang2.ogg',
						'sound/interactions/bang3.ogg'), 70, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_HAND, src)
	partner.dir = get_dir(partner,src)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/do_breastfuck(mob/living/partner)
	var/message

	if(is_fucking(partner, CUM_TARGET_BREASTS))
		message = "[pick("fucks \the <b>[partner]</b>'s' breasts.",
			"grinds their cock between \the <b>[partner]</b>'s boobs.",
			"thrusts into \the <b>[partner]</b>'s tits.",
			"grabs \the <b>[partner]</b>'s breasts together and presses their dick between them.")]"
	else
		message = "pushes \the <b>[partner]</b>'s breasts together and presses their dick between them."
		set_is_fucking(partner , CUM_TARGET_BREASTS)


	playlewdinteractionsound(loc, pick('sound/interactions/bang1.ogg',
						'sound/interactions/bang2.ogg',
						'sound/interactions/bang3.ogg'), 70, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	handle_post_sex(NORMAL_LUST, CUM_TARGET_BREASTS, partner)
	partner.dir = get_dir(partner,src)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/do_mountface(mob/living/partner)
	var/message

	if(is_fucking(partner, GRINDING_FACE_WITH_ANUS))
		message = "[pick("grinds their ass into \the <b>[partner]</b>'s face.",
			"shoves their ass into \the <b>[partner]</b>'s face.")]"
	else
		message = "[pick(
			"grabs the back of \the <b>[partner]</b>'s head and forces it into their asscheeks.",
			"squats down and plants their ass right on \the <b>[partner]</b>'s face")]"
		set_is_fucking(partner , GRINDING_FACE_WITH_ANUS)

	playlewdinteractionsound(loc, pick('sound/interactions/squelch1.ogg',
						'sound/interactions/squelch2.ogg',
						'sound/interactions/squelch3.ogg'), 70, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	handle_post_sex(LOW_LUST, null, src)
	partner.dir = get_dir(src, partner)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/do_lickfeet(mob/living/partner)
	var/message

	if(partner.get_equipped_item(slot_shoes) != null)
		message = "licks \the <b>[partner]</b>'s [partner.get_shoes()]."
	else
		message = "licks \the <b>[partner]</b>'s [partner.has_feet() == 1 ? "foot" : "feet"]."

	playlewdinteractionsound(loc, 'sound/interactions/champ_fingering.ogg', 50, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	handle_post_sex(LOW_LUST, null, src)
	partner.dir = get_dir(src, partner)
	do_fucking_animation(get_dir(src, partner))

/*Grinding YOUR feet in TARGET's face*/
/mob/living/proc/do_grindface(mob/living/partner)
	var/message

	if(is_fucking(partner, GRINDING_FACE_WITH_FEET))
		if(src.get_equipped_item(slot_shoes) != null)
			message = "[pick(list("grinds their [get_shoes()] into <b>[partner]</b>'s face.",
				"presses their footwear down hard on <b>[partner]</b>'s face.",
				"rubs off the dirt from their [get_shoes()] onto <b>[partner]</b>'s face."))]"
		else
			message = "[pick(list("grinds their bare feet into <b>[partner]</b>'s face.",
				"deviously covers <b>[partner]</b>'s mouth and nose with their bare feet.",
				"runs the soles of their bare feet against <b>[partner]</b>'s lips."))]"

	else if(is_fucking(partner, GRINDING_MOUTH_WITH_FEET))
		if(src.get_equipped_item(slot_shoes) != null)
			message = "[pick(list("pulls their [get_shoes()] out of <b>[partner]</b>'s mouth and puts them on their face.",
				"slowly retracts their [get_shoes()] from <b>[partner]</b>'s mouth, putting them on their face instead."))]"
		else
			message = "[pick(list("pulls their bare feet out of <b>[partner]</b>'s mouth and rests them on their face instead.",
				"retracts their bare feet from <b>[partner]</b>'s mouth and grinds them into their face instead."))]"

		set_is_fucking(partner , GRINDING_FACE_WITH_FEET)

	else
		if(src.get_equipped_item(slot_shoes) != null)
			message = "[pick(list("plants their [get_shoes()] ontop of <b>[partner]</b>'s face.",
				"rests their [get_shoes()] on <b>[partner]</b>'s face and presses down hard.",
				"harshly places their [get_shoes()] atop <b>[partner]</b>'s face."))]"
		else
			message = "[pick(list("plants their bare feet ontop of <b>[partner]</b>'s face.",
				"rests their feet on <b>[partner]</b>'s face, smothering them.",
				"positions their bare feet atop <b>[partner]</b>'s face."))]"

		set_is_fucking(partner , GRINDING_FACE_WITH_FEET)

	playlewdinteractionsound(loc, pick('sound/interactions/foot_dry1.ogg',
						'sound/interactions/foot_dry2.ogg',
						'sound/interactions/foot_dry3.ogg',
						'sound/interactions/foot_dry4.ogg'), 70, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	partner.handle_post_sex(LOW_LUST, null, src)
	partner.dir = get_dir(src, partner)
	do_fucking_animation(get_dir(src, partner))

/*Grinding YOUR feet in TARGET's mouth*/
/mob/living/proc/do_grindmouth(mob/living/partner)
	var/message

	if(is_fucking(partner, GRINDING_MOUTH_WITH_FEET))
		if(src.get_equipped_item(slot_shoes) != null)
			message = "[pick(list("roughly shoves their [get_shoes()] deeper into <b>[partner]</b>'s mouth.",
				"harshly forces another inch of their [get_shoes()] into <b>[partner]</b>'s mouth.",
				"presses their weight down, their [get_shoes()] prying deeper into <b>[partner]</b>'s mouth."))]"
		else
			message = "[pick(list("wiggles their toes deep inside <b>[partner]</b>'s mouth.",
				"crams their barefeet down deeper into <b>[partner]</b>'s mouth, making them gag.",
				"roughly grinds their feet on <b>[partner]</b>'s tongue."))]"

	else if(is_fucking(partner, GRINDING_FACE_WITH_FEET))
		if(src.get_equipped_item(slot_shoes) != null)
			message = "[pick(list("decides to force their [get_shoes()] deep into <b>[partner]</b>'s mouth.",
				"pressed the tip of their [get_shoes()] against <b>[partner]</b>'s lips and shoves inwards."))]"
		else
			message = "[pick(list("pries open <b>[partner]</b>'s mouth with their toes and shoves their bare foot in.",
				"presses down their foot even harder, cramming their foot into <b>[partner]</b>'s mouth."))]"

		set_is_fucking(partner , GRINDING_MOUTH_WITH_FEET)

	else
		if(src.get_equipped_item(slot_shoes) != null)
			message = "[pick(list("readies themselves and in one swift motion, shoves their [get_shoes()] into <b>[partner]</b>'s mouth.",
				"grinds the tip of their [get_shoes()] against <b>[partner]</b>'s mouth before pushing themselves in."))]"
		else
			message = "[pick(list("rubs their dirty bare feet across <b>[partner]</b>'s face before prying them into their muzzle.",
				"forces their barefeet into <b>[partner]</b>'s mouth.",
				"covers <b>[partner]</b>'s mouth and nose with their foot until they gasp for breath, then shoves both feet inside before they can react."))]"
		set_is_fucking(partner , GRINDING_MOUTH_WITH_FEET)

	playlewdinteractionsound(loc, pick('sound/interactions/foot_wet1.ogg',
						'sound/interactions/foot_wet2.ogg',
						'sound/interactions/foot_wet3.ogg'), 70, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	partner.handle_post_sex(LOW_LUST, null, src)
	partner.dir = get_dir(src, partner)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/do_footfuck(mob/living/partner)
	var/message

	if(is_fucking(src, CUM_TARGET_FEET))
		message = "[pick("fucks \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot", "sole")].",
			"rubs their dick on \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot", "sole")].",
			"grinds their cock on \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot", "sole")].")]"
	else
		message = "[pick("positions their cock on \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot", "sole")].",
			"positions their cock on \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot","sole")].",
			"starts grinding their cock against \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot", "sole")].")]"
		set_is_fucking(src, CUM_TARGET_FEET)

	playlewdinteractionsound(loc, pick('sound/interactions/foot_dry1.ogg',
						'sound/interactions/foot_dry3.ogg',
						'sound/interactions/foot_wet1.ogg',
						'sound/interactions/foot_wet2.ogg'), 70, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	handle_post_sex(NORMAL_LUST, CUM_TARGET_FEET, src)
	partner.dir = get_dir(partner,src)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/do_dfootfuck(mob/living/partner)
	var/message

	if(is_fucking(src, CUM_TARGET_FEET))
		message = "[pick("fucks \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes() : pick("feet", "soles")].",
			"rubs their dick between \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes() : pick("feet", "soles")].",
			"thrusts their cock between \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes() : pick("feet", "soles")].")]"
	else
		message = "[pick("positions their cock between \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes() : pick("feet", "soles")].",
			"starts grinding their cock against \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes() : pick("feet", "soles")].",
			"starts grinding their cock between \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes() : pick("feet", "soles")].")]"
		set_is_fucking(src, CUM_TARGET_FEET)

	playlewdinteractionsound(loc, pick('sound/interactions/foot_dry1.ogg',
						'sound/interactions/foot_dry3.ogg',
						'sound/interactions/foot_wet1.ogg',
						'sound/interactions/foot_wet2.ogg'), 70, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	handle_post_sex(NORMAL_LUST, CUM_TARGET_FEET, src)
	partner.dir = get_dir(partner,src)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/do_vfootfuck(mob/living/partner)
	var/message

	if(is_fucking(src, CUM_TARGET_FEET))
		message = "[pick("grinds their pussy against \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot", "sole")].",
			"rubs their clit on \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot", "sole")].",
			"ruts on \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot", "sole")].")]"
	else
		message = "[pick("positions their vagina on \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot", "sole")].",
			"positions their clit on \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot","sole")].",
			"starts grinding their pussy against \the <b>[partner]</b>'s [partner.get_shoes() ? partner.get_shoes(TRUE) : pick("foot", "sole")].")]"
		set_is_fucking(src, CUM_TARGET_FEET)

	playlewdinteractionsound(loc, pick('sound/interactions/foot_dry1.ogg',
						'sound/interactions/foot_dry3.ogg',
						'sound/interactions/foot_wet1.ogg',
						'sound/interactions/foot_wet2.ogg'), 70, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	handle_post_sex(NORMAL_LUST, CUM_TARGET_FEET, src)
	partner.dir = get_dir(partner,src)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/do_footjob(mob/living/partner)
	var/message

	if(partner.is_fucking(src, CUM_TARGET_FEET))
		message = "[pick("jerks \the <b>[partner]</b> off with their [get_shoes() ? get_shoes(TRUE) : pick("foot", "sole")].",
			"rubs their [get_shoes() ? get_shoes(TRUE) : pick("foot", "sole", "toes")] on \the <b>[partner]</b>'s shaft.",
			"works their [get_shoes() ? get_shoes(TRUE) : pick("foot", "sole")] up and down on \the <b>[partner]</b>'s cock.")]"
	else
		message = "[pick("[get_shoes() ? "positions their [get_shoes(TRUE)] on" :"positions their foot on"] \the <b>[partner]</b>'s cock.",
			"starts playing around with \the <b>[partner]</b>'s cock, using their [get_shoes() ? get_shoes(TRUE) :"foot"].")]"
		partner.set_is_fucking(src, CUM_TARGET_FEET)

	playlewdinteractionsound(loc, pick('sound/interactions/foot_dry1.ogg',
						'sound/interactions/foot_dry3.ogg',
						'sound/interactions/foot_wet1.ogg',
						'sound/interactions/foot_wet2.ogg'), 70, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_FEET, src)
	partner.dir = get_dir(partner,src)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/do_dfootjob(mob/living/partner)
	var/message

	if(partner.is_fucking(src, CUM_TARGET_FEET))
		message = "[pick("jerks \the <b>[partner]</b> off with their [get_shoes() ? get_shoes() : pick("feet", "soles")].",
			"rubs their [get_shoes() ? get_shoes() : pick("feet", "soles")] on \the <b>[partner]</b>'s shaft.",
			"rubs [get_shoes() ? "their [get_shoes()]" : "all of their toes"] on \the <b>[partner]</b>'s cock.",
			"works their [get_shoes() ? get_shoes() : pick("feet", "soles")] up and down on \the <b>[partner]</b>'s cock.")]"
	else
		message = "[pick("[get_shoes() ? "wraps their [get_shoes()] around" : "wraps their [pick("feet", "soles")] around"] \the <b>[partner]</b>'s cock.",
			"starts playing around with \the <b>[partner]</b>'s cock, using their [get_shoes() ? get_shoes() : "feet"].")]"
		partner.set_is_fucking(src, CUM_TARGET_FEET)

	playlewdinteractionsound(loc, pick('sound/interactions/foot_dry1.ogg',
						'sound/interactions/foot_dry3.ogg',
						'sound/interactions/foot_wet1.ogg',
						'sound/interactions/foot_wet2.ogg'), 70, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_FEET, src)
	partner.dir = get_dir(partner,src)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/do_footjob_v(mob/living/partner)
	var/message

	if(partner.is_fucking(src, CUM_TARGET_FEET))
		message = "[pick("rubs \the <b>[partner]</b> clit with their [get_shoes() ? get_shoes(TRUE) : pick("foot", "sole")].",
			"rubs their [get_shoes() ? get_shoes(TRUE) : pick("foot", "sole", "toes")] on \the <b>[partner]</b>'s coochie.",
			"rubs their [get_shoes() ? get_shoes(TRUE) : pick("foot", "sole", "toes")] on \the <b>[partner]</b>'s vagina.",
			"rubs their foot up and down on \the <b>[partner]</b>'s pussy.")]"
	else
		message = "[pick("[get_shoes() ? "positions their [get_shoes(TRUE)] on" : "positions their foot on"] \the <b>[partner]</b>'s pussy.",
			"starts playing around with \the <b>[partner]</b>'s pussy, using their [get_shoes() ? get_shoes(TRUE) : "foot"].")]"
		partner.set_is_fucking(src, CUM_TARGET_FEET)

	playlewdinteractionsound(loc, pick('sound/interactions/foot_dry1.ogg',
						'sound/interactions/foot_dry3.ogg',
						'sound/interactions/foot_wet1.ogg',
						'sound/interactions/foot_wet2.ogg'), 70, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting())
	partner.handle_post_sex(NORMAL_LUST, CUM_TARGET_FEET, src)
	partner.dir = get_dir(partner,src)
	do_fucking_animation(get_dir(src, partner))

/mob/living/proc/get_shoes(var/singular = FALSE)
	var/obj/A = get_equipped_item(slot_shoes)
	if(A)
		var/txt = A.name
		if(findtext (A.name,"the"))
			txt = copytext(A.name, 5, length(A.name)+1)
			if(singular)
				txt = copytext(A.name, 5, length(A.name))
			return txt
		else
			if(singular)
				txt = copytext(A.name, 1, length(A.name))
			return txt

/mob/living/proc/handle_post_sex(amount, orifice, mob/living/partner)
	if(stat != CONSCIOUS)
		return

	if(amount)
		add_lust(amount)
	if(get_lust() >= lust_tolerance)
		if(prob(10))
			to_chat(src, "<b>You struggle to not orgasm!</b>")
			return
		if(lust >= lust_tolerance*3)
			cum(partner, orifice)
	else
		moan()

/mob/living/proc/get_unconsenting(var/extreme = FALSE, var/list/ignored_mobs)
	var/list/nope = list()
	nope += ignored_mobs
	for(var/mob/M in range(7, src))
		if(!M.client)
			nope += M
	return nope

//Yep, weird shit goes down here.
/mob/living/proc/do_eyefuck(mob/living/partner)
	var/message

	if(is_fucking(partner, CUM_TARGET_EYES))
		message = "[pick(
			"pounds into \the <b>[partner]</b>'s [has_eyes_lewd() ? "eye":"eyesocket"].",
			"shoves their dick deep into \the <b>[partner]</b>'s skull",
			"thrusts in and out of \the <b>[partner]</b>'s [has_eyes_lewd() ? "eye":"eyesocket"].",
			"goes balls deep into \the <b>[partner]</b>'s cranium over and over again.")]"
		var/client/cli = partner.client
		var/mob/living/carbon/C = partner
		if(cli && istype(C))
			if(prob(25))
				var/obj/item/organ/internal/eyes/E = C.internal_organs_by_name[BP_EYES]
				if(E)
					E.damage += rand(3,7)
				C.adjustBrainLoss(rand(3,7))
	else
		message = "forcefully slides their cock inbetween \the <b>[partner]</b>'s [has_eyes_lewd() ? "eyelid":"eyesocket"]."
		set_is_fucking(partner, CUM_TARGET_EYES)

	playlewdinteractionsound(loc, pick('sound/interactions/champ1.ogg',
						'sound/interactions/champ2.ogg'), 50, 1, -1)
	visible_message(message = "<font color=purple><b>\The [src]</b> [message]</font>", ignored_mobs = get_unconsenting(TRUE))
	handle_post_sex(NORMAL_LUST, CUM_TARGET_EYES, partner)
	partner.handle_post_sex(LOW_LUST, null, src)
	partner.dir = get_dir(partner,src)
	do_fucking_animation(get_dir(src, partner))