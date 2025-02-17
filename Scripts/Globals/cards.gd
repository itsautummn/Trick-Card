extends Node


const sprites = {
	"Joker": [
		preload("res://Aseprite Files/Cards/Jokers/joker_red.aseprite"), 
		preload("res://Aseprite Files/Cards/Jokers/joker_black.aseprite")
	],
	"Ace": [
		preload("res://Aseprite Files/Cards/Hearts/ace_heart.aseprite"),
		preload("res://Aseprite Files/Cards/Diamonds/ace_diamond.aseprite"),
		preload("res://Aseprite Files/Cards/Spades/ace_spade.aseprite"),
		preload("res://Aseprite Files/Cards/Clubs/ace_club.aseprite")
	],
	"King": [
		preload("res://Aseprite Files/Cards/Hearts/king_heart.aseprite"),
		preload("res://Aseprite Files/Cards/Diamonds/king_diamond.aseprite"),
		preload("res://Aseprite Files/Cards/Spades/king_spade.aseprite"),
		preload("res://Aseprite Files/Cards/Clubs/king_club.aseprite")
	],
	"Queen": [
		preload("res://Aseprite Files/Cards/Hearts/queen_heart.aseprite"),
		preload("res://Aseprite Files/Cards/Diamonds/queen_diamond.aseprite"),
		preload("res://Aseprite Files/Cards/Spades/queen_spade.aseprite"),
		preload("res://Aseprite Files/Cards/Clubs/queen_club.aseprite")
	],
	"Jack": [
		preload("res://Aseprite Files/Cards/Hearts/jack_heart.aseprite"),
		preload("res://Aseprite Files/Cards/Diamonds/jack_diamond.aseprite"),
		preload("res://Aseprite Files/Cards/Spades/jack_spade.aseprite"),
		preload("res://Aseprite Files/Cards/Clubs/jack_club.aseprite")
	],
	"Ten": [
		preload("res://Aseprite Files/Cards/Hearts/ten_heart.aseprite"),
		preload("res://Aseprite Files/Cards/Diamonds/ten_diamond.aseprite"),
		preload("res://Aseprite Files/Cards/Spades/ten_spade.aseprite"),
		preload("res://Aseprite Files/Cards/Clubs/ten_club.aseprite")
	],
	"Nine": [
		preload("res://Aseprite Files/Cards/Hearts/nine_heart.aseprite"),
		preload("res://Aseprite Files/Cards/Diamonds/nine_diamond.aseprite"),
		preload("res://Aseprite Files/Cards/Spades/nine_spade.aseprite"),
		preload("res://Aseprite Files/Cards/Clubs/nine_club.aseprite")
	],
	"Eight": [
		preload("res://Aseprite Files/Cards/Hearts/eight_heart.aseprite"),
		preload("res://Aseprite Files/Cards/Diamonds/eight_diamond.aseprite"),
		preload("res://Aseprite Files/Cards/Spades/eight_spade.aseprite"),
		preload("res://Aseprite Files/Cards/Clubs/eight_club.aseprite")
	],
	"Seven": [
		preload("res://Aseprite Files/Cards/Hearts/seven_heart.aseprite"),
		preload("res://Aseprite Files/Cards/Diamonds/seven_diamond.aseprite"),
		preload("res://Aseprite Files/Cards/Spades/seven_spade.aseprite"),
		preload("res://Aseprite Files/Cards/Clubs/seven_club.aseprite")
	],
	"Six": [
		preload("res://Aseprite Files/Cards/Hearts/six_heart.aseprite"),
		preload("res://Aseprite Files/Cards/Diamonds/six_diamond.aseprite"),
		preload("res://Aseprite Files/Cards/Spades/six_spade.aseprite"),
		preload("res://Aseprite Files/Cards/Clubs/six_club.aseprite")
	],
	"Five": [
		preload("res://Aseprite Files/Cards/Hearts/five_heart.aseprite"),
		preload("res://Aseprite Files/Cards/Diamonds/five_diamond.aseprite"),
		preload("res://Aseprite Files/Cards/Spades/five_spade.aseprite"),
		preload("res://Aseprite Files/Cards/Clubs/five_club.aseprite")
	],
	"Four": [
		preload("res://Aseprite Files/Cards/Hearts/four_heart.aseprite"),
		preload("res://Aseprite Files/Cards/Diamonds/four_diamond.aseprite"),
		preload("res://Aseprite Files/Cards/Spades/four_spade.aseprite"),
		preload("res://Aseprite Files/Cards/Clubs/four_club.aseprite")
	],
	"Three": [
		preload("res://Aseprite Files/Cards/Hearts/three_heart.aseprite"),
		preload("res://Aseprite Files/Cards/Diamonds/three_diamond.aseprite"),
		preload("res://Aseprite Files/Cards/Spades/three_spade.aseprite"),
		preload("res://Aseprite Files/Cards/Clubs/three_club.aseprite")
	],
	"Two": [
		preload("res://Aseprite Files/Cards/Hearts/two_heart.aseprite"),
		preload("res://Aseprite Files/Cards/Diamonds/two_diamond.aseprite"),
		preload("res://Aseprite Files/Cards/Spades/two_spade.aseprite"),
		preload("res://Aseprite Files/Cards/Clubs/two_club.aseprite")
	],
}

const deck_backs = {
	"Red": preload("res://Aseprite Files/Cards/Backs/red_back.aseprite"),
	"Black": preload("res://Aseprite Files/Cards/Backs/black_back.aseprite")
}

var rank_names = [
	"Joker",
	"Ace",
	"King",
	"Queen",
	"Jack",
	"Ten",
	"Nine",
	"Eight",
	"Seven",
	"Six",
	"Five",
	"Four",
	"Three",
	"Two"
]

var suit_names = [
	"Heart",
	"Diamond",
	"Spade",
	"Club"
]

var color_names = [
	"Red",
	"Black"
]

enum Ranks {
	JOKER,
	ACE,
	KING,
	QUEEN,
	JACK,
	TEN,
	NINE,
	EIGHT,
	SEVEN,
	SIX,
	FIVE,
	FOUR,
	THREE,
	TWO
}

enum Suits {
	HEART,
	DIAMOND,
	SPADE,
	CLUB
}

enum Colors {
	RED,
	BLACK
}

enum Backs {
	RED,
	BLACK
}
