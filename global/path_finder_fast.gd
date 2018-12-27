extends Node
class_name PathFinderFast
var priority_queue = load("res://global/priority_queue.gd")

class Location:
	var xy
	var z
	var pos_str
	func _init(_xy , _z):
		xy = _xy
		z  = _z

class PathFinderNodeFast:
	var F
	var G
	var PX
	var PY
	var Status
	var PZ
	var JumpLength
	var posStr
	func _init():
		F = 0
		G = 0
		PX = 0
		PY = 0
		JumpLength = 0
		PZ = 0
		Status = 0
		posStr = ""
	func UpdateStatus(newStatus):
		Status = newStatus

var nodes = []
var touchedLocations = []
var mOpen
var mPath = []

var mGridY
var mGridX

var mGrid
var mDirection = [[0,-1], [1,0], [0,1], [-1,0], [1,-1], [1,1], [-1,1], [-1,-1]]
var dirction_arr = [Vector2(1,0),Vector2(-1,0),Vector2(0,1),Vector2(0,-1)]


func init(grid,w,h):
	mGrid = grid
	mGridY = h
	mGridX = w
	
	nodes.resize(mGridX*mGridY)
	mOpen = priority_queue.new(nodes)

func check_consecutive_ground_num(start_pos,num):
	var count = 1
	var vaild_num = 0
	while true:
		var t2 = mGrid[start_pos.y][start_pos.x + count]
		var t3 =mGrid[start_pos.y + 1][start_pos.x + count]
		if mGrid[start_pos.y][start_pos.x + count] == 1 and mGrid[start_pos.y + 1][start_pos.x + count] == 0:
			vaild_num += 1
			count += 1
		else:
			break
	count = -1
	while true:
		if mGrid[start_pos.y][start_pos.x + count] == 1 and mGrid[start_pos.y + 1][start_pos.x + count] == 0:
			vaild_num += 1
			count -= 1
		else:
			break
	vaild_num += 1
#	print("vaild_num:",vaild_num)
	if vaild_num >= num:
		return true
	return false

func wander_pathfinding(start_pos, character_width, character_height, max_character_jump_height, search_limit):
	var arrive_pos_arr = []
	var queue_arr = []
	queue_arr.append(start_pos)
	var count = 0
#	print("search_limit:",search_limit)
	var gird_weight_arr = []
	for y in range(mGridY):
		var arr = []
		arr.resize(mGridX)
		gird_weight_arr.append(arr)
	gird_weight_arr[start_pos.y][start_pos.x] = 0
	
	while queue_arr.size() > 0:
		print_winder_debug_info("----------------once---------------")
		print_winder_debug_info(queue_arr)
		var next_pos = queue_arr.pop_front()
		print_winder_debug_info("pop: " + str(next_pos.x) + "," + str(next_pos.y))
		
		count = count + 1
		if count > search_limit:
			return arrive_pos_arr
		
		for i in range(4):
			var new_pos = next_pos + dirction_arr[i]	
			var is_arrive_pos = false
			var is_on_ground = false 
			var is_ceiling   = false
			if next_pos.x == 5 and next_pos.y == 7:
				print("")
			#过滤边界
			if new_pos.x < 0 or new_pos.x > mGridX - 1 or new_pos.y < 0 or new_pos.y > mGridY - 1: 
				continue
			#过滤障碍  
			if mGrid[new_pos.y][new_pos.x] == 0:
				continue
			
			if mGrid[new_pos.y + 1][new_pos.x] == 0:
				is_on_ground = true
			elif mGrid[new_pos.y - character_height][new_pos.x] == 0:
				is_ceiling = true
			
			var origin_value = gird_weight_arr[next_pos.y][next_pos.x]
			var jump_value = 0
			if origin_value != null:
				jump_value = origin_value
#			gird_weight_arr[next_pos.y][next_pos.x] = jumpo
			var new_jump_value = jump_value
			#在天花板
			if is_ceiling:
				if new_pos.x != next_pos.x:#不在头顶方向
					new_jump_value = max(max_character_jump_height * 2 + 1, jump_value + 1)
				else:                             #头顶
					new_jump_value = max_character_jump_height * 2
			#在地上
			elif is_on_ground:
				new_jump_value = 0
				is_arrive_pos = true
			#上升
			elif new_pos.y < next_pos.y:
				if int(jump_value) % 2 == 0:
					new_jump_value = jump_value + 2
				else:
					new_jump_value = jump_value + 1
			#下降
			elif new_pos.y > next_pos.y:
				if int(jump_value) % 2 == 0:
					new_jump_value = max(max_character_jump_height * 2, jump_value + 2)
				else:
					new_jump_value = max(max_character_jump_height * 2, jump_value + 1)
			elif !is_on_ground && new_pos.x != next_pos.x:
				new_jump_value = jump_value + 1
			
			#--------------------过滤节点--------------#
			#跳转值大于0，且单数，过滤到左右位置
			if jump_value >= 0 && int(jump_value) % 2 != 0 && next_pos.x != new_pos.x:
				continue
			#到达最大跳转值，过滤上面的位置
			if jump_value >= max_character_jump_height * 2 && new_pos.y < next_pos.y:
				continue
			if new_jump_value >= max_character_jump_height * 2 + 6 && new_jump_value != jump_value && (new_jump_value - (max_character_jump_height * 2 + 6)) % 8 != 3:
				continue
			

			var new_origin = gird_weight_arr[new_pos.y][new_pos.x]
			if new_origin != null:
				if new_jump_value < new_origin:
					new_origin = new_jump_value
					print_winder_debug_info("	@insert: " + str(new_pos.x) + "," + str(new_pos.y))
					queue_arr.append(new_pos)
			else:
				gird_weight_arr[new_pos.y][new_pos.x] = new_jump_value
				print_winder_debug_info("	@insert: " + str(new_pos.x) + "," + str(new_pos.y))
				queue_arr.append(new_pos)
			
			if is_arrive_pos:
				arrive_pos_arr.append(new_pos)
				print_winder_debug_info("		ground: " + str(new_pos.x) + "," + str(new_pos.y))

#func _sort_arrvie_pos_arr(queue_arr,new_pos,gird_weight_arr):
#	var cur_value = gird_weight_arr[pos.y][pos.x]
#	for pos in queue_arr:
		
		

func find_path(start, end, characterWidth, characterHeight, maxCharacterJumpHeight, mSearchLimit = 2000):
	for i in range(mGridX * mGridY):
		nodes[i]=[]
	
	if mGrid[end.y][end.x] == 0:
		return null
	
	mOpen.Clear()
	print(start , end)
	#init variables
	var mFound              = false
	var mStop               = false
	var mStopped            = false
	var mCloseNodeCounter   = 0
	var mOpenNodeValue     	= 1
	var mCloseNodeValue    	= 2
	var mHEstimate		    = 2
	var mLocationX			= 0
	var mLocationY			= 0
	var mNewLocationX       = 0
	var mNewLocationY       = 0
	var mNewLocation		= 0
	var mNewG				= 0
	var mH					= 0

	var mLocation = Location.new(start.y * mGridX + start.x , 0)
	var mEndLocation = end.y * mGridX + end.x

	var firstNode = PathFinderNodeFast.new()
	firstNode.G = 0
	firstNode.F = mHEstimate
	firstNode.PX = start.x
	firstNode.PY = start.y
	firstNode.PZ = 0
	firstNode.Status = mOpenNodeValue

	if mGrid[start.y + 1][start.x] == 0:
		firstNode.JumpLength = 0
	else:
		firstNode.JumpLength = maxCharacterJumpHeight * 2

	nodes[mLocation.xy].append(firstNode)
	mLocation.pos_str = "[" +str(0) + "," + str(0) + "]"
	mOpen.Push(mLocation)
	var count = 0
	while mOpen.Count() > 0 && !mStop:
		mLocation = mOpen.Pop()
		print_debug_info("--------Pop:" + str(int(mLocation.xy) % int(mGridX)) + " " + str(floor(mLocation.xy / int(mGridX))))
		if nodes[mLocation.xy][mLocation.z].Status == mCloseNodeValue:
			continue

		mLocationX = int(mLocation.xy) % int(mGridX)
		mLocationY = floor(mLocation.xy / mGridX)

		if mLocation.xy == mEndLocation:
			nodes[mLocation.xy][mLocation.z].UpdateStatus(mCloseNodeValue)
			mFound = true
			print_debug_info("find count:"+str(count))
			break

		if mCloseNodeCounter > mSearchLimit:
			mStopped = true
			print_debug_info("Over search limit")
			return null
		count = count + 1
#		print("parent:" + "(" +str(mLocationX) + "," + str(mLocationY) + ")")
		for i in range(4):
			#坐标
			mNewLocationX = mLocationX + mDirection[i][0]
			mNewLocationY = mLocationY + mDirection[i][1]
			print_debug_info("child:" + "(" +str(mNewLocationX) + "," + str(mNewLocationY) + ")")
			if mNewLocationX == 17 and mNewLocationY == 6:
				print("")
			#索引
			mNewLocation  = mNewLocationY * mGridX + mNewLocationX

			var onGround = false #地上标志
			var atCeiling = false#天花板标志

			if mNewLocationX < 0 or mNewLocationX > mGridX - 1 or mNewLocationY < 0 or mNewLocationY > mGridY - 1:
				continue  
			if mGrid[mNewLocationY][mNewLocationX] == 0: #障碍区直接跳过
				continue

			if mGrid[mNewLocationY + 1][mNewLocationX] == 0:
				onGround = true
			elif mGrid[mNewLocationY - characterHeight][mNewLocationX] == 0:
				atCeiling = true

			var jumpLength = nodes[mLocation.xy][mLocation.z].JumpLength
			var newJumpLength = jumpLength

			if atCeiling:#在天花板
				if mNewLocationX != mLocationX:#不在头顶方向
					newJumpLength = max(maxCharacterJumpHeight * 2 + 1, jumpLength + 1)
				else:                             #头顶
					newJumpLength = maxCharacterJumpHeight * 2#max(maxCharacterJumpHeight * 2, jumpLength + 2)

			elif onGround:#在地上
				newJumpLength = 0;
			elif mNewLocationY < mLocationY:
#				if jumpLength < 2:
#					newJumpLength = 3
				if int(jumpLength) % 2 == 0:
					newJumpLength = jumpLength + 2
				else:
					newJumpLength = jumpLength + 1
			elif mNewLocationY > mLocationY:
				if int(jumpLength) % 2 == 0:
					newJumpLength = max(maxCharacterJumpHeight * 2, jumpLength + 2)
				else:
					newJumpLength = max(maxCharacterJumpHeight * 2, jumpLength + 1)

			elif !onGround && mNewLocationX != mLocationX:
				newJumpLength = jumpLength + 1

			if jumpLength >= 0 && int(jumpLength) % 2 != 0 && mLocationX != mNewLocationX:
				continue;
				
#			if int(maxCharacterJumpHeight * 2) % 2 != 0 && newJumpLength > maxCharacterJumpHeight*2:
#				continue;
				
			if jumpLength >= maxCharacterJumpHeight * 2 && mNewLocationY < mLocationY:
				continue;

			if newJumpLength >= maxCharacterJumpHeight * 2 + 6 && mNewLocationX != mLocationX && (newJumpLength - (maxCharacterJumpHeight * 2 + 6)) % 8 != 3:
				continue;
			
			var test1 = nodes[mLocation.xy][mLocation.z].G
			var test2 = mGrid[mNewLocationY][mNewLocationX]
			var text3 = newJumpLength / 4
			mNewG = nodes[mLocation.xy][mLocation.z].G + mGrid[mNewLocationY][mNewLocationX] + newJumpLength / 4.0

			if nodes[mNewLocation].size() > 0:
				var lowestJump = 0xffff
				var couldMoveSideways = false
				for j in range(nodes[mNewLocation].size()):
					if nodes[mNewLocation][j].JumpLength < lowestJump:
						lowestJump = nodes[mNewLocation][j].JumpLength

					if int(nodes[mNewLocation][j].JumpLength) % 2 == 0 && nodes[mNewLocation][j].JumpLength < maxCharacterJumpHeight * 2 + 6:
						couldMoveSideways = true

				if lowestJump <= newJumpLength && (int(newJumpLength) % 2 != 0 || newJumpLength >= maxCharacterJumpHeight * 2 + 6 || couldMoveSideways):
					continue
			mH = mHEstimate * (abs(mNewLocationX - end.x) + abs(mNewLocationY - end.y))

			var newNode = PathFinderNodeFast.new()
			newNode.JumpLength = newJumpLength
			newNode.PX = mLocationX
			newNode.PY = mLocationY
			newNode.PZ = mLocation.z
			newNode.G = mNewG
			newNode.F = mNewG + mH
			newNode.Status = mOpenNodeValue
			
			print_debug_info("(" +str(mNewLocationX) + "," + str(mNewLocationY) + ")" + " F:" + str(mNewG + mH)+ " G:"+ str(mNewG) + " PG:" + str(nodes[mLocation.xy][mLocation.z].G) + " H:"+str(mH))
			
			if nodes[mNewLocation].size() == 0:
				touchedLocations.append(mNewLocation)

			nodes[mNewLocation].append(newNode)
			print_debug_info("	nodes.append:"+str(mNewLocation) + " jumpValue:" + str(newJumpLength) + "[" +str(mNewLocationX) + "," + str(mNewLocationY) + "]")
			var location = Location.new(mNewLocation, nodes[mNewLocation].size() - 1)
			location.pos_str = "[" +str(mNewLocationX) + "," + str(mNewLocationY) + "]"
			mOpen.Push(location)
			
		nodes[mLocation.xy][mLocation.z].UpdateStatus(mCloseNodeValue)
		mCloseNodeCounter += 1

	if mFound:
		var posX = end.x
		var posY = end.y

		var fPrevNodeTmp = PathFinderNodeFast.new()
		var fNodeTmp = nodes[mEndLocation][0]

		var fNode = end
		var fPrevNode = end

		var loc = fNodeTmp.PY * mGridX + fNodeTmp.PX

		var mPath = []
		while fNode.x != fNodeTmp.PX || fNode.y != fNodeTmp.PY:
			var fNextNodeTmp = nodes[loc][fNodeTmp.PZ]
#			print("check coord:",fNode)
			if fNode.x == 4 and fNode.y == 4:
				print(mPath)
			if mPath.size() == 0: #終點
				mPath.append(fNode)
#				print("終點:",fNode)
			elif fNodeTmp.JumpLength == 0 && fPrevNodeTmp.JumpLength != 0: #起跳點
				mPath.append(fNode)
#				print("起跳點:",fNode)
			elif fNextNodeTmp.JumpLength != 0 && fNodeTmp.JumpLength == 0: #著陸點
				mPath.append(fNode)
#				print("著陸點:",fNode)
			elif fNode.y < mPath[mPath.size() - 1].y && fNode.y < fNodeTmp.PY:#最高點
				mPath.append(fNode)
#				print("最高點:",fNode)
			elif mGrid[fNode.y][fNode.x - 1] == 0 || mGrid[fNode.y][fNode.x + 1] == 0:#绕过障碍的节点
				if fNode.y != mPath[mPath.size() - 1].y && fNode.x != mPath[mPath.size() - 1].x:
					mPath.append(fNode)
			
#					print("绕过障碍的节点:",fNode)
#			mPath.append(fNode)
			fPrevNode = fNode
			posX = fNodeTmp.PX
			posY = fNodeTmp.PY
			fPrevNodeTmp = fNodeTmp
			fNodeTmp = fNextNodeTmp
			loc = fNodeTmp.PY * mGridX + fNodeTmp.PX;
			fNode = Vector2(posX, posY)

		return mPath
	return null

func print_debug_info(info):
	return
	print(info)

func print_winder_debug_info(info):
	return 
	print(info)





