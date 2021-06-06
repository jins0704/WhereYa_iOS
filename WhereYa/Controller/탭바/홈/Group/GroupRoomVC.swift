//
//  GroupRoomVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/05/25.
//

import UIKit
import CoreLocation
import JJFloatingActionButton
import Toast_Swift
import Starscream

class GroupRoomVC: UIViewController,MTMapViewDelegate{

    static let identifier = "GroupRoomVC"
    
    var promise : Promise? //나중에 받아올 약속
    var mapView: MTMapView?
    var mapPoint1: MTMapPoint?
    var poiItems: [MTMapPOIItem]?
    var locationManager = CLLocationManager()
    var currentLocation : MTMapPointGeo?
    
    var dataDelegate : dataDelegate?
    var promiseLocation : MTMapPointGeo?
    let socketURL = APIConstants.SOCKET_URL
    var request : URLRequest?
    var socket : WebSocket?
    var friends : [UserLocation] = []
    
    @IBOutlet var mapScreenView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPromiseInfo()
        setLocationManager()
        setMap()
        setFloatingButton()
        setSocket()
    }
    func setPromiseInfo(){
        guard let promiseLogitude = Double(promise?.destination?.x ?? "0.0") else { return};
        guard let promiseLatitude = Double(promise?.destination?.y ?? "0.0") else { return}
        promiseLocation = MTMapPointGeo(latitude: promiseLatitude, longitude: promiseLogitude)
    }
    func setLocationManager(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        //위치업데이트
        if CLLocationManager.locationServicesEnabled(){
            print("loc ON")
            locationManager.startUpdatingLocation()
        }
        else{print("loc OFF")}
    }
    
    func setMap(){
     
        // 지도 불러오기
        let mapPoint = CGPoint(x: 0, y: 0)
        let mapSize = CGSize(width: mapScreenView.frame.size.width, height: mapScreenView.frame.size.height)
        mapView = MTMapView(frame: .init(origin: mapPoint, size: mapSize))
        
        if let mapView = mapView {
            mapView.delegate = self
            mapView.baseMapType = .standard
            
            // 지도 중심점, 레벨
            mapView.setMapCenter(MTMapPoint(geoCoord: promiseLocation!), zoomLevel: 4, animated: true)
            
            // 현재 위치 트래킹
            mapView.showCurrentLocationMarker = true
            mapView.currentLocationTrackingMode = .onWithoutHeading
            
            // 마커 추가
            self.mapPoint1 = MTMapPoint(geoCoord: promiseLocation!)
            let poiItem1 = MTMapPOIItem()
            poiItem1.markerType =  MTMapPOIItemMarkerType.yellowPin
            poiItem1.mapPoint = mapPoint1
            poiItem1.itemName = "약속 장소"
            
            poiItems?.append(poiItem1)
            var cnt = 0
            var b : Double = 0
            for friend in friends{
                let poiItem = MTMapPOIItem()
                
                poiItem.markerType = MTMapPOIItemMarkerType.customImage
                poiItem.customImage = UIImage(named: CharacterImage.images[cnt])
                poiItem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.29104667912, longitude: 127.05+b))
                friend.characterImg = CharacterImage.images[cnt]
                poiItem.itemName = friend.name
                mapView.add(poiItem)
                cnt += 1
                b += 0.002
            }
    
            mapView.add(poiItem1)
            
            //            mapView.addPOIItems([poiItem1,poiItem2]
            //            mapView.fitAreaToShowAllPOIItems()
            
            let touchdownCircle = MTMapCircle()
        
            touchdownCircle.circleCenterPoint = mapPoint1
            touchdownCircle.circleRadius = 1000.0
            touchdownCircle.circleFillColor = UIColor(red: 1, green: 1, blue: 0, alpha: 0.5)
            touchdownCircle.circleLineWidth = 5
            touchdownCircle.tag = 1
            mapView.addCircle(touchdownCircle)
            
            self.mapScreenView.addSubview(mapView)
        }
    }
    
    func setFloatingButton(){
        let actionButton = JJFloatingActionButton()
        
        actionButton.buttonColor = UIColor.subpink
        
        actionButton.addItem(title: "상세정보", image: UIImage(systemName: "list.dash")?.withRenderingMode(.alwaysTemplate)) { item in
          // do something
        
            let storyboard = UIStoryboard.init(name: "TabbarVC", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: "PromiseDetailVC")
            
            self.dataDelegate = nextVC as? dataDelegate
            self.dataDelegate?.hiddenUI(hidden: true)
            self.dataDelegate?.sendPromise(self.promise!)
            
            self.present(nextVC, animated: true, completion: nil)
        }

        actionButton.addItem(title: "친구현황", image: UIImage(systemName: "person.3.fill")?.withRenderingMode(.alwaysTemplate)) { item in
            let storyboard = UIStoryboard.init(name: "TabbarVC", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: "GroupConditionVC")
            
            self.dataDelegate = nextVC as? dataDelegate
            self.dataDelegate?.sendUserLocation(self.friends)
            
            self.present(nextVC, animated: true, completion: nil)
        }

        actionButton.addItem(title: "터치다운", image: UIImage(systemName: "hand.raised.fill")?.withRenderingMode(.alwaysTemplate)) { item in
   
            let loc1 = CLLocation(latitude: self.currentLocation?.latitude ?? 0, longitude: self.currentLocation?.longitude ?? 0)
            let loc2 = CLLocation(latitude: self.promiseLocation!.latitude, longitude: self.promiseLocation!.longitude)
            
            let distance = loc1.distance(from: loc2)
            if(distance > 500){
                self.view.makeToast("\(Int(distance - 500))m 남았어요!", duration: 0.5, position: .center)
            }
            else{
                self.view.makeToast("도착했어요!-\(distance)", duration: 0.5, position: .center)
                //item.isHidden = true
            }
        }

        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true

    }
    // Custom: 현 위치 트래킹 함수
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func moveToMyLocation(_ sender: Any) {
        self.mapView?.setMapCenter(MTMapPoint(geoCoord: currentLocation ?? promiseLocation!), zoomLevel: 3, animated: true)
    }
    
    @IBAction func moveToPromiseLocation(_ sender: Any) {
        // 지도 중심점, 레벨
        self.mapView?.setMapCenter(MTMapPoint(geoCoord: promiseLocation!), zoomLevel: 3, animated: true)
    }
}

extension GroupRoomVC : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            print(coordinate.latitude) //y값 위도
            print(coordinate.longitude) //x값 경도
        }
    }
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        currentLocation = location?.mapPointGeo()
        if let latitude = currentLocation?.latitude, let longitude = currentLocation?.longitude{
//            print("MTMapView updateCurrentLocation (\(latitude),\(longitude)) accuracy (\(accuracy))")
            if let room = socket{
                //print("hi socket")
                let message = ["roomId" : promise?.id ?? "0","name": UserDefaults.standard.string(forKey: UserKey.NICKNAME) ?? "a","x" : String(longitude),
                               "y" : String(latitude)] as [String : Any]
                
                do {
                    let data = try JSONSerialization.data(withJSONObject: message)
                    if let dataString = String(data: data, encoding: .utf8){
                        room.write(string: dataString)
                    }
                } catch {
                    print("JSON serialization failed: ", error)
                }
            }
        }
    }
}

extension GroupRoomVC : dataDelegate{
    func sendUserLocation(_ userlocations: [UserLocation]) {}
    
    func sendUserLocation(_ userlocation: UserLocation) {}
    
    func hiddenUI(hidden: Bool) {}
    
    func sendPromise(_ promise: Promise) {
        self.promise = promise
        
        if let users = promise.friends{
            for i in users{
                let user = UserLocation.init()
                user.name = i
                user.touchdown = false
                if(i == "bbb"){user.touchdown = true} //test
                friends.append(user)
            }
        }
    }
}

//socket
extension GroupRoomVC : WebSocketDelegate{
    func setSocket(){
        self.request = URLRequest(url: URL(string: socketURL)!)
        request?.timeoutInterval = 10
        //        request?.setValue("Room", forHTTPHeaderField: "Sec-WebSocket-Protocol")
        socket = WebSocket(request: request!, certPinner: FoundationSecurity(allowSelfSigned: true))
        socket?.delegate = self
        socket?.connect()
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch(event){
        case .connected(let headers):
            print(".connected - \(headers)")
        case .disconnected(let reason, let code):
            print(".disconnected - \(reason), \(code)")
        case .text(let text):
            print("received text: \(text)")
        case .binary(let data):
            print("received data: \(data)")
        case .pong(_):
            print("received pong")
        case .ping(_):
            print("received ping")
        case .viabilityChanged:
            print("viabilityChanged")
        case .reconnectSuggested:
            print("reconnectSuggested")
        case .cancelled:
            print("cancelled")
        case .error(_): break
            
        }
    }
}
