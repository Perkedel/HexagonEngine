#if TOOLS
using Godot;
using System;

[Tool]
public partial class QuickPrimitives : EditorPlugin
{
	Control dock;
	
	public override void _EnterTree()
	{
		dock = (Control)GD.Load<PackedScene>("addons/quick_primitives/Dock_buttons.tscn").Instantiate();
		AddControlToDock(DockSlot.LeftUl, dock);
		
	}

	public override void _ExitTree()
	{

		RemoveControlFromDocks(dock);
		dock.Free();
	}
}
#endif
