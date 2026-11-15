extends Node2D
var time_elasped = 0.0
var minutes: float = time_elasped / 60
var seconds: float = fmod(minutes, 60)
func _process(delta: float) -> void:
	time_elasped += delta
var time_string := "%02d:%02d:%02d" % [minutes,seconds]
