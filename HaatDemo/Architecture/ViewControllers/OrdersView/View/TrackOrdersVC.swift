//
//  TrackOrdersVC.swift
//  HaatDemo
//
//  Created by Dhairya on 29/09/24.
//

import UIKit
import GoogleMaps
import CoreLocation
import CocoaMQTT

class TrackOrdersVC: UIViewController, CLLocationManagerDelegate, CocoaMQTTDelegate {

    @IBOutlet weak var gmsMapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    let ordersViewModel: OrdersViewModel = OrdersViewModel()
    
    var mqttClient: CocoaMQTT?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Configure location manager
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        // Enable My Location layer
        self.gmsMapView.isMyLocationEnabled = true
        self.gmsMapView.settings.myLocationButton = true
        
        self.getMQTTDataFromServer()
        
    }
    
    func getMQTTDataFromServer() {
        ordersViewModel.getMQTTDriverLocationCredentialsFromServer { model in
            self.setUpMQTTServerConnection(modelMq: model!)
        }
    }
    
    func setUpMQTTServerConnection(modelMq: MQTTModel) {
        // Initialize the MQTT client
        let clientID = modelMq.clientId ?? ""
        mqttClient = CocoaMQTT(clientID: clientID, host: modelMq.host ?? "", port: 8883)
        
        // Set username and password if required
        mqttClient?.username = modelMq.userName ?? ""
        mqttClient?.password = modelMq.password ?? ""
        
        // Set the MQTT delegate
        mqttClient?.delegate = self
        
        // Configure connection options
        mqttClient?.keepAlive = 60
        mqttClient?.cleanSession = true
        mqttClient?.autoReconnect = true
        mqttClient?.enableSSL = true // Set to true if you are using a secured broker (MQTT over TLS)
        mqttClient?.willMessage?.qos = .qos0
        mqttClient?.subscribe(modelMq.topic ?? "")
        mqttClient?.allowUntrustCACertificate = true
        
        // Connect to the MQTT broker
        _ = mqttClient?.connect()
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        DispatchQueue.main.async {
          self.mqttClient?.disconnect()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // Called when location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
    
    // Handle location authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - CocoaMQTTDelegate Methods
    // Called when the client successfully connects to the MQTT broker
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept {
            print("Connected to MQTT broker")
            // Subscribe to the topic with QoS 0 (At most once delivery)
            mqtt.subscribe("user/driver/location/39a82f2a-962a-4fed-8fd7-6d3850a6c585/#", qos: .qos0)
        }
    }

    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
    
    // Called when a message is received from a topic the client is subscribed to
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        print("Message received on topic: \(message.topic), message: \(message.string ?? "")")
        // Convert the string to Data
        if let jsonData = (message.string ?? "").data(using: .utf8) {
            do {
                // Use JSONSerialization to convert Data to Dictionary
                if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    print(jsonDict)
                    // Access elements like this
                    let locationData = jsonDict["location"] as! [String: Any]
                    let geoMetoryData = locationData["geometry"] as! [String: Any]
                    let cordArr = geoMetoryData["coordinates"] as! NSArray
                    self.updateMapCameraWithLocation(lng: "\(cordArr[0])", lat: "\(cordArr[1])")
                }
            } catch {
                print("Error deserializing JSON: \(error.localizedDescription)")
            }
        }
    }
    
    func updateMapCameraWithLocation(lng: String, lat: String) {
        let camera = GMSCameraPosition.camera(withLatitude: NSString(format: "%@", lat).doubleValue, longitude: NSString(format: "%@", lng).doubleValue, zoom: 12.0)
        self.gmsMapView.camera = camera
        self.gmsMapView.clear()
        
        let currentLocation = CLLocationCoordinate2D(latitude: NSString(format: "%@", lat).doubleValue, longitude: NSString(format: "%@", lng).doubleValue)
        let marker = GMSMarker()
        marker.position = currentLocation
        marker.title = "You are here"
        marker.map = self.gmsMapView
    }

    // Called when the client disconnects from the MQTT broker
    func mqtt(_ mqtt: CocoaMQTT, didDisconnectWithError err: Error?) {
        print("Disconnected from MQTT broker, error: \(err?.localizedDescription ?? "none")")
    }

    // Called when a message is successfully published
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("Message published to topic: \(message.topic), message: \(message.string ?? "")")
    }

    // Called when a message is successfully subscribed to a topic
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        print("Successfully subscribed to topics: \(success.allKeys)")
    }

    // Called when the subscription to a topic fails
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics failed: [String]) {
        print("Failed to subscribe to topics: \(failed)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("Here")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("here")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("here")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("here")
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
