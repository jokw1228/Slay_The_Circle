extends Node

'''
!! SIMPLE PLAYING / STOPPING
{
playing music : AudioManager.play_music("labelname","trackname",fade_time,loop)
stopping music : AudioManager.stop_music(fade_time)

playing SFX : AudioManager.play_sound("labelname","resource")
stopping SFX : AudioManager.stop_sound("labelname","resource")
}

YOU CAN SEE "LABELNAME" AND "TRACKNAME"(OR "RESOURCE") IN THE INSPECTOR OF THE MUSICBANK OR SOUNDBANK NODE.
'''

func play_music(label: String,track: String, fade_time : float,auto_loop : bool):
	MusicManager.play(label,track,fade_time,auto_loop)
	
func stop_music(fade_time : float):
	MusicManager.stop(fade_time)
	
	
	
	
func play_sound(label: String, resource: String):
	SoundManager.play(label,resource)
	
func play_varied_sound(label: String, resource: String, p_pitch: float, p_volume:float):
	SoundManager.play_varied(label,resource,p_pitch,p_volume)
	
func stop_sound(label: String, resource: String):
	SoundManager.stop(label,resource)
	
'''
test

func _ready() -> void:
	MusicManager.loaded.connect(on_music_manager_loaded)
func on_music_manager_loaded() -> void:
	MusicManager.play("bgm","fast_bgm")


func _ready() -> void:
	SoundManager.loaded.connect(on_sound_manager_loaded)
func on_sound_manager_loaded() -> void:
	SoundManager.play("sfx","test")
'''


