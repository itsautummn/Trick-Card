extends Node2D

signal earn_money
signal game_won
signal game_lost
signal game_saved
signal game_error
signal play_sfx

@export var hand_label: Label

@onready var hand: Node2D = $Hand
@onready var deck: Node2D = $Deck
@onready var discard_scene: Node2D = $Discard
@onready var effects: Node2D = $Effects

const MAX_GUESSES: int = 3

var num_guesses: int = 3


func _ready() -> void:
	deck.make_deck()
	draw_cards(hand.HAND_SIZE)
	
	
# =============================================================================================================== #
# DECK METHODS
# =============================================================================================================== #

# Takes cards from the deck and puts them into the hand
func draw_cards(amount: int) -> void:
	if deck.cards_in.is_empty():
		deck.out_of_cards()
		return
	
	for n in amount:
		# Take card from deck
		var card = deck.cards_in.pop_back()
		if deck.cards_in.is_empty():
			deck.out_of_cards()
			break
		deck.cards.remove_child(card)
		card.visible = true
		
		# Add card to hand
		hand.cards_in.append(card)
		hand.cards.add_child(card)
		card.enable()
		card.card_selected.connect(hand._on_card_selected)
		card.card_deselected.connect(hand._on_card_deselected)
		
	hand.reposition_cards()


# =============================================================================================================== #
# HAND METHODS
# =============================================================================================================== #

# Long ass method
func play_hand() -> void:
	# ============== #
	# Before effects
	# ============== #
	
	# If we don't have any cards in hand, don't play hand
	if hand.cards_selected.size() <= 0:
		return
		
	# Set a bool to check if the trick card was played and to see if we die from it
	var played_trick: bool = false
	var player_lost: bool = false
	for card in hand.cards_selected:
		if card.is_trick():
			played_trick = true
			player_lost = true
	
	# Set a variable that will be how much this hand will earn us
	var money_to_earn = Globals.money_for_hand[hand.current_hand]
	
	# Go through all the effects to check if any variables need to change
	var effect_dict = go_through_effects(played_trick)
	
	# ========== #
	# Do Effects #
	# ========== #
	
	# If we have the double money effect
	if effect_dict["Double Money"] == true:
		money_to_earn *= 2
		
	# If we have the death save effect
	if effect_dict["Death Save"] == true:
		player_lost = false
		
		
	# Remove the effects from the array if it was used
	for effect in effects.effects_array:
		if effect.used:
			effects.remove_effect(effect)
	
	# ============= #
	# After Effects
	# ============= #
	
	# Check if we earned money from this hand
	if money_to_earn > 0:
		# Play sound effect for earning money
		play_sfx.emit("Coin")
		earn_money.emit(money_to_earn)
	else:
		# Play the generic sound effect for no money earned
		play_sfx.emit("Flip")
		
	# Check if the player was saved by the death chip
	if not player_lost and played_trick:
		# NOTE: RESET TRICK
		game_saved.emit()
		
	# Check if we lost the game from playing this hand
	elif player_lost:
		game_lost.emit()
		return
	
	# Discard the hand played
	discard()
	
	# Reposition Cards
	hand.reposition_cards()
	
	# Reset the label so it doesn't say our last played hand after playing it
	hand_label.text = ""
	

# Makes a guess on a card, if its the trick the player wins, if not a guess is taken away. 3 guesses til loss.
func guess_card() -> void:
	if hand.cards_selected.size() != 1:
		# NOTE: Must only guess one card!
		game_error.emit(Globals.Errors.GUESS_ONE)
		return
	
	# Setting up variables
	var card = hand.cards_selected.front() # Globals selected will only be one card
	
	# Take a guess away
	update_guesses(-1)
	
	# If the card is the trick card, the player won
	if card.is_trick():
		game_won.emit()
		return
	
	# Discard the guessed card
	discard()
	
	# Reposition cards
	hand.reposition_cards()
	
	# Check if the player has used all guesses, if so, player loses
	if num_guesses <= 0:
		game_lost.emit()


# Takes cards from hand and puts them into discard
func discard() -> void:
	for card in hand.cards_selected:
		# Take cards from hand
		hand.cards.remove_child(card) # NOTE: Make add and remove card functions for hand, deck, and discard
		hand.cards_in.erase(card)
		card.disable(true)
		card.reset_pos()
	
		# Put cards in discard
		discard_scene.cards_in.append(card)
		discard_scene.add_child(card)
	
	# Draw more cards to hand
	draw_cards(hand.cards_selected.size())
	hand.cards_selected.clear()
	

func add_effect(effect) -> void:
	effects.add_effect(effect)


# Returns a dictionary of boolean based on if the effect is to be used
func go_through_effects(played_trick: bool):
	var effect_dict = {
		"Double Money": false,
		"Death Save": false
	}
	
	for effect in effects.effects_array:
		match effect.type:
			Globals.Effects.DOUBLE_MONEY:
				effect_dict["Double Money"] = true
				effect.used = true
			Globals.Effects.DEATH_SAVE:
				if played_trick:
					effect_dict["Death Save"] = true
					effect.used = true
	
	return effect_dict


func update_guesses(amount):
	num_guesses += amount
	$Labels/Guesses.text = "Guesses\nLeft: " + str(num_guesses)
	
	
func reset_guesses():
	num_guesses = MAX_GUESSES
	$Labels/Guesses.text = "Guesses\nLeft: " + str(num_guesses)


func reset_trick():
	if deck.cards_in.size() <= 0:
		game_lost.emit()
		return
	deck.cards_in[randi_range(0, deck.cards_in.size() -1)].set_trick_card(true)
