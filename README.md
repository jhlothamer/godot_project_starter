# Godot Project Starter
This is a starter project for Godot Engine 3.x. To use simply clone or download this repository. Then copy the "game" folder to another location and rename it. You'll then be able to open the copied project in Godot and start updating.

## Why use a Project Starter?
There are a few things every game should have, even a quick project hacked out during a game jam. Such things are

- A title
- Crediting your work and the works of others
- Instructions on how to play the game
- Transition affects between scenes
- A hud (heads up display) with Pause and Game Over dialogs

All of this is somewhat configurable, but you can also completely modify the scenes if you want, or even replace them. But for a game jam, or a simple prototype build where you don't want or can't spend the time on such things, this project may be for you.

In addition to the above items the start pack comes with these other goodies!

- TransitionMgr singleton - transition smoothly from scene to scene via code
- ScreenshotMgr singleton - capture frame images for screenshots in game
- Cover Image Generator scene - generate properly sized cover images for itch.io and other game hosting sites


## The Minimum You Should Change
If you use this project starter then they are a few things you'll want to change. The rest is optional.

1. Update The project name in the Project Settings. (Application > Config > Name) This will be loaded by the title scene. If you don't do this the title will say "Godot Project Starter".
2. Update the how_to_play.txt file (located at assets\data\how_to_play.txt)
3. In the howToPlay scene, update the the PlayBtn control to refer to your game scene in it's Scene To Load property. By default this just sends the player back to the title scene.
4. Update the credits.txt file (located at assets\data\credits.txt).

## What's Configurable?

### Title Scene Game Title
The Title scene uses the configured application name for the title. Just change the Name under Application > Config in the Project Settings. Note: this will take affect at runtime only.

### Credits Scene Text
The Credits scene loads it's text from the credits.txt file. Just update this file to give credit for any asset or component you need to. It's ALWAYS a good idea to list credit for any asset you don't own.

### How to Play Text
The How to Play scene load's it's text from the how_to_play.txt file. Just update this file to provide instructions about your game. Note: The How to Place scene is shown before every game session by default.

### What Scene a Button Transitions To
The buttons have a custom property called "Scene To Load". Just set this to the resource path of the scene you want to transition to when the button is clicked.

### Button Transition Speed and Sound Fade Out/In
The buttons use the transition manager (see below), which allows for a fade out/in affect when switching scenes. You can set the transition speed (in seconds) and whether the audio fades out/in. Note that a speed of zero or less will cause the default speed to be used. That speed is found in the Project Settings -> Globals -> Transition Mgr Default Speed.

## Pause and Game Over Dialogs
The pause and game over dialogs are contained in a scene called a hud.  To include the dialogs in your game, just instance the hud scene into your game's scene.

### Pause Dialog
The pause dialog is setup to automatically appear when the "pause" action is pressed.  This action is set up in the Input Map in the Project Settings.  Out of the box the pause dialog will popup when the escape key or start button on a gamepad are pressed.

The pause dialog has 3 buttons: a resume, restart and main menu button.  Resume hides the pause menu.  Restart does nothing out of the box: you'll have to set the "Scene To Load" property to your games main scene or connect the button's pressed event to a new function.  The main menu button takes the player to the title scene.

### Game Over Dialog
The game over dialog automatically appears when the "game_over" action is "pressed".  Of course, there's no button for this.  You must send this action in code to initiate the game over dialog.  Here's the code for that.

> 	var a = InputEventAction.new()<br>
> 	a.action = "game_over"<br>
> 	a.pressed = true<br>
> 	Input.parse_input_event(a)

### Other Dialogs
You can add additional dialogs by creating a new Control scene with DialogBackground child node and the additional dialog buttons/controls you need to add.

Whenever the custom control appears, either in reaction to an event or by command, you'll want to set the paused property of the scene tree to true to pause the game.  And don't forget to set it back to false when the dialog disappears.

## Other Goodies
### Transition Manager
The transition manager is a singleton that manages the transition between scenes. It simply fades the screen to black, switches scenes and then fades back in. It can also fade out the main audio bus's so the difference in background music isn't as jarring.

The Transition manager, called TransitionMgr, has only one public function called transition_to. It accepts a scene path, transition speed (in seconds) and a flag indicating if the main audio bus should be faded out and in as well.

A speed of transition no longer needs to be passed into the transition_to function. When speed isn't provided to the function, a new project setting (Project Settings -> Globals -> Transition Mgr Default Speed) is used. This allows you to set the speed for the while project in one place and override it for special cases.

### Screenshot Manager
The screenshot manager is a singleton that takes screenshots each frame and saves them to a new folder in the app data folder for the game. This new folder's name is based on the current date/time. Screenshots are toggled on and off by activating the "toggle_screenshots" action. Once activated a screenshot will be taken each frame until deactivated or a max number of files is created. This will allow you to either choose the best shot during an action sequence or combine the images into an animated GIF. (You can use a site like ezgif.com to make animated gifs.)

#### How to Make It Work
The screenshot manager is disabled by default. To enable it you must add a key/button binding to the "toggle_screenshots" action in the Input Map. Out of the box this action has none and so no screenshots can be taken with the manager. This is to keep players from accidentally activating the manager.

#### Disabled for Release Exports
The screenshot manager also frees itself for release exports (i.e. when you uncheck "Export With Debug" when exporting the project). Translation: you can only use it during debugging or debug exports. If you want to change this, just update the screenshot_mgr.gd script.

#### Project Settings

The screenshot manager has several settings located in the Project Settings under the Global section. They are:

- Screenshot Mgr Max Images - the maximum number of screenshots taken at a time. Default is 1000.
- Screenshot Mgr Resize Factor - Use this to shrink (or enlarge) the images saved. Default is 1.0 - so no resizing by default.
- Screenshot Mgr Toggle Action Name - defaulted to "toggle_screenshots".

### Cover Image Generator Scene
Creating a cover image for sites like itch.io is easy to do with game assets added to this non-game scene. Just add the assets, labels and animations and hook up the start of any animations with the start/stop button. This scene will capture screenshots that are cropped to the size of the "Cover" control node in the scene.

## Where Did the SoundTrackMgr and SignalMgr Components go?
If you used the project starter in the past you may have used the SoundTrackMgr and SignalMgr components. These are no longer included in the project starter but instead can be found Godot Helper Pack which is an add-on pack containing many useful components to make developing in GDScript easier. You can download the helper pack [here](https://github.com/jhlothamer/godot_helper_pack).

