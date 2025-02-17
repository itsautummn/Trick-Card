extends Node2D


@export var hand_size: int = 5
@export var size: int = 96 # In pixels
@export var label: Label

@warning_ignore("integer_division") var left_to_right = Vector2i(0 - size / 2, 0 + size / 2)
var cards_in: Array[Area2D] = []
var cards_selected: Array[Area2D] = []

# Global bools for checking current hand each time a card is (de)selected
var current_hand: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_deck_cards_drawn(cards_drawn: Array[Area2D]) -> void:
	for card in cards_drawn:
		cards_in.append(card)
		$Cards.add_child(card)
		card.enable()
		card.card_selected.connect(_on_card_selected)
		card.card_deselected.connect(_on_card_deselected)
	_reposition_cards()

# Function: Position so that the cards center is in the middle of the hand, and spreads to left and right edges.
# Steps: 	Space the cards out based on the ratio `size / cards_in.size()`
# 			Fill out cards from left to right
# 			Make sure there is space between the left side and the left card
func _reposition_cards() -> void:
	@warning_ignore("integer_division") var ratio = size / cards_in.size()
	@warning_ignore("integer_division") var x = left_to_right.x + ratio / 2
	for card in cards_in:
		card.position.x = x
		x += ratio


func _on_card_selected(card):
	card.position.y -= 10
	cards_selected.append(card)
	check_possible_hands()


func _on_card_deselected(card):
	card.position.y += 10
	cards_selected.erase(card)
	check_possible_hands()


func check_possible_hands():
	var found: bool = false
	if cards_selected.size() == 0:
		current_hand = ""
	elif cards_selected.size() == 1:
		current_hand = "High Card"
	else:
		if check_full_house():
			current_hand = "Full House"
			found = true
		elif check_two_pair():
			current_hand = "Two Pair"
			found = true
		elif check_pair():
			current_hand = "Pair"
			found = true
		if check_three_kind():
			current_hand = "Three of a Kind"
			found = true
		if check_four_kind():
			current_hand = "Four of a Kind"
			found = true
		if check_flush():
			current_hand = "Flush"
			found = true
		if check_straight():
			current_hand = "Straight"
			found = true
	if not found:
		current_hand = "High Card"
	label.text = current_hand


func play_hand() -> void:
	print("Money Earned: ", Globals.money_earned[current_hand])


func check_kind() -> bool:
	for card in cards_selected:
		if card.rank != cards_selected.front().rank:
			return false
	return true


func check_pair():
	for i in cards_selected:
		for j in cards_selected:
			if i == j:
				continue
			if i.rank == j.rank:
				return true
	return false


func check_three_kind():
	if cards_selected.size() < 3:
		return false
	

func check_four_kind():
	if cards_selected.size() < 4:
		return false


func check_two_pair() -> bool:
	if cards_selected.size() < 4:
		return false
	var sorted = cards_selected.duplicate()
	sorted.sort_custom(func(a, b): return a.rank < b.rank)
	if sorted.front().rank == sorted[1].rank and sorted[2].rank == sorted.back().rank:
		return true
	return false


func check_full_house():
	if cards_selected.size() != 5:
		return false
	var sorted = cards_selected.duplicate()
	sorted.sort_custom(func(a, b): return a.rank < b.rank)
	if sorted.front().rank == sorted[1].rank and sorted[1].rank == sorted[2].rank:
		if sorted[3].rank == sorted.back().rank:
			return true
	return false


func check_flush():
	if cards_selected.size() != 5:
		return false
	for card in cards_selected:
		if card.suit != cards_selected.front().suit:
			return false
	return true


func check_straight():
	if cards_selected.size() != 5:
		return false
	var sorted = cards_selected.duplicate()
	sorted.sort_custom(func(a, b): return a.rank < b.rank)
	var last_rank = sorted.front().rank
	for n in sorted.size():
		if n == 0:
			continue
		if sorted[n].rank == last_rank + 1:
			last_rank = sorted[n].rank
		else:
			return false
	return true
