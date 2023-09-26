# XRController Midi Player ![icon](icon.png)
A Godot Engine node which can play .mid files on the vibration motor of XR controllers. 

## Getting started
1. Add the plugin to your Godot project using the asset library
2. Add the ![icon](icon.png) XRControllerMidiPlayer node to your scene
3. Provide the path to a .mid file in the node inspector
4. Add any XRInterface node you like to the node 
```
midi_player = $XRControllerMidiPlayer
midi_player.xr_interfaces.append($XRController3D_r)
midi_player.xr_interfaces.append($XRController3D_l)
```
5. Start the song
```
midi_player.play()
```

## Node settings
You can change those in the node inspector.

### midi_file
The path to the .mid file which will be loaded when play() is called.

### xr_interfaces
Array of XRInterface objects which will be used to play on.

### amplitude
The strength of the vibration. 0 = off, 1 = maximum

### play_speed
Play speed multiplier.

### overlap_tracks
Midi files can have more tracks than you XRInterfaces.

This option will try to spread the tracks equally over your XRInterfaces.

This will work in most cases but may end in obscure chaos for some complex midi files. If you disable it the player will just use 1 track per XRInterface and discard all further tracks.

## License
MIT
