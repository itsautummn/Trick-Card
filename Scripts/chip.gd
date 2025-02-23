extends Node2D

signal pressed
signal hovering
signal nothovering

@export var chip_name: String
@export var cost: int

@onready var chip_spot = get_parent()


func get_cards_in_deck() -> Array[Area2D]:
	return chip_spot.card_controller.deck.get_cards_in() # Parent is chip spot


func get_cards_in_hand():
	return chip_spot.card_controller.hand.get_cards_in() # Parent is chip spot


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		pressed.emit(self)


func effect():
	$Effect.effect()


func _on_area_2d_mouse_entered() -> void:
	hovering.emit(self)


func _on_area_2d_mouse_exited() -> void:
	nothovering.emit()
