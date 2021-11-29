"""
	XM reader by Yui Kinomoto @arlez80
"""

const Mod: = preload("Mod.gd")

"""
	ファイルから読み込み
	@param	path	File path
	@return	smf
"""
func read_file( path:String ) -> Mod.Mod:
	var f:File = File.new( )

	if not f.file_exists( path ):
		print( "file %s is not found" % path )
		breakpoint

	f.open( path, f.READ )
	var stream:StreamPeerBuffer = StreamPeerBuffer.new( )
	stream.set_data_array( f.get_buffer( f.get_len( ) ) )
	f.close( )

	return self._read( stream )

"""
	配列から読み込み
	@param	data	PoolByteArray
	@return	smf
"""
func read_data( data:PoolByteArray ) -> Mod.Mod:
	var stream:StreamPeerBuffer = StreamPeerBuffer.new( )
	stream.set_data_array( data )
	return self._read( stream )

"""
	読み込み
	@param	stream
	@return	smf
"""
func _read( stream:StreamPeerBuffer ) -> Mod.Mod:
	var xm: = Mod.Mod.new( )

	if self._read_string( stream, 17 ) != "Extended Module: ":
		return null
	xm.module_name = self._read_string( stream, 20 )
	if stream.get_u8( ) != 0x1A:
		return null
	xm.tracker_name = self._read_string( stream, 20 )
	xm.version = stream.get_u16( )

	var header_size:int = stream.get_u32( )
	xm.song_length = stream.get_u16( )
	xm.restart_position = stream.get_u16( )
	xm.channel_count = stream.get_u16( )

	var pattern_count:int = stream.get_u16( )
	var instrument_count:int = stream.get_u16( )
	xm.flags = stream.get_u16( )
	xm.init_tick = stream.get_u16( )
	xm.init_bpm = stream.get_u16( )

	xm.song_positions = stream.get_partial_data( header_size - 20 )[1]

	xm.patterns = self._read_patterns( stream, xm.flags, pattern_count, xm.channel_count )
	if len( xm.patterns ) == 0:
		return null

	xm.instruments = self._read_instruments( stream, instrument_count )
	if len( xm.instruments ) == 0:
		return null

	return xm

func _read_patterns( stream:StreamPeerBuffer, flags:int, pattern_count:int, channels:int ) -> Array:
	var patterns:Array = []

	for i in range( pattern_count ):
		var pattern:Array = []

		if stream.get_u32( ) != 9:
			return []
		if stream.get_u8( ) != 0:
			return []
		var row_count:int = stream.get_u16( )
		var size:int = stream.get_u16( )

		for k in range( row_count ):
			var line:Array = []
			for ch in range( channels ):
				var patr: = Mod.ModPatternNote.new( )
				var first:int = stream.get_u8( )
				if first & 0x80 != 0:
					if first & 1 != 0: patr.note = stream.get_u8( )
				else:
					patr.note = first
					first = 0xFF
				if 0 < patr.note:
					patr.note -= 1
				if first & 2 != 0: patr.instrument = stream.get_u8( )
				if first & 4 != 0: patr.volume = stream.get_u8( )
				if first & 8 != 0: patr.effect_command = stream.get_u8( )
				if first & 16 != 0: patr.effect_param = stream.get_u8( )
				if 0 < patr.note:
					if flags & Mod.ModFlags.LINEAR_FREQUENCY_TABLE != 0:
						patr.key_number = _conv_linear_freq( patr.note )
					else:
						patr.key_number = _conv_amiga_freq( patr.note )
				line.append( patr )
			pattern.append( line )
		patterns.append( pattern )

	return patterns

func _conv_amiga_freq( note:int ) -> int:
	return int( 6848.0 / pow( 2.0, note / 12.0 ) )

func _conv_linear_freq( note:int ) -> int:
	return 7680 - note * 64

func _read_instruments( stream:StreamPeerBuffer, instrument_count:int ) -> Array:
	var instruments:Array = []

	for i in range( instrument_count ):
		var inst: = Mod.ModInstrument.new( )
		var size:int = stream.get_u32( )
		var remain_size:int = size
		inst.name = self._read_string( stream, 22 )
		#print( "%d/%d %s" % [ i, instrument_count, inst.name] )
		if stream.get_u8( ) != 0:
			return []

		var sample_count:int = stream.get_u16( )
		var sample_numbers:Array = []
		remain_size -= 4 + 22 + 1 + 2
		if 0 < sample_count:
			var sample_header_size:int = stream.get_u32( )
			sample_numbers = stream.get_partial_data( 96 )[1]
			inst.volume_envelope = Mod.ModEnvelope.new( )
			for k in range( 12 ):
				var ve: = Mod.ModEnvelopePoint.new( )
				ve.frame = stream.get_u16( )
				ve.value = stream.get_u16( )
				inst.volume_envelope.points.append( ve )
			inst.panning_envelope = Mod.ModEnvelope.new( )
			for k in range( 12 ):
				var pe: = Mod.ModEnvelopePoint.new( )
				pe.frame = stream.get_u16( )
				pe.value = stream.get_u16( )
				inst.panning_envelope.points.append( pe )
			remain_size -= 4 + 96 + 48 + 48
			inst.volume_envelope.point_count = stream.get_u8( )
			inst.panning_envelope.point_count = stream.get_u8( )
			inst.volume_envelope.sustain_point = stream.get_u8( )
			inst.volume_envelope.loop_start_point = stream.get_u8( )
			inst.volume_envelope.loop_end_point = stream.get_u8( )
			inst.panning_envelope.sustain_point = stream.get_u8( )
			inst.panning_envelope.loop_start_point = stream.get_u8( )
			inst.panning_envelope.loop_end_point = stream.get_u8( )
			inst.volume_envelope.set_flag( stream.get_u8( ) )
			inst.panning_envelope.set_flag( stream.get_u8( ) )
			inst.vibrato_type = stream.get_u8( )
			inst.vibrato_speed = stream.get_u8( )
			inst.vibrato_depth = stream.get_u8( )
			inst.vibrato_depth_shift = stream.get_u8( )
			inst.volume_fadeout = stream.get_u16( )
			remain_size -= 16

		if 0 < remain_size:
			stream.get_partial_data( remain_size )	# reserved 

		if 0 < sample_count:
			var sounds:Array = []
			# Sound Header
			for k in range( sample_count ):
				var xms: = Mod.ModSample.new( )
				xms.length = stream.get_u32( )
				xms.loop_start = stream.get_u32( )
				xms.loop_length = stream.get_u32( )
				xms.volume = stream.get_u8( )
				xms.finetune = stream.get_8( )
				xms.loop_type = stream.get_u8( )
				if xms.loop_type & 16 != 0:
					xms.bit = 16
				xms.loop_type &= 3
				xms.panning = stream.get_u8( )
				xms.relative_note = stream.get_8( )
				stream.get_u8( )		# Reserved
				xms.name = self._read_string( stream, 22 )
				sounds.append( xms )
			# Sound Data
			for xms in sounds:
				var d:Array = []
				var p:int = 0

				if xms.bit == 16:
					for k in range( xms.length >> 1 ):
						p += stream.get_16( )
						d.append( p & 0xFF )
						d.append( ( p >> 8 ) & 0xFF )
				else:
					for k in range( xms.length ):
						p += stream.get_8( )
						d.append( p & 0xFF )

				xms.data = PoolByteArray( d )

			inst.samples = []
			for k in sample_numbers:
				if len( sounds ) <= k:
					inst.samples.append( sounds[0] )
				else:
					inst.samples.append( sounds[k] )

		instruments.append( inst )

	return instruments

"""
	文字列の読み込み
	@param	stream	Stream
	@param	size	string size
	@return string
"""
func _read_string( stream:StreamPeerBuffer, size:int ) -> String:
	return stream.get_partial_data( size )[1].get_string_from_ascii( )

