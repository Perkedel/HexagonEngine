using System;

namespace Calcatz.EzpzInspector {

    [AttributeUsage(AttributeTargets.Method)]
    public partial class ExportButtonAttribute : Attribute {

        public ExportButtonAttribute() {

        }

    }

}
