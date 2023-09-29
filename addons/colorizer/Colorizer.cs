#if TOOLS
using Godot;
using System;

[Tool]
public partial class Colorizer : EditorPlugin
{
	Control dock;
	
	public override void _EnterTree()
	{
		dock = (Control)GD.Load<PackedScene>("addons/colorizer/Dock_colors.tscn").Instantiate();
		AddControlToDock(DockSlot.LeftUl, dock);
	}

	public override void _ExitTree()
	{
		RemoveControlFromDocks(dock);
		dock.Free();
	}
	
}
#endif
