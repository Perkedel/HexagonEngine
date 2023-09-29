@tool

extends Node
class_name BetterRandNumGen
################
#This class attempts to make a more random (normal) distribution of digits generated in the resultant numbers than the Godot's built in PCG (as of Godot 4.0)
# It also does so with no need to 'PRE-randomize' anything
#
# Functions:
#   BetterRandNumGen.randi()							same as RandomNumberGenerator.randi()
#   BetterRandNumGen.randi_range()						same as RandomNumberGenerator.randi_range()
#   BetterRandNumGen.randf()							same as RandomNumberGenerator.randf()
#   BetterRandNumGen.randf_range()						same as RandomNumberGenerator.randf_range()
#   BetterRandNumGen.generate_digits( v_need:int )		generate a string of variable length filled with integers 0-9
#   BetterRandNumGen.get_from_array(x=0,y=0,arrToUse=0)	not intended for external use. Internally used to collect a random digit
#   
#   
################


#In case the class gets called back to back many times, retain the x,y coords from run to run and don't re-calc initial values to save time.
var v_piArrX :int= -1
var v_piArrY :int= -1
var v_sliderArrX  :int= -1
var v_sliderArrY  :int= -1
#testing shows repeated use of the number generator does get slightly faster due to use of the global tracker and not re-calculating the x,y coords.


func randi(): #Landers (10 digits) integer generator
	return int(generate_digits(10))
	
func randi_range(from:int,to:int): #Landers (10 digits) integer generator where integer is bound to the input range
	var v_initialRandom :int = int(generate_digits(10)) 
	var v_rangeBound:int= from +(v_initialRandom / (9999999999/(to-from+1)))
	#var v_rangeBound:int = remap(v_initialRandom, 0, 9999999999, from, to) #depending on input range will sometime fail to EVER produce the to result in testing meaning it is not always actually inclusive. ALso is NOT faster than the above formula.
	return v_rangeBound
	
func randf(): #Landers (10.3 digits) float generator (from 00000000000 to 1.000000000000) Returns a random floating point value between 0.0 and 1.0 (inclusive).
	var v_a = generate_digits(13)
	#print("v_a: "+str(v_a))
	var v_b :float=float(v_a[0]+v_a[1]+v_a[2]+v_a[3]+v_a[4]+v_a[5]+v_a[6]+v_a[7]+v_a[8]+v_a[9]+"."+v_a[10]+v_a[11]+v_a[12])/9999999999.999
	#print(v_b)
	return v_b
	
func randf_range (from:float,to:float): #Landers (10.3 digits) float generator. Returns a random floating point value between from and to (inclusive).
	var v_a = generate_digits(13)
	var v_initialRandom :float= float(v_a[0]+v_a[1]+v_a[2]+v_a[3]+v_a[4]+v_a[5]+v_a[6]+v_a[7]+v_a[8]+v_a[9]+"."+v_a[10]+v_a[11]+v_a[12])
	#print("v_a: "+str(v_a))
	var v_rangeBound :float= from +( v_initialRandom / (9999999999.999/(to-from)))
	#print(v_b)
	return v_rangeBound

func generate_digits(v_need:int=1): #[v_need must be a number greater than 0 (not negative) ] #This can be useful for creating stuffed arrays of strings, representing random integers of varying lengths (eg. map seeds etc.).
	#Initialize variables
	var v_unixTime :String= str(Time.get_unix_time_from_system()) #eg. 1681155797.023   [keep last 3 digits] (milisecond precision)
	var v_microSecs :String= str(Time.get_ticks_usec())	#eg. 308288936    [keep last 5 digits] (microsecond precision)
	#var v_stuffed_arr :String= "" #v_stuffed_arr has length of 8, see below
	var v_seedA :int=0
	var v_seedB :int=0
	var v_seedC :int=0
	var v_seedD :int=0
	var v_seedE :int=0
	var v_seedF :int=0
	var v_seedG :int=0
	var v_seedH :int=0
	var v_randInt :String="" 
	var v_piResponseArray:Array
	var v_performStep = 0
	var v_jumpBy = 0	#how far to jump through the arrays to then identify the next number generated
	var v_sliderRespArr =[]
	if v_unixTime[-1]==".":
		#v_stuffed_arr = "000"+v_microSecs[-1]+v_microSecs[-2]+v_microSecs[-3]+v_microSecs[-4]+v_microSecs[-5];
		v_seedA = 0
		v_seedB = 0
		v_seedC = 0
		v_seedD = int(v_microSecs[-1])
		v_seedE = int(v_microSecs[-2])
		v_seedF = int(v_microSecs[-3])
		v_seedG = int(v_microSecs[-4])
		v_seedH = int(v_microSecs[-5])
	elif v_unixTime[-2]==".":
		#v_stuffed_arr = "00"+v_unixTime[-1]+v_microSecs[-1]+v_microSecs[-2]+v_microSecs[-3]+v_microSecs[-4]+v_microSecs[-5];
		v_seedA = int(v_unixTime[-1])
		v_seedB = 0
		v_seedC = 0
		v_seedD = int(v_microSecs[-1])
		v_seedE = int(v_microSecs[-2])
		v_seedF = int(v_microSecs[-3])
		v_seedG = int(v_microSecs[-4])
		v_seedH = int(v_microSecs[-5])
	elif v_unixTime[-3]==".":
		#v_stuffed_arr = "0"+v_unixTime[-1]+v_unixTime[-2]+v_microSecs[-1]+v_microSecs[-2]+v_microSecs[-3]+v_microSecs[-4]+v_microSecs[-5];
		v_seedA = int(v_unixTime[-1])
		v_seedB = int(v_unixTime[-2])
		v_seedC = 0
		v_seedD = int(v_microSecs[-1])
		v_seedE = int(v_microSecs[-2])
		v_seedF = int(v_microSecs[-3])
		v_seedG = int(v_microSecs[-4])
		v_seedH = int(v_microSecs[-5])
	else : #v_unixTime[-4]=="."
		#v_stuffed_arr = v_unixTime[-1]+v_unixTime[-2]+v_unixTime[-3]+v_microSecs[-1]+v_microSecs[-2]+v_microSecs[-3]+v_microSecs[-4]+v_microSecs[-5]
		v_seedA = int(v_unixTime[-1])
		v_seedB = int(v_unixTime[-2])
		v_seedC = int(v_unixTime[-3])
		v_seedD = int(v_microSecs[-1])
		v_seedE = int(v_microSecs[-2])
		v_seedF = int(v_microSecs[-3])
		v_seedG = int(v_microSecs[-4])
		v_seedH = int(v_microSecs[-5])
	
	#print("is this a first run situation? v_piArrX=-1: "+str(v_piArrX==-1))
	if v_piArrX==-1: #this is an initial run situation. get and store coordinates into global variables
		#initial x,y coordinates for slider array
		#v_sliderArrX = int(v_stuffed_arr[2]+v_stuffed_arr[5])+int(v_stuffed_arr[7])
		#v_sliderArrY = int(v_stuffed_arr[6]+v_stuffed_arr[1])+int(v_stuffed_arr[7])
		v_sliderArrX = int(v_unixTime[-3]+v_microSecs[-3]) +v_seedH
		v_sliderArrY = int(v_microSecs[-4]+v_unixTime[-2]) +v_seedH
		#initial x,y coordinates for pi array
		#v_piArrX = int(v_stuffed_arr[0]+v_stuffed_arr[4])-int(v_stuffed_arr[7])
		#v_piArrY = int(v_stuffed_arr[3]+v_stuffed_arr[1])-int(v_stuffed_arr[7])
		v_piArrX = int(v_unixTime[-1]+v_microSecs[-2]) -v_seedH
		v_piArrY = int(v_microSecs[-1]+v_unixTime[-2]) -v_seedH
		
		
	#Using the captured inputs stored in v_stuffed_arr and the following formula which rotates useage of what and where the variables apply, calculate continuous
	#x,y coordinates then look up the number stored in that position from the v_pi_normal array.
	for n in v_need:
		v_performStep=v_performStep+1
		if v_performStep>12: v_performStep=1
		v_jumpBy = v_seedA + v_seedH + 3*n
		#print("iteration: "+str(n))
		
		#in testing used 'match' function instead of the if statements, however the match was ~400 ms slower on average.
		if v_performStep==1: #shift up/right
			#print("On n="+str(n)+" entered n divisible by 1")
			v_sliderArrX=v_sliderArrX+v_jumpBy
			v_sliderArrY=v_sliderArrY-v_jumpBy
			v_sliderRespArr=get_from_array(v_sliderArrX,v_sliderArrY,1)
			v_piArrX=v_piArrX+(3*int(v_sliderRespArr[0]))
			v_piArrY=v_piArrY-(3*int(v_sliderRespArr[0]))
			v_sliderArrX=v_sliderRespArr[1]
			v_sliderArrY=v_sliderRespArr[2]
			v_piResponseArray=get_from_array(v_piArrX,v_piArrY)
			v_randInt = v_randInt+v_piResponseArray[0]
			v_piArrX = v_piResponseArray[1]
			v_piArrY = v_piResponseArray[2]
			
		elif v_performStep==2:	#shift right
			#print("On n="+str(n)+" entered n divisible by 2")
			v_sliderArrX=v_sliderArrX+v_jumpBy
			v_sliderRespArr=get_from_array(v_sliderArrX,v_sliderArrY,1) #offset is now the semi-randomly selected distance to be jumped through the pi-normalized array prior to selecting our next random number
			v_piArrX=v_piArrX+(3*int(v_sliderRespArr[0]))	#Needs to be a significant jump so multiplying by an odd number (ensures can attain odd resultants)
			v_sliderArrX=v_sliderRespArr[1]
			v_sliderArrY=v_sliderRespArr[2]
			v_piResponseArray=get_from_array(v_piArrX,v_piArrY)
			v_randInt = v_randInt+v_piResponseArray[0]
			v_piArrX = v_piResponseArray[1]
			v_piArrY = v_piResponseArray[2]
			
		elif v_performStep==3:	#shift up/left
			#print("On n="+str(n)+" entered n divisible by 3")
			v_sliderArrX=v_sliderArrX-v_jumpBy
			v_sliderArrY=v_sliderArrY-v_jumpBy
			v_sliderRespArr=get_from_array(v_sliderArrX,v_sliderArrY,1)
			v_piArrX=v_piArrX-(3*int(v_sliderRespArr[0]))
			v_piArrY=v_piArrY-(3*int(v_sliderRespArr[0]))
			v_sliderArrX=v_sliderRespArr[1]
			v_sliderArrY=v_sliderRespArr[2]
			v_piResponseArray=get_from_array(v_piArrX,v_piArrY)
			v_randInt = v_randInt+v_piResponseArray[0]
			v_piArrX = v_piResponseArray[1]
			v_piArrY = v_piResponseArray[2]
			
		elif v_performStep==4:	#shift down
			#print("On n="+str(n)+" entered n divisible by 4")
			v_sliderArrY=v_sliderArrY+v_jumpBy
			v_sliderRespArr=get_from_array(v_sliderArrX,v_sliderArrY,1)
			v_piArrY=v_piArrY+(3*int(v_sliderRespArr[0]))
			v_sliderArrX=v_sliderRespArr[1]
			v_sliderArrY=v_sliderRespArr[2]
			v_piResponseArray=get_from_array(v_piArrX,v_piArrY)
			v_randInt = v_randInt+v_piResponseArray[0]
			v_piArrX = v_piResponseArray[1]
			v_piArrY = v_piResponseArray[2]
			
		elif v_performStep==5:	#shift up/right
			#print("On n="+str(n)+" entered n divisible by 5")
			v_sliderArrX=v_sliderArrX+v_jumpBy
			v_sliderArrY=v_sliderArrY-v_jumpBy
			v_sliderRespArr=get_from_array(v_sliderArrX,v_sliderArrY,1)
			v_piArrX=v_piArrX+(3*int(v_sliderRespArr[0]))
			v_piArrY=v_piArrY-(3*int(v_sliderRespArr[0]))
			v_sliderArrX=v_sliderRespArr[1]
			v_sliderArrY=v_sliderRespArr[2]
			v_piResponseArray=get_from_array(v_piArrX,v_piArrY)
			v_randInt = v_randInt+v_piResponseArray[0]
			v_piArrX = v_piResponseArray[1]
			v_piArrY = v_piResponseArray[2]
			
		elif v_performStep==6:	#shift down/right
			#print("On n="+str(n)+" entered n divisible by 6")
			v_sliderArrX=v_sliderArrX+v_jumpBy
			v_sliderArrY=v_sliderArrY+v_jumpBy
			v_sliderRespArr=get_from_array(v_sliderArrX,v_sliderArrY,1)
			v_piArrX=v_piArrX+(3*int(v_sliderRespArr[0]))
			v_piArrY=v_piArrY+(3*int(v_sliderRespArr[0]))
			v_sliderArrX=v_sliderRespArr[1]
			v_sliderArrY=v_sliderRespArr[2]
			v_piResponseArray=get_from_array(v_piArrX,v_piArrY)
			v_randInt = v_randInt+v_piResponseArray[0]
			v_piArrX = v_piResponseArray[1]
			v_piArrY = v_piResponseArray[2]
			
		elif v_performStep==7:	#shift up
			#print("On n="+str(n)+" entered n divisible by 7")
			v_sliderArrY=v_sliderArrY-v_jumpBy
			v_sliderRespArr=get_from_array(v_sliderArrX,v_sliderArrY,1)
			v_piArrY=v_piArrY-(3*int(v_sliderRespArr[0]))
			v_sliderArrX=v_sliderRespArr[1]
			v_sliderArrY=v_sliderRespArr[2]
			v_piResponseArray=get_from_array(v_piArrX,v_piArrY)
			v_randInt = v_randInt+v_piResponseArray[0]
			v_piArrX = v_piResponseArray[1]
			v_piArrY = v_piResponseArray[2]
			
		elif v_performStep==8:	#shift left
			#print("On n="+str(n)+" entered n divisible by 8")
			v_sliderArrX=v_sliderArrX-v_jumpBy
			v_sliderRespArr=get_from_array(v_sliderArrX,v_sliderArrY,1)
			v_piArrX=v_piArrX-(3*int(v_sliderRespArr[0]))
			v_sliderArrX=v_sliderRespArr[1]
			v_sliderArrY=v_sliderRespArr[2]
			v_piResponseArray=get_from_array(v_piArrX,v_piArrY)
			v_randInt = v_randInt+v_piResponseArray[0]
			v_piArrX = v_piResponseArray[1]
			v_piArrY = v_piResponseArray[2]
			
		elif v_performStep==9:	#shift down/left
			#print("On n="+str(n)+" entered n divisible by 9") 
			v_sliderArrX=v_sliderArrX-v_jumpBy
			v_sliderArrY=v_sliderArrY+v_jumpBy
			v_sliderRespArr=get_from_array(v_sliderArrX,v_sliderArrY,1)
			v_piArrX=v_piArrX-(3*int(v_sliderRespArr[0]))
			v_piArrY=v_piArrY+(3*int(v_sliderRespArr[0]))
			v_sliderArrX=v_sliderRespArr[1]
			v_sliderArrY=v_sliderRespArr[2]
			v_piResponseArray=get_from_array(v_piArrX,v_piArrY)
			v_randInt = v_randInt+v_piResponseArray[0]
			v_piArrX = v_piResponseArray[1]
			v_piArrY = v_piResponseArray[2]
			
		elif v_performStep==10:	#shift down/right  
			#print("On n="+str(n)+" entered n divisible by 10") 
			v_sliderArrX=v_sliderArrX+v_jumpBy
			v_sliderArrY=v_sliderArrY+v_jumpBy
			v_sliderRespArr=get_from_array(v_sliderArrX,v_sliderArrY,1)
			v_piArrX=v_piArrX+(3*int(v_sliderRespArr[0]))
			v_piArrY=v_piArrY+(3*int(v_sliderRespArr[0]))
			v_sliderArrX=v_sliderRespArr[1]
			v_sliderArrY=v_sliderRespArr[2]
			v_piResponseArray=get_from_array(v_piArrX,v_piArrY)
			v_randInt = v_randInt+v_piResponseArray[0]
			v_piArrX = v_piResponseArray[1]
			v_piArrY = v_piResponseArray[2]
			
		elif v_performStep==11:	#shift right   
			#print("On n="+str(n)+" entered n divisible by 11")
			v_sliderArrX=v_sliderArrX+v_jumpBy
			v_sliderRespArr=get_from_array(v_sliderArrX,v_sliderArrY,1) #offset is now the semi-randomly selected distance to be jumped through the pi-normalized array prior to selecting our next random number
			v_piArrX=v_piArrX+(3*int(v_sliderRespArr[0]))	#Needs to be a significant jump so multiplying by an odd number (ensures can attain odd resultants)
			v_sliderArrX=v_sliderRespArr[1]
			v_sliderArrY=v_sliderRespArr[2]
			v_piResponseArray=get_from_array(v_piArrX,v_piArrY)
			v_randInt = v_randInt+v_piResponseArray[0]
			v_piArrX = v_piResponseArray[1]
			v_piArrY = v_piResponseArray[2]
			
		elif v_performStep==12:		#shift up/left
			#print("On n="+str(n)+" entered n divisible by 12")
			v_sliderArrX=v_sliderArrX-v_jumpBy
			v_sliderArrY=v_sliderArrY-v_jumpBy
			v_sliderRespArr=get_from_array(v_sliderArrX,v_sliderArrY,1)
			v_piArrX=v_piArrX-(3*int(v_sliderRespArr[0]))
			v_piArrY=v_piArrY-(3*int(v_sliderRespArr[0]))
			v_sliderArrX=v_sliderRespArr[1]
			v_sliderArrY=v_sliderRespArr[2]
			v_piResponseArray=get_from_array(v_piArrX,v_piArrY)
			v_randInt = v_randInt+v_piResponseArray[0]
			v_piArrX  = v_piResponseArray[1]
			v_piArrY  = v_piResponseArray[2]
			
	#print("generated: "+v_randInt)
	return v_randInt

func get_from_array(x=0,y=0,arrToUse=0): #arrToUse 0 is the pi normalized array we actually get the random number from, 1 is the slider array we use to lookup a random distance that will be how far through the pi array we jump coordinates in each iteration of n above
	
	#storing these arrays in a separate file and loading as a global variable was roughly the same speed, however loading them directly in the function KILLED run time performance.
	#must either store separately & load at run time as global variable or store directly in the function

	#Real world base of pi (1000 digits), with added numbers, roughly evenly distributed, to attain even count of digits total.
	const v_pi_normalized_array : Array = [
		['3','8','2','6','9','4','9','5','3','8','0','5','9','4','9','5','0','8','3','4','7','3','4','8','9','3','9','9','2','0','1','2','5','6'],
		['1','8','3','3','3','2','9','6','1','6','2','2','0','1','7','1','8','3','9','7','6','8','7','5','5','7','3','6','2','1','4','8','9','6'],
		['4','4','0','7','8','8','6','5','6','1','7','0','3','3','5','1','8','3','5','7','6','2','8','3','6','6','9','3','3','0','2','7','3','1'],
		['1','1','8','4','4','1','4','0','5','0','3','9','6','4','9','8','4','7','8','0','7','7','7','4','1','2','8','1','6','0','0','5','4','3'],
		['5','9','7','2','4','3','6','6','2','9','4','2','0','6','1','5','5','6','2','5','9','7','2','7','1','9','3','8','0','0','6','5','7','0'],
		['9','7','8','1','0','1','4','5','7','4','7','0','0','9','9','4','7','7','2','3','4','8','1','1','2','8','0','5','8','3','1','4','5','0'],
		['2','1','1','1','6','1','6','4','1','5','2','9','1','4','5','8','5','3','4','9','6','5','4','0','1','7','7','9','7','1','7','6','1','1'],
		['6','6','6','7','0','7','2','9','2','4','4','8','9','5','3','0','2','3','3','2','0','7','6','5','2','7','2','5','2','3','1','8','0','9'],
		['5','9','4','0','4','4','7','3','0','6','5','6','1','1','0','7','7','6','7','1','5','7','8','3','9','4','9','0','5','0','7','6','9','2'],
		['3','0','0','6','9','5','2','3','1','3','8','2','3','9','9','4','2','2','3','7','1','1','4','0','0','7','4','8','3','7','0','7','5','7'],
		['5','4','6','7','5','0','9','4','9','7','7','8','3','4','2','9','5','4','7','1','0','3','4','7','2','7','7','2','3','8','7','3','7','8'],
		['8','3','2','9','5','5','4','4','0','2','2','2','0','1','5','4','4','4','1','7','3','4','0','9','1','1','8','4','4','4','6','1','7','7'],
		['9','6','8','8','0','2','8','6','9','6','0','9','5','5','1','6','8','0','2','6','2','2','9','7','9','3','0','4','4','3','6','3','8','6'],
		['7','9','2','2','8','8','9','1','1','6','0','2','5','1','8','2','9','6','9','2','4','7','0','2','6','0','4','5','6','8','5','1','1','6'],
		['9','9','6','1','5','4','5','2','4','4','3','5','3','1','6','3','1','5','0','9','0','5','1','2','0','9','9','9','8','7','9','5','8','1'],
		['3','7','2','4','8','1','4','8','0','8','6','4','0','6','1','7','2','6','7','3','0','7','2','7','9','9','9','4','5','5','1','9','5','4'],
		['2','3','3','5','2','0','9','4','5','2','6','0','6','0','1','2','2','0','9','1','0','7','2','5','8','6','5','5','0','2','4','2','7','1'],
		['3','7','0','8','2','2','3','7','6','1','0','9','5','9','0','9','7','6','0','7','8','9','4','9','6','0','1','5','3','6','7','5','7','1'],
		['8','5','8','0','6','7','0','5','4','3','6','1','4','4','7','9','9','4','2','6','5','8','9','6','6','5','6','3','5','8','5','6','5','0'],
		['4','1','9','8','3','0','3','6','8','3','3','0','8','3','3','6','3','4','1','7','6','9','5','8','4','1','0','0','2','8','3','7','8','9'],
		['6','0','9','6','1','1','8','4','5','9','1','7','7','8','8','3','8','3','7','5','8','6','3','6','0','8','5','4','6','6','0','2','0','5'],
		['2','5','8','5','7','9','1','2','6','3','5','1','8','3','4','2','1','0','9','2','1','5','4','9','3','7','9','6','3','7','3','8','5','9'],
		['6','8','6','1','7','0','9','8','4','6','5','4','2','0','1','7','8','8','6','3','2','0','3','2','0','0','7','9','1','5','5','6','3','0'],
		['4','5','0','3','2','3','6','3','6','0','8','5','0','5','9','4','3','6','8','8','7','9','8','5','4','7','7','4','9','8','4','3','2','9'],
		['3','2','2','2','5','8','8','2','9','7','8','3','4','7','3','6','0','0','6','5','1','6','0','8','4','2','3','0','3','7','9','8','1','3'],
		['3','0','8','8','3','4','4','3','2','2','5','6','6','2','2','9','1','2','0','4','4','1','1','9','1','1','1','8','1','5','8','8','7','2'],
		['8','9','0','2','5','5','4','6','3','6','1','4','6','7','6','7','1','1','7','6','5','7','4','2','8','1','7','3','5','3','2','2','1','1'],
		['3','7','4','3','9','2','2','3','4','0','7','3','5','0','1','5','9','3','9','7','2','7','6','3','4','3','3','0','1','8','5','3','6','9'],
		['2','4','3','0','4','1','8','7','6','2','4','6','2','3','1','6','4','9','4','4','6','3','5','5','1','4','2','9','8','3','3','8','2','6'],
		['7','9','4','6','0','1','8','8','0','4','8','7','1','6','7','8','9','4','3','8','2','6','0','4','5','9','8','2','8','2','4','5','2','8'],
		['9','4','8','6','8','0','1','7','5','9','6','8','0','5','9','7','1','5','0','1','3','0','4','2','9','9','1','6','2','0','9','3','6','4'],
		['5','4','2','4','1','5','0','6','3','1','8','9','3','7','3','3','2','9','7','8','5','3','9','0','5','2','6','4','1','8','0','7','8','2'],
		['0','5','9','7','2','5','9','7','8','4','1','2','8','6','1','5','9','4','0','4','6','7','5','1','8','9','0','2','7','3','4','8','7','0'],
		['2','9','5','0','8','5','7','8','4','1','7','5','2','5','0','1','6','6','2','6','0','1','2','9','1','9','5','5','1','8','9','7','0','2'],
		]
	#Note: v_pi_normalized_array is missing the following numbers that would make it a perfectly normalized array: (so tiny bias? needs testing!)
	# 1, 9, 8, 9

	#Real world base of pi (1000 digits), with added numbers, roughly evenly distributed, to attain even count of digits total.
	const v_slider_array : Array = [
		['7','8','1','0','4','6','3','9','0','2','6','1','9','9','2','4','0','1','4','5','1','1','2','7','4','3','6','1','8','7','8','5','1','5'],
		['9','2','2','8','7','0','8','1','4','6','2','5','0','9','3','5','6','3','5','6','3','7','0','2','1','4','6','5','8','2','5','9','9','4'],
		['0','7','8','4','3','7','2','0','9','8','1','5','7','6','1','6','9','7','0','0','8','5','4','7','8','9','9','0','3','9','0','8','2','6'],
		['7','9','8','1','5','5','9','1','9','2','1','0','6','1','5','5','8','2','0','0','9','9','7','3','0','2','3','0','4','3','4','8','4','7'],
		['8','6','9','0','2','3','9','0','9','5','9','0','4','7','7','2','4','0','6','5','2','4','2','4','8','2','6','0','8','9','3','6','3','3'],
		['2','2','6','1','7','1','2','3','5','0','8','1','7','6','0','1','1','3','8','7','7','3','3','4','6','6','6','4','2','2','9','6','6','3'],
		['5','8','3','2','8','8','3','6','8','2','6','5','5','3','7','0','2','1','0','7','9','6','3','3','4','0','5','7','3','2','4','6','5','0'],
		['4','3','5','2','8','9','4','5','3','6','8','2','5','6','1','2','3','3','8','7','9','4','7','7','4','2','2','6','3','5','0','4','0','8'],
		['2','3','8','3','5','7','8','5','7','1','9','7','8','3','4','6','8','9','9','9','0','4','0','4','1','6','3','4','4','6','1','1','2','1'],
		['8','8','1','5','1','3','9','8','8','5','4','8','6','9','9','9','2','8','7','8','2','8','8','1','4','7','6','9','3','7','9','5','5','0'],
		['2','9','0','3','8','0','7','7','1','1','6','2','6','3','3','6','5','3','2','1','2','3','0','6','8','0','0','1','0','1','6','4','7','7'],
		['8','2','3','7','1','2','7','3','9','2','5','4','7','9','7','3','7','0','1','1','9','5','4','7','5','1','5','1','3','7','9','3','9','1'],
		['9','4','3','1','9','5','1','5','5','3','0','9','1','3','5','5','6','7','8','4','5','6','6','3','6','5','9','3','5','6','8','6','1','8'],
		['5','1','4','1','9','3','6','7','0','3','9','2','2','6','1','8','0','0','2','5','9','7','8','2','8','0','0','6','4','4','4','5','1','2'],
		['4','5','0','0','7','6','8','5','5','1','7','0','2','0','9','6','4','8','7','9','8','4','6','8','4','5','3','3','1','7','0','8','0','6'],
		['0','0','1','6','7','3','8','5','0','0','5','9','5','9','7','9','1','9','5','3','1','0','5','5','5','0','1','9','2','8','3','6','7','7'],
		['3','5','8','0','4','6','4','6','7','9','5','8','8','9','5','3','0','6','1','4','6','1','2','3','7','4','3','3','8','0','8','3','9','0'],
		['7','6','7','8','4','9','1','8','7','1','5','0','8','3','1','1','5','6','1','2','7','9','0','2','9','2','6','4','1','0','3','0','8','6'],
		['4','1','7','4','5','5','1','2','4','2','3','2','5','1','8','0','5','9','8','4','2','6','7','7','6','9','5','1','3','8','2','1','7','4'],
		['7','0','3','4','9','5','3','1','0','2','1','2','7','8','6','2','4','6','8','8','5','5','5','1','9','7','9','4','3','1','8','7','6','1'],
		['3','3','4','9','0','8','3','9','6','4','7','4','2','5','7','2','5','6','2','4','0','9','1','2','5','4','4','9','7','4','1','0','2','6'],
		['5','2','4','6','3','8','7','2','5','7','5','4','4','1','0','2','8','6','8','3','1','7','7','2','9','6','5','9','7','2','5','7','9','3'],
		['8','0','9','3','8','4','8','8','1','0','4','9','2','6','7','1','8','7','8','9','9','3','7','1','0','8','6','6','9','1','1','0','1','8'],
		['8','9','4','4','9','2','0','3','5','8','3','0','2','3','7','9','8','3','5','3','2','2','8','6','2','8','4','3','0','4','5','7','7','1'],
		['0','6','1','4','6','8','6','2','6','3','1','7','4','5','0','2','4','3','1','6','5','9','5','2','6','5','5','3','5','6','7','2','2','1'],
		['2','9','4','0','6','2','8','9','4','9','0','7','5','2','0','9','0','0','4','4','6','6','4','0','8','0','2','2','9','5','1','2','4','9'],
		['7','5','4','5','2','4','1','4','0','6','2','2','9','4','0','9','1','9','8','6','0','3','7','3','7','4','6','8','8','4','4','6','6','7'],
		['9','6','1','8','1','8','6','9','9','4','9','0','6','6','2','5','4','9','4','4','7','9','2','7','0','2','9','7','6','9','5','8','9','7'],
		['1','3','5','0','3','1','1','3','5','8','2','6','1','5','3','7','1','9','4','3','4','5','4','1','3','7','1','8','5','3','6','7','4','6'],
		['2','8','2','0','2','4','3','8','7','5','5','1','1','7','0','2','5','2','7','3','7','7','0','6','7','2','4','3','2','9','0','3','4','6'],
		['0','7','3','8','0','1','7','6','9','2','5','8','8','8','2','4','6','1','0','6','6','8','3','5','8','4','4','9','5','3','5','0','0','0'],
		['0','9','4','5','2','2','3','0','1','1','6','6','4','7','9','3','2','7','3','6','5','7','7','3','0','3','8','7','5','8','3','9','2','2'],
		['4','7','6','8','0','4','3','0','4','1','5','5','9','3','3','9','7','9','7','6','7','2','4','9','8','5','2','0','9','4','8','1','1','8'],
		['5','4','4','0','6','6','3','9','1','7','8','3','1','7','0','1','2','9','8','1','4','7','0','0','2','2','1','5','0','6','9','2','6','1'],
		]
	#Note: v_pi_normalized_array is missing the following numbers that would make it a perfectly normalized array: (so tiny bias? needs testing!)
	# 6, 4, 3, 1

	while x<0: #normalize the x y coordinates to be within the array size (34x34)
		x=x+34
	while y<0:
		y=y+34

	if x>33: #normalize the x y coordinates to be within the array size (34x34)
		x=x%34
	if y>33:
		y=y%34
	
	#print("Using x: "+str(x)+", y: "+str(y))
	var v_digit=0
	if arrToUse==0:
		v_digit=v_pi_normalized_array[y][x]
	elif arrToUse==1:
		v_digit=v_slider_array[y][x]
	var v_response=[v_digit,x,y]
	
	#print("Returning digit: "+v_digit)
	return v_response
