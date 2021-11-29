extends Node

"""
	100% pure GDScript Mod Player [Godot Mod Player] by Yui Kinomoto @arlez80
"""

class_name ModPlayer

# -----------------------------------------------------------------------------
# Import
const Mod = preload( "Mod.gd" )
const XM = preload( "XM.gd" )

# -------------------------------------------------------
# 定数
const mod_master_bus_name:String = "arlez80_GModP_MASTER_BUS"
const mod_channel_bus_name:String = "arlez80_GModP_CHANNEL_BUS%d"
const default_mix_rate:int = 4144
const default_linear_mix_rate:int = 8363
const chip_speed:float = 56.0
const volume_table:PoolRealArray = PoolRealArray([
	-144.0,-36.1,-30.1,-26.6,-24.1,-22.1,-20.6,-19.2,-18.1,-17,-16.1,-15.3,-14.5,-13.8,-13.2,-12.6,-12,-11.5,-11,-10.5,-10.1,-9.7,-9.3,-8.9,-8.5,-8.2,-7.8,-7.5,-7.2,-6.9,-6.6,-6.3,-6,-5.8,-5.5,-5.2,-5,-4.8,-4.5,-4.3,-4.1,-3.9,-3.7,-3.5,-3.3,-3.1,-2.9,-2.7,-2.5,-2.3,-2.1,-2,-1.8,-1.6,-1.5,-1.3,-1.2,-1,-0.9,-0.7,-0.6,-0.4,-0.3,-0.1,0
])

# -----------------------------------------------------------------------------
# Signals

signal note_on( channel_number, note )
signal looped

# -----------------------------------------------------------------------------
# Classes
class GodotModPlayerChannelAudioEffect:
	var ae_panner:AudioEffectPanner = null
	#var ae_reverb:AudioEffectReverb = null
	#var ae_chorus:AudioEffectChorus = null

class GodotModPlayerInstrument:
	var source:Object		# Mod.ModInstrument
	var array_ass:Array		# AudioStreamSample[]

class GodotModPlayerPitch:
	const center_key_freq:float = 856.0

	var value:int	# 現在値
	var dest:int	# 変化目標（ポルタメント用）
	var speed:int	# 変化量（ポルタメント用）

	var arpeggio:Array		# アルペジオリスト
	var arpeggio_count:int	# アルペジオカウンタ
	var arpeggio_enabled:bool

	var linear_freq:bool = false

	func _init( ):
		self.value = 0
		self.dest = 0
		self.speed = 0
		self.arpeggio = [0,0,0]
		self.arpeggio_count = 0
		self.arpeggio_enabled = false

	func update( ):
		if self.dest < self.value:
			self.value -= self.speed
			if self.value < self.dest:
				self.value = self.dest
				self.speed = 0
		elif self.value < self.dest:
			self.value += self.speed
			if self.dest < self.value:
				self.value = self.dest
				self.speed = 0

	func get_pitch_scale( with:int = 0 ) -> float:
		var v:int = self.value + with

		if self.arpeggio_enabled:
			v += self.arpeggio[self.arpeggio_count]
			self.arpeggio_count = ( self.arpeggio_count + 1 ) % 3

		if self.linear_freq:
			return pow( 2.0, ( 4608 - v ) / 768.0 )

		if v == 0:
			return 0.0001

		return center_key_freq / v

	func get_fine_pitch_scale( ) -> float:
		return pow( 2.0, ( self.value / 128.0 ) / 12.0 )

class GodotModPlayerEffect:
	var type:int = 0
	var phase:int = 0
	var speed:int = 0
	var depth:int = 0
	var depth_shift:int = 0

	var value:int = 0

	func update( ) -> void:
		var v:int = 0
		match self.type:
			Mod.ModWaveFormType.SINE_WAVEFORM:		# 正弦波
				# TODO: そのうちtableにでもしておく
				v = int( sin( self.phase * ( PI / 32.0 ) ) * 255.0 )
			Mod.ModWaveFormType.SAW_WAVEFORM:		# のこぎり
				v = 255 - ( ( self.phase + 0x20 ) & 0x3F ) * 8
			Mod.ModWaveFormType.SQUARE_WAVEFORM:	# 矩形波
				v = 255 - ( self.phase & 0x20 ) * 16
			Mod.ModWaveFormType.RAMDOM_WAVEFORM:	# 乱数
				v = self.rng.randi( 511 ) - 255
			Mod.ModWaveFormType.REV_SAW_WAVEFORM:	# 逆のこぎり
				v = ( ( self.phase + 0x20 ) & 0x3F ) * 8

		self.phase += self.speed

		self.value = ( v * self.depth ) >> self.depth_shift

class GodotModPlayerEnvelope:
	var source:Object			# Mod.ModEnvelope

	var frame:int = 0
	var value:int = 0
	var init_value:int = 0
	var sustain:bool = false
	var enabled:bool = false

	func note_on( _source:Object ):
		self.source = _source
		self.sustain = true
		self.frame = 0
		if self.source != null and self.source.enabled:
			self.value = self.source.points[0].value
		else:
			self.value = self.init_value

	func note_off( ):
		self.sustain = false

	func update( ) -> void:
		if self.source == null:
			self.value = self.init_value
			return

		self.enabled = self.source.enabled

		if not self.enabled:
			self.value = self.init_value
			return

		var current_point:int = 0
		var prev_sum_frame:int = 0
		var sum_frame:int = 0
		var loop_start_frame:int = 0
		for i in range( 1, self.source.point_count ):
			sum_frame += self.source.points[i].frame
			if self.source.loop_start_point == i:
				loop_start_frame = sum_frame
			if self.frame < sum_frame:
				var t:float = float( self.frame - prev_sum_frame ) / float( sum_frame - prev_sum_frame )
				var s:float = 1.0 - t
				self.value = int( self.source.points[i-1].value * s + self.source.points[i].value * t )
				break
			prev_sum_frame = sum_frame
			current_point = i

		if self.source.sustain_enabled and self.sustain and self.source.sustain_point == current_point:
			pass
		elif self.source.loop_enabled and self.source.loop_end_point == current_point:
			self.frame = loop_start_frame
		elif current_point == self.source.point_count and sum_frame < self.frame:
			self.frame = sum_frame
		else:
			self.frame += 1

class GodotModPlayerChannelStatus:
	const head_silent_second:float = 1.0
	const gap_second:float = 44100.0 / 1024.0 / 1000.0

	var source_inst:Object		# Mod.ModInstrument
	var source_sample:Object	# Mod.ModSample
	var asps:Array				# AudioStreamPlayer[]
	var asp_switcher:int

	var channel_number:int
	var last_instrument:int = -1
	var mute:bool
	var pitch:GodotModPlayerPitch
	var fine_pitch:GodotModPlayerPitch
	var relative_pitch:float = 1.0

	var sample_number:int
	var volume:int
	var panning:int
	var amplified:int
	var fx_count:int
	var vibrato:GodotModPlayerEffect
	var tremolo:GodotModPlayerEffect

	var volume_env:GodotModPlayerEnvelope
	var panning_env:GodotModPlayerEnvelope

	var force_note_off:bool = false

	func _init( _channel_number:int, linear_freq:bool ):
		self.mute = false
		self.force_note_off = false

		self.channel_number = _channel_number
		self.panning = 128

		for i in range( 2 ):
			var asp: = AudioStreamPlayer.new( )
			asp.bus = mod_channel_bus_name % self.channel_number
			self.asps.append( asp )
		self.asp_switcher = 0

		self.pitch = GodotModPlayerPitch.new( )
		self.fine_pitch = GodotModPlayerPitch.new( )
		self.pitch.linear_freq = linear_freq
		self.fine_pitch.linear_freq = linear_freq
		self.vibrato = GodotModPlayerEffect.new( )
		self.vibrato.depth_shift = 7
		self.tremolo = GodotModPlayerEffect.new( )
		self.tremolo.depth_shift = 6
		self.volume_env = GodotModPlayerEnvelope.new( )
		self.volume_env.init_value = 64
		self.panning_env = GodotModPlayerEnvelope.new( )
		self.panning_env.init_value = 32

	func tick_update( ):
		self.volume_env.update( )
		self.panning_env.update( )

	func update( ) -> void:
		if self.mute:
			for asp in self.asps:
				if asp.is_playing( ):
					asp.stop( )
			return

		for i in range( self.asps.size( ) ):
			var asp:AudioStreamPlayer = self.asps[i]
			if self.asp_switcher == i and ( not self.force_note_off ):
				if asp.is_playing( ):
					asp.volume_db = self.get_volume_db( )
					asp.pitch_scale = self.get_pitch_scale( )
			else:
				if asp.is_playing( ):
					asp.volume_db -= 4.0
					if asp.volume_db < -100.0:
						asp.stop( )

	func get_volume_db( ) -> float:
		var v:float = ( clamp( self.volume + self.tremolo.value, 0.0, 64.0 ) / 64.0 ) * ( self.volume_env.value / 64.0 )
		return volume_table[int(v * 64)]

	func get_pitch_scale( ) -> float:
		return self.pitch.get_pitch_scale( self.vibrato.value ) * self.relative_pitch * self.fine_pitch.get_fine_pitch_scale( )

	func note_off( ):
		self.volume_env.note_off( )
		self.panning_env.note_off( )

	func note_on( inst:GodotModPlayerInstrument, sample_number:int, effect_command:int, key_number:int, note:int ) -> void:
		if self.mute:
			return

		self.force_note_off = false
		self.asp_switcher = ( self.asp_switcher + 1 ) % self.asps.size( )

		self.source_inst = inst.source
		self.source_sample = self.source_inst.samples[note-1]
		if self.source_sample.panning != -1:
			self.panning = self.source_sample.panning

		var asp:AudioStreamPlayer = self.asps[self.asp_switcher]
		asp.stop( )
		asp.stream = inst.array_ass[note-1]
		self.volume = self.source_sample.volume
		self.sample_number = sample_number
		if effect_command == 0x03 || effect_command == 0x05:
			self.pitch.dest = key_number
		else:
			self.pitch.value = key_number
		self.fine_pitch.value = self.source_sample.finetune
		self.relative_pitch = pow( 2.0, self.source_sample.relative_note / 12.0 )
		if self.source_inst.vibrato_type != -1:
			self.vibrato.type = self.source_inst.vibrato_type
			self.vibrato.speed = self.source_inst.vibrato_speed
			self.vibrato.depth = self.source_inst.vibrato_depth
			self.vibrato.depth_shift = self.source_inst.vibrato_depth_shift

		self.volume_env.note_on( self.source_inst.volume_envelope )
		self.panning_env.note_on( self.source_inst.panning_envelope )

		asp.volume_db = self.get_volume_db( )
		var pitch_scale:float = self.get_pitch_scale( )
		asp.pitch_scale = pitch_scale
		asp.play( max( 0.0, self.head_silent_second - clamp( self.gap_second - AudioServer.get_time_to_next_mix( ), 0.0, self.gap_second ) * pitch_scale ) )

# -----------------------------------------------------------------------------
# Export

# ファイル
export (String, FILE, "*.mod,*.xm") var file:String = "" setget set_file
# 再生中か？
export (bool) var playing:bool = false
# 音量
export (float, -144.0, 0.0) var volume_db:float = -20.0 setget set_volume_db
# キーシフト（未実装）
#export (int) var key_shift:int = 0
# ループフラグ
export (bool) var loop:bool = false
# mix_target same as AudioStreamPlayer's one
export (int, "MIX_TARGET_STEREO", "MIX_TARGET_SURROUND", "MIX_TARGET_CENTER") var mix_target:int = AudioStreamPlayer.MIX_TARGET_STEREO
# bus same as AudioStreamPlayer's one
export (String) var bus:String = "Master"
# リリースタイムの発音軽減を与えてブツ切り回避する
#export (bool) var append_release_time:bool = true

# -----------------------------------------------------------------------------
# 変数

# Modデータ
var mod_data:Mod.Mod = null setget set_mod_data
# テンポ
var tempo:float = 125.0 setget set_tempo
# 行毎秒
var row_per_second:float = 0.02
# tick毎行
var tick_per_row:int = 4
# tick毎秒
var tick_per_second:float = 1.0 / chip_speed
# 次の行への秒数
var next_row_remain_second:float = 0.0
# 次のtickへの秒数
var next_tick_remain_second:float = 0.0
# 追加tick
var extra_tick:int = 0
# tick処理済み回数
var processed_tick_count:int = 0
# 位置（秒）
var position:float = 0.0
# 曲位置
var song_position:int = 0
# パターン内位置
var pattern_position:int = 0
# 次の行
var pattern_position_on_next_row:int = 0
# 楽器
var instruments:Array = []
# チャンネル
var channel_status:Array = []
# Modチャンネルエフェクト
var channel_audio_effects:Array = []
# パターンジャンプ先
var pattern_position_jump_point:int = 0
# パターンループカウンタ
var pattern_loop_count:int = 0
# パターンループ先
var pattern_loop_origin:int = 0
# 乱数
var rng:RandomNumberGenerator
# グローバル音量コマンドを有効にするか？
var enable_global_volume_command:bool = true
# グローバル音量 (mod/xm指定の数字)
var global_volume:int = 64
# グローバル音量 (計算用db)
var global_volume_db:float = 0.0

"""
	準備
"""
func _ready( ):
	self.rng = RandomNumberGenerator.new( )

	if AudioServer.get_bus_index( self.mod_master_bus_name ) == -1:
		AudioServer.add_bus( -1 )
		var mod_master_bus_idx:int = AudioServer.get_bus_count( ) - 1
		AudioServer.set_bus_name( mod_master_bus_idx, self.mod_master_bus_name )
		AudioServer.set_bus_send( mod_master_bus_idx, self.bus )
		AudioServer.set_bus_volume_db( AudioServer.get_bus_index( self.mod_master_bus_name ), self.volume_db )

		for i in range( 32 ):
			AudioServer.add_bus( -1 )
			var mod_channel_bus_idx:int = AudioServer.get_bus_count( ) - 1
			AudioServer.set_bus_name( mod_channel_bus_idx, self.mod_channel_bus_name % i )
			AudioServer.set_bus_send( mod_channel_bus_idx, self.mod_master_bus_name )
			AudioServer.set_bus_volume_db( mod_channel_bus_idx, 0.0 )

			var cae: = GodotModPlayerChannelAudioEffect.new( )
			cae.ae_panner = AudioEffectPanner.new( )
			AudioServer.add_bus_effect( mod_channel_bus_idx, cae.ae_panner )
			self.channel_audio_effects.append( cae )

	if self.playing:
		self.play( )

"""
	通知
"""
func _notification( what:int ):
	# 破棄時
	if what == NOTIFICATION_PREDELETE:
		pass
		#AudioServer.remove_bus( AudioServer.get_bus_index( self.mod_master_bus_name ) )
		#for i in range( 0, 16 ):
		#	AudioServer.remove_bus( AudioServer.get_bus_index( self.midi_channel_bus_name % i ) )

"""
	再生前の初期化
"""
func _prepare_to_play( ):
	# ファイル読み込み
	if self.mod_data == null:
		match self.file.get_extension( ):
			"mod":
				var mod_reader: = Mod.new( )
				self.mod_data = mod_reader.read_file( self.file )
			"xm":
				var xm_reader: = XM.new( )
				var m:Object = xm_reader.read_file( self.file )
				self.mod_data = m
			_:
				self.mod_data = null

	if self.mod_data == null:
		self.stop( )
		return

	if self.channel_status != null:
		for t in self.channel_status:
			for asp in t.asps:
				self.remove_child( asp )

	self.set_volume_db( self.volume_db )

	self.instruments = []
	var temp_head_silent:Array = []
	var head_silent_samples:int = default_mix_rate
	if self.mod_data.flags & Mod.ModFlags.LINEAR_FREQUENCY_TABLE != 0:
		head_silent_samples = default_linear_mix_rate
	for i in range( head_silent_samples ):
		temp_head_silent.append( 0 )
	var head_silent:PoolByteArray = PoolByteArray( temp_head_silent )
	var loaded:Dictionary = {}
	for t in self.mod_data.instruments:
		var inst:GodotModPlayerInstrument = GodotModPlayerInstrument.new( )

		inst.source = t
		inst.array_ass = []

		for sample in t.samples:
			var id:int = sample.get_instance_id( )
			var ass:AudioStreamSample = null
			if not( id in loaded ):
				ass = AudioStreamSample.new( )
				ass.stereo = false
				if self.mod_data.flags & Mod.ModFlags.LINEAR_FREQUENCY_TABLE != 0:
					ass.mix_rate = self.default_linear_mix_rate
				else:
					ass.mix_rate = self.default_mix_rate
				if sample.bit == 16:
					ass.data = head_silent + head_silent  + sample.data
					ass.format = AudioStreamSample.FORMAT_16_BITS
				else:
					ass.data = head_silent + sample.data
					ass.format = AudioStreamSample.FORMAT_8_BITS
				ass.loop_begin = sample.loop_start + head_silent_samples
				ass.loop_end = ass.loop_begin + sample.loop_length
				if sample.bit == 16:
					ass.loop_begin /= 2
					ass.loop_end /= 2
				ass.loop_mode = AudioStreamSample.LOOP_DISABLED
				if sample.loop_type & Mod.ModLoopType.FORWARD_LOOP != 0:
					ass.loop_mode = AudioStreamSample.LOOP_FORWARD
				elif sample.loop_type & Mod.ModLoopType.PING_PONG_LOOP != 0:
					ass.loop_mode = AudioStreamSample.LOOP_PING_PONG
				loaded[id] = ass
				loaded[id] = ass
			else:
				ass = loaded[id]
			inst.array_ass.append( ass )

		self.instruments.append( inst )
	for k in loaded.keys( ):
		loaded.erase( k )

	self.channel_status = []
	for i in range( self.mod_data.channel_count ):
		var cs: = GodotModPlayerChannelStatus.new( i, self.mod_data.flags & Mod.ModFlags.LINEAR_FREQUENCY_TABLE != 0 )
		if 4 < self.mod_data.channel_count:
			cs.panning = 128
		else:
			cs.panning = [64,192,192,64][i]
		for asp in cs.asps:
			self.add_child( asp )
		self.channel_status.append( cs )

"""
	再生
	@param	from_position
"""
func play( from_position:float = 0.0 ):
	self._prepare_to_play( )
	if self.mod_data == null:
		return

	self.playing = true
	if from_position == 0.0:
		self.position = 0.0
		self.song_position = 0
		self.pattern_position_jump_point = 1
		self.pattern_position = -1
		self.pattern_position_on_next_row = -1
		self.pattern_loop_count = 0
		self.pattern_loop_origin = 0
		self.tick_per_second = 1.0 / self.chip_speed
		self.set_tempo( self.mod_data.init_bpm )
		self.set_tick( self.mod_data.init_tick )
		self.processed_tick_count = 10000
		self.next_tick_remain_second = 0.0
		self.next_row_remain_second = self.row_per_second
	else:
		self.seek( from_position )

"""
	シーク: TODO:未実装
"""
func seek( to_position:float ):
	self._previous_time = 0.0
	self._stop_all_notes( )

"""
	停止
"""
func stop( ):
	self._stop_all_notes( )
	self.playing = false

"""
	ファイル変更
"""
func set_file( path:String ):
	file = path
	self.mod_data = null
	if self.playing:
		self.play( )

"""
	Modデータ更新
"""
func set_mod_data( md ):
	mod_data = md

"""
	音量設定
"""
func set_volume_db( vdb:float ):
	var master_bus_id:int = AudioServer.get_bus_index( self.mod_master_bus_name )
	volume_db = vdb
	if master_bus_id == -1:
		return

	var gvdb:float = self.global_volume_db if self.enable_global_volume_command else 0.0
	AudioServer.set_bus_volume_db( master_bus_id, volume_db + gvdb )

"""
	全音を止める
"""
func _stop_all_notes( ):
	for t in self.channel_status:
		t.note_off( )
		t.force_note_off = true
		for asp in t.asps:
			if asp.is_playing( ):
				asp.stop( )

"""
	テンポ設定
"""
func set_tempo( _tempo:float ):
	tempo = _tempo
	self.tick_per_second = 1.0 / ( chip_speed * ( _tempo / 125.0 ) )
	self.row_per_second = self.tick_per_row * self.tick_per_second

"""
	tickからテンポ設定
"""
func set_tick( _tick:int ):
	self.tick_per_row = _tick
	self.row_per_second = self.tick_per_row * self.tick_per_second

"""
	1フレームでシーケンス処理
"""
func _process( delta:float ):
	if self.mod_data != null:
		if self.playing:
			self.position += delta
			self.next_row_remain_second -= delta
			self.next_tick_remain_second -= delta
			if self.next_row_remain_second <= 0.0:
				self.next_tick_remain_second = -INF
			while self.next_tick_remain_second <= 0.0 and self.processed_tick_count < self.tick_per_row + self.extra_tick:
				var rps:float = self.row_per_second
				self._process_tick( )
				if self.row_per_second != rps:
					self.next_row_remain_second = self.row_per_second
				# printt( "TICK %d/%d" % [ self.processed_tick_count, self.tick_per_row + self.extra_tick ], self.next_tick_remain_second )
				self.next_tick_remain_second += self.tick_per_second
				self._process_row( )
				self.processed_tick_count += 1
			if self.next_row_remain_second <= 0.0:
				self.extra_tick = 0
				self._process_next_line( )
				self.next_row_remain_second = self.row_per_second
				self.next_tick_remain_second = 0.0
				self.processed_tick_count = 1
			self._process_update_channels( )
		else:
			self.stop( )

func _process_next_line( ) -> void:
	if 0 <= self.pattern_position_on_next_row:
		self.pattern_position = self.pattern_position_on_next_row
		self.pattern_position_on_next_row = -1
		self.song_position = self.pattern_position_jump_point
		self.pattern_position_jump_point = self.song_position + 1
	else:
		self.pattern_position += 1
		if len( self.mod_data.patterns[self.mod_data.song_positions[self.song_position]] ) <= self.pattern_position:
			self.pattern_position = 0
			self.song_position = self.pattern_position_jump_point
			self.pattern_position_jump_point = self.song_position + 1

	if self.mod_data.song_length <= self.song_position:
		if self.loop:
			self.song_position = self.mod_data.restart_position
			self.pattern_position_jump_point = self.song_position + 1
			self.emit_signal( "looped" )
		else:
			self.song_position = 0
			self.stop( )
			return

"""
	1行処理
"""
func _process_row( ) -> void:
	var pattern_line:Array = self.mod_data.patterns[self.mod_data.song_positions[self.song_position]][self.pattern_position]
	for channel in self.channel_status:
		self._process_row_for_channel( channel, pattern_line[channel.channel_number] )

"""
	チャンネルごとの1行
"""
func _process_row_for_channel( channel:GodotModPlayerChannelStatus, note:Mod.ModPatternNote ) -> void:
	#printt( channel.channel_number, pattern_node.sample_number, pattern_node.key_number, pattern_node.effect_command )

	var note_on:bool = self.processed_tick_count == 1
	# Note関係のエフェクトコマンド
	if note.effect_command == 0x0E:
		match ( note.effect_param >> 4 ):
			0x09:	# Retrigger Note
				note_on = ( ( self.processed_tick_count - 1 ) % ( note.effect_param & 0x0F ) ) == 0
			0x0D:	# Note Delay
				note_on = ( note.effect_param & 0x0F ) == self.processed_tick_count

	# 楽器設定
	if note.instrument != 0:
		channel.last_instrument = note.instrument - 1
	# 発音
	if note_on:
		channel.pitch.arpeggio_count = 0
		if note.note == 96:
			channel.note_off( )
		elif 0 < note.key_number:
			if 0 <= channel.last_instrument and channel.last_instrument < self.instruments.size( ):
				var inst:GodotModPlayerInstrument = self.instruments[channel.last_instrument]
				channel.note_on( inst, note.instrument, note.effect_command, note.key_number, note.note )

			self.emit_signal( "note_on", channel.channel_number, note )

	if self.processed_tick_count == 1:
		self._process_tick_for_channel( channel, note, true )

"""
	1tick処理
"""
func _process_tick( ) -> void:
	if self.pattern_position < 0:
		return

	var pattern_line:Array = self.mod_data.patterns[self.mod_data.song_positions[self.song_position]][self.pattern_position]
	for channel in self.channel_status:
		self._process_tick_for_channel( channel, pattern_line[channel.channel_number], false )

"""
	チャンネルごとの1tick
"""
func _process_tick_for_channel( channel:GodotModPlayerChannelStatus, note:Mod.ModPatternNote, disable_channel_row:bool ) -> void:
	#print( "%08x %08x" % [ note.effect_command, note.effect_param ] )

	channel.pitch.arpeggio_enabled = false
	channel.vibrato.value = 0
	channel.tremolo.value = 0

	channel.tick_update( )

	if 0x10 <= note.volume and note.volume <= 0x50:
		channel.volume = note.volume - 0x10
	elif 0x60 <= note.volume:
		match note.volume >> 4:
			0x06:	# Volume slide down
				if not disable_channel_row:
					channel.volume = int( clamp( channel.volume - ( note.volume & 0x0F ), 0, 64 ) )
			0x07:	# Volume slide up
				if not disable_channel_row:
					channel.volume = int( clamp( channel.volume + ( note.volume & 0x0F ), 0, 64 ) )
			0x08:	# Fine volume slide down
				if not disable_channel_row:
					channel.volume = int( clamp( channel.volume - ( note.volume & 0x0F ), 0, 64 ) )
			0x09:	# Fine volume slide up
				if not disable_channel_row:
					channel.volume = int( clamp( channel.volume + ( note.volume & 0x0F ), 0, 64 ) )
			0x0A:	# Set vibrato speed
				channel.vibrato.speed = (channel.vibrato.speed & 0x0F) | ( ( note.volume & 0x0F ) << 4 );
			0x0C:	# Panning
				var p:int = note.volume & 0x0F
				p |= p << 4
				channel.panning = p
			0x0D:	# Panning slide left
				if not disable_channel_row:
					channel.panning = int( clamp( channel.panning - ( note.panning & 0x0F ), 0, 255 ) )
			0x0E:	# Panning slide right
				if not disable_channel_row:
					channel.panning = int( clamp( channel.panning + ( note.panning & 0x0F ), 0, 255 ) )
			0x0F:	# Tone portamento
				if 0 < note.volume & 0x0F:
					var p:int = note.volume & 0x0F
					p |= p << 4
					channel.pitch.speed = p
			_:
				printerr( "unknown volume effect command: %02x" % note.volume )

	# エフェクトコマンド
	match note.effect_command:
		0x00:	# Arpeggio
			channel.pitch.arpeggio[1] = int( channel.pitch.value / pow( 2.0, ( note.effect_param >> 4 ) / 12.0 ) ) - channel.pitch.value
			channel.pitch.arpeggio[2] = int( channel.pitch.value / pow( 2.0, ( note.effect_param & 0x0F ) / 12.0 ) ) - channel.pitch.value
			channel.pitch.arpeggio_enabled = true
		0x01:	# Portament up
			if not disable_channel_row:
				channel.pitch.value = int( max( channel.pitch.value - note.effect_param, 0 ) )
		0x02:	# Portament down
			if not disable_channel_row:
				channel.pitch.value = channel.pitch.value + note.effect_param
		0x03:	# Portament speed
			channel.pitch.speed = note.effect_param
			channel.pitch.update( )
		0x04:	# Vibrato
			if 0 < note.effect_param & 0xF0:
				channel.vibrato.speed = note.effect_param >> 4
			if 0 < note.effect_param & 0x0F:
				channel.vibrato.depth = note.effect_param & 0x0F
			channel.vibrato.update( )
		0x05:	# Portament + Volume slide
			channel.pitch.update( )
			channel.volume = int( clamp( channel.volume + ( note.effect_param >> 4 ) - ( note.effect_param & 0x0F ), 0, 64 ) )
		0x06:	# Vibrato + Volume slide
			channel.vibrato.update( )
			channel.volume = int( clamp( channel.volume + ( note.effect_param >> 4 ) - ( note.effect_param & 0x0F ), 0, 64 ) )
		0x07:	# Tremolo
			if 0 < note.effect_param & 0xF0:
				channel.tremolo.speed = note.effect_param >> 4
			if 0 < note.effect_param & 0x0F:
				channel.tremolo.depth = note.effect_param & 0x0F
			channel.tremolo.update( )
		0x08:	# Panning
			channel.panning = int( clamp( note.effect_param * 2, 0, 255 ) )
		0x09:	# Sample offset
			printerr( "not implemented: 9xx Sample offset" )
		0x0A:	# Volume slide
			if not disable_channel_row:
				channel.volume = int( clamp( channel.volume + ( note.effect_param >> 4 ) - ( note.effect_param & 0x0F ), 0, 64 ) )
		0x0B:	# Pattern jump
			if disable_channel_row:
				self.pattern_position_jump_point = note.effect_param
				self.pattern_position_on_next_row = 0
		0x0C:	# Volume
			channel.volume = int( clamp( note.effect_param, 0, 64 ) )
		0x0D:	# Pattern break
			if disable_channel_row:
				self.pattern_position_jump_point = self.song_position + 1
				self.pattern_position_on_next_row = ( note.effect_param >> 4 ) * 10 + ( note.effect_param & 0x0F )
				if 64 <= self.pattern_position_on_next_row:
					self.pattern_position_on_next_row = 0
		0x0E:	# 拡張コマンド
			match ( note.effect_param >> 4 ):
				0x01:	# Fine portamento up
					if 0 < note.effect_param & 0x0F:
						channel.fine_pitch.speed = note.effect_param & 0x0F
					channel.fine_pitch.update( )
				0x02:	# Fine portamento down
					if 0 < note.effect_param & 0x0F:
						channel.fine_pitch.speed = - (note.effect_param & 0x0F)
					channel.fine_pitch.update( )
				0x04:	# Vibrato type
					channel.vibrato.type = note.effect_param
					channel.vibrato.update( )
				0x06:	# Pattern loop
					if disable_channel_row:
						if 0 < ( note.effect_param & 0x0F ):
							if ( note.effect_param & 0x0F ) == self.pattern_loop_count:
								self.pattern_loop_count = 0
							else:
								self.pattern_loop_count += 1
								self.pattern_position_jump_point = self.song_position
								self.pattern_position_on_next_row = self.pattern_loop_origin
						else:
							self.pattern_loop_origin = self.pattern_position
				0x07:	# Tremoro type
					channel.tremolo.type = note.effect_param
					channel.tremolo.update( )
				0x09:	# Retrigger Note
					pass
				0x0A:	# Fine volume slide up
					if not disable_channel_row:
						channel.volume = int( clamp( channel.volume + ( note.volume & 0x0F ), 0, 64 ) )
				0x0B:	# Fine volume slide down
					if not disable_channel_row:
						channel.volume = int( clamp( channel.volume - ( note.volume & 0x0F ), 0, 64 ) )
				0x0C:	# Note cut
					if self.processed_tick_count - 1 == note.volume & 0x0F:
						channel.volume = 0
				0x0D:	# Note delay
					pass
				0x0E:	# Pattern delay
					var r:int = ( note.effect_param & 0x0F )
					self.extra_tick = r * self.tick_per_row
					if disable_channel_row:
						self.next_row_remain_second += self.row_per_second * r
				_:
					printerr( "unknown extended command: %04x" % [ note.effect_param ] )
		0x0F:	# Tick / Tempo
			if note.effect_param < 0x20:
				self.set_tick( note.effect_param )
			else:
				self.set_tempo( note.effect_param )
		0x10:	# Global volume
			self.global_volume = int( clamp( note.effect_param, 0, 64 ) )
			self.global_volume_db = self.volume_table[self.global_volume]
			self.set_volume_db( self.volume_db )
		0x11:	# Global volume slide
			self.global_volume = int( clamp( self.global_volume + ( note.effect_param >> 4 ) - ( note.effect_param & 0x0F ), 0, 64 ) )
			self.global_volume_db = self.volume_table[self.global_volume]
			self.set_volume_db( self.volume_db )
		0x14:	# Key off
			printerr( "not implemented: Kxx Key off" )
		0x15:	# Set envelope position
			channel.tremolo.phase = note.effect_param
		0x19:	# Pannning slide
			if not disable_channel_row:
				channel.panning = int( clamp( channel.panning + ( note.effect_param >> 4 ) - ( note.effect_param & 0x0F ), 0, 255 ) )
		0x1B:	# Multi retrig note
			printerr( "not implemented: Rxy Multi retrig note" )
		0x1D:	# Tremor
			printerr( "not implemented: Txy Tremor" )
		_:
			printerr( "unknown command: %02x : %04x" % [ note.effect_command, note.effect_param ] )

"""
	チャンネル更新
"""
func _process_update_channels( ) -> void:
	for channel in self.channel_status:
		channel.update( )
		var cae:GodotModPlayerChannelAudioEffect = self.channel_audio_effects[channel.channel_number]
		cae.ae_panner.pan = clamp( ( ( channel.panning - 128 ) / 128.0 ) + ( ( channel.panning_env.value - 32 ) / 32.0 ), -1.0, 1.0 )
