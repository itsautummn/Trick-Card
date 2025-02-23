extends Node2D

@onready var effect_scene = preload("res://Scenes/chips/effect.tscn")
@onready var tex = preload("res://Aseprite Files/Chips/death_chip.aseprite")
var chip: Node2D

func _ready() -> void:
	chip = get_parent()


func effect() -> void:
	var e = effect_scene.instantiate()
	e.type = Globals.Effects.DEATH_SAVE
	e.texture = tex
	chip.chip_spot.card_controller.add_effect(e)
	chip.queue_free()
