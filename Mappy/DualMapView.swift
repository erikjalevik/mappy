//
//  DualMapView.swift
//  Mappy
//
//  Created by Erik Jälevik on 24/07/15.
//  Copyright (c) 2015 Futurice. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class DualMapView: UIView, MKMapViewDelegate
{
    // MARK: - Public variables

    let typeSwitcher = UISegmentedControl()

    // MARK: - Private variables

    private let leftMap = MKMapView()
    private let rightMap = MKMapView()

    private var portraitConstraints: [Constraint] = []
    private var landscapeConstraints: [Constraint] = []

    private let margin: CGFloat = 10

    // MARK: - Lifecycle

    override init(frame: CGRect = CGRectZero)
    {
        super.init(frame: frame)

        build()
        makeConstraints()
    }

    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    private func build()
    {
        backgroundColor = UIColor.blackColor()
        
        leftMap.setTranslatesAutoresizingMaskIntoConstraints(false)
        leftMap.delegate = self;
        addSubview(leftMap)

        rightMap.setTranslatesAutoresizingMaskIntoConstraints(false)
        rightMap.delegate = self;
        addSubview(rightMap)

        typeSwitcher.insertSegmentWithTitle("Satellite", atIndex: 0, animated: false)
        typeSwitcher.insertSegmentWithTitle("Hybrid", atIndex: 0, animated: false)
        typeSwitcher.insertSegmentWithTitle("Map", atIndex: 0, animated: false)
        typeSwitcher.selectedSegmentIndex = 0;
        typeSwitcher.tintColor = UIColor(hue: 0.03, saturation: 1.0, brightness: 0.9, alpha: 1.0)
        typeSwitcher.setTranslatesAutoresizingMaskIntoConstraints(false)
        typeSwitcher.addTarget(self, action: "onTypeSwitched:", forControlEvents: .ValueChanged);
        addSubview(typeSwitcher)
    }

    private func makeConstraints()
    {
        makeSharedConstraints()
        makeLandscapeConstraints()
        makePortraitConstraints()
    }

    private func makeSharedConstraints()
    {
        typeSwitcher.snp_makeConstraints { (make) -> Void in
            make.top.left.equalTo(self).offset(margin)
        }
    }

    private func makeLandscapeConstraints()
    {
        landscapeConstraints = leftMap.snp_prepareConstraints { (make) -> Void in
            make.top.equalTo(typeSwitcher.snp_bottom).offset(margin)
            make.left.equalTo(self).offset(margin)
            make.bottom.equalTo(self).offset(-margin)
            make.right.equalTo(rightMap.snp_left).offset(-margin)
        }
        
        landscapeConstraints += rightMap.snp_prepareConstraints { (make) -> Void in
            make.top.bottom.equalTo(leftMap)
            make.right.equalTo(self).offset(-margin)
            make.width.equalTo(leftMap)
        }
    }

    private func makePortraitConstraints()
    {
        let topMap = leftMap;
        let bottomMap = rightMap;
       
        portraitConstraints = topMap.snp_prepareConstraints { (make) -> Void in
            make.top.equalTo(typeSwitcher.snp_bottom).offset(margin)
            make.left.equalTo(self).offset(margin)
            make.bottom.equalTo(bottomMap.snp_top).offset(-margin)
            make.right.equalTo(self).offset(-margin)
        }

        portraitConstraints += bottomMap.snp_prepareConstraints { (make) -> Void in
            make.left.right.height.equalTo(topMap)
            make.bottom.equalTo(self).offset(-margin)
        }
    }

    // MARK: - Public Interface

    func setOrientation(orientation: UIInterfaceOrientation)
    {
        switch orientation
        {
            case .Portrait, .PortraitUpsideDown:
                deactivateConstraints(landscapeConstraints)
                activateConstraints(portraitConstraints)

            case .LandscapeLeft, .LandscapeRight:
                deactivateConstraints(portraitConstraints)
                activateConstraints(landscapeConstraints)
            
            default:
                assert(false, "Unknown orientation")
        }
    }
    
    func activateConstraints(constraints: [Constraint])
    {
        for constraint in constraints
        {
            constraint.activate()
        }
    }

    func deactivateConstraints(constraints: [Constraint])
    {
        for constraint in constraints
        {
            constraint.deactivate()
        }
    }

    // MARK: - Event handlers

    func onTypeSwitched(sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex
        {
            case 0:
                leftMap.mapType = .Standard
                rightMap.mapType = .Standard
            case 1:
                leftMap.mapType = .Hybrid
                rightMap.mapType = .Hybrid
            case 2:
                leftMap.mapType = .Satellite
                rightMap.mapType = .Satellite
            default:
                assert(false, "Unknown option")
        }
    }

    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool)
    {
        if animated
        {
            // Hack: way of filtering out region changes not initiated by the user,
            // relying on the fact that they will not have the animated flag set.
            return;
        }

        let otherMap = mapView === leftMap ? rightMap : leftMap;

        var otherRegion = otherMap.region
        if CLLocationCoordinate2DIsValid(otherRegion.center)
        {
            let newSpan = mapView.region.span
            otherRegion.span = newSpan
            otherMap.setRegion(otherRegion, animated: true)
        }
    }
}
