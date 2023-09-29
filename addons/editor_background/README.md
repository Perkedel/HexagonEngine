# Editor Background
A highly customizable background addon for Godot 4.x!
The current background addons for Godot weren't customizable enough for me which is why I made this addon!

![](background_options.png)

## How to use
Enable the plugin which is located at **Project Settings** > **Plugins** > **Editor Background**.

Go to **Project** > **Tools** > **Background Options...** to open up the Background Options window.

## Fix notice
If somehow the **background_options.tscn** scene gets corrupted:
1. Open **background_options.tscn** in a text editor.
2. Remove lines **3** and **10**.
3. Reload project.
4. Open **background_options.tscn** in Godot.
5. Right click **background_options** node.
6. Click Attach script and load **background_options.gd**.
7. Enable plugin and it should be fixed!

I have absolutely no clue why the scene file keeps getting corrupted. I assume it might be a Godot bug.