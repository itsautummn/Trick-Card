extends Node2D

@onready var cards: Node2D = $Cards

const MAX_CARDS: int = 54

var cards_in: Array[Area2D]
var back = Globals.Backs.RED
var enabled: bool = false


func _ready() -> void:
	$Sprite2D.texture = Globals.deck_backs[Globals.back_names[back]]


func make_deck() -> void:
	# Add each card as an instantiated child to the array
	var card_instance: Area2D
	for rank in Globals.Ranks.size():
		for suit in Globals.Suits.size():
			card_instance = Globals.card_scene.instantiate()
			if rank == Globals.Ranks.JOKER: # Skip jokers and add later
				continue
			card_instance.rank = rank
			card_instance.suit = suit
			if suit == Globals.Suits.HEART or suit == Globals.Suits.DIAMOND:
				card_instance.color = Globals.Colors.RED
			else:
				card_instance.color = Globals.Colors.BLACK
			card_instance.disable()
			cards_in.append(card_instance)
	for i in 2:
		card_instance = Globals.card_scene.instantiate()
		card_instance.rank = Globals.Ranks.JOKER
		card_instance.color = Globals.Colors.BLACK if i else Globals.Colors.RED
		card_instance.disable()
		cards_in.append(card_instance)
	
	# Shuffle the array to randomize the order, then add the children to the scene
	cards_in.shuffle()
	var non_joker_cards: Array[Area2D]
	for card in cards_in:
		if card.rank != Globals.Ranks.JOKER:
			non_joker_cards.append(card)
	var trick_index = randi_range(0, non_joker_cards.size() - 1)
	non_joker_cards[trick_index].set_trick_card(true)
	for card in cards_in:
		cards.add_child(card)


func out_of_cards() -> void:
	if enabled:
		disable()
		visible = false


func enable():
	enabled = true
	

func disable():
	enabled = false
	

func get_cards_in():
	return cards_in
