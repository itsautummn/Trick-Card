extends Area2D

signal card_selected
signal card_deselected

var rank: Cards.Ranks
var suit: Cards.Suits
var color: Cards.Colors
var enabled: bool = true
var selected: bool = false


func _ready():
	if rank == Cards.Ranks.JOKER:
		$Sprite2D.texture = Cards.sprites[Cards.rank_names[rank]][color]
	else:
		$Sprite2D.texture = Cards.sprites[Cards.rank_names[rank]][suit]


func enable() -> void:
	enabled = true
	visible = true


func disable() -> void:
	enabled = false
	visible = false


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click") and enabled:
		print(Cards.rank_names[rank], " of ", Cards.suit_names[suit], "s")
		if not selected:
			selected = true
			card_selected.emit(self)
		else:
			selected = false
			card_deselected.emit(self)
