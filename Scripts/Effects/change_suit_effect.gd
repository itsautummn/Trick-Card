extends Node2D

var deck_cards: Array[Area2D]
var hand_cards: Array[Area2D]
var chip: Node2D

func _ready() -> void:
	chip = get_parent()


func effect() -> void:
	hand_cards = chip.get_cards_in_hand()
	deck_cards = chip.get_cards_in_deck()
	var trick: Area2D = find_trick()
	
	var prev_suit = trick.suit
	trick.suit = pick_random_suit(trick.suit)
	trick.update()
	print("Changed trick card ", Globals.rank_names[trick.rank], " of ", Globals.suit_names[prev_suit], " to a ", Globals.suit_names[trick.suit])
	chip.queue_free()


func pick_random_suit(old_suit) -> Globals.Suits:
	var possible_suits = Globals.Suits.duplicate()
	possible_suits.erase(old_suit)
	return possible_suits.values().pick_random()


func find_trick() -> Area2D:
	for card in deck_cards:
		if card.is_trick():
			return card
			
	for card in hand_cards:
		if card.is_trick():
			return card
	
	return null # This will never happen, just shuts up the error
