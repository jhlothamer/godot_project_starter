# Godot Project Starter
This is a starter project for Godot Engine 3.1.  To use simply clone or download this repo.  Then copy the "game" folder to another location and rename it.  You'll then be able to open the copied project in Godot and start updating.

## Why use a Project Starter?
There are a few things every game should have, even a quick project hacked out during a game jam.  Such things are

- A title
- Crediting the work of others you use
- Instructions on how to play the game
- Transition affects between scenes (Ok, not a must, but nice!)
- Soundtrack changing per scene (Again, not a must, but nice!)

All of this is somewhat configurable, but you can also completely modify the scenes if you want, or even replace them.  But for a game jam, or a simple prototype build where you don't want or can't spend the time on such things, this project may be for you.

## The Minimum You Should Change
If you use this project starter then they are a few things you'll want to change.  The rest is optional.

1. Update The project name in the Project Settings.  (Application > Config > Name)  This will be loaded by the title scene.  If you don't do this the title will say "Godot Project Starter".
2. Update the howToPlay.txt file (located at scenes\howToPlay\howToPlay.txt)  If you don't you'll get some generic instructions that probably don't fit your game.
3. In the howToPlay scene, update the the playBtn control to refer to your game scene in it's Scene To Load property.  By default this just sends the player back to the title scene.


## What's Configurable?

### Title Scene Game Title
The Title scene uses the configured application name for the title.  Just change the Name under Application > Config in the Project Settings.  Note: this will take affect at runtime only.

### Credits Scene Text
The Credits scene loads it's text from the credits.txt file.  Just update this file to give credit for any asset or component you need to.  It's ALWAYS a good idea to list credit for any asset you don't own.

### How to Play Text
the How to Play scene load's it's text from the howToPlay.txt file.  Just update this file to provide instructions about your game.  Note: The How to Place scene is shown before every game sesson by default.

### Title/Credits/How To Play scene Background Color
The background color of these three scenes is controlled by the background color of the Title scene.  Just change the color of the Self Modulate property on the root node for the Title scene to configure the color the way you want.

### Per Scene Soundtrack
The project comes with a Soundtrack manager class that is autoloaded by default.  It looks for scene changes and switches the sound track if the scene name has a configured sound track.  This is configured in the soundTrackMgr_config.json file.  Just list the scene name along with a sound track resource path.  Additionally you need to indicate the soundtrack to play on start up.  The following in an example configuration.
```
{
	"title": {
		"start_up" : "true",
		"resource_path": "res://assets/music/title.ogg"
	},
	"howToPlay": {
		"resource_path": "res://assets/music/howToPlay.ogg"
	}
}
```

### What Scene a Button "Goes" to
The buttons have a custom property called "Scene To Load".  Just set this to the resource path of the scene you want to transition to when the button is clicked.

### Button Transition Speed and Sound Fade Out/In
The buttons use the transition manager, which allows for a fade out/in affect when switching scenes.  You can set the transition speed (in seconds) and whether the audio fades out/in.

## Other Goodies
### Signal Manager
Signals are a greate feature of the Godot Engine that allows for flexible component interactions and development.  But the connection of components can be time consuming and not as pleasant when dealing with dynamically created objects.  The signal manager helps with this by allowing the registration of publishers and subscribers of these signals.  Here's how it works.

Whenever a component is created, the Godot Engine calls the _ready function.  this is the time when a component registers itself with the signal manager.  If it's registering as a subscriber of a signal, then it will be automatically conntected with any component that registers as a publisher of that signal.  Obviously it's the other way around for a publisher.  But order doesn't matter, so you don't have to worry about having one component created first specifically.

Here's an example component with a signal it want's to pubish.

```
#Foo.gd
signal my_signal()

func _ready():
	SignalMgr.register_publisher(self, "my_signal")
```

And here's a subscriber registering to be connected to the publisher for that signal.

```
#Bar.gd
func _ready():
	SignalMgr.register_subscriber(self, "my_signal", "on_my_signal")

func on_my_signal():
	print("my_signal sent")
```

Now the publisher just emits the signal as usual with emit_signal.
