extends CharacterBody2D

@onready var indicator = $Indicator
var mousePos: Vector2
var hue: float
var direction: Vector2
var distance: float

func _physics_process(delta: float) -> void:
	direction = self.global_position.direction_to(mousePos)
	distance = self.global_position.distance_to(mousePos)
	
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity = Vector2(velocity.x * 0.9,velocity.y * 0.9)
		
	# Indicator Color
	mousePos = get_global_mouse_position()
	hue = 1.0 - clampf(distance / 360, 0.85, 1)
	indicator.self_modulate = Color.from_hsv(hue,1,1,1)
	
	# Hopping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity = direction * clamp(distance * 2, 0, 500)
#
	move_and_slide()
