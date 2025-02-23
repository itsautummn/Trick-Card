extends Node2D

signal play_sfx

@export var hand_label: Label

@onready var cards: Node2D = $Cards

const LEFT_RIGHT: Vector2i = Vector2i(0 - 48, 0 + 48)
const TRANSFORM_SIZE: int = 96
const HAND_SIZE: int = 5

var known_hands: Dictionary
var cards_selected: Array[Area2D]
var cards_in: Array[Area2D]
var current_hand: String


func check_possible_hands():
	known_hands.clear()
	check_pairs()
	check_three_kind()
	check_four_kind()
	check_full_house()
	check_flush()
	check_straight()
	check_royal_straight()
	check_straight_flush()
	check_royal_flush()
	check_joker()
	if known_hands.has("Joker"):
		current_hand = "Joker"
		hand_label.text = "Joker"
	elif known_hands.has("Royal Flush"):
		current_hand = "Royal Flush"
		hand_label.text = "Royal\nFlush"
	elif known_hands.has("Flush Straight"):
		current_hand = "Flush Straight"
		hand_label.text = "Flush\nStraight"
	elif known_hands.has("Royal Straight"):
		current_hand = "Royal Straight"
		hand_label.text = "Royal\nStraight"
	elif known_hands.has("Straight"):
		current_hand = "Straight"
		hand_label.text = "Straight"
	elif known_hands.has("Flush"):
		current_hand = "Flush"
		hand_label.text = "Flush"
	elif known_hands.has("Full House"):
		current_hand = "Full House"
		hand_label.text = "Full\nHouse"
	elif known_hands.has("Four of a Kind"):
		current_hand = "Four of a Kind"
		hand_label.text = "Four of\na Kind"
	elif known_hands.has("Two Pair"):
		current_hand = "Two Pair"
		hand_label.text = "Two\nPair"
	elif known_hands.has("Three of a Kind"):
		current_hand = "Three of a Kind"
		hand_label.text = "Three of\na Kind"
	elif known_hands.has("Pair"):
		current_hand = "Pair"
		hand_label.text = "Pair"
	else:
		current_hand = "High Card"
		hand_label.text = "High\nCard"
	if cards_selected.is_empty():
		current_hand = ""
		hand_label.text = ""


func check_pairs(): # First Check, Dependent
	for i in cards_selected:
		for j in cards_selected:
			if i == j:
				continue
			if i.rank == j.rank:
				if known_hands.has("Pair"):
					if not i in known_hands["Pair"] and not j in known_hands["Pair"]:
						known_hands["Two Pair"] = [known_hands["Pair"][0], known_hands["Pair"][1], i, j]
				else:
					known_hands["Pair"] = [i, j]


func check_three_kind(): # Second Check, Dependent
	if known_hands.has("Pair"):
		for i in cards_selected:
			if i in known_hands["Pair"]:
				continue
			if i.rank == known_hands["Pair"].front().rank:
				known_hands["Three of a Kind"] = [known_hands["Pair"][0], known_hands["Pair"][1], i]

func check_four_kind(): # Third Check, Dependent
	if known_hands.has("Three of a Kind"):
		for i in cards_selected:
			if i in known_hands["Three of a Kind"]:
				continue
			if i.rank == known_hands["Pair"].front().rank:
				known_hands["Four of a Kind"] = [known_hands["Three of a Kind"][0], known_hands["Three of a Kind"][1], known_hands["Three of a Kind"][2], i]


func check_full_house(): # Fourth Check, Independent
	if cards_selected.size() != 5:
		return
	var sorted = cards_selected.duplicate()
	sorted.sort_custom(func(a, b): return a.rank < b.rank)
	if sorted.front().rank == sorted[1].rank and sorted[1].rank == sorted[2].rank:
		if sorted[3].rank == sorted.back().rank:
			known_hands["Full House"] = [sorted.front(), sorted[1], sorted[2], sorted[3], sorted.back()]


func check_flush(): # Fifth Check, Independent
	if cards_selected.size() != 5:
		return
	for card in cards_selected:
		if card.suit != cards_selected.front().suit:
			return
	known_hands["Flush"] = [cards_selected.front(), cards_selected[1], cards_selected[2], cards_selected[3], cards_selected.back()]


func check_straight(): # Sixth Check, Independent
	if cards_selected.size() != 5:
		return
	var sorted = cards_selected.duplicate()
	sorted.sort_custom(func(a, b): return a.rank < b.rank)
	var last_rank = sorted.front().rank
	for n in sorted.size():
		if n == 0:
			continue
		if sorted[n].rank == last_rank + 1:
			last_rank = sorted[n].rank
		else:
			return
	known_hands["Straight"] = [sorted.front(), sorted[1], sorted[2], sorted[3], sorted.back()]


func check_royal_straight(): # Nineth Check, Dependent on sixth
	if cards_selected.size() != 5:
		return
	if known_hands.has("Straight"):
		var sorted = cards_selected.duplicate()
		sorted.sort_custom(func(a, b): return a.rank < b.rank)
		if sorted.front().rank == Globals.Ranks.ACE:
			known_hands["Royal Straight"] = known_hands["Straight"]


func check_straight_flush(): # Seventh Check, Dependent
	if cards_selected.size() != 5:
		return
	if known_hands.has("Straight") and known_hands.has("Flush"):
		known_hands["Flush Straight"] = known_hands["Straight"]


func check_royal_flush(): # Tenth Check, Dependent
	if cards_selected.size() != 5:
		return
	if known_hands.has("Royal Straight") and known_hands.has("Flush Straight"):
		known_hands["Royal Flush"] = known_hands["Royal Straight"]


func check_joker(): # Eleventh Check, Independent
	if cards_selected.size() != 1:
		return
	if cards_selected.front().rank == Globals.Ranks.JOKER:
		known_hands["Joker"] = cards_selected.front()


func get_cards_in() -> Array[Area2D]:
	return cards_in


# Function: Position so that the cards center is in the middle of the hand, and spreads to left and right edges.
# Steps: 	Space the cards out based on the ratio `size / cards_in.size()`
# 			Fill out cards from left to right
# 			Make sure there is space between the left side and the left card
func reposition_cards() -> void:
	if cards_in.is_empty():
		return
	@warning_ignore("integer_division") var ratio = TRANSFORM_SIZE / cards_in.size()
	@warning_ignore("integer_division") var x = LEFT_RIGHT.x + ratio / 2
	for card in cards_in:
		card.position.x = x
		x += ratio


func _on_card_selected(card):
	card.position.y -= 10
	cards_selected.append(card)
	check_possible_hands()
	play_sfx.emit("Select")


func _on_card_deselected(card):
	card.position.y += 10
	cards_selected.erase(card)
	check_possible_hands()
	play_sfx.emit("Select")
