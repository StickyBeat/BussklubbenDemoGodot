extends Object

class_name BussklubbenAPI

# Hides the loader
static func game_loaded() -> void:
	if OS.has_feature("web"):
		if JavaScriptBridge.eval("window.ClubHouseGame != null"):
			JavaScriptBridge.eval("window.ClubHouseGame.gameLoaded({hideInGame: true,});")

# Set the current player score
static func set_score(score : int) -> void:
	if OS.has_feature("web"):
		if JavaScriptBridge.eval("window.ClubHouseGame != null"):
			JavaScriptBridge.eval("window.ClubHouseGame.setScore(%s);" % str(score))

# Signal that the game is done and that the leaderboard should be shown
static func game_done() -> void:
	if OS.has_feature("web"):
		if JavaScriptBridge.eval("window.ClubHouseGame != null"):
			JavaScriptBridge.eval("window.ClubHouseGame.gameDone();")

# Register restart callback that the wrapper can call
static func register_restart(restart) -> void:
	if OS.has_feature("web"):
		if JavaScriptBridge.eval("window.ClubHouseGame != null"):
			var window = JavaScriptBridge.get_interface("window")
			window.ClubHouseGame.registerRestart(restart)
