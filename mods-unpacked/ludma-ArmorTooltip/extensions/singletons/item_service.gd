extends "res://singletons/item_service.gd"

func _ready():
	var ehp_stat = load("res://mods-unpacked/ludma-ArmorTooltip/Scenes/ehpmod_stat_ehp.tres")
	stats.append(ehp_stat)
