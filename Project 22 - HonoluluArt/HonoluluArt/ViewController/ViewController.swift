//
//  ViewController.swift
//  HonoluluArt
//
//  Created by pike young on 2017/9/12.
//  Copyright © 2017年 pike young. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    /// 起始经纬度
    fileprivate let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    
    /// 范围半径
    fileprivate let regionRadius: CLLocationDistance = 1000
    
    fileprivate var artworks = [Artwork]()
    fileprivate var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
      
        /// Set up map.
        mapView.delegate = self
        centerMapOnLocation(location: initialLocation)
        loadInitialData()
        
        // 添加大头针信息
        mapView.addAnnotations(artworks)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    /// 检查定位权限
    fileprivate func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    /// 设置地图显示区域，用于控制当前屏幕显示地图范围
    ///
    /// - Parameter location: 位置
    fileprivate func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /// 加载json数据
    fileprivate func loadInitialData() {
        let fileName = Bundle.main.path(forResource: "PublicArt", ofType: "json")
        var data: Data?
        do {
            data = try Data(contentsOf: URL(fileURLWithPath: fileName!), options: NSData.ReadingOptions(rawValue: 0))
        } catch _ {
            data = nil
        }
        
        if let data = data {
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject],
                    let jsonData = JSONValue.fromObject(jsonObject)?["data"]?.array {
                    for artworkJSON in jsonData {
                        if let artworkJSON = artworkJSON.array,
                            let artwork = Artwork.fromJSON(json: artworkJSON) {
                            artworks.append(artwork)
                        }
                    }
                }
            } catch let error as NSError {
                print(error.description)
            }
        }
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKPinAnnotationView?
        /// 判断有没有大头针信息
        if let annotation = annotation as? Artwork {
            let identifier = "pin"
            /// 复用大头针View
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView{
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else  {
                /// 第一次创建大头针View
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view?.canShowCallout = true
                view?.calloutOffset = CGPoint(x: -5, y: 5)
                view?.pinTintColor = annotation.pinColor()
                view?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // 大头针点击
        let location = view.annotation as! Artwork
        // 步行模式
        let lauchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        // 打开地图
        location.mapItem().openInMaps(launchOptions: lauchOptions)
    }
}

