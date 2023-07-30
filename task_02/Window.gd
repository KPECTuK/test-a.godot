class_name DialogWindow extends Container

func _notification(what):
	match what:
		NOTIFICATION_CHILD_ORDER_CHANGED:
			print('order is changed')
			set_size(Vector2(100, 100))
