using Godot;
using System;

[Tool]
public partial class ColorPickerButton : Godot.ColorPickerButton
{
	[Export] ColorButton btn;
	Color color = new Color(1,0,0);
	EditorInterface edi;
	EditorSelection eds;
	
	public override void _EnterTree()
	{
		ColorChanged += ColorizeSelection;
	}
	
	public void ColorizeSelection(Color color)
	{
		btn = GetParent().GetNode("Button") as ColorButton;
		btn.color = color;
	}
}
