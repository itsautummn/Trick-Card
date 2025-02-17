extends Area2D

@warning_ignore("integer_division")

signal cards_drawn

@export var hand: Node2D
@export var back: Texture2D = Cards.deck_backs["Black"]
@export var max_cards: int = 52

var num_cards: int = max_cards
var cards_in: Array[Area2D] = []
var enabled: bool = true

const card_scene = preload("res://Scenes/card.tscn")


func _ready() -> void:
	make_deck()
	

func make_deck() -> void:
	# Add each card as an instantiated child to the array
	var card_instance: Area2D
	for rank in Cards.Ranks.size():
		for suit in Cards.Suits.size():
			card_instance = card_scene.instantiate()
			if rank == Cards.Ranks.JOKER: # Skip jokers and add later
				continue
			card_instance.rank = rank
			card_instance.suit = suit
			if suit == Cards.Suits.HEART or suit == Cards.Suits.DIAMOND:
				card_instance.color = Cards.Colors.RED
			else:
				card_instance.color = Cards.Colors.BLACK
			card_instance.disable()
			cards_in.append(card_instance)
	for i in 2:
		card_instance = card_scene.instantiate()
		card_instance.rank = Cards.Ranks.JOKER
		card_instance.color = Cards.Colors.BLACK if i else Cards.Colors.RED
		card_instance.disable()
		cards_in.append(card_instance)
	
	# Shuffle the array to randomize the order, then add the children to the scene
	cards_in.shuffle()
	for card in cards_in:
		$Cards.add_child(card)
	
	# Set the sprite of the deck
	$Sprite2D.texture = back


func draw_cards(amount: int) -> void:
	var cards_being_drawn: Array[Area2D] = []
	for n in amount:
		if not enabled:
			break
		var card = cards_in.pop_back()
		if cards_in.is_empty():
			out_of_cards()
		cards_being_drawn.append(card)
		$Cards.remove_child(card)
	cards_drawn.emit(cards_being_drawn)


func out_of_cards() -> void:
	if enabled:
		disable()
		$Sprite2D.texture = null


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click") and enabled:
		draw_cards(hand.hand_size)
		disable()


func enable():
	enabled = true
	

func disable():
	enabled = false
