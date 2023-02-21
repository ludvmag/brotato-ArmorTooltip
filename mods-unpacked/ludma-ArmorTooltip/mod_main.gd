extends Node

const MOD_DIR = "ludma-ArmorTooltip/"
const MYMODNAME_LOG = "ludma-ArmorTooltip"

var dir = ""
var ext_dir = ""
var trans_dir = ""

func _init(modLoader = ModLoader):
	ModLoaderUtils.log_info("Init", MYMODNAME_LOG)
	dir = modLoader.UNPACKED_DIR + MOD_DIR
	ext_dir = dir + "extensions/"
	trans_dir = dir + "translations/"


	# Add translations
	modLoader.add_translation_from_resource(trans_dir + "ludma_ehpmod_Translation.en.translation")
	# Add extensions
	modLoader.install_script_extension(ext_dir + "ui/menus/shop/item_description.gd")
	modLoader.install_script_extension(ext_dir + "ui/menus/shop/stat_popup.gd")
	modLoader.install_script_extension(ext_dir + "singletons/utils.gd")
	modLoader.install_script_extension(ext_dir + "singletons/item_service.gd")

func _ready():
	add_EHP_Stats()
	ModLoaderUtils.log_info("Done", MYMODNAME_LOG)

func add_EHP_Stats()->void:
	var ehp_container_scene_path = "res://mods-unpacked/ludma-ArmorTooltip/Scenes/EHPContainer.tscn"
	var ehp_container = load(ehp_container_scene_path).instance()

	var stats_container_scene_path = "res://ui/menus/shop/stats_container.tscn"
	var stats_container_scene = load(stats_container_scene_path).instance()
	
	var primary_stats_container = stats_container_scene.get_node('MarginContainer').get_node('VBoxContainer2').get_node('PrimaryStats')

	primary_stats_container.add_child(ehp_container, true)
	ehp_container.set_owner(stats_container_scene)

	ModLoader.save_scene(stats_container_scene, stats_container_scene_path)
