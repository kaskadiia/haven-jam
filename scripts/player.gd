extends CharacterBody2D

@onready var indicator = $Indicator
var mousePos: Vector2
var hue: float = 0.15
var direction: Vector2
var distance: float
@export var charge: float

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
	indicator.rotation = direction.angle()
	indicator.self_modulate = Color.from_hsv(hue,1,1,1)
	
	if Input.is_action_just_pressed("charge"):
		if charge <= 2:
			charge += 0.5
			hue -= 0.025
		else:
			charge = 0
			hue = 0.15
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity = direction * 250 * (1 + charge)
		charge = 0
		hue = 0.15

	move_and_slide()
