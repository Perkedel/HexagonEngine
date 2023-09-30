#if TOOLS
using Godot;
using System;
using System.Collections.Generic;
using System.Reflection;

namespace Calcatz.EzpzInspector {

    public partial class CustomInspectorPlugin : EditorInspectorPlugin {

        private Dictionary<string, Type> typeCache = new Dictionary<string, Type>();

        private Dictionary<Type, MethodInfo[]> methodCache = new Dictionary<Type, MethodInfo[]>();

        internal void Init() {
            typeCache = new Dictionary<string, Type>();
            methodCache = new Dictionary<Type, MethodInfo[]>();
        }

        internal void Clear() {
            typeCache.Clear();
            methodCache.Clear();
            typeCache = null;
            methodCache = null;
        }

        private MethodInfo[] GetExportedButtonMethods(Type type) {
            var methods = new List<MethodInfo>();
            var typeInfo = type.GetTypeInfo();

            while (true) {
                foreach (var m in typeInfo.DeclaredMethods) {
                    var exportButton = m.GetCustomAttribute<ExportButtonAttribute>();
                    if (exportButton != null) {
                        methods.Add(m);
                    }
                }

                Type type2 = typeInfo.BaseType;
                if (type2 == typeof(Node) || type2 == null) {
                    break;
                }
                typeInfo = type2.GetTypeInfo();
            }

            return methods.ToArray();
        }

        public override bool _CanHandle(GodotObject @object) {
            var script = @object.GetScript().As<CSharpScript>();
            if (script != null && !string.IsNullOrEmpty(script.ResourcePath)) {
                if (!typeCache.TryGetValue(script.ResourcePath, out var type)) {
                    var temp = script.New().AsGodotObject();
                    type = temp.GetType();
                    temp.Free();
                    typeCache.Add(script.ResourcePath, type);

                    var methods = GetExportedButtonMethods(type);
                    if (methods.Length > 0) {
                        methodCache.Add(type, methods);
                    }
                }
                return methodCache.ContainsKey(type) && methodCache[type].Length > 0;
            }
            return false;
        }

        public override void _ParseCategory(GodotObject @object, string category) {
            foreach (var kvp in methodCache) {
                if (category != kvp.Key.Name) continue;

                foreach (var method in kvp.Value) {
                    var button = new Button();
                    string methodName = method.Name;
                    button.Text = methodName;
                    button.Pressed += () => {
                        if (@object.HasMethod(methodName)) {
                            @object.Call(methodName);
                        }
                    };
                    AddCustomControl(button);
                }
            }
        }

    }

}
#endif