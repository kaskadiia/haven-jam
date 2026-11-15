extends CharacterBody2D

@export var failUI: Label
@export var timer: Label
@onready var indicator = $Indicator
@onready var g_indicator = $GhostInd

@export var goal_obj: Area2D

@export var charge: float
@export var goal: bool = false
var reached_final_goal = false
@export var canMove: bool = true

var mousePos: Vector2
var hue: float = 0.15
var direction: Vector2
var distance: float
var dir_buff: Vector2
var charge_buff: float
var lost = false

func time_lose():
	if not lost:
		lost = true
		canMove = false
		velocity = Vector2.ZERO
		failUI.visible = true
		failUI.text = resultsText[randi_range(0,len(resultsText)) - 1] + "\nPress R to Restart"
		Engine.time_scale = 0

func _ready() -> void:
	pass # failUI.visible = true
	# failUI.text = "Press LMB / Space to hop!\nPress RMB / Z to increase power!\nHop and reach the carrot at the end!"
#bounce
func bounce():
	if dir_buff.y < -0.18:
		velocity = dir_buff * 250 * (1 + charge_buff)
	#$Sprite.scale.y = 0.1

func reverse_seq():
	if not goal:
		goal = true
		failUI.visible = true
		failUI.text = "Now, bounce back to the starting flag!"
		get_tree().create_timer(3).timeout.connect(func():
			failUI.visible = false
		)
		goal_obj.visible = false
		timer.time = int(timer.time * 1.35)
		timer.get_node("../Warning").visible = true
		if timer.time > 240:
			timer.time = 240
	

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

	#if Input.is_action_just_pressed("charge"):
		#if charge <= 2:
			#charge += 0.5
			#hue -= 0.025
		#else:
			#charge = 0
			#hue = 0.15
	# Hop
	dir_buff = direction
	charge_buff = charge
	
	#if Input.is_action_just_pressed("jump"):
		#dir_buff = direction
		#charge_buff = charge
		#g_indicator.rotation = dir_buff.angle()
		#g_indicator.self_modulate = indicator.self_modulate
		#if is_on_floor() and canMove == true:
			#bounce()

		
	# Restart
	if Input.is_action_pressed("restart level"):
		get_tree().reload_current_scene()
		Engine.time_scale = 1
		#position = Vector2(0,0)
		#velocity = Vector2(velocity.x * 0.0,velocity.y * 0.0)
		#failUI.visible = false
		#timer.time_elapsed = 0.0
		#goal = false
		#charge = 0
		#dir_buff = Vector2.ZERO
		#charge_buff = 0
		#hue = 0.15
		#canMove = true
	
	if ($Sprite.scale.x < 0 and velocity.x > 0) or ($Sprite.scale.x > 0 and velocity.x < 0):
		$Sprite.scale.x = -$Sprite.scale.x

	#$Sprite.scale.y = lerpf($Sprite.scale.y, 0.2, 0.02)
	
	
		
	# Exit
	if Input.is_action_pressed("exit"):
		get_tree().change_scene_to_file("res://scenes/level_select.tscn")
		
	var last = velocity
		
	
	move_and_slide()
	if is_on_wall():
		velocity = last.bounce(get_wall_normal())
	if is_on_floor() and not Input.is_action_just_pressed("jump"):
		if dir_buff:
			bounce()
		elif last.y > 230.0:
			velocity.y = -last.y
	
	if timer.time < 0:
		time_lose()
		# charge scroll option
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if charge <= 2:
					charge += 0.5
					hue -= 0.025
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if charge > 0:
					charge = 0
					hue = 0.15

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
		time_lose()
	if area.is_in_group("goal"):
		reverse_seq()
	if area.is_in_group("finalgoal"):
		if goal == true and not reached_final_goal:
			reached_final_goal = true
			canMove = false
			failUI.visible = true
			failUI.text = "Amazing! Cleared in " + timer.real_time() + "!\nPress R to Restart"
			
func please_let_me_commit():
		pass
