## This is the master script for the entire game ##

extends Node2D

signal money_updated

# First Level Nodes
@export var card_controller: Node2D
@export var sound_controller: Node2D
@export var canvas_layer: CanvasLayer

# Card Controller Second Level Nodes
@onready var hand: Node2D = card_controller.get_node("Hand")
@onready var deck: Node2D = card_controller.get_node("Deck")
@onready var discard: Node2D = card_controller.get_node("Discard")
@onready var effects: Node2D = card_controller.get_node("Effects")
@onready var game_buttons: Node2D = card_controller.get_node("Buttons")

# Sound Controller Second Level Nodes
@onready var game_music: AudioStreamPlayer2D = sound_controller.get_node("Game Music")
@onready var shop_music: AudioStreamPlayer2D = sound_controller.get_node("Shop Music")
@onready var game_over_music: AudioStreamPlayer2D = sound_controller.get_node("Game Over Music")
@onready var ambience_sfx: AudioStreamPlayer2D = sound_controller.get_node("Ambience")
@onready var sfx: AudioStreamPlayer2D = sound_controller.get_node("SFX")

# Canvas Layer Second Level Nodes
@onready var shop = canvas_layer.get_node("Shop")
@onready var game_over_screen = canvas_layer.get_node("Game Over")
@onready var message = canvas_layer.get_node("Message")

var all_cards: Array[Area2D]
var money: int = 0
var deck_back: Texture2D

func _ready() -> void:
	get_tree().paused = false
	

func _on_chip_bought(chip: Node2D) -> void:
	if money - chip.cost < 0:
		return
	update_money(-chip.cost)
	chip.effect()
	play_sfx("Purchase")


func update_money(amount: int) -> void:
	money += amount
	shop.update_money_label(money)


func play_sfx(sound: String) -> void:
	sfx.stream = Globals.sound_effects[sound]
	sfx.play()


func game_won() -> void:
	play_sfx("Tink")
	get_tree().paused = true
	game_over_screen.play("You Win!")


func game_lost() -> void:
	play_sfx("Fail")
	get_tree().paused = true
	game_over_screen.play("You Lost...")


func game_saved() -> void:
	play_sfx("Angel")
	send_message("SAVED")
	card_controller.reset_trick()
	

func game_error(error: Globals.Errors) -> void:
	var text: String
	match error:
		Globals.Errors.GUESS_ONE:
			text = "Must guess only one card!"
	play_sfx("Error")
	send_message(text)


func restart_game() -> void:
	get_tree().reload_current_scene()


func quit_game() -> void:
	get_tree().quit()


func send_message(m: String) -> void:
	message.get_node("Label").text = m
	message.get_node("AnimationPlayer").play("message")
