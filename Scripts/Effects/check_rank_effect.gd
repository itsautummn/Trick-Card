extends Node2D

var hand_cards: Array[Area2D]
var deck_cards: Array[Area2D]
var chip: Node2D

func _ready() -> void:
	chip = get_parent()


func effect() -> void:
	hand_cards = chip.get_cards_in_hand()
	deck_cards = chip.get_cards_in_deck()
	var trick: Area2D = find_trick()
	
	check_rank_against_hand(trick)
	chip.queue_free()


func find_trick() -> Area2D:
	for card in deck_cards:
		if card.is_trick():
			return card
			
	for card in hand_cards:
		if card.is_trick():
			return card
	
	return null # This will never happen, just shuts up the error


func check_rank_against_hand(trick):
	for card in hand_cards:
		if card.rank == trick.rank:
			chip.chip_spot.game.send_message("Trick card MATCHES a rank held in hand")
			return
	chip.chip_spot.game.send_message("Trick card does not match a rank held in hand")
