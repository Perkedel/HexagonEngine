using Godot;
using System;

[Tool]
public partial class Button : Godot.TextureButton
{
	public override void _EnterTree()
	{
		Pressed += CreatePrimitive;
	}

	public void Clicked()
	{
		GD.Print("You clicked me!");
		// OS.ShellOpen("https://formation-facile.fr/");
		
	}
	
	public void CreatePrimitive()
	{
		var cubeScene = GD.Load<PackedScene>("res://addons/quick_primitives/scenes/"+this.Name+".tscn");
		
		var cubeNode = cubeScene.Instantiate();
		
		GetTree().EditedSceneRoot.AddChild(cubeNode);
		
		GD.Print("Added " + this.Name + " to " + GetTree().EditedSceneRoot.Name + " node.");
		
		cubeNode.Owner = GetTree().EditedSceneRoot;
	}
}
