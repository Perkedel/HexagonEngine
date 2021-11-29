"""
	MOD reader by Yui Kinomoto @arlez80
"""

const period_table:PoolIntArray = PoolIntArray([
	1712,1616,1525,1440,1357,1281,1209,1141,1077,1017, 961, 907,
	856, 808, 762, 720, 678, 640, 604, 570, 538, 508, 480, 453,
	428, 404, 381, 360, 339, 320, 302, 285, 269, 254, 240, 226,
	214, 202, 190, 180, 170, 160, 151, 143, 135, 127, 120, 113,
	107, 101,  95,  90,  85,  80,  76,  71,  67,  64,  60,  57,
])

enum ModFlags {
	LINEAR_FREQUENCY_TABLE = 1,
}

enum ModWaveFormType {
	SINE_WAVEFORM = 0,
	SAW_WAVEFORM = 1,
	SQUARE_WAVEFORM = 2,
	RAMDOM_WAVEFORM = 3,
	REV_SAW_WAVEFORM = 4,
}

enum ModLoopType {
	NO_LOOP = 0,
	FORWARD_LOOP = 1,
	PING_PONG_LOOP = 2,
}

class Mod:
	var module_name:String
	var tracker_name:String
	var version:int
	var flags:int = 0

	var song_length:int
	var unknown_number:int
	var channel_count:int
	var song_positions:Array	# int
	var magic:String
	var patterns:Array			# ModPattern[][]
	var instruments:Array		# ModInstrument[]

	var init_tick:int = 6
	var init_bpm:int = 125
	var restart_position:int = 0

class ModPatternNote:
	var key_number:int
	var note:int
	var instrument:int
	var volume:int = 0
	var effect_command:int
	var effect_param:int

class ModInstrument:
	var name:String
	var samples:Array					# ModSample[96]
	var volume_envelope:ModEnvelope
	var panning_envelope:ModEnvelope
	var vibrato_type:int = -1			# ModWaveFormType
	var vibrato_speed:int = -1
	var vibrato_depth:int = -1
	var vibrato_depth_shift:int = -1
	var volume_fadeout:int = -1

class ModSample:
	var data:PoolByteArray
	var name:String
	var length:int
	var loop_start:int
	var loop_length:int
	var volume:int
	var finetune:int
	var loop_type:int = ModLoopType.FORWARD_LOOP		# set(ModLoopType)
	var bit:int = 8										# 8 or 16
	var panning:int	= -1
	var relative_note:int = 0

class ModEnvelope:
	var points:Array		# ModEnvelopePoint[12]
	var point_count:int
	var sustain_point:int
	var loop_start_point:int
	var loop_end_point:int

	var enabled:bool
	var sustain_enabled:bool
	var loop_enabled:bool

	func set_flag( f:int ):
		self.enabled = ( f & 1 ) != 0
		self.sustain_enabled = ( f & 2 ) != 0
		self.loop_enabled = ( f & 4 ) != 0

class ModEnvelopePoint:
	var frame:int
	var value:int

"""
	ファイルから読み込み
	@param	path	File path
	@return	smf
"""
func read_file( path:String ) -> Mod:
	var f:File = File.new( )

	if not f.file_exists( path ):
		print( "file %s is not found" % path )
		breakpoint

	f.open( path, f.READ )
	var stream:StreamPeerBuffer = StreamPeerBuffer.new( )
	stream.set_data_array( f.get_buffer( f.get_len( ) ) )
	stream.big_endian = true
	f.close( )

	return self._read( stream )

"""
	配列から読み込み
	@param	data	PoolByteArray
	@return	smf
"""
func read_data( data:PoolByteArray ) -> Mod:
	var stream:StreamPeerBuffer = StreamPeerBuffer.new( )
	stream.set_data_array( data )
	stream.big_endian = true
	return self._read( stream )

"""
	読み込み
	@param	stream
	@return	smf
"""
func _read( stream:StreamPeerBuffer ) -> Mod:
	var mod:Mod = Mod.new( )
	mod.module_name = self._read_string( stream, 20 )
	mod.tracker_name = ""
	mod.instruments = self._read_sample_informations( stream )
	mod.song_length = stream.get_u8( )
	mod.unknown_number = stream.get_u8( )
	mod.song_positions = stream.get_partial_data( 128 )[1]
	var max_song_position:int = 0
	for sp in mod.song_positions:
		if max_song_position < sp:
			max_song_position = sp

	mod.magic = self._read_string( stream, 4 )
	var channel_count:int = 4
	match mod.magic:
		"6CHN":
			channel_count = 6
		"FLT8", "8CHN", "CD81", "OKTA":
			channel_count = 8
		"16CN":
			channel_count = 16
		"32CN":
			channel_count = 32
		_:
			if mod.magic.substr( 2 ) == "CH":
				channel_count = int( mod.magic )
			# print( "Unknown magic" )
			# breakpoint
			pass
	mod.channel_count = channel_count

	mod.patterns = self._read_patterns( stream, max_song_position + 1, channel_count )
	self._read_sample_data( stream, mod.instruments )

	return mod

"""
	サンプルのデータを読み込む
"""
func _read_sample_informations( stream:StreamPeerBuffer ) -> Array:
	var instruments:Array = []

	for i in range( 31 ):
		var sample: = ModSample.new( )
		sample.name = self._read_string( stream, 22 )
		sample.length = stream.get_u16( ) * 2
		var finetune:int = stream.get_u8( ) & 0x0F
		if 0x08 < finetune:
			finetune = finetune - 0x10
		sample.finetune = finetune * 16
		sample.volume = stream.get_u8( )
		sample.loop_start = stream.get_u16( ) * 2
		sample.loop_length = stream.get_u16( ) * 2
		if sample.loop_length < 8:
			sample.loop_type = ModLoopType.NO_LOOP
		else:
			sample.loop_type = ModLoopType.FORWARD_LOOP

		var instrument: = ModInstrument.new( )
		instrument.name = sample.name
		instrument.samples = []
		for k in range( 96 ):
			instrument.samples.append( sample )
		instrument.volume_envelope = ModEnvelope.new( )
		instrument.volume_envelope.enabled = false
		instrument.panning_envelope = ModEnvelope.new( )
		instrument.panning_envelope.enabled = false

		instruments.append( instrument )

	return instruments

"""
	パターンを読み込む
"""
func _read_patterns( stream:StreamPeerBuffer, max_position:int, channels:int ) -> Array:
	var patterns:Array = []

	for position in range( 0, max_position ):
		var pattern:Array = []
		for i in range( 0, 64 ):
			var line:Array = []
			for ch in range( 0, channels ):
				var v1:int = stream.get_u16( )
				var v2:int = stream.get_u16( )
				var mod_pattern_note: = ModPatternNote.new( )
				mod_pattern_note.instrument = ( ( v1 >> 8 ) & 0xF0 ) | ( ( v2 >> 12 ) & 0x0F )
				mod_pattern_note.key_number = v1 & 0x0FFF
				mod_pattern_note.effect_command = ( v2 >> 8 ) & 0x0F
				mod_pattern_note.effect_param = v2 & 0x0FF
				# TODO: 遅かったら二分探索にでもしませんか
				if 0 < mod_pattern_note.key_number:
					mod_pattern_note.note = 23
					for k in period_table:
						mod_pattern_note.note += 1
						if k <= mod_pattern_note.key_number:
							break
				else:
					mod_pattern_note.note = 0
				line.append( mod_pattern_note )
			pattern.append( line )
		patterns.append( pattern )

	return patterns

"""
	波形データ読み込む
"""
func _read_sample_data( stream:StreamPeerBuffer, instruments:Array ):
	for instrument in instruments:
		var sample:Mod.ModSample = instrument.samples[0]
		if 0 < sample.length:
			sample.data = stream.get_partial_data( sample.length )[1]

"""
	文字列の読み込み
	@param	stream	Stream
	@param	size	string size
	@return string
"""
func _read_string( stream:StreamPeerBuffer, size:int ) -> String:
	return stream.get_partial_data( size )[1].get_string_from_ascii( )
