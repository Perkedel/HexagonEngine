"""
	Sound Bank by Yui Kinomoto @arlez80
"""

const drum_track_bank:int = 128
const ADSR = preload( "ADSR.gd" )
const SoundFont = preload( "SoundFont.gd" )

class_name Bank

# 音色
class Instrument:
	var array_base_pitch:Array	# これは本当はPoolRealArrayなんだけど、参照型ではなく値型らしく、代入だけでメモリ使用量が爆発してしまう
	var array_stream:Array
	var ads_state:Array
	var release_state:Array
	var volume_db:float = 0.0
	var vel_range_min:int = 0
	var vel_range_max:int = 127
	var preset:Preset
	# var assine_group = 0	# reserved

	"""
	func _init( ):
		self.ads_state = [
			ADSR.VolumeState.new( 0.0, 0.0 ),
			ADSR.VolumeState.new( 0.2, -144.0 )
		]
		self.release_state = [
			ADSR.VolumeState.new( 0.0, 0.0 ),
			ADSR.VolumeState.new( 0.01, -144.0 )
		]
	"""

class Preset:
	var name:String = ""
	var number:int = 0
	var instruments:Array = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null]
	var bags:Array = []

# SoundFont解析用
class TempSoundFontBag:
	var preset:Preset
	var coarse_tune:int
	var fine_tune:int
	var key_range:TempSoundFontRange
	var instrument:TempSoundFontInstrument
	var pan:float = 0.5

class TempSoundFontInstrument:
	var name:String = ""
	var bags:Array = []

class TempSoundFontRange:
	var low:int
	var high:int

	func _init( low:int = 0, high:int = 127 ):
		self.low = low
		self.high = high

	func duplicate( ) -> TempSoundFontRange:
		var new:TempSoundFontRange = TempSoundFontRange.new( )
		new.low = self.low
		new.high = self.high

		return new

class TempSoundFontInstrumentBag:
	var sample
	var sample_id:int = -1
	var sample_start_offset:int = 0
	var sample_end_offset:int = 0
	var sample_start_loop_offset:int = 0
	var sample_end_loop_offset:int = 0
	var coarse_tune:int = 0
	var fine_tune:int = 0
	var original_key:int = 255
	var keynum:int = 0
	var sample_modes:int = 0
	var key_range:TempSoundFontRange = TempSoundFontRange.new( 0, 127 )
	var vel_range:TempSoundFontRange = TempSoundFontRange.new( 0, 127 )
	var volume_db:float = 0.0
	var adsr:TempSoundFontInstrumentBagADSR = TempSoundFontInstrumentBagADSR.new( )

	func duplicate( ) -> TempSoundFontInstrumentBag:
		var new:TempSoundFontInstrumentBag = TempSoundFontInstrumentBag.new( )
		new.sample = self.sample
		new.sample_id = sample_id
		new.sample_start_offset = sample_start_offset
		new.sample_end_offset = sample_end_offset
		new.sample_start_loop_offset = sample_start_loop_offset
		new.sample_end_loop_offset = sample_end_loop_offset
		new.coarse_tune = coarse_tune
		new.fine_tune = fine_tune
		new.original_key = original_key
		new.keynum = keynum
		new.key_range = key_range.duplicate( )
		new.vel_range = vel_range.duplicate( )
		new.volume_db = volume_db
		new.adsr = adsr.duplicate( )

		return new

class TempSoundFontInstrumentBagADSR:
	var attack_vol_env_time:float = 0.001	# sec
	var decay_vol_env_time:float = 0.001	# sec
	var sustain_vol_env_db:float = 0.0		# dB
	var release_vol_env_time:float = 0.001	# sec

	func duplicate( ) -> TempSoundFontInstrumentBagADSR:
		var new:TempSoundFontInstrumentBagADSR = TempSoundFontInstrumentBagADSR.new( )
		new.attack_vol_env_time = self.attack_vol_env_time
		new.decay_vol_env_time = self.decay_vol_env_time
		new.sustain_vol_env_db = self.sustain_vol_env_db
		new.release_vol_env_time = self.release_vol_env_time

		return new

# 音色テーブル
var presets:Dictionary = {}

"""
	追加
"""
func set_preset_sample( program_number:int, base_sample:int, base_key:int ):
	var preset:Preset = Preset.new( )
	preset.name = "#%03d" % program_number
	preset.number = program_number
	for i in range(0,128):
		var inst:Instrument = Instrument.new( )
		inst.array_base_pitch = PoolRealArray( [ float( i - base_key ) / 12.0 ] )
		inst.array_stream = [ base_sample ]
		inst.preset = preset
		preset.instruments[i] = inst

	self.set_preset( program_number, preset )

"""
	追加
"""
func set_preset( program_number:int, preset:Preset ):
	self.presets[program_number] = preset

"""
	指定した楽器を取得
"""
func get_preset( program_number:int, bank:int = 0 ) -> Preset:
	var pc:int = program_number | ( bank << 7 )

	# 存在しない場合
	if not self.presets.has( pc ):
		if self.drum_track_bank == bank:
			# ドラムの場合（Standard Kitを選択）
			pc = self.drum_track_bank << 7
		else:
			# 通常楽器の場合（Bank #0を選択）
			pc = program_number
		# それでも存在しない場合
		if not self.presets.has( pc ):
			if self.presets.empty( ): push_error( "Bank is empty." )
			# 一番最初のデフォルト音源を読む
			pc = self.presets.keys( )[0]

	var preset = self.presets[pc]
	return preset

"""
	サウンドフォント読み込み
"""
func read_soundfont( sf:SoundFont.SoundFont, need_program_numbers = null ):
	var sf_insts:Array = self._read_soundfont_pdta_inst( sf )

	var bag_index:int = 0
	var gen_index:int = 0
	for phdr_index in range( 0, len( sf.pdta.phdr )-1 ):
		var phdr:SoundFont.SoundFontPresetHeader = sf.pdta.phdr[phdr_index]

		var preset:Preset = Preset.new( )
		var program_number:int = phdr.preset | ( phdr.bank << 7 )

		preset.name = phdr.name
		preset.number = program_number

		var bag_next:int = sf.pdta.phdr[phdr_index+1].preset_bag_index
		var bag_count:int = bag_index
		while bag_count < bag_next:
			var gen_next:int = sf.pdta.pbag[bag_count+1].gen_ndx
			var gen_count:int = gen_index
			var bag:TempSoundFontBag = TempSoundFontBag.new( )
			bag.preset = preset
			while gen_count < gen_next:
				var gen:SoundFont.SoundFontGenerator = sf.pdta.pgen[gen_count]
				match gen.gen_oper:
					SoundFont.gen_oper_coarse_tune:
						bag.coarse_tune = gen.amount
					SoundFont.gen_oper_fine_tune:
						bag.fine_tune = gen.amount
					SoundFont.gen_oper_key_range:
						bag.key_range = TempSoundFontRange.new( gen.uamount & 0xFF, gen.uamount >> 8 )
					SoundFont.gen_oper_pan:
						bag.pan = float( gen.amount + 500 ) / 1000.0
					SoundFont.gen_oper_instrument:
						bag.instrument = sf_insts[gen.uamount]
				gen_count += 1
			if bag.instrument != null:
				preset.bags.append( bag )
			gen_index = gen_next
			bag_count += 1
		bag_index = bag_next

		# 追加するか？
		if need_program_numbers != null:
			if not( program_number in need_program_numbers ) and not( phdr.preset in need_program_numbers ):
				continue
		# 追加
		self._read_soundfont_preset_compose_sample( sf, preset )
		self.presets[program_number] = preset

func _read_soundfont_pdta_inst( sf:SoundFont.SoundFont ) -> Array:
	var sf_insts:Array = []
	var bag_index:int = 0
	var gen_index:int = 0

	for inst_index in range( 0, len( sf.pdta.inst ) - 1 ):
		var inst = sf.pdta.inst[inst_index]
		var sf_inst:TempSoundFontInstrument = TempSoundFontInstrument.new( )

		var bag_next:int = sf.pdta.inst[inst_index+1].inst_bag_ndx
		var bag_count:int = bag_index
		var global_bag:TempSoundFontInstrumentBag = TempSoundFontInstrumentBag.new( )
		while bag_count < bag_next:
			var bag:TempSoundFontInstrumentBag = global_bag.duplicate( )
			var gen_next:int = sf.pdta.ibag[bag_count+1].gen_ndx
			var gen_count:int = gen_index
			while gen_count < gen_next:
				var gen:SoundFont.SoundFontGenerator = sf.pdta.igen[gen_count]
				match gen.gen_oper:
					SoundFont.gen_oper_key_range:
						bag.key_range.high = gen.uamount >> 8
						bag.key_range.low = gen.uamount & 0xFF
					SoundFont.gen_oper_vel_range:
						bag.vel_range.high = gen.uamount >> 8
						bag.vel_range.low = gen.uamount & 0xFF
					SoundFont.gen_oper_overriding_root_key:
						bag.original_key = gen.amount
					SoundFont.gen_oper_start_addrs_offset:
						bag.sample_start_offset += gen.amount
					SoundFont.gen_oper_end_addrs_offset:
						bag.sample_end_offset += gen.amount
					SoundFont.gen_oper_start_addrs_coarse_offset:
						bag.sample_start_offset += gen.amount * 32768
					SoundFont.gen_oper_end_addrs_coarse_offset:
						bag.sample_end_offset += gen.amount * 32768
					SoundFont.gen_oper_startloop_addrs_offset:
						bag.sample_start_loop_offset += gen.amount
					SoundFont.gen_oper_endloop_addrs_offset:
						bag.sample_end_loop_offset += gen.amount
					SoundFont.gen_oper_startloop_addrs_coarse_offset:
						bag.sample_start_loop_offset += gen.amount * 32768
					SoundFont.gen_oper_endloop_addrs_coarse_offset:
						bag.sample_end_loop_offset += gen.amount * 32768
					SoundFont.gen_oper_coarse_tune:
						bag.coarse_tune = gen.amount
					SoundFont.gen_oper_fine_tune:
						bag.fine_tune = gen.amount
					SoundFont.gen_oper_keynum:
						bag.keynum = gen.amount
					SoundFont.gen_oper_attack_vol_env:
						bag.adsr.attack_vol_env_time = pow( 2.0, float( gen.amount ) / 1200.0 )
					SoundFont.gen_oper_decay_vol_env:
						bag.adsr.decay_vol_env_time = pow( 2.0, float( gen.amount ) / 1200.0 )
					SoundFont.gen_oper_release_vol_env:
						bag.adsr.release_vol_env_time = pow( 2.0, float( gen.amount ) / 1200.0 )
					SoundFont.gen_oper_sustain_vol_env:
						# -144 db == sound font 1440
						var s:float = min( max( 0.0, float( gen.amount ) ), 1440.0 ) / 10.0
						bag.adsr.sustain_vol_env_db = -s
					SoundFont.gen_oper_sample_modes:
						bag.sample_modes = gen.uamount
					SoundFont.gen_oper_sample_id:
						bag.sample_id = gen.uamount
						bag.sample = sf.pdta.shdr[gen.amount]
						if bag.original_key == 255:
							bag.original_key = bag.sample.original_key
					SoundFont.gen_oper_initial_attenuation:
						var s:float = min( max( 0.0, float( gen.amount ) ), 1440.0 ) / 10.0
						bag.volume_db = -s
					#_:
					#	print( gen.gen_oper )
				gen_count += 1
			# global zoneでない場合
			if bag.sample != null:
				sf_inst.bags.append( bag )
			else:
				global_bag = bag
			gen_index = gen_next
			bag_count += 1
		sf_insts.append( sf_inst )
		bag_index = bag_next

	return sf_insts

func _read_soundfont_preset_compose_sample( sf:SoundFont.SoundFont, preset:Preset ):
	var sample_base:PoolByteArray = sf.sdta.smpl

	for pbag_index in range( 0, preset.bags.size( ) ):
		var pbag:TempSoundFontBag= preset.bags[pbag_index]
		for ibag_index in range( 0, pbag.instrument.bags.size( ) ):
			var ibag:TempSoundFontInstrumentBag = pbag.instrument.bags[ibag_index]
			if ibag.vel_range.high < 100: continue
			var sample:SoundFont.SoundFontSampleHeader = ibag.sample
			var array_stream:Array = Array( )
			var array_base_pitch:PoolRealArray = PoolRealArray( )

			for i in range( 0, 2 ):
				var start:int = sample.start + ibag.sample_start_offset
				var end:int = sample.end + ibag.sample_end_offset
				var start_loop:int = sample.start_loop + ibag.sample_start_loop_offset
				var end_loop:int = sample.end_loop + ibag.sample_end_loop_offset
				var base_pitch:float = ( pbag.coarse_tune + ibag.coarse_tune ) / 12.0 + ( pbag.fine_tune + ibag.sample.pitch_correction + ibag.fine_tune ) / 1200.0

				var ass:AudioStreamSample = AudioStreamSample.new( )
				ass.data = sample_base.subarray( start * 2, end * 2 - 1 )
				ass.format = AudioStreamSample.FORMAT_16_BITS
				ass.mix_rate = sample.sample_rate
				ass.stereo = false
				ass.loop_begin = start_loop - start
				ass.loop_end = end_loop - start
				if ibag.sample_modes == SoundFont.sample_mode_no_loop or ibag.sample_modes == SoundFont.sample_mode_unused_no_loop:
					ass.loop_mode = AudioStreamSample.LOOP_DISABLED
				else:
					ass.loop_mode = AudioStreamSample.LOOP_FORWARD

				array_stream.append( ass )
				array_base_pitch.append( base_pitch )

				if sample.sample_type != SoundFont.sample_link_mono_sample and sample.sample_type != SoundFont.sample_link_rom_mono_sample:
					sample = sf.pdta.shdr[sample.sample_link]
				else:
					break

			var key_range:TempSoundFontRange = ibag.key_range
			var vel_range:TempSoundFontRange = ibag.vel_range

			# ADSRステート生成
			var adsr:TempSoundFontInstrumentBagADSR = ibag.adsr
			var a:float = adsr.attack_vol_env_time
			var d:float = adsr.decay_vol_env_time
			var s:float = adsr.sustain_vol_env_db
			var r:float = adsr.release_vol_env_time
			var volume_db:float = ibag.volume_db
			var ads_state:Array = [
				ADSR.VolumeState.new( 0.0, -144.0 ),
				ADSR.VolumeState.new( a, 0.0 ),
				ADSR.VolumeState.new( a+d, s ),
			]
			if a <= 0.001:
				ads_state = [
					ADSR.VolumeState.new( 0.0, 0.0 ),
					ADSR.VolumeState.new( d, s ),
				]
			var release_state:Array = [
				ADSR.VolumeState.new( 0.0, s ),
				ADSR.VolumeState.new( r, -144.0 ),
			]
			for key_number in range( key_range.low, key_range.high + 1 ):
				#if preset.number == drum_track_bank << 7:
				#	if 36 <= key_number and key_number <= 40:
				#		print( key_number, " # ", ibag.sample.name, " # ", volume_db );
				if preset.instruments[key_number] == null:
					preset.instruments[key_number] = []
				var instrument:Instrument = Instrument.new( )
				instrument.preset = preset
				instrument.array_base_pitch = array_base_pitch
				if ibag.original_key != 255:
					var shift_pitch:float = float( key_number - ibag.original_key ) / 12.0
					for k in range( len( instrument.array_base_pitch ) ):
						instrument.array_base_pitch[k] += shift_pitch
				instrument.array_stream = array_stream

				instrument.volume_db = volume_db
				instrument.ads_state = ads_state
				instrument.release_state = release_state
				instrument.vel_range_min = vel_range.low
				instrument.vel_range_max = vel_range.high
				preset.instruments[key_number].append( instrument )
