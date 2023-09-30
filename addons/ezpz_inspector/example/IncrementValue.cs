using Calcatz.EzpzInspector;
using Godot;
using System;

namespace Calcatz.Example {

    [Tool]
    public partial class IncrementValue : Node {

        [Export]
        private int _currentValue = 0;

        [ExportButton]
        private void Increment() {
            _currentValue++;
        }

        // [Tool] attribute is required, but it also makes our code executed in editor.
        // In that case, if you don't want your code to be executed in editor, use Engine.IsEditorHint()

        public override void _Ready() {
            if (Engine.IsEditorHint()) return;
            // Write execution here ...
        }

        public override void _Process(double delta) {
            if (Engine.IsEditorHint()) return;
            // Write execution here ...
        }

    }

}