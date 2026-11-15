extends Label

@export var time_elapsed: float = 0
var minutes: int = int(time_elapsed) / 60
var seconds: int = int(time_elapsed) % 60
var time_string = "%02d:%02d" % [minutes,seconds]

func _process(delta: float) -> void:
	time_elapsed += delta
	minutes = int(time_elapsed) / 60
	seconds = int(time_elapsed) % 60
	time_string = "%02d:%02d" % [minutes,seconds]
	text = str(time_string)
