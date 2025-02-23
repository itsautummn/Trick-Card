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
	
	var prev_rank = trick.rank
	trick.rank = pick_random_rank(trick.rank)
	trick.update()
	print("Changed trick card ", Globals.rank_names[prev_rank], " of ", Globals.suit_names[trick.suit], " to a ", Globals.rank_names[trick.rank])
	chip.queue_free()


func pick_random_rank(old_rank) -> Globals.Ranks:
	var possible_ranks = Globals.Ranks.duplicate()
	possible_ranks.erase(old_rank)
	possible_ranks.erase(Globals.Ranks.JOKER)
	return possible_ranks.values().pick_random()


func find_trick() -> Area2D:
	for card in deck_cards:
		if card.is_trick():
			return card
			
	for card in hand_cards:
		if card.is_trick():
			return card
	
	return null # This will never happen, just shuts up the error
