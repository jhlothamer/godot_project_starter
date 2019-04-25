extends Button

export (String) var sceneToLoad = ""
export (float) var transitionSpeed = 2.0
export (bool) var fadeSound = false

func _on_Button_pressed():
	if sceneToLoad == null || sceneToLoad == "":
		return
	transitionMgr.transitionTo(sceneToLoad, transitionSpeed, fadeSound)
