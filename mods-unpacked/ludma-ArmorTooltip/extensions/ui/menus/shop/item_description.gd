extends "res://ui/menus/shop/item_description.gd"

# Extensions
# =============================================================================

func set_item(item_data:ItemParentData)->void :
	.set_item(item_data)
	
	var armorEffects = []
	var hpRegenEffects = []
	for effect in item_data.effects:
		if effect.key == "stat_armor":
			armorEffects.append(effect)
		if effect.key == "stat_hp_regeneration":
			hpRegenEffects.append(effect)
	
	if not item_data is ItemData:
		return
		
	if not armorEffects.empty():
		var armorTextFunc = funcref(self, "get_additional_armor_text")
		if item_data is CharacterData or item_data is UpgradeData:
			# Upgrade and Character Data.
			replaceText(item_data.get_effects_text(), "] " + tr("STAT_ARMOR"), armorEffects, armorTextFunc)
		else:
			# ItemData (But not character or upgrade)
			replaceText(item_data.get_effects_text(), tr("STAT_ARMOR"), armorEffects, armorTextFunc)
			
	if not hpRegenEffects.empty():
		var hpregTextFunc = funcref(self, "get_additional_hpreg_text")
		replaceText(item_data.get_effects_text(), tr("STAT_HP_REGENERATION"), hpRegenEffects, hpregTextFunc)


# Custom
# =============================================================================

func replaceText(itemText: String, stringToReplace: String, armorEffects: Array, textFunc)->void:
	var findFrom = 0
	for effect in armorEffects:
		var additionalText = textFunc.call_func(effect.value)
		
		var armorIndex = itemText.find(stringToReplace, findFrom)
		if armorIndex < 0:
			continue
		
		var posToInsert = armorIndex + stringToReplace.length()
		itemText = itemText.insert(posToInsert, additionalText)
		findFrom = posToInsert + additionalText.length()
		
	get_effects().bbcode_text = itemText

func get_additional_hpreg_text(addedRegen: int)->String:
	var currentReg = Utils.get_stat("stat_hp_regeneration")
	var currentHps = getHealthPerSecond(currentReg)
	var hpsAfterAdded = getHealthPerSecond(currentReg + addedRegen)
	
	return " ({0}/s -> {1}/s)".format([currentHps, hpsAfterAdded])

func getHealthPerSecond(hpreg: float)->float:
	var val = RunData.get_hp_regeneration_timer(hpreg)
	if val == 99:
		return 0.0
		
	var amount = 2 if RunData.effects["double_hp_regen"] else 1
	var amount_per_sec = amount / val
	var hps = stepify(amount_per_sec, 0.01)
		
	return hps

func get_additional_armor_text(addedArmor: int)->String:
	var currentArmor = Utils.get_stat("stat_armor")
	var currentArmorReduction = round((1.0 - RunData.get_armor_coef(currentArmor)) * 100.0)
	var reductionAfterAddedArmor = round((1.0 - RunData.get_armor_coef(currentArmor + addedArmor)) * 100.0)
	
	if currentArmorReduction < 0:
		currentArmorReduction = "[color=" + Utils.NEG_COLOR_STR + "]" + str(currentArmorReduction) + "%[/color]"
	elif currentArmorReduction > 0:
		currentArmorReduction = "[color=" + Utils.POS_COLOR_STR + "]" + str(currentArmorReduction) + "%[/color]"
	else:
		currentArmorReduction = str(currentArmorReduction) + "%"
	
	if reductionAfterAddedArmor < 0:
		reductionAfterAddedArmor = "[color=" + Utils.NEG_COLOR_STR + "]" + str(reductionAfterAddedArmor) + "%[/color]"
	elif reductionAfterAddedArmor > 0:
		reductionAfterAddedArmor = "[color=" + Utils.POS_COLOR_STR + "]" + str(reductionAfterAddedArmor) + "%[/color]"
	else:
		reductionAfterAddedArmor = str(reductionAfterAddedArmor) + "%"
		
	return " ({0} -> {1})".format([currentArmorReduction, reductionAfterAddedArmor])
