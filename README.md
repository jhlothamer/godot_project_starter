# Godot Project Starter
This is a starter project for Godot Engine 3.2. To use simply clone or download this repository. Then copy the "game" folder to another location and rename it. You'll then be able to open the copied project in Godot and start updating.

## Why use a Project Starter?
There are a few things every game should have, even a quick project hacked out during a game jam. Such things are

- A title
- Crediting your work and the works of others
- Instructions on how to play the game
- Transition affects between scenes

All of this is somewhat configurable, but you can also completely modify the scenes if you want, or even replace them. But for a game jam, or a simple prototype build where you don't want or can't spend the time on such things, this project may be for you.

## The Minimum You Should Change
If you use this project starter then they are a few things you'll want to change. The rest is optional.

1. Update The project name in the Project Settings. (Application > Config > Name) This will be loaded by the title scene. If you don't do this the title will say "Godot Project Starter".
2. Update the how_to_play.txt file (located at assets\data\how_to_play.txt)
3. In the howToPlay scene, update the the playBtn control to refer to your game scene in it's Scene To Load property. By default this just sends the player back to the title scene.
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
The buttons use the transition manager, which allows for a fade out/in affect when switching scenes. You can set the transition speed (in seconds) and whether the audio fades out/in. Note that a speed of zero or less will cause the default speed to be used.  That speed is found in the Project Settings -> Globals -> Transition Mgr Default Speed.

## Other Goodies
### Transition Manager
The transition manager is a singleton that manages the transition between scenes. It simply fades the screen to black, switches scenes and then fades back in. It can also fade out the main audio bus's so the difference in background music isn't as jarring.

The Transition manager, called TransitionMgr, has only one public function called transition_to. It accepts a scene path, transition speed (in seconds) and a flag indicating if the main audio bus should be faded out and in as well.

A speed of transition no longer needs to be passed into the transition_to function.  When speed isn't provided to the function, a new project setting (Project Settings -> Globals -> Transition Mgr Default Speed) is used.  This allows you to set the speed for the while project in one place and override it for special cases.

### Screen Shot Manager
Screenshots are required even for game jams these days, and they're better if they are animated! To create animated GIFs, just add the Screenshot Manager to your scene, add keys/button bindings to the "screen_shot" action, and scoop the the screen shots from the user data folder. Then you can upload them to to a site like ezgif.com to create the GIF file. Here are the options to the Screen Shot Manager.

- Screenshot Max - the maximum number of screenshots taken at a time.
- Resize Factor - Use this to shrink (or enlarge) the images saved.
- Enabled - flag to enable Screenshot Manager.
- Screenshot Action Name - defaulted to "screen_shot", but you can use a different action name if you want.

Since you'll be copying the game, you can modify the defaults and auto load the Screenshot Manager scene in your project so you can collect screenshots in any scene in your game. Just be sure to disable it when you release your game, unless taking screen shots is a feature you want players to use.

### Cover Image Generator Scene
Creating a cover image for sites like itch.io is easy to do with game assets added to this non-game scene.  Just add the assets, labels and animations and hook up the start of any animations with the start/stop button.  This scene will capture screen shots that are cropped to the size of the "Cover" control node in the scene.

## Where Did the SoundTrackMgr and SignalMgr Components go?
If you used the project starter in the past you may have used the SoundTrackMgr and SignalMgr components. These are no longer included in the project starter but instead can be found Godot Helper Pack which is an addon pack containing many useful components to make developing in GDScript easier. You can download the helper pack [here](https://github.com/jhlothamer/godot_helper_pack).
