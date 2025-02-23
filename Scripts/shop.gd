extends Control

signal chip_bought

@export var game: Node2D


func update_money_label(money: int) -> void:
	$"Labels/Money Label".text = "$" + str(money)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for spot in $"Chip Spots".get_children():
		var chip = Globals.chip_scenes[spot.color][randi_range(0, Globals.chip_scenes[spot.color].size() - 1)].instantiate()
		chip.pressed.connect(_on_chip_pressed)
		chip.hovering.connect(_on_chip_hovered)
		chip.nothovering.connect(_on_chip_not_hovered)
		spot.add_child(chip)
		chip.position = Vector2.ZERO


func _on_open_pressed() -> void:
	set_visibility(true)
	game.play_sfx("Select")


func _on_close_pressed() -> void:
	set_visibility(false)
	game.play_sfx("Select")


func set_visibility(value: bool) -> void:
	visible = value


func _on_chip_pressed(chip) -> void:
	print(chip, " Pressed")
	chip_bought.emit(chip)
	$Tooltips/Cost.text = ""
	$Tooltips/Effect.text = ""


func _on_chip_hovered(chip) -> void:
	var text: String
	match chip.chip_name:
		"Joker":
			text = "Turns random\ncard in hand to\na joker"
		"Money":
			text = "Doubles next\namount of\nmoney earned"
		"Guesses":
			text = "Refreshes\nnumber of\nguesses"
		"Change Rank":
			text = "Changes rank of\ntrick card"
		"Change Suit":
			text = "Changes suit of\ntrick card"
		"Death":
			text = "Saves you from\nplaying trick\ncard one time"
		"Rank":
			text = "Tells if trick\nrank matches\nrank in hand"
		"Suit":
			text = "Tells if trick\nsuit matches\nsuit in hand"
		"Hand":
			text = "Tells if trick\ncard is in hand"
	$Tooltips/Cost.text = "Cost:\n$" + str(chip.cost)
	$Tooltips/Effect.text = "Effect:\n" + text
			

func _on_chip_not_hovered() -> void:
	$Tooltips/Cost.text = ""
	$Tooltips/Effect.text = ""
