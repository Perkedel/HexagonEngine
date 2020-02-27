#This Class module manages an instanced Random Sequence
#It tracks it's own sequence of results so you can refer back to them at any point
#It's seed persists, so you don't have to worry about the regular RNG messing it up
#Place this in your module, for example res://lib/SeededRandomSequence.gd


#Initial and current state
var _initial_seed
var _current_state

#The results, in sequence
var _result_sequence

#Init
func _init(new_seed=null):
	#Was a seed given?
	if new_seed == null:
		#Provide a random seed
		randomize()
		new_seed = randi()
	
	#Apply the seed
	self.reset(new_seed)

#Reset to the original state
func reset(new_seed=null, hard=false):
	#Reset the sequence, optionally with a new seed
	
	#If a hard reset, ignore seeds and get a new one
	if hard:
		randomize()
		new_seed = randi()

	#Was there a new seed?
	if new_seed != null:
		#Set that seed
		self._initial_seed = new_seed
	
	#Hash the seed to support non-integers
	var hashed_seed = hash(self._initial_seed)
	
	#Get the first state
	self._result_sequence = []
	self._current_state = rand_seed(hashed_seed)[1]

#Get the next number
func next():
	#Get the next integer
	
	#Get the next state
	var random_result = rand_seed(self._current_state)
	self._current_state = random_result[1]

	#Return the integer
	var random_integer = random_result[0]
	self._result_sequence.append(random_integer)
	return random_integer

#Get a particular number in the sequence
func get_at_index(index):
	#Gets the result at a specified index.
	#Note: This WILL update the sequence to that index if it is further than the current index!
	
	#We need to generate numbers until we get to this index
	while index >= self._result_sequence.size():
		#We need to keep generating more
		self.next()
	
	#We are now at least as far as the specified index
	#We can return it's result
	return self._result_sequence[index]

func save_state():
	#Save the current state of the sequence to a JSON string
	#You would then save this to disk, etc.

	#Store various variables
	var state = {}
	state['initial_seed'] = self._initial_seed
	state['current_state'] = str(self._current_state)

	#Get the JSON string
	var json = JSON.print(state, ' ', false)
	return json

func load_state(json_state):
	#Load a JSON state, generated from the save_state function
	#WARNING: If this is not a 'valid' state, this process will take an ~infinite amount of time until it reaches the state. Don't feed invalid data!

	#Re-initialize with the previous state
	var json_result = JSON.parse(json_state)
	var json_data = json_result.result

	#Did it parse the result properly?
	if typeof(json_data) != TYPE_DICTIONARY:
		#Invalid result
		print("Unable to load JSON state!")
		print(json_result.error_string)
		return
	
	
	var previous_seed = json_data['initial_seed']
	self._init(previous_seed)
	var c  =0
	#Now start getting values until the state matches the previous one
	var previous_state = json_data['current_state']
	print('PREV ', previous_state, ' ', float(previous_state), ' ', str(previous_state))
	print(str(self._current_state))
	while str(self._current_state) != previous_state and c < 100:

		#Get the next value
		print(c, ' ', self._current_state, ' ', previous_state)
		self.next()
		c = c + 1

	#At this point, we've restored the state to the previous version!
	return
