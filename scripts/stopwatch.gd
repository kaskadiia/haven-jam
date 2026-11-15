extends Label

@export var time_elapsed: float = 0
@export var player: CharacterBody2D

var time : float = 0
var minutes: int = int(time_elapsed) / 60
var seconds: int = int(time_elapsed) % 60
var time_string = "%02d:%02d" % [minutes,seconds]

func _process(delta: float) -> void:
	time_elapsed += delta
	if not player.goal:
		time += delta
		label_settings.font_color = Color(1.0, 1.0, 1.0, 1.0)
	else:
		time -= delta
		label_settings.font_color = Color(1.0, 0.0, 0.0, 1.0)
	minutes = int(time) / 60
	seconds = int(time) % 60
	time_string = "%02d:%02d" % [minutes,seconds]
	text = str(time_string)
func real_time():
	return "%02d:%02d" % [int(time_elapsed) / 60, int(time_elapsed) % 60]
