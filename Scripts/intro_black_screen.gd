extends Control

var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await $Timer.timeout
	tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 0, 1)
