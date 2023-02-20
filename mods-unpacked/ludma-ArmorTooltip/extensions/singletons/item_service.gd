extends "res://singletons/utils.gd"

func get_stat(stat_name:String)->float:
	if stat_name != "ehpmod_stat_ehp":
		return .get_stat(stat_name)
	
	return get_ehp()


## Custom

func get_ehp()->float:
	var hpCap = RunData.effects["hp_cap"]
	var max_hp = hpCap if hpCap < 9999 else .get_stat("stat_max_hp")
	var armor = .get_stat("stat_armor")
	
	var ehp = calc_ehp(max_hp, armor)
	
	return ehp

func calc_ehp(maxhp: int, armor: int)->float:
	var damage_taken_percent = RunData.get_armor_coef(armor)
	var ehp = maxhp / damage_taken_percent
	
	return ehp

#if key.to_lower() == "stat_dodge" and stat_value > RunData.effects["dodge_cap"]:
#		value_text += " | " + str(RunData.effects["dodge_cap"] as int)
#	elif key.to_lower() == "stat_max_hp" and RunData.effects["hp_cap"] < 9999:
#		value_text += " | " + str(RunData.effects["hp_cap"] as int)
