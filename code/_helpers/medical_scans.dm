/mob/living/carbon/human/proc/get_raw_medical_data(var/tag = FALSE)
	var/mob/living/carbon/human/H = src
	var/list/scan = list()

	scan["name"] = H.name
	scan["time"] = stationtime2text()
	var/brain_result
	if(H.should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/brain/brain = H.internal_organs_by_name[BP_BRAIN]
		if(!brain || H.stat == DEAD || (H.status_flags & FAKEDEATH))
			brain_result = 0
		else if(H.stat != DEAD)
			brain_result = round(max(0,(1 - brain.damage/brain.max_damage)*100))
	else
		brain_result = -1
	scan["brain_activity"] = brain_result

	var/pulse_result
	if(H.should_have_organ(BP_HEART))
		var/obj/item/organ/internal/heart/heart = H.internal_organs_by_name[BP_HEART]
		if(!heart)
			pulse_result = 0
		else if(BP_IS_ROBOTIC(heart))
			pulse_result = -2
		else if(H.status_flags & FAKEDEATH)
			pulse_result = 0
		else
			pulse_result = H.get_pulse(GETPULSE_TOOL)
	else
		pulse_result = -1

	if(pulse_result == ">250")
		pulse_result = -3
	scan["pulse"] = text2num(pulse_result)

	scan["blood_pressure"] = H.get_blood_pressure()
	scan["blood_o2"] = H.get_blood_oxygenation()
	scan["blood_volume"] = H.vessel.get_reagent_amount(/datum/reagent/blood)
	scan["blood_volume_max"] = H.species.blood_volume
	scan["temperature"] = H.bodytemperature
	scan["trauma"] = H.getBruteLoss()
	scan["burn"] = H.getFireLoss()
	scan["toxin"] = H.getToxLoss()
	scan["oxygen"] = H.getOxyLoss()
	scan["radiation"] = H.radiation
	scan["genetic"] = H.getCloneLoss()
	scan["paralysis"] = H.paralysis
	scan["immune_system"] = H.virus_immunity()
	scan["worms"] = H.has_brain_worms()

	scan["reagents"] = list()

	if(H.reagents.total_volume)
		for(var/datum/reagent/R in H.reagents.reagent_list)
			var/list/reagent  = list()
			reagent["name"]= R.name
			reagent["quantity"] = round(H.reagents.get_reagent_amount(R.type),1)
			reagent["scannable"] = R.scannable
			scan["reagents"] += list(reagent)

	scan["external_organs"] = list()

	for(var/obj/item/organ/external/E in H.organs)
		var/list/O = list()
		O["name"] = E.name
		O["is_stump"] = E.is_stump()
		O["brute_ratio"] = E.brute_ratio
		O["burn_ratio"] = E.burn_ratio
		O["limb_flags"] = E.limb_flags
		O["brute_dam"] = E.brute_dam
		O["burn_dam"] = E.burn_dam
		O["scan_results"] = E.get_scan_results(tag)

		scan["external_organs"] += list(O)

	scan["internal_organs"] = list()

	for(var/obj/item/organ/internal/I in H.internal_organs)
		var/list/O = list()
		O["name"] = I.name
		O["is_broken"] = I.is_broken()
		O["is_bruised"] = I.is_bruised()
		O["is_damaged"] = I.is_damaged()
		O["scan_results"] = I.get_scan_results(tag)

		scan["internal_organs"] += list(O)

	scan["missing_organs"] = list()

	for(var/organ_name in H.species.has_organ)
		if(!locate(H.species.has_organ[organ_name]) in H.internal_organs)
			scan["missing_organs"] += organ_name
	if(H.sdisabilities & BLIND)
		scan["blind"] = TRUE
	if(H.sdisabilities & NEARSIGHTED)
		scan["nearsight"] = TRUE
	return scan

/proc/display_medical_data_header(var/list/scan, skill_level = SKILL_DEFAULT)
	//In case of problems, abort.
	var/dat = list()

	if(!scan["name"])
		return "<center><span class='bad'><strong>>ERROR DE LECTURA DEL ESCANEO</strong></span></center>"

	//Table definition and starting data block.
	/*
	<!--Clean HTML Formatting-->
	<table class="block" width="95%">
		<tr><td><strong>Scan Results For:</strong></td><td>Name</td></tr>
		<tr><td><strong>Scan Performed At:</strong></td><td>00:00</td></tr>
	*/
	dat += "<table class='block' width='95%'>"
	dat += "<tr><td><strong>Resultados del escaneo para:</strong></td><td>[scan["name"]]</td></tr>"
	dat += "<tr><td><strong>Escaneo realizado a las:</strong></td><td>[scan["time"]]</td></tr>"

	dat = JOINTEXT(dat)
	return dat

/proc/display_medical_data_health(var/list/scan, skill_level = SKILL_DEFAULT)
	//In case of problems, abort.
	if(!scan["name"])
		return "<center><span class='bad'><strong>ERROR DE LECTURA DEL ESCANEO</strong></span></center>"

	var/list/subdat = list()
	var/dat = list()

	//Brain activity
	/*
		<tr><td><strong>Brain Activity:</strong></td><td>100%</td></tr>
	*/
	dat += "<tr><td><strong>Actividad cerebral:</strong></td>"
	switch(scan["brain_activity"])
		if(0)
			dat += "<td><span class='bad'>Ninguna, el paciente tiene muerte cerebral</span></td></tr>"
		if(-1)
			dat += "<td><span class='average'>ERROR - Biologia no estandar</span></td></tr>"
		else
			if(skill_level >= SKILL_BASIC)
				if(scan["brain_activity"] <= 50)
					dat += "<td><span class='bad'>[scan["brain_activity"]]%</span></td></tr>"
				else if(scan["brain_activity"] <= 80)
					dat += "<td><span class='average'>[scan["brain_activity"]]%</span></td></tr>"
				else
					dat += "<td>[scan["brain_activity"]]%</td></tr>"
			else
				dat += "<td>hay una linea ondulada aqui</td></tr>"

	//Circulatory System
	/*
		<tr><td><strong>Pulse Rate:</strong></td><td>75bpm</td></tr>
		<tr><td colspan='2'><span class='average'>Patient is tachycardic.</span></td></tr>
		<tr><td><strong>Blood Pressure:</strong></td><td>120/80 (100% oxygenation)</td></tr>
		<tr><td><strong>Blood Volume:</strong></td><td>560u/560u</td></tr>
		<tr><td colspan="2" align="center"><span class='bad'>Patient in Hypovolemic Shock. Transfusion highly recommended.</span></td></tr>
	*/
	dat += "<tr><td><strong>Frecuencia del pulso:</strong></td>"
	if(scan["pulse"] == -1)
		dat += "<td><span class='average'>ERROR - Biologia no estandar</span></td></tr>"
	else if(scan["pulse"] == -2)
		dat += "<td>N/A</td></tr>"
	else if(scan["pulse"] == -3)
		dat += "<td><span class='bad'>250+lpm</span></td></tr>"
	else if(scan["pulse"] == 0)
		dat += "<td><span class='bad'>[scan["pulse"]]lpm</span></td></tr>"
	else if(scan["pulse"] >= 140)
		dat += "<td><span class='bad'>[scan["pulse"]]lpm</span></td></tr>"
	else if(scan["pulse"] >= 120)
		dat += "<td><span class='average'>[scan["pulse"]]lpm</span></td></tr>"
	else
		dat += "<td>[scan["pulse"]]lpm</td></tr>"
	if(skill_level >= SKILL_ADEPT)
		if((scan["pulse"] >= 140) || (scan["pulse"] == -3))
			dat+= "<tr><td colspan='2'><span class='bad'>El paciente es taquicardico.</span></td></tr>"
		else if(scan["pulse"] >= 120)
			dat += "<tr><td colspan='2'><span class='average'>El paciente es taquicardico.</span></td></tr>"
		else if(scan["pulse"] == 0)
			dat+= "<tr><td colspan='2'><span class='bad'>El corazon del paciente se detuvo.</span></td></tr>"
		else if((scan["pulse"] > 0) && (scan["pulse"] <= 40))
			dat+= "<tr><td colspan='2'><span class='average'>El paciente tiene bradicardia.</span></td></tr>"


	var/ratio = scan["blood_volume"]/scan["blood_volume_max"]
	dat += "<tr><td><strong>Precion sanguinea:</strong></td><td>[scan["blood_pressure"]]"
	if(scan["blood_o2"] <= 70)
		dat += "(<span class='bad'>[scan["blood_o2"]]% de oxigenacion en la sangre</span>)</td></tr>"
	else if(scan["blood_o2"] <= 85)
		dat += "(<span class='average'>[scan["blood_o2"]]% de oxigenacion en la sangre</span>)</td></tr>"
	else if(scan["blood_o2"] <= 90)
		dat += "(<span class='oxyloss'>[scan["blood_o2"]]% de oxigenacion en la sangre</span>)</td></tr>"
	else
		dat += "([scan["blood_o2"]]% de oxigenacion en la sangre)</td></tr>"

	dat += "<tr><td><strong>Volumen sanguineo:</strong></td><td>[scan["blood_volume"]]u/[scan["blood_volume_max"]]u</td></tr>"

	if(skill_level >= SKILL_ADEPT)
		if(ratio <= 0.70)
			dat += "<tr><td colspan='2'><span class='bad'>El paciente esta en shock hipovolemico. Transfusion muy recomendable.</span></td></tr>"

	// Body temperature.
	/*
		<tr><td><strong>Body Temperature:</strong></td><td>40&deg;C (98.6&deg;F)</td></tr>
	*/
	dat += "<tr><td><strong>Temperatura corporal:</strong></td><td>[scan["temperature"]-T0C]&deg;C ([scan["temperature"]*1.8-459.67]&deg;F)</td></tr>"

	//Information Summary
	/*
		<tr><td><strong>Physical Trauma:</strong></td><td>severe</td></tr>
		<tr><td><strong>Burn Severity:</strong></td><td>severe</td></tr>
		<tr><td><strong>Systematic Organ Failure:</strong>severe</td></tr>
		<tr><td><strong>Oxygen Deprivation:</strong></td><td>severe</tr>
		<tr><td><strong>Radiation Level:</strong></td><td>acute</td></tr>
		<tr><td><strong>Genetic Tissue Damage:</strong></td><td>severe</td></tr>
		<tr><td><strong>Paralysis Summary:</strong></td><td>approx 0 seconds left</td></tr>
	*/
	if(skill_level >= SKILL_BASIC)
		subdat += "<tr><td><strong>Trauma fisico:</strong></td><td>\t[get_severity(scan["trauma"],TRUE)]</td></tr>"
		subdat += "<tr><td><strong>Severidad de quemaduras:</strong></td><td>\t[get_severity(scan["burn"],TRUE)]</td></tr>"
		subdat += "<tr><td><strong>Falla sistematica de organos:</strong></td><td>\t[get_severity(scan["toxin"],TRUE)]</td></tr>"
		subdat += "<tr><td><strong>Falta de oxigeno:</strong></td><td>\t[get_severity(scan["oxygen"],TRUE)]</td></tr>"
		subdat += "<tr><td><strong>Niveles de radiacion:</strong></td><td>\t[get_severity(scan["radiation"]/5,TRUE)]</td></tr>"
		subdat += "<tr><td><strong>Dano genetico del tejido:</strong></td><td>\t[get_severity(scan["genetic"],TRUE)]</td></tr>"

		if(scan["paralysis"])
			subdat += "<tr><td><strong>Resumen de paralisis:</strong></td><td>aproximadamente [scan["paralysis"]/4] segundos restantes</td></tr>"

		dat += subdat

		subdat = null
		//Immune System
		/*
			<tr><td colspan='2'><center>Antibody levels and immune system performance are at 100% of baseline.</center></td></tr>
			<tr><td colspan='2'><span class='bad'><center>Viral Pathogen detected in blood stream.</center></span></td></tr>
			<tr><td colspan='2'><span class='bad'><center>Large growth detected in frontal lobe, possibly cancerous.</center></span></td></tr>
		*/
		dat += "<tr><td colspan = '2'>Los niveles de anticuerpos y el rendimiento del sistema inmune estan en un [scan["immune_system"]*100]% de referencia.</td></tr>"

		if(scan["worms"])
			dat += "<tr><td colspan='2'><span class='bad'><center>Gran crecimiento detectado en el lobulo frontal, posiblemente canceroso.</center></span></td></tr>"

		//Reagent scan
		/*
			<tr><td colspan='2'>Beneficial reagents detected in subject's bloodstream:</td></tr>
			<tr><td colspan='2'>10u dexalin plus</td></tr>
		*/
		var/other_reagent = FALSE

		for(var/list/R in scan["reagents"])
			if(R["scannable"])
				subdat += "<tr><td colspan='2'>[R["quantity"]]u [R["name"]]</td></tr>"
			else
				other_reagent = TRUE
		if(subdat)
			dat += "<tr><td colspan='2'>Reactivos beneficiosos detectados en el torrente sanguineo del paciente:</td></tr>"
			dat += subdat
		if(other_reagent)
			dat += "<tr><td colspan='2'><span class='average'>Advertencia: Sustancia desconocida detectada en la sangre del sujeto.</span></td></tr>"

	//summary for the medically disinclined.
	/*
			<tr><td colspan='2'>You see a lot of numbers and abbreviations here, but you have no clue what any of this means.</td></tr>
	*/
	else
		dat += "<tr><td colspan='2'>Ves muchos numeros y abreviaturas aqui, pero no tienes idea de lo que esto significa.</td></tr>"

	dat = JOINTEXT(dat)

	return dat

/proc/display_medical_data_body(var/list/scan, skill_level = SKILL_DEFAULT)
	//In case of problems, abort.
	if(!scan["name"])
		return "<center><span class='bad'><strong>ERROR DE LECTURA DEL ESCANEO</strong></span></center>"

	var/list/subdat = list()
	var/dat = list()
	//External Organs
	/*
			<tr><td colspan='2'><center>
				<table class='block' border='1' width='95%'>
					<tr><th colspan='3'>Body Status</th></tr>
					<tr><th>Organ</th><th>Damage</th><th>Status</th></tr>
					<tr><td>head</td><td><span class='brute'>Severe physical trauma</span><br><span class='burn'>Severe burns</span></td><td><span class='bad'>Bleeding</span></td></td>
					<tr><td>upper body</td><td>None</td><td></td></tr>
					<tr><td>right arm</td><td>N/A</td><td><span class='bad'>Missing</span></td></tr>
	*/

	dat += "<tr><td colspan='2'><center><table class='block' border='1' width='95%'><tr><th colspan='3'>Estado del cuerpo</th></tr>"
	dat += "<tr><th>Organo</th><th>Dano</th><th>Estado</th></tr>"
	subdat = list()

	for(var/list/E in scan["external_organs"])
		if(!E)
			break
		var/row = list()
		row += "<tr><td>[E["name"]]</td>"
		if(E["is_stump"])
			row += "<td><span class='bad'>Faltante</span></td>"
			if(skill_level >= SKILL_ADEPT)
				row += "<td><span class='bad'>[english_list(E["scan_results"], nothing_text = "&nbsp;")]</span></td>"
			else
				row += "<td>&nbsp;</td>"
		else
			row += "<td>"
			if(E["brute_dam"] + E["burn_dam"] == 0)
				row += "Ninguno</td>"
			if(skill_level < SKILL_ADEPT)
				if(E["brute_dam"])
					row += "<span class='bad'>Danado</span><br>"
				if(E["burn_dam"])
					row += "<span class='average'>Quemado</span></td>"
			else
				if(E["brute_dam"])
					row += "<span class='bad'>dano fisico [capitalize(get_wound_severity(E["brute_ratio"], (E["limb_flags"] & ORGAN_FLAG_HEALS_OVERKILL)))]</span><br>"
				if(E["burn_dam"])
					row += "<span class='average'>quemadura [capitalize(get_wound_severity(E["burn_ratio"], (E["limb_flags"] & ORGAN_FLAG_HEALS_OVERKILL)))] </span></td>"
			if(skill_level >= SKILL_ADEPT)
				row += "<td>"
				row += "<span class='bad'>[english_list(E["scan_results"], nothing_text="&nbsp;")]</span>"
				row += "</td>"
			else
				row += "<td>&nbsp;</td>"
		row += "</tr>"
		subdat += JOINTEXT(row)
	dat += subdat
	subdat = list()


	//Internal Organs
	/*
					<tr><th colspan='3'><center>Internal Organs</center></th></tr>
					<tr><td>heart</td<td>None</td><td></td>
					<tr><td>lungs</td><td><span class='bad'>Severe</td><td>Decaying</span></td>
					<tr><td colspan='3'><span class='bad'>No liver detected.</span></td></tr>
					<tr><td colspan='3'>No appendix detected.</td></tr>
					<tr><td colspan='3'><span class='bad'>Cateracts detected.</span></td></tr>
					<tr><td colspan='3'><span class='average'>Retinal misalignment detected.</span></td></tr>
				</table>
			</center></td></tr>
	*/
	if(skill_level >= SKILL_BASIC)
		dat += "<tr><th colspan='3'><center>Organos internos</center></th></tr>"
		for(var/list/I in scan["internal_organs"])
			var/row = list()
			row += "<tr><td>[I["name"]]</td>"
			if(I["is_broken"])
				row += "<td><span class='bad'>severo</span></td>"
			else if(I["is_bruised"])
				row += "<td><span class='average'>moderado</span></td>"
			else if(I["is_damaged"])
				row += "<td>menor</td>"
			else
				row += "<td>Ninguno</td>"
			row += "<td>"
			row += "<span class='bad'>[english_list(I["scan_results"], nothing_text="&nbsp;")]</span>"
			row += "</td></tr>"
			subdat += jointext(row, null)

	if(skill_level <= SKILL_ADEPT)
		dat += shuffle(subdat)
	else
		dat += subdat
	for(var/organ_name in scan["missing_organs"])
		if(organ_name != "appendix")
			dat += "<tr><td colspan='3'><span class='bad'>No se detecto: [organ_name].</span></td></tr>"
		else
			dat += "<tr><td colspan='3'>No se detecto: [organ_name]</td></tr>"

	if(scan["blind"])
		dat += "<tr><td colspan='3'><span class='bad'>Cataratas detectadas.</span></td></tr>"
	else if(scan["nearsight"])
		dat += "<tr><td colspan='3'><span class='average'>Desalineacion retiniana detectada.</span></td></tr>"
	dat += "</table></center></td></tr>"

	dat = JOINTEXT(dat)
	return dat

/proc/display_medical_data(var/list/scan, skill_level = SKILL_DEFAULT, var/TT = FALSE)
	//In case of problems, abort.
	if(!scan["name"])
		return "<center><span class='bad'><strong>ERROR DE LECTURA DEL ESCANEO</strong></span></center>"

	var/dat = list()

	if(TT)
		dat += "<tt>"

	//necessary evil, due to the limitations of nanoUI's variable length output.
	//This allows for the display_medical_data proc to be used for non-ui things
	//while keeping the variable size lower for the scanner template.
	//decoupling the two would lead to inconsistent output between the template
	//and other sources if changes are ever made.
	dat += display_medical_data_header(scan, skill_level)
	dat += display_medical_data_health(scan, skill_level)
	dat += display_medical_data_body(scan, skill_level)

	if(TT)
		dat += "</tt>"

	dat = JOINTEXT(dat)
	return dat

/proc/get_severity(amount, var/tag = FALSE)
	if(!amount)
		return "ninguno"
	. = "menor"
	if(amount > 50)
		if(tag)
			. = "<span class='bad'>severo</span>"
		else
			. = "severe"
	else if(amount > 25)
		if(tag)
			. = "<span class='bad'>significante</span>"
		else
			. = "significant"
	else if(amount > 10)
		if(tag)
			. = "<span class='average'>moderado</span>"
		else
			. = "moderate"