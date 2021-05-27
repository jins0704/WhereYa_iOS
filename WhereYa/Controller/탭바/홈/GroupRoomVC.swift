//
//  GroupRoomVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/05/25.
//

import UIKit
public let DEFAULT_POSITION = MTMapPointGeo(latitude: 37.576568, longitude: 127.029148)

class GroupRoomVC: UIViewController,MTMapViewDelegate {

    static let identifier = "GroupRoomVC"
    
    var mapView: MTMapView?
    var mapPoint1: MTMapPoint?
    var poiItem1: MTMapPOIItem?
    
    @IBOutlet var mapScreenView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            poiItem1?.markerType = MTMapPOIItemMarkerType.bluePin
            poiItem1?.mapPoint = mapPoint1
            poiItem1?.itemName = "아무데나 찍어봄"
            mapView.add(poiItem1)
            
            //            mapView.addPOIItems([poiItem1,poiItem2]
            //            mapView.fitAreaToShowAllPOIItems()
            
            self.mapScreenView.addSubview(mapView)
        }
        
    }
    
    
    // Custom: 현 위치 트래킹 함수
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        let currentLocation = location?.mapPointGeo()
        if let latitude = currentLocation?.latitude, let longitude = currentLocation?.longitude{
            print("MTMapView updateCurrentLocation (\(latitude),\(longitude)) accuracy (\(accuracy))")
        }
    }
    
    func mapView(_ mapView: MTMapView?, updateDeviceHeading headingAngle: MTMapRotationAngle) {
        print("MTMapView updateDeviceHeading (\(headingAngle)) degrees")
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
