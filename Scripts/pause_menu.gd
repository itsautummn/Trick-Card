extends Control


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		visible = !visible
		get_tree().paused = !get_tree().paused


func _on_play_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_how_to_play_pressed() -> void:
	$"How To Menu".visible = true


func _on_how_to_close_pressed() -> void:
	$"How To Menu".visible = false
