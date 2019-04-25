extends CanvasLayer


var scenePath = ""
const defaultAnimationSpeed = 2.0
var animationSpeed = defaultAnimationSpeed
var doVolumeAnim = false
onready var startingBusVolume = AudioServer.get_bus_volume_db(0)
var muteBusVolume = -80

export var forAnimDb = 1.0 setget setForAnimDb

func setForAnimDb(value):
	if doVolumeAnim:
		forAnimDb = value
		AudioServer.set_bus_volume_db(0, muteBusVolume + forAnimDb*-1*(muteBusVolume - startingBusVolume))


func transitionTo(scene, speed = 1, includeSound = false):
	scenePath = scene
	animationSpeed = defaultAnimationSpeed * speed
	doVolumeAnim = includeSound
	$fadeAnimation.play("fadeOut", -1, animationSpeed)
	

func _on_fadeAnimation_animation_finished(anim_name):
	if anim_name == "fadeOut":
		var results = get_tree().change_scene(scenePath)
		if results != OK:
			print("error changing scene")
			return
		get_tree().paused = false
		$fadeAnimation.play("fadeIn", -1, animationSpeed)


