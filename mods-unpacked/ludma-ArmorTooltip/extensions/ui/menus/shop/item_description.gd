extends "res://ui/menus/shop/item_description.gd"

# Extensions
# =============================================================================

func set_item(item_data:ItemParentData)->void :
	.set_item(item_data)
	
	var armorGain = 0
	var hasArmor = false
	for effect in item_data.effects:
		if effect.key == "stat_armor":
			hasArmor = true
			armorGain = effect.value
	
	if !hasArmor:
		return
	
	var additionalText = get_additional_armor_text(armorGain)
	replaceArmorText(item_data.get_effects_text(), additionalText)
	
# Custom
# =============================================================================

func replaceArmorText(itemText: String, additionalText: String)->void:
	var armorTr = tr("STAT_ARMOR")
	var armorTrLength = armorTr.length()
	
	var armorIndex = itemText.find(armorTr)
	if armorIndex < 0:
		return
	
	var posToInsert = armorIndex + armorTrLength
	var newText = itemText.insert(posToInsert, additionalText)

	get_effects().bbcode_text = newText

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
