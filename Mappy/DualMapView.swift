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

    override init(frame: CGRect = CGRect.zero)
    {
        super.init(frame: frame)

        build()
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    private func build()
    {
        backgroundColor = UIColor.black
        
        leftMap.translatesAutoresizingMaskIntoConstraints = false
        leftMap.delegate = self;
        addSubview(leftMap)

        rightMap.translatesAutoresizingMaskIntoConstraints = false
        rightMap.delegate = self;
        addSubview(rightMap)

        typeSwitcher.insertSegment(withTitle: "Satellite", at: 0, animated: false)
        typeSwitcher.insertSegment(withTitle: "Hybrid", at: 0, animated: false)
        typeSwitcher.insertSegment(withTitle: "Map", at: 0, animated: false)
        typeSwitcher.selectedSegmentIndex = 0;
        typeSwitcher.tintColor = UIColor(hue: 0.03, saturation: 1.0, brightness: 0.9, alpha: 1.0)
        typeSwitcher.translatesAutoresizingMaskIntoConstraints = false
        typeSwitcher.addTarget(self, action: #selector(onTypeSwitched(sender:)), for: .valueChanged)
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
        typeSwitcher.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(margin)
            make.centerX.equalTo(self)
        }
    }

    private func makeLandscapeConstraints()
    {
        landscapeConstraints = leftMap.snp.prepareConstraints { (make) in
            make.top.equalTo(typeSwitcher.snp.bottom).offset(margin)
            make.left.equalTo(self).offset(margin)
            make.bottom.equalTo(self).offset(-margin)
            make.right.equalTo(rightMap.snp.left).offset(-margin)
        }
        
        landscapeConstraints += rightMap.snp.prepareConstraints { (make) in
            make.top.bottom.equalTo(leftMap)
            make.right.equalTo(self).offset(-margin)
            make.width.equalTo(leftMap)
        }
    }

    private func makePortraitConstraints()
    {
        let topMap = leftMap;
        let bottomMap = rightMap;
       
        portraitConstraints = topMap.snp.prepareConstraints { (make) in
            make.top.equalTo(typeSwitcher.snp.bottom).offset(margin)
            make.left.equalTo(self).offset(margin)
            make.bottom.equalTo(bottomMap.snp.top).offset(-margin)
            make.right.equalTo(self).offset(-margin)
        }

        portraitConstraints += bottomMap.snp.prepareConstraints { (make) in
            make.left.right.height.equalTo(topMap)
            make.bottom.equalTo(self).offset(-margin)
        }
    }

    // MARK: - Public Interface

    func setOrientation(_ orientation: UIInterfaceOrientation)
    {
        switch orientation
        {
            case .portrait, .portraitUpsideDown:
                deactivateConstraints(landscapeConstraints)
                activateConstraints(portraitConstraints)

            case .landscapeLeft, .landscapeRight:
                deactivateConstraints(portraitConstraints)
                activateConstraints(landscapeConstraints)
            
            default:
                assert(false, "Unknown orientation")
        }
    }
    
    func activateConstraints(_ constraints: [Constraint])
    {
        for constraint in constraints
        {
            constraint.activate()
        }
    }

    func deactivateConstraints(_ constraints: [Constraint])
    {
        for constraint in constraints
        {
            constraint.deactivate()
        }
    }

    // MARK: - Event handlers

    @objc private func onTypeSwitched(sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex
        {
            case 0:
                leftMap.mapType = .standard
                rightMap.mapType = .standard
            case 1:
                leftMap.mapType = .hybrid
                rightMap.mapType = .hybrid
            case 2:
                leftMap.mapType = .satellite
                rightMap.mapType = .satellite
            default:
                assert(false, "Unknown option")
        }
    }

    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
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
