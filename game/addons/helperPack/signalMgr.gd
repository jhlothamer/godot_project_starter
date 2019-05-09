extends Node

var subscribers = {}
var publishers = {}

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
	
	if !subscriber.is_connected("tree_exiting", self, "subscriberExitTree"):
		subscriber.connect("tree_exiting", self, "subscriberExitTree", [subscriber])

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
	publishers.erase(publisher.get_instance_id())

func deRegisterSubscriber(subscriber):
	if !subscribers.has(subscriber.get_instance_id()):
		print("subscriber dereg - but is not in list!!")
	subscribers.erase(subscriber.get_instance_id())

func watchPubExitTree(publisher):
	if !publisher.is_connected("tree_exiting", self, "publisherExitTree"):
		publisher.connect("tree_exiting", self, "publisherExitTree", [publisher])

func connectPubSub(pub, sub):
	if !pub.publisher.is_connected(pub.signalName, sub.subscriber, sub.method):
		pub.publisher.connect(pub.signalName, sub.subscriber, sub.method, sub.binds)#, sub.binds, sub.flags)
		
func publisherExitTree(publisher):
	deRegisterPublisher(publisher)
	
func subscriberExitTree(subscriber):
	deRegisterSubscriber(subscriber)

