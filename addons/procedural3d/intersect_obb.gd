static func obb_points(shape):
	var rv = []
	for i in [ Vector3(-1, -1, -1), Vector3(-1, -1, 1),  Vector3(-1, 1, -1), Vector3(-1, 1, 1),  Vector3(1, -1, -1), Vector3(1, -1, 1),  Vector3(1, 1, -1), Vector3(1, 1, 1) ]:
		rv.append(shape.global_transform.xform(i*shape.shape.extents))
	return rv

static func obb_range(points, axis):
	var x = axis.dot(points[0])
	var rv = { min=x, max=x }
	for p in points:
		x = axis.dot(p)
		if rv.min > x: rv.min = x
		if rv.max < x: rv.max = x
	return rv

static func obb_test_axis(p1, p2, a):
	var r1 = obb_range(p1, a)
	var r2 = obb_range(p2, a)
	return r1.min >= r2.max or r1.max <= r2.min

static func intersect(shape1, shape2):
	var t1 = shape1.global_transform
	var t2 = shape1.global_transform
	var axes = [
		t1.basis.x,
		t1.basis.y,
		t1.basis.z,
		t2.basis.x,
		t2.basis.y,
		t2.basis.z
	]
	for i in range(3):
		for j in range(3):
			var axis = axes[i].cross(axes[3+j])
			if axis.length() != 0:
				axes.append(axis)
	var p1 = obb_points(shape1)
	var p2 = obb_points(shape2)
	for a in axes:
		if obb_test_axis(p1, p2, a):
			return false
	return true
