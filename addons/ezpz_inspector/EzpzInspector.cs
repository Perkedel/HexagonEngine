#if TOOLS
using Godot;
using System;

namespace Calcatz.EzpzInspector {

	[Tool]
	public partial class EzpzInspector : EditorPlugin {

		private CustomInspectorPlugin inspectorPlugin;

		public override void _EnterTree() {
			inspectorPlugin = new CustomInspectorPlugin();
			inspectorPlugin.Init();
			AddInspectorPlugin(inspectorPlugin);
		}

		public override void _ExitTree() {
			inspectorPlugin.Clear();
			RemoveInspectorPlugin(inspectorPlugin);
		}
	}

}
#endif
