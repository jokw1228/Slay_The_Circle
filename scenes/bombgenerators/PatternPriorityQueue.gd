extends RefCounted
class_name PatternPriorityQueue

var queue: Array[Dictionary]
# dictionary format:
# {"pattern_key" = "pattern_name", "pattern_value" = weight}

static func create() -> PatternPriorityQueue:
	return PatternPriorityQueue.new()

func parent(index: int) -> int:
	return (index - 1) / 2

func left(index: int) -> int:
	return index * 2 + 1

func right(index: int) -> int:
	return index * 2 + 2

func heap_extract_min() -> Dictionary:
	var tmp: Dictionary = queue[0]
	queue[0] = queue[queue.size() - 1]
	queue[queue.size() - 1] = tmp
	var min: Dictionary = queue.pop_back() as Dictionary
	min_heapify(0)
	return min

func min_heapify(index: int):
	var l: int = left(index)
	var r: int = right(index)
	var smallest_index: int = index
	if l < queue.size():
		if queue[l]["pattern_value"] < queue[index]["pattern_value"]:
			smallest_index = l
	if r < queue.size():
		if queue[r]["pattern_value"] < queue[index]["pattern_value"]:
			smallest_index = r
	if smallest_index != index:
		var tmp: Dictionary = queue[index]
		queue[index] = queue[smallest_index]
		queue[smallest_index] = tmp
		min_heapify(smallest_index)

func heap_decrease_key(index: int, pattern_dict: Dictionary):
	if queue[index]["pattern_value"] < pattern_dict["pattern_value"]:
		return
	queue[index]["pattern_value"] = pattern_dict["pattern_value"]
	while index > 0 and queue[parent(index)]["pattern_value"] > queue[index]["pattern_value"]:
		var tmp: Dictionary = queue[index]
		queue[index] = queue[parent(index)]
		queue[parent(index)] = tmp
		index = parent(index)

func min_heap_insert(pattern_dict: Dictionary):
	const infinite = INF
	queue.push_back({"pattern_key" = pattern_dict["pattern_key"], "pattern_value" = infinite})
	heap_decrease_key(queue.size() - 1, pattern_dict)
