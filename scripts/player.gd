extends CharacterBody2D

@onready var failUI = $Camera2D/CameraUI/Results
@onready var timer = $Camera2D/CameraUI/Timer
@onready var indicator = $Indicator

@export var charge: float
@export var goal: bool = false
@export var canMove: bool = true

var mousePos: Vector2
var hue: float = 0.15
var direction: Vector2
var distance: float

func _ready() -> void:
	failUI.visible = true
	failUI.text = "Press LMB / Space to hop!\nPress RMB / Z to increase power!\nHop and reach the carrot at the end!"

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
	# Hop
	if Input.is_action_just_pressed("jump") and is_on_floor() and canMove == true:
		velocity = direction * 250 * (1 + charge)
		charge = 0
		hue = 0.15
		if failUI.visible == true:
			failUI.visible = false
		
	# Restart
	if Input.is_action_pressed("restart level"):
		position = Vector2(0,0)
		velocity = Vector2(velocity.x * 0.0,velocity.y * 0.0)
		failUI.visible = false
		timer.time_elapsed = 0.0
		goal = false
		charge = 0
		hue = 0.15
		canMove = true
	move_and_slide()

# Results
const resultsText = [
	"Unfortunate...",
	"oof",
	"A fail...",
	"Try again!!",
	"You can bounce back!!!",
	"You got this!!"
]

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("danger"):
		velocity = Vector2(velocity.x * 0.0,velocity.y * 0.0)
		failUI.visible = true
		failUI.text = resultsText[randi_range(0,len(resultsText)) - 1] + "\nPress R to Restart"
		canMove = false
	if area.is_in_group("goal"):
		goal = true
		failUI.visible = true
		failUI.text = "Now, bounce back to the starting flag!"
	if area.is_in_group("finalgoal"):
		if goal == true:
			canMove = false
			failUI.visible = true
			failUI.text = "Amazing! Cleared in " + timer.text + "!\nPress R to Restart"
