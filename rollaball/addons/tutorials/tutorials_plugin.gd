# addons/tutorials/tutorials_plugin.gd
@tool
extends EditorPlugin

const MainView = preload("res://addons/tutorials/tutorials.tscn")
var main_view_instance

func _enter_tree():
	main_view_instance = MainView.instantiate()
	EditorInterface.get_editor_main_screen().add_child(main_view_instance)
	_make_visible(false)


func _exit_tree():
	if main_view_instance:
		main_view_instance.queue_free()


func _has_main_screen():
	return true


func _make_visible(visible):
	if main_view_instance:
		main_view_instance.visible = visible


func _get_plugin_name():
	return "Tutorials"


func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
