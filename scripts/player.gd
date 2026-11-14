extends CharacterBody2D

@onready var indicator = $Indicator
var mousePos: Vector2
var hue: float
var direction: Vector2
var distance: float
var speed: float
@export var charge: float

func _physics_process(delta: float) -> void:
	direction = self.global_position.direction_to(mousePos)
	distance = self.global_position.distance_to(mousePos)
	speed = clamp(distance * 2, 0, 500)
	
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity = Vector2(velocity.x * 0.9,velocity.y * 0.9)
		
	# Indicator Color
	mousePos = get_global_mouse_position()
	hue = 1.0 - clampf(speed / 500, 0.85, 1)
	indicator.self_modulate = Color.from_hsv(hue,1,1,1)
	
	if Input.is_action_just_pressed("charge"):
		charge += 0.5
	elif not Input.is_action_just_pressed("charge") and charge >= 0.1:
		charge -= 0.01
		

	
	
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity = direction * speed * charge
		charge -= charge
#
	move_and_slide()
