class_name Complex extends Object

var real: float
var imag: float


func _init(re: float,im: float):
	real = re
	imag = im

func sum(x) -> Complex:
	if x is Complex:
		return Complex.new(real+x.real, imag+x.imag)
	else:
		return Complex.new(real+x, imag)

func sub(x) -> Complex:
	if x is Complex:
		return Complex.new(real-x.real, imag-x.imag)
	else:
		return Complex.new(real-x, imag)

func mul(x) -> Complex:
	if x is Complex:
		return Complex.new(real*x.real-imag*x.imag, real*x.imag+imag*x.real)
	else:
		return Complex.new(real*x, imag*x)
		
func div(x) -> Complex:
	if x is Complex:
		var den = x.mod2()
		return Complex.new((real*x.real+imag*x.imag)/den, (imag*x.real-real*x.imag)/den)
	else:
		return Complex.new(real/x, imag/x)

func pow(x) -> Complex:
	var mo = mod()
	var ph = phase()

	var ans_ph = Complex.new(log(mo), ph)
	ans_ph = ans_ph.mul(x)
	
	return ans_ph.exp()

func conj() -> Complex:
	return Complex.new(real, -imag)

func mod2() -> float:
	return real*real+imag*imag

func mod() -> float:
	return sqrt(mod2())

func phase() -> float:
	return atan2(imag, real)

func sqrt() -> Complex:
	return self.pow(0.5)

func exp() -> Complex:
	var m = exp(real)
	return Complex.new(cos(imag), sin(imag)).mul(m)

func log() -> Complex:
	var m = mod()
	var p = phase()
	return Complex.new(log(m), p)
	
func sin() -> Complex:
	return self.exp().sub(self.conj().exp()).div(Complex.new(0, 2))
	
func cos() -> Complex:
	return self.exp().sum(self.conj().exp()).div(2.0)

func repr() -> String:
	return str(real) + ('+' if imag >= 0 else '') + str(imag) + 'i'
