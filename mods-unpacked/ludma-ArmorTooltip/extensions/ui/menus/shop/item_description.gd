extends "res://ui/menus/shop/item_description.gd"

# Extensions
# =============================================================================

func set_item(item_data:ItemParentData)->void :
	.set_item(item_data)
	
	var armorEffects = []
	for effect in item_data.effects:
		if effect.key == "stat_armor":
			armorEffects.append(effect)
	
	if armorEffects.empty() or not item_data is ItemData:
		return
	
	if item_data is CharacterData or item_data is UpgradeData:
		# Upgrade and Character Data.
		replaceArmorText(item_data.get_effects_text(), "] " + tr("STAT_ARMOR"), armorEffects)
	else:
		# ItemData (But not character or upgrade)
		replaceArmorText(item_data.get_effects_text(), tr("STAT_ARMOR"), armorEffects)

# Custom
# =============================================================================

func replaceArmorText(itemText: String, stringToReplace: String, armorEffects: Array)->void:
	var findFrom = 0
	for effect in armorEffects:
		var additionalText = get_additional_armor_text(effect.value)	
		
		var armorIndex = itemText.find(stringToReplace, findFrom)
		if armorIndex < 0:
			continue
		
		var posToInsert = armorIndex + stringToReplace.length()
		itemText = itemText.insert(posToInsert, additionalText)
		findFrom = posToInsert + additionalText.length()
		
	get_effects().bbcode_text = itemText

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
