extends Node

var config : Dictionary = {}
var configPath = "res://utils/soundTrackMgr_config.json"

var currentSceneBeingPlayed = null

func _ready():
	load_config()
	var results = get_tree().connect("node_added", self, "on_node_added")
	if results != OK:
		print("Error connecting to tree node_added signal")
	call_deferred("init")

func init():
	for sceneName in config.keys():
		if config[sceneName].has("start_up") && config[sceneName].has("resource_path"):
			var resource = get_resource(sceneName)
			if resource != null:
				$soundTrack.stream = resource
				$soundTrack.play()
				currentSceneBeingPlayed = sceneName
			return


func on_node_added(node : Node):
	if node.get_parent() != get_tree().root:
		return
	var path = str(node.get_path())
	var sceneName = path.replace("/root/", "")
	play_scene(sceneName)

func play_scene(sceneName):
	if !config.has(sceneName):
		return
	var resource = get_resource(sceneName)
	if resource == null:
		return
	if currentSceneBeingPlayed == sceneName:
		return
	currentSceneBeingPlayed = sceneName
	$soundTrack.stream = resource
	$soundTrack.play()

func get_resource(sceneName):
	var sceneConfig = config[sceneName]
	if sceneConfig.has("resource"):
		return sceneConfig["resource"]
	var file = File.new()
	if !file.file_exists(sceneConfig["resource_path"]):
		sceneConfig["resource"] = null
	else:
		sceneConfig["resource"] = load(sceneConfig["resource_path"])
	file.close()
	return sceneConfig["resource"]

func load_config():
	var configFile = File.new()
	if !configFile.file_exists(configPath):
		configFile.close()
		return
	configFile.open(configPath, File.READ)
	var txt = configFile.get_as_text()
	configFile.close()
	if txt == null || txt == "":
		return
	var results = JSON.parse(txt)
	if results.error != OK:
		print("error loading spawn config: " + results.error_string)
		return
	config = results.result
