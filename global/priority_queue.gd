extends Node

class ComparePFNodeMatrix:
	var mMatrix
	func _init(matrix):
		mMatrix = matrix
	func Compare(a , b):
		if mMatrix[a.xy][a.z].F > mMatrix[b.xy][b.z].F:
			return 1
		elif mMatrix[a.xy][a.z].F < mMatrix[b.xy][b.z].F:
			return -1
		return 0
		
var InnerList = []
var mComparer

func _init(nodes):
	mComparer = ComparePFNodeMatrix.new(nodes)

func SwitchElements(i,j):
	var h = InnerList[i]
	InnerList[i] = InnerList[j]
	InnerList[j] = h

func OnCompare(i,j):
	return mComparer.Compare(InnerList[i],InnerList[j])

func Push(item):
	var p = InnerList.size()
	var p2
	InnerList.append(item)
	while true:
		if p == 0:
			break
		p2 = (p-1)/2
		if OnCompare(p,p2) < 0:
			SwitchElements(p,p2)
			p = p2
		else:
			break
	return p

func Pop():
	var result = InnerList[0]
	var p = 0
	var p1
	var p2
	var pn
	InnerList[0] = InnerList[InnerList.size()-1]
	InnerList.pop_back()
	while true:
		pn = p
		p1 = 2*p+1
		p2 = 2*p+2
		if InnerList.size() > p1 && OnCompare(p,p1) > 0:
			p = p1
		if InnerList.size() > p2 && OnCompare(p,p2)>0:
			p = p2
		if p == pn:
			break
		SwitchElements(p,pn)
	return result

func Update(i):
	var p = i
	var pn
	var p1
	var p2
	while true:
		if p==0:
			break
		p2 = (p-1)/2
		if OnCompare(p,p2) < 0:
			SwitchElements(p,p2)
		else:
			break
		if p<i:
			return
		while true:
			pn = p;
			p1 = 2*p+1;
			p2 = 2*p+2;
			if InnerList.size() > p1 && OnCompare(p,p1)>0:
				p = p1
			if InnerList.size() > p2 && OnCompare(p,p2)>0:
				p = p2
			if p == pn:
				break
			SwitchElements(p,pn)

func Peek():
	if InnerList.size() > 0:
		return InnerList[0]

func Count():
	return InnerList.size()

func RemoveLocation(item):
	var index = -1
	for j in range(InnerList.size()):         
		if mComparer.Compare(InnerList[j], item) == 0:
			index = j
		if index != -1:
			InnerList.RemoveAt(index)

func getIndex(index):
	return InnerList[index]

func setIndex(index,value):
	InnerList[index] = value
	Update(index)

func print_data():
	for item in InnerList:
		print("#:"+item.pos_str)

func Clear():
	InnerList = []