extends Label

func _ready():
	set_text(str(Global.AMMO))

func _process(delta):
	set_text(str(Global.AMMO))
