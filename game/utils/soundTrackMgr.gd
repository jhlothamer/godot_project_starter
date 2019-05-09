extends Node

var config : Dictionary = {}
var configPath = "res://utils/soundTrackMgr_config.json"

var currentSceneBeingPlayed = null
export var debug : bool = false

func _ready():
	load_config()
	var results = get_tree().connect("node_added", self, "on_node_added")
	if results != OK:
		print("Error connecting to tree node_added signal")
	call_deferred("init")

func debug_out_folder_files(path):
	print(path)
	print("================================")
	var dir = Directory.new()
#	if !dir.dir_exists(path):
#		print("dir does not exist: " + path)
#		return
	if dir.open(path) != OK:
		print("dir did not open: " + path)
		return
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while (file_name != ""):
		if dir.current_is_dir():
			print("Found directory: " + file_name)
		else:
			print("Found file: " + file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
	

func init():
	for sceneName in config.keys():
		if config[sceneName].has("start_up") && config[sceneName].has("resource_path"):
			var resource = get_resource(sceneName)
			if resource != null:
				$soundTrack.stream = resource
				$soundTrack.play()
				currentSceneBeingPlayed = sceneName
			else:
				debug_print("sound track manader did not get resource for scene " + sceneName)
			return
	debug_print("soundtrack manager did not find a startup track")


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
		debug_print("soundtrack manager found cached resource for scene " + sceneName)
		return sceneConfig["resource"]
	
	var file = File.new()
	var path = sceneConfig["resource_path"]
	
	if !file.file_exists(path):
		var fileName = path.get_file()
		if fileName != null:
			#see if we have the import path and use that instead
			#this is to get around certain files not being in export even when added to export extentions list (like ogg)
			var importPath = find_import_path(fileName) # "res://.import/" + fileName + "str"
			if importPath != null:
				debug_print("using import file " + importPath)
				path = importPath
				sceneConfig["resource"] = load(path)
			else:
				debug_print("did not find import file for " + fileName)
				debug_print("soundtrack manager did not find scene " + sceneName + " resource at " + path)
				sceneConfig["resource"] = null
		else:
			debug_print("resource path seems to be invalid: " + path)
			sceneConfig["resource"] = null
	else:
		debug_print("soundtrack manager loading resource for scene " + sceneName + " from " + path)
		sceneConfig["resource"] = load(path)
	file.close()
	return sceneConfig["resource"]

func load_config():
	var configFile = File.new()
	if !configFile.file_exists(configPath):
		debug_print("did not find soundtrack config file " + configPath)
		configFile.close()
		return
	configFile.open(configPath, File.READ)
	var txt = configFile.get_as_text()
	debug_print("loaded sound track config " + txt)
	configFile.close()
	if txt == null || txt == "":
		return
	var results = JSON.parse(txt)
	if results.error != OK:
		debug_print("error loading spawn config: " + results.error_string)
		return
	config = results.result

func find_import_path(fileName):
	var hits = []
	var dir = Directory.new()
	if dir.open("res://.import") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if !dir.current_is_dir():
				var index = file_name.find(fileName)
				if index > -1:
					if !file_name.ends_with("md5"):
						hits.append(file_name)
			file_name = dir.get_next()
	else:
		debug_print("An error occurred when trying to access the path.")
	if hits.size() == 1:
		return "res://.import/" + hits[0]
	return null

func debug_print(message):
	if !debug:
		return
	print(message)
	
