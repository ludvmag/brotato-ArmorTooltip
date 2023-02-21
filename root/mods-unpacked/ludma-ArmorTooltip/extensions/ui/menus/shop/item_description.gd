extends "res://ui/menus/shop/item_description.gd"
###
# Currently modifying text the basic case of stat modifiers on Items,Characters and Upgrades. Examples:
# +3[/color] Armor
# -2[/color] HP Regeneration
# -100[/color] Armor
# Not covering:
# "+x armor while standing still/ while moving" - effect_stat_while_not_moving
# "+X for every Y you have" - EFFECT_GAIN_STAT_FOR_EVERY_PERM_STAT
# Regeneration potion's "HP regen doubled when below 50% hp"
#
###
# Extensions
# =============================================================================

func set_item(item_data:ItemParentData)->void :
	.set_item(item_data)
	
	var effects = []
	for effect in item_data.effects:
		if effect.key == "stat_armor":
			effects.append(effect)
		if effect.key == "stat_hp_regeneration":
			effects.append(effect)
	
	if not item_data is ItemData:
		return
	
	#var itemText = item_data.get_effects_text()
	var itemText = get_effects().bbcode_text
	if not effects.empty():
		itemText = insertText(itemText, effects)

	get_effects().bbcode_text = itemText

# Custom
# =============================================================================

func insertText(itemText: String, effects: Array)->String:
	var regex = RegEx.new()
	var findFrom = 0
	for effect in effects:
		var effectTextKey = effect.key.to_upper()
		var textFunc = get_additional_text_func_for_effect(effectTextKey)
		var additionalText = textFunc.call_func(effect.value)
		
		regex.compile("(\\-|\\+)\\d+(\\[\\/color\\])+ " + tr(effectTextKey)) # regex for 'basic case'.
		var regexMatch = regex.search(itemText, findFrom)
		if not regexMatch:
			continue
		
		var posToInsert = regexMatch.get_end()
		itemText = itemText.insert(posToInsert, additionalText)
		findFrom = posToInsert + additionalText.length()
		
	return itemText

func get_additional_text_func_for_effect(effect_key: String)->FuncRef:
	if effect_key == "STAT_ARMOR":
		return funcref(self, "get_additional_armor_text")
	elif effect_key == "STAT_HP_REGENERATION":
		return funcref(self, "get_additional_hpreg_text")
	else:
		return null

func get_additional_hpreg_text(addedRegen: int)->String:
	var currentReg = Utils.get_stat("stat_hp_regeneration")
	var currentHps = getHealthPerSecond(currentReg)
	var hpsAfterAdded = getHealthPerSecond(currentReg + addedRegen)
	
	var currentHpsString = add_color(currentHps, "/s")
	var hpsAfterAddedString = add_color(hpsAfterAdded, "/s")
	var arrow = get_colored_arrow(currentHps, hpsAfterAdded)
	
	return " ({0} {1} {2})".format([currentHpsString, arrow, hpsAfterAddedString])

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
	var armorAfterAddedArmor = currentArmor + addedArmor
	var currentArmorReduction = round((1.0 - RunData.get_armor_coef(currentArmor)) * 100.0)
	var reductionAfterAddedArmor = round((1.0 - RunData.get_armor_coef(armorAfterAddedArmor)) * 100.0)
	
	currentArmorReduction = add_color(currentArmorReduction, "%")
	reductionAfterAddedArmor = add_color(reductionAfterAddedArmor, "%")
	var arrow = get_colored_arrow(currentArmor, armorAfterAddedArmor)
	
	return " ({0} {1} {2})".format([currentArmorReduction, arrow, reductionAfterAddedArmor])

func add_color(value, postfix: String = "")->String:
	if value < 0:
		return "[color=" + Utils.NEG_COLOR_STR + "]" + str(value) + postfix + "[/color]"
	elif value > 0:
		return "[color=" + Utils.POS_COLOR_STR + "]" + str(value) + postfix + "[/color]"
	else:
		return str(value) + postfix

func get_colored_arrow(initialValue, afterAdditionValue):
	if initialValue > afterAdditionValue:
		return "[color=" + Utils.NEG_COLOR_STR + "]" + "->" + "[/color]"
	elif initialValue < afterAdditionValue:
		return "[color=" + Utils.POS_COLOR_STR + "]" + "->" + "[/color]"
	else:
		return "->"
