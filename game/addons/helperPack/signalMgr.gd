extends Node

class Subscriber:
	var subscriber
	var signalName : String
	var method : String
	var binds
	func _init(subscriber, signalName, method, binds):
		self.subscriber = subscriber
		self.signalName = signalName
		self.method = method
		self.binds = binds
	func connect_publisher(publisher):
		if !publisher.is_connected(signalName, subscriber, method):
			publisher.connect(signalName, subscriber, method, binds)

class Publisher:
	var publisher
	var signalName : String
	func _init(publisher, signalName):
		self.publisher = publisher
		self.signalName = signalName
	func connect_subscribers(subscribers):
		for subscriber in subscribers:
			subscriber.connect_publisher(publisher)
	func connect_subscriber(subscriber):
		subscriber.connect_publisher(publisher)

var subscribers = {}
var publishers = {}

func register_subscriber(subscriber, signalName, method, binds=Array()):
	var sub = Subscriber.new(subscriber, signalName, method, binds)
	var instance_id = subscriber.get_instance_id()
	if !subscribers.has(instance_id):
		subscribers[instance_id] = []
		watch_tree_exited(subscriber)
	subscribers[instance_id].append(sub)
	for pubs in publishers.values():
		for pub in pubs:
			if pub.signalName == sub.signalName:
				pub.connect_subscriber(sub)

func register_publisher(publisher, signalName):
	var pub = Publisher.new(publisher, signalName)
	var instance_id = publisher.get_instance_id()
	if !publishers.has(instance_id):
		publishers[instance_id] = []
		watch_tree_exited(publisher)
	publishers[instance_id].append(pub)
	for subs in subscribers.values():
		for sub in subs:
			if sub.signalName == pub.signalName:
				pub.connect_subscriber(sub)

func unregister_subscriber(subscriber):
	var instance_id = subscriber.get_instance_id()
	subscribers.erase(instance_id)

func unregister_publisher(publisher):
	var instance_id = publisher.get_instance_id()
	publishers.erase(instance_id)

func unregister(publisherOrSubscriber):
	unregister_publisher(publisherOrSubscriber)
	unregister_subscriber(publisherOrSubscriber)

func clear():
	subscribers = {}
	publishers = {}

func watch_tree_exited(publisherSubscriber):
	if !publisherSubscriber.is_connected("tree_exited", self, "on_tree_exited"):
		publisherSubscriber.connect("tree_exited", self, "on_tree_exited", [publisherSubscriber])

func on_tree_exited(publisherSubscriber):
	unregister(publisherSubscriber)


