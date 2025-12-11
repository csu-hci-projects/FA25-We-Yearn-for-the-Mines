extends Node2D

@export var triggerTileMapLayerPairs : Array[TileMapLayerPair]

func _ready() -> void:
	# for each key tilelayer, attach its signal to the disabling of the value tile layer
	print_debug(triggerTileMapLayerPairs)
	for pair in triggerTileMapLayerPairs:
		var signalingLayer : ExtendedTileMapLayer = get_node(pair.signalingLayer) as ExtendedTileMapLayer
		var listeninglayer : ExtendedTileMapLayer = get_node(pair.listeningLayer) as ExtendedTileMapLayer
		signalingLayer.on_cell_changed.connect(listeninglayer.detach_node)
