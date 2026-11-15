extends Control

@export var l1 : PackedScene
@export var l2 : PackedScene
@export var l3 : PackedScene

func _ready() -> void:
	for i in $TextureRect.get_children():
		if i.get_class() == "Button":
			i.pressed.connect(_on_button_pressed.bind(i.name))

func _on_button_pressed(name : StringName) -> void:
	if name == "Level1":
		get_tree().change_scene_to_packed(l1)
	elif name == "Level2":
		get_tree().change_scene_to_packed(l2)
	elif name == "Level3":
		get_tree().change_scene_to_packed(l3)
