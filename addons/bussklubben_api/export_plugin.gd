extends EditorExportPlugin

const LOGO_FILE = "images/logo.png"
const EXPORT_FOLDERS = ["images/", "fonts/"]
const EXPORT_FILES = ["index.css", "images/spinner.svg",
"fonts/dosis-v18-latin-600.svg", "fonts/dosis-v18-latin-600.ttf", "fonts/dosis-v18-latin-600.woff", "fonts/dosis-v18-latin-600.woff2",
"fonts/dosis-v18-latin-700.svg", "fonts/dosis-v18-latin-700.ttf", "fonts/dosis-v18-latin-700.woff", "fonts/dosis-v18-latin-700.woff2",
"fonts/dosis-v18-latin-800.svg", "fonts/dosis-v18-latin-800.ttf", "fonts/dosis-v18-latin-800.woff", "fonts/dosis-v18-latin-800.woff2",
"fonts/dosis-v18-latin-regular.svg", "fonts/dosis-v18-latin-regular.ttf", "fonts/dosis-v18-latin-regular.woff", "fonts/dosis-v18-latin-regular.woff2"]

var update_export_options := true
var export_path := ""
var plugin_path: String = get_script().resource_path.get_base_dir()
var export_web := false
var export_logo := false

func _get_name() -> String:
	return "BussklubbenAPI Export"

func _get_export_options(platform: EditorExportPlatform) -> Array[Dictionary]:
	if platform is EditorExportPlatformWeb:
		return [
			{
				"option": {
					"name": "include_placeholder_bussklubben_logo",
					"type": TYPE_BOOL
				},
				"default_value": true
			}
		]
	return []

func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
	if features.has("web"):
		export_web = true
		export_path = path
		export_logo = false
		if has_method("get_option") and get_option("include_placeholder_bussklubben_logo"):
			export_logo = true

func _export_end() -> void:
	if export_web:
		if export_logo:
			DirAccess.copy_absolute(plugin_path.path_join(LOGO_FILE), export_path.get_base_dir().path_join(LOGO_FILE))
		for folder in EXPORT_FOLDERS:
			DirAccess.make_dir_absolute(export_path.get_base_dir().path_join(folder))
		for file in EXPORT_FILES:
			DirAccess.copy_absolute(plugin_path.path_join(file), export_path.get_base_dir().path_join(file))

	export_web = false

func _should_update_export_options(platform: EditorExportPlatform) -> bool:
	if not platform is EditorExportPlatformWeb: return false
	var u = update_export_options
	update_export_options = false
	return u
