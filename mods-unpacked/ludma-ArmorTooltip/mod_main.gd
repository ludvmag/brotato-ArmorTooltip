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

	# Add extensions
	modLoader.install_script_extension(ext_dir + "ui/menus/shop/item_description.gd")
	# modLoader.install_script_extension(ext_dir + "singletons/run_data.gd")
		
func _ready():
	ModLoaderUtils.log_info("Done", MYMODNAME_LOG)
