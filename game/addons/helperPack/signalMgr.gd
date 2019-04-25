extends Node

var subscribers = {}
var publishers = {}

var currentScene

func _ready():
	var tree = get_tree()
	currentScene = tree.current_scene
	tree.connect("node_removed", self, "node_removed")

func node_removed(n):
	if n != currentScene:
		return
	#clear()
	call_deferred("reGetCurrentScene")

func reGetCurrentScene():
	currentScene = get_tree().current_scene

#func _enter_tree():
#	clear()

#func _exit_tree():
#	clear()

class Subscriber:
	var subscriber = null
	var signalName = ""
	var method = ""
	var binds = null
	var flags = 0
	func _init(sub, sig, m, b, f):
		subscriber = sub
		signalName = sig
		method = m
		binds = b
		flags = f
	func getSignalName():
		return signalName

class Publisher:
	var publisher = null
	var signalName = ""
	func _init(pub, sig):
		publisher = pub
		signalName = sig

func registerSubscriber(subscriber, signalName, method, binds = Array(), flags=0):
	watchSubExitTree(subscriber)
	var sub = Subscriber.new(subscriber, signalName, method, binds, flags)
	var instanceId = subscriber.get_instance_id()
	if !subscribers.has(instanceId):
		subscribers[instanceId] = []
	subscribers[instanceId].append(sub)
	for pubArray in publishers.values():
		for pub in pubArray:
			if pub.signalName == sub.signalName:
				connectPubSub(pub, sub)

func watchSubExitTree(subscriber):
	
	if !subscriber.is_connected("tree_exited", self, "subscriberExitTree"):
		subscriber.connect("tree_exited", self, "subscriberExitTree", [subscriber])

func registerPublisher(publisher, signalName):
	watchPubExitTree(publisher)
	var pub = Publisher.new(publisher, signalName)
	var instanceId = publisher.get_instance_id()
	if !publishers.has(instanceId):
		publishers[instanceId] = []
	publishers[instanceId].append(pub)
	for subArray in subscribers.values():
		for sub in subArray:
			if pub.signalName == sub.signalName:
				connectPubSub(pub, sub)


func deRegisterPublisher(publisher):
	if !publishers.has(publisher.get_instance_id()):
		print("publisher dereg - but is not in list!!")
		return
	var pub = publishers[publisher.get_instance_id()]
	print("dereg publisher: " + str(pub[0].signalName))
	publishers.erase(publisher.get_instance_id())

func deRegisterSubscriber(subscriber):
	if !subscribers.has(subscriber.get_instance_id()):
		print("subscriber dereg - but is not in list!!")
	subscribers.erase(subscriber.get_instance_id())

func watchPubExitTree(publisher):
	if !publisher.has_user_signal("exit_tree"):
		return
	if !publisher.is_connected("exit_tree", self, "publisherExitTree"):
		publisher.connect("exit_tree", self, "publisherExitTree", [publisher])

func connectPubSub(pub, sub):
	pub.publisher.connect(pub.signalName, sub.subscriber, sub.method, sub.binds)#, sub.binds, sub.flags)

func publisherExitTree(publisher):
	deRegisterPublisher(publisher)
	
func subscriberExitTree(subscriber):
	deRegisterSubscriber(subscriber)

