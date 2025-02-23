extends Node2D

var hand_cards: Array[Area2D]
var chip: Node2D


func _ready() -> void:
	chip = get_parent()


func effect() -> void:
	hand_cards = chip.get_cards_in_hand()
	var trick: Area2D = find_trick()
	
	if trick != null:
		chip.chip_spot.game.send_message("TRICK CARD IN HAND!")
	else:
		chip.chip_spot.game.send_message("Trick card not in hand...")
	chip.queue_free()


func find_trick() -> Area2D:		
	for card in hand_cards:
		if card.is_trick():
			return card
	
	return null
