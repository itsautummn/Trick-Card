extends Control


func play(text: String) -> void:
	visible = true
	$VBoxContainer/Label.text = text
