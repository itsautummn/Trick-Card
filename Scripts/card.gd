extends Area2D

signal card_selected
signal card_deselected

var rank = Globals.Ranks.JOKER
var suit = Globals.Suits.HEART
var color = Globals.Colors.RED
var trick: bool = false
var enabled: bool = true
var selected: bool = false


func _ready():
	update()


func enable(visibility: bool = true) -> void:
	enabled = true
	visible = visibility


func disable(visibility: bool = false) -> void:
	enabled = false
	visible = visibility


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click") and enabled:
		if not selected:
			selected = true
			card_selected.emit(self)
		else:
			selected = false
			card_deselected.emit(self)


func reset_pos():
	position = Vector2(0, 0)


func set_trick_card(b: bool):
	trick = b


func is_trick():
	return trick


func update():
	if rank == Globals.Ranks.JOKER:
		$Sprite2D.texture = Globals.sprites[Globals.rank_names[rank]][color]
	else:
		$Sprite2D.texture = Globals.sprites[Globals.rank_names[rank]][suit]
