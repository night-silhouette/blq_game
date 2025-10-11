extends Node2D

func rand_direction():
	return Vector2(randfloat(-1,1),randfloat(-1,1)).normalized()
	

func rand_sign():
	var flag=randi_range(0,1)
	if flag:
		return 1
	else :
		return -1

func randfloat(st:float,end:float):
	var span=randf()
	var difference=end-st;
	return st+difference*span;
	

func randarr(arr:Array):
	return arr[randi_range(0,arr.size())-1]
	

func min_arr_or_dic(arg):#[n1,n2,n3...]  or  #{n1:value,n2:value...}
	if arg is Array:
		var res=arg[0]
		for i in range(arg.size()-1):
			if arg[i+1]<res:
				res=arg[i+1]
		return res	
	elif arg is Dictionary :
		var keys=arg.keys()
		var res=arg[keys[0]]
		for i in range(keys.size()-1):
			if arg[keys[i+1]]<res:
				res=arg[keys[i+1]]
		return res	

func max_arr_or_dic(arg):#[n1,n2,n3...]  or  #{n1:value,n2:value...}
	if arg is Array:
		var res=arg[0]
		for i in range(arg.size()-1):
			if arg[i+1]>res:
				res=arg[i+1]
		return res	
	elif arg is Dictionary :
		var keys=arg.keys()
		var res=arg[keys[0]]
		for i in range(keys.size()-1):
			if arg[keys[i+1]]>res:
				res=arg[keys[i+1]]
		return res	
func rand_distribute(arg_arr:Array[Array]): #[[obj,n1],[obj,n2],...]
	var flag=false
	for arg in arg_arr:
		if arg[1]<0:
			flag=true
	if flag:
		var dic={}
		for arg in arg_arr:
			dic[arg[0]]=arg[1]
		return max_arr_or_dic(dic)
				
		
	var res;
	var num:float=0.0
	for arg in arg_arr:
		num+=arg[1]
	var temp=randfloat(0,num)
	var i:float=0.0
	for arg in arg_arr:
		i+=arg[1]
		if i>=temp:
			res=arg[0]
			break
	return res
func set_prop_all(target_class:String, prop_name:String, prop_value,root=get_tree().current_scene):

	if root == null:
		return
	_recursive_set_prop(root, target_class, prop_name, prop_value)
func _recursive_set_prop(
	cur_node:Node, target_class:String, prop_name:String, prop_value
):
	var cur_class=cur_node.get_class()
	if target_class.to_lower()==cur_class.to_lower():
			cur_node.set_indexed(prop_name,prop_value)
			
	var node_list= cur_node.get_children()
	if node_list.is_empty():
		return
	for item in node_list:
		_recursive_set_prop(item,target_class,prop_name,prop_value)


func pysical_query_circle(radius:float,center:Vector2)->Array[Dictionary]:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = radius
	
	query.transform=Transform2D(0,center)
	query.shape=circle_shape
	var query_result_arr=space_state.intersect_shape(query,256)
	return query_result_arr
