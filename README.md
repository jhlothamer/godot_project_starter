looking for a Godot 3 version?  Please see the master branch.
# Godot 4.x Project Starter
This is a starter project for Godot Engine 4.x. To use simply clone or download this repository. Then copy the "game" folder to another location and rename it. You'll then be able to open the copied project in Godot and start updating.

## Why use a Project Starter?
There are a few things every game should have, even a quick project hacked out during a game jam. Such things are

- A title
- Crediting your work and the works of others
- Instructions on how to play the game
- Transition affects between scenes
- A HUD (heads up display) with Pause, Game Over and Settings dialogs

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
5. Update the input_map_setting_cfg.json file so input actions can be rebound by the player. (located at assets\data\input_map_setting_cfg.json). Alternatively you can remove the Settings buttons found on the title and pause dialog scenes. See below for more details.

## What's Configurable?

### Background of Title, Credit, How to Play Scenes
These scenes all use another scene for their background/background color. It's called scene_background. It's located in the same folder these other scenes are (scenes/etc).

To change the background color of all these scenes, just modify the Self Modulate color on scene_background.

### Theme
The Godot project starter uses Godot's theme system. The theme resource file used can be found in assets/themes and is called global.tres. You can modify fonts, colors, etc. for buttons, labels, edit, text edits, etc. by double clicking on this file in the Godot file system dock and use the theme editor that shows up.

#### Titles
Title labels in the project starter use a different theme than the global one described above. Instead they use the title theme (resource file is title.tres located in the assets/themes folder). This way titles can be given different fonts and other theme settings than regular labels.

#### Fonts
There are three font resources for titles, buttons and text. These are located in assets/fonts. To update the font of all titles, buttons or text provided in the project starter, just change the settings of these resources. The global theme (above) also uses the resources.

### Title Scene Game Title
The Title scene uses the configured application name for the title. Just change the Name under Application > Config in the Project Settings. Note: this will take affect at runtime only.

There are buttons on the title screen to start a New Game (goes to how to play scene by default), go to the Settings scene, view game Credits and Exit the game. Note that the Exit button is automatically hidden for HTML5 exports.

### Credits Scene Text
The Credits scene loads it's text from the credits.txt file, which is located in the assets/data folder. Just update this file to give credit for any asset or component you need to. It's ALWAYS a good idea to list credit for any asset you don't own.

### How to Play Text
The How to Play scene load's it's text from the how_to_play.txt file, which is located in the assets/data folder. Just update this file to provide instructions about your game. Note: The How to Place scene is shown before every game session by default.

### Settings
The project starter comes with a Settings UI that allows for bus volumes and input map bindings to be set by the player.

#### Volume Settings
The project starter has 3 buses and therefore 3 separate settings for volume the player can set. This is Master, Music and SoundFx.

Be sure to set the bus on AudioStreamPlayer nodes to the appropriate audio bus.

#### Control Settings
The project starter allows players to set input action event bindings. To set what can be bound update the input_map_setting_cfg.json file located in the assets/data folder.

#### input_map_setting_cfg.json
Hopefully most of the settings that can be configured are self-explanatory. But here are the following properties that can be set and what they do.

- settings_save_file_path - where the player's settings are saved. This should be in the user:// folder.
- bindings_per_action - how many event bindings can be set. Think of these as being "primary" (for right-handers), "secondary" (for left-handers) and "game pad" (if your game supports game pads)
- binding_colum_names - these names are shown in the UI
- binding_column_types - the types of events allowed for each binding. These types are "key" (keyboard button), "mouse" (mouse button) and "pad" (game pad button). To allow for more than one type for a binding column use the pipe character ("|") in between these types. E.g. "key|mouse" to allow for either key or mouse button events.
- mouse_settings - this JSON object determines if mouse settings should be shown at all, min/max/default mouse sensitivity values and a default value for inverting the y mouse button.
- categories - An array of objects that represent an input map category. Use these to group actions for "movement", "inventory", "weapons", etc.
- - Each category has a name and an actions array, which contains objects with the action_name and display_name for the action. The action_name must match an action configured in your games input map.

#### Player Settings Save Files
The save files are all in JSON format and are formatted with indents to make them easier to read.

The volume settings are saved in user://sound_settings.json. By default input map and mouse settings are stored in user://input_map_settings.json, but can be configured to be stored elsewhere.

#### Obtaining Settings (InputMapMgr Singleton)
Obviously the volume and action event bindings take affect immediately and your game doesn't need to worry about any updates to them. But if your game needs the mouse settings, you'll need to use the InputMapMgr singleton.

##### InputMapMgr.get_mouse_settings()
Use this function to get the InputMouseSettings object with the current sensitivity and invert_y settings.

##### input_settings_updated signal
Connect to the input_settings_updated signal of the InputMapMgr singleton to be alerted when the user has updated any control setting - including the mouse settings. To obtain the updated mouse settings use the InputMapMgr.get_mouse_settings() function.

### What Scene a Button Transitions To
The buttons have a custom property called "Scene To Load". Just set this to the resource path of the scene you want to transition to when the button is clicked.

### Button Transition Speed and Sound Fade Out/In
The buttons use the transition manager (see below), which allows for a fade out/in affect when switching scenes. You can set the transition speed (in seconds) and whether the audio fades out/in. Note that a speed of zero or less will cause the default speed to be used. That speed is found in the Project Settings -> Globals -> Transition Mgr Default Speed.

## In Game Dialogs
The in game dialogs (pause, game over, settings) are contained in a scene called a HUD. To include the dialogs in your game, just instance the hud scene into your game's scene.

### Pause Dialog
The pause dialog is setup to automatically appear when the "pause" action is pressed. This action is set up in the Input Map in the Project Settings. Out of the box the pause dialog will popup when the escape key or start button on a game pad are pressed.

The pause dialog has 3 buttons: a resume, restart and main menu button. Resume hides the pause menu. Restart does nothing out of the box: you'll have to set the "Scene To Load" property to your games main scene or connect the button's pressed event to a new function. The main menu button takes the player to the title scene.

### Game Over Dialog
The game over dialog automatically appears when the "game_over" action is "pressed". Of course, there's no button for this. You must send this action in code to initiate the game over dialog. Here's the code for that.

> var a = InputEventAction.new()<br>
> a.action = "game_over"<br>
> a.pressed = true<br>
> Input.parse_input_event(a)

### Settings Dialog
This dialog is launched from the pause dialog when the Settings button is clicked. If for some reason you do not want the settings dialog available in the game, you can remove the button from the pause dialog.

### Other Dialogs
You can add additional dialogs by creating a new Control scene with DialogBackground child node and the additional dialog buttons/controls you need to add.

Whenever the custom control appears, either in reaction to an event or by command, you'll want to set the paused property of the scene tree to true to pause the game. And don't forget to set it back to false when the dialog disappears.

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
- Screenshot Mgr Frame Delay - Controls how often a frame is saved as a screenshot. This corresponds to the frame delay when making a gif out of the images. Default is 0.1, which corresponds to a frame delay of 10/100 of a second between animated gif frames. This default results in a smoothly animated gif that is also smaller as well as a lot fewer image files being created.

### Cover Image Generator Scene
Creating a cover image for sites like itch.io is easy to do with game assets added to this non-game scene. Just add the assets, labels and animations and hook up the start of any animations with the start/stop button. This scene will capture screenshots that are cropped to the size of the "Cover" control node in the scene.

## Where Did the SoundTrackMgr and SignalMgr Components go?
If you used the project starter in the past you may have used the SoundTrackMgr and SignalMgr components. These are no longer included in the project starter but instead can be found Godot Helper Pack which is an add-on pack containing many useful components to make developing in GDScript easier. You can download the helper pack [here](https://github.com/jhlothamer/godot_helper_pack).

## Assets Used
The Godot Project Starter comes with the following assets. These are listed in the credits.txt file as well and so, by default, the project will credit these assets in the Credits scene.


### Art
The following are is used in displaying input prompts.

"FREE Keyboard and controllers prompts pack" by xelu (https://opengameart.org/content/free-keyboard-and-controllers-prompts-pack) 
licensed under CC0 1.0 (http://creativecommons.org/publicdomain/zero/1.0/)

### Sound
The following sound is played when the player updates the sound effects volume.

bong_001.ogg from "Interface Sounds" by Kenney
https://www.kenney.nl/assets/interface-sounds
License: CC0 1.0 (http://creativecommons.org/publicdomain/zero/1.0/)

### Fonts
The following font is used throughout the project.

https://fontlibrary.org/en/font/jellee-typeface
by Alfredo Marco Pradil
License: OFL (SIL Open Font License) (http://scripts.sil.org/OFL)






