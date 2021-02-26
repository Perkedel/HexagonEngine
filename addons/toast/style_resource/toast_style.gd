tool
extends Resource

class_name ToastStyle

enum Position{
	Top,
	Bottom
};

enum Type{
	Float,
	Full
};

export(Position) var position = Position.Bottom;
export(Type) var toastType = Type.Float;

export(Color, RGBA) var backgroundColor = Color( 1, 1, 1, 0.8);
export(Color, RGBA) var fontColor = Color( 0.01, 0.01, 0.01, 1);

export(int) var cornerRadius = 20;
export(float) var contentMarginLeft = 20.0;
export(float) var contentMarginRight = 20.0;
export(float) var contentMarginTop = 10.0;
export(float) var contentMarginBottom = 10.0;

export(int, "Left", "Center", "Right", "Fill") var textAlign = 1;
