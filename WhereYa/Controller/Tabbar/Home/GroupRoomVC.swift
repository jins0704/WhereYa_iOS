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

public let DEFAULT_POSITION = MTMapPointGeo(latitude: 37.576568, longitude: 127.029148)

class GroupRoomVC: UIViewController,MTMapViewDelegate {

    static let identifier = "GroupRoomVC"

    var promise : Promise? //나중에 받아올 약속
    var mapView: MTMapView?
    var mapPoint1: MTMapPoint?
    var poiItem1: MTMapPOIItem?
    
    var locationManager = CLLocationManager()
    var currentLocation : MTMapPointGeo?
    
    
    @IBOutlet var mapScreenView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocationManager()
        setMap()
        setFloatingButton()
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
            mapView.setMapCenter(MTMapPoint(geoCoord: DEFAULT_POSITION), zoomLevel: 4, animated: true)
            
            // 현재 위치 트래킹
            mapView.showCurrentLocationMarker = true
            mapView.currentLocationTrackingMode = .onWithoutHeading
            
            // 마커 추가
            self.mapPoint1 = MTMapPoint(geoCoord: MTMapPointGeo(latitude:  37.585568, longitude: 127.019148))
            poiItem1 = MTMapPOIItem()
            poiItem1?.markerType = MTMapPOIItemMarkerType.yellowPin
            poiItem1?.mapPoint = mapPoint1
            poiItem1?.itemName = "약속 장소"
    

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
            
            //self.celldelegate = nextVC as? CellDelegate
            //celldelegate?.sendData(name: myNameLabel.text!, image: myProfileImage.image!)
            //nextVC.modalPresentationStyle = .
            
            self.present(nextVC, animated: true, completion: nil)
        
            
        }

        actionButton.addItem(title: "친구현황", image: UIImage(systemName: "person.3.fill")?.withRenderingMode(.alwaysTemplate)) { item in
          // do something
        }

        actionButton.addItem(title: "터치다운", image: UIImage(systemName: "hand.raised.fill")?.withRenderingMode(.alwaysTemplate)) { item in
   
            let loc1 = CLLocation(latitude: self.currentLocation?.latitude ?? 0, longitude: self.currentLocation?.longitude ?? 0)
            let loc2 = CLLocation(latitude: DEFAULT_POSITION.latitude, longitude: DEFAULT_POSITION.longitude)
            
            let distance = loc1.distance(from: loc2)
            if(distance > 1000){
                self.view.makeToast("아직 도착하지 못했어요", duration: 0.5, position: .center)
            }
            else{
                self.view.makeToast("도착했어요!", duration: 0.5, position: .center)
                item.isHidden = true
            }
        }

        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true

        // last 4 lines can be replaced with
        // actionButton.display(inViewController: self)
    }
    // Custom: 현 위치 트래킹 함수
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func moveToMyLocation(_ sender: Any) {
        self.mapView?.setMapCenter(MTMapPoint(geoCoord: currentLocation ?? DEFAULT_POSITION), zoomLevel: 3, animated: true)
    }
    
    @IBAction func moveToPromiseLocation(_ sender: Any) {
        // 지도 중심점, 레벨
        self.mapView?.setMapCenter(MTMapPoint(geoCoord: DEFAULT_POSITION), zoomLevel: 3, animated: true)
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
            print("MTMapView updateCurrentLocation (\(latitude),\(longitude)) accuracy (\(accuracy))")
        }
    }
    
    func mapView(_ mapView: MTMapView?, updateDeviceHeading headingAngle: MTMapRotationAngle) {
        print("MTMapView updateDeviceHeading (\(headingAngle)) degrees")
    }
}
