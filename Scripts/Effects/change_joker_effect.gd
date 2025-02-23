extends Node2D

var hand_cards: Array[Area2D]
var chip: Node2D

func _ready() -> void:
	chip = get_parent()


func effect() -> void:
	hand_cards = chip.get_cards_in_hand()
	change_to_joker()
	chip.queue_free()


func change_to_joker():
	var card = hand_cards.pick_random()
	print(Globals.rank_names[card.rank], " of ", Globals.suit_names[card.suit], " changed to a joker")
	card.rank = Globals.Ranks.JOKER
	card.update()
	
