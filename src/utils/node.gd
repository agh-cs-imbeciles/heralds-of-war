class_name NodeUtils


static func get_root(node: Node) -> Node:
	var root: Node = node
	while root.get_parent() and root.get_parent() is not Viewport:
		root = root.get_parent()

	return root
