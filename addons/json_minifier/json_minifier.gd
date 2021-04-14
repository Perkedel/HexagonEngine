###############################################################################
# JSON Minifier                                                               #
# Copyright © 2020 Kyle Simpson <getify@gmail.com>                            #
# Adopted to Godot by Piet Bronders                                           #
#-----------------------------------------------------------------------------#

class_name JSONMinifier

# Takes a JSON in string format and removes all the comments and white space.
static func minify_json(string : String, strip_space: bool = true) -> String:
	# Let's iterate on every match for each token
	# This is actually a tokenization
	# Tokens of interest are ", /*, */, //, \n, \r, \t, and space
	var tokenizer = RegEx.new()
	tokenizer.compile('\\"|(/\\*)|(\\*/)|(//)|\n|\r')
	var end_slashes_re = RegEx.new()
	end_slashes_re.compile('(\\\\)*$')

	var in_string := false
	var in_multi := false
	var in_single := false

	var new_str := PoolStringArray()
	var index := 0

	for reg_ex_match in tokenizer.search_all(string):
		if not (in_multi or in_single):
			var tmp = string.substr(index, reg_ex_match.get_start() - index)
			if not in_string and strip_space:
				# replace white space as defined in standard
				var replacer := RegEx.new()
				replacer.compile('[ \t\n\r]+')
				tmp = replacer.sub(tmp, '')
			new_str.append(tmp)
		elif not strip_space:
			# Replace comments with white space so that the JSON parser reports
			# the correct column numbers on parsing errors.
			new_str.append(' '.repeat(reg_ex_match.get_start() - index))

		index = reg_ex_match.get_end()
		var val : String = reg_ex_match.get_string()

		if val == '"' and not (in_multi or in_single):
			var escaped : RegExMatch = end_slashes_re.search(string, 0, reg_ex_match.get_start())

			# start of string or unescaped quote character to end string
			if not in_string or (escaped.get_string().empty() or len(escaped.get_string()) % 2 == 0):  # noqa
				in_string = not in_string
			index -= 1  # include " character in next catch
		elif not (in_string or in_multi or in_single):
			if val == '/*':
				in_multi = true
			elif val == '//':
				in_single = true
		elif val == '*/' and in_multi and not (in_string or in_single):
			in_multi = false
			if not strip_space:
				new_str.append(" ".repeat(val.length()))
		elif val in '\r\n' and not (in_multi or in_string) and in_single:
			in_single = false
		elif not ((in_multi or in_single) or (val in ' \r\n\t' and strip_space)):  # noqa
			new_str.append(val)

		if not strip_space:
			if val in '\r\n':
				new_str.append(val)
			elif in_multi or in_single:
				new_str.append(' '.repeat(val.length()))

	new_str.append(string.substr(index))
	return new_str.join('')
