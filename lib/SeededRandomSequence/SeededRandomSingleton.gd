extends Node

const SeededRandomSequence = preload("./SeededRandomSequence.gd")
var sequence = SeededRandomSequence.new()

"""
This is a singleton for the SeededRandomSequence
You can add it to your project as a singleton to use globally
To do this, go to Project->Project Settings->AutoLoad and add this script
You can then reference it and get/set seeds and retrieve values
For example, add it as a singleton named SeededRandomSequence and access it like:

SeededRandomSequence.sequence.reset(new_seed) #Optional
var value = SeededRandomSequence.sequence.next() #Get the random value
print(value)
"""

