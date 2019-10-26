extends TextureProgress

var VT

func _ready():
	VT = Global.VT
	value = VT

func _process(delta):
	VT = Global.VT
	value = VT
