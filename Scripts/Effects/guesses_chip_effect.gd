extends Node2D

var chip: Node2D


func _ready() -> void:
	chip = get_parent()


func effect() -> void:
	chip.chip_spot.card_controller.reset_guesses()
	chip.queue_free()
