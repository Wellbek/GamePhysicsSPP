extends Viewport

func _ready():
	size = OS.get_window_size()
	get_tree().get_root().connect("size_changed", self, "_on_window_resized")

func _on_window_resized():
	size = OS.get_window_size()
