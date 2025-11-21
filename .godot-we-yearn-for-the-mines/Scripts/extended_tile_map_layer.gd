extends TileMapLayer
class_name ExtendedTileMapLayer

signal on_cell_changed()

func overloaded_set_cell(coords : Vector2i, source_id : int = -1, atlas_coords : Vector2i = Vector2i(-1, -1), alternative_tile : int = 0) -> void:
	print_debug("Setting Cell!!")
	super.set_cell(coords, source_id, atlas_coords, alternative_tile)
	on_cell_changed.emit()

func detach_node() -> void:
	if get_parent():
		print_debug("Detaching self???")
		get_parent().remove_child(self)
