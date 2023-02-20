extends "res://singletons/item_service.gd"

func get_stat_small_icon(stat_name:String)->Resource:
	if stat_name != "ehpmod_stat_ehp":
		return .get_stat_small_icon(stat_name)
	
	return load("res://mods-unpacked/ludma-ArmorTooltip/res/ehp_icon.png")
