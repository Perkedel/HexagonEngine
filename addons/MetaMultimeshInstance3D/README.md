Meta Multimesh Instance 3D
==

![Logo](addons/MetaMultimeshInstance3D/MMI3Dicon_cleaned.svg "MetaMultimesh3D Logo")

This is a simple addon that will let you take control of your multimeshes in the editor. Simply enable the addon and then add "MetaMultimeshInstance3D" from the nodes selector to your scene.

(The addon does nothing at runtime. It's only a Multimesh at that point.)

1. Place any number of MeshInstances under it (as children) and it will use their position, scale and rotations, as well as the first mesh ecountered, to populate a MeshInstance3D for you.
2. You can "explode" the instances inside a multimesh out into MeshInstances again, where you can transform and then "implode" them back into the multimesh. You can go back and forth like this.
3. There's also a second button that will make collision shapes according to your choice.

Video Tutorial
--
[![](https://img.youtube.com/vi/jEvUMjBwQQM/0.jpg)](https://www.youtube.com/watch?v=jEvUMjBwQQM "Video tutorial.")

HTH

dbat


