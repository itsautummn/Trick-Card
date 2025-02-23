extends Node2D

var hand_cards: Array[Area2D]
var deck_cards: Array[Area2D]
var chip: Node2D

func _ready() -> void:
	chip = get_parent()


func effect() -> void:
	hand_cards = chip.get_cards_in_hand()
	deck_cards = chip.get_cards_in_deck()
	var flag: bool = is_trick_in_deck()
	var trick: Area2D = find_trick()
	
	print("Trick found in deck, now putting trick in hand")
	print(trick)
	
	if flag:
		remove_trick_from_deck(trick)
	
	# Add cards in hand to cards selected
	for card in chip.chip_spot.card_controller.hand.cards_in:
		chip.chip_spot.card_controller.hand.cards_selected.append(card)
	# Discard cards in hand to draw cards after putting trick in front
	chip.chip_spot.card_controller.discard()
	
	print(chip.chip_spot.card_controller.hand.cards_in)
	
	chip.queue_free()


func is_trick_in_deck():
	for card in deck_cards:
		if card.is_trick():
			return true
	return false


func find_trick() -> Area2D:
	for card in deck_cards:
		if card.is_trick():
			return card
			
	for card in hand_cards:
		if card.is_trick():
			return card
	
	return null # This will never happen, just shuts up the error


func remove_trick_from_deck(trick):
	deck_cards.erase(trick)
	deck_cards.insert(randi_range(0, 4), trick)
