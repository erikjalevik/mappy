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

class DualMapView: UIView
{
    var leftMap = MKMapView()
    var rightMap = MKMapView()

    var typeSwitcher = UISegmentedControl()

    var sharedConstraints: [NSLayoutConstraint] = []
    var portraitConstraints: [NSLayoutConstraint] = []
    var landscapeConstraints: [NSLayoutConstraint] = []

    var portraitConstraintsSnp: [Constraint] = []
    var landscapeConstraintsSnp: [Constraint] = []

    let margin: CGFloat = 10

    // MARK: - Lifecycle

    convenience init()
    {
        self.init(frame: CGRectZero)
        
        build()
        makeConstraints()
    }
    
    private func build()
    {
        backgroundColor = UIColor.blackColor()
        
        leftMap.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(leftMap)

        rightMap.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(rightMap)

        typeSwitcher.insertSegmentWithTitle("Satellite", atIndex: 0, animated: false)
        typeSwitcher.insertSegmentWithTitle("Hybrid", atIndex: 0, animated: false)
        typeSwitcher.insertSegmentWithTitle("Map", atIndex: 0, animated: false)
        typeSwitcher.selectedSegmentIndex = 0;
        typeSwitcher.tintColor = UIColor(hue: 0.03, saturation: 1.0, brightness: 0.9, alpha: 1.0)
        typeSwitcher.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(typeSwitcher)
    }

    private func makeConstraints()
    {
        makeSharedConstraints()
        makeLandscapeConstraints()
        makePortraitConstraints()

        NSLayoutConstraint.activateConstraints(sharedConstraints)
        // portrait or landscape will be determined in setOrientation
    }

    private func makeSharedConstraints()
    {
        // typeSwitcher
        sharedConstraints.append(NSLayoutConstraint(
            item: typeSwitcher,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Top,
            multiplier: 1,
            constant: 0))

        sharedConstraints.append(NSLayoutConstraint(
            item: typeSwitcher,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Left,
            multiplier: 1,
            constant: margin))
    }

    private func makeLandscapeConstraints()
    {
        // leftMap
        landscapeConstraints.append(NSLayoutConstraint(
            item: leftMap,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: typeSwitcher,
            attribute: .Bottom,
            multiplier: 1,
            constant: margin))

        landscapeConstraints.append(NSLayoutConstraint(
            item: leftMap,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Left,
            multiplier: 1,
            constant: margin))

        landscapeConstraints.append(NSLayoutConstraint(
            item: leftMap,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Bottom,
            multiplier: 1,
            constant: -margin))

        landscapeConstraints.append(NSLayoutConstraint(
            item: leftMap,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: rightMap,
            attribute: .Left,
            multiplier: 1,
            constant: -margin))

        // rightMap
        landscapeConstraints.append(NSLayoutConstraint(
            item: rightMap,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: leftMap,
            attribute: .Top,
            multiplier: 1,
            constant: 0))

        landscapeConstraints.append(NSLayoutConstraint(
            item: rightMap,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: leftMap,
            attribute: .Bottom,
            multiplier: 1,
            constant: 0))

        landscapeConstraints.append(NSLayoutConstraint(
            item: rightMap,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Right,
            multiplier: 1,
            constant: -margin))

        landscapeConstraints.append(NSLayoutConstraint(
            item: rightMap,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: leftMap,
            attribute: .Width,
            multiplier: 1,
            constant: 0))
    }

    private func makePortraitConstraints()
    {
        let topMap = leftMap;
        let bottomMap = rightMap;
        
        // topMap
        portraitConstraints.append(NSLayoutConstraint(
            item: topMap,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: typeSwitcher,
            attribute: .Bottom,
            multiplier: 1,
            constant: margin))

        portraitConstraints.append(NSLayoutConstraint(
            item: topMap,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Left,
            multiplier: 1,
            constant: margin))

        portraitConstraints.append(NSLayoutConstraint(
            item: topMap,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: bottomMap,
            attribute: .Top,
            multiplier: 1,
            constant: -margin))

        portraitConstraints.append(NSLayoutConstraint(
            item: topMap,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Right,
            multiplier: 1,
            constant: -margin))

        // bottomMap
        portraitConstraints.append(NSLayoutConstraint(
            item: bottomMap,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Left,
            multiplier: 1,
            constant: margin))

        portraitConstraints.append(NSLayoutConstraint(
            item: bottomMap,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Bottom,
            multiplier: 1,
            constant: -margin))

        portraitConstraints.append(NSLayoutConstraint(
            item: bottomMap,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Right,
            multiplier: 1,
            constant: -margin))

        portraitConstraints.append(NSLayoutConstraint(
            item: bottomMap,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: topMap,
            attribute: .Height,
            multiplier: 1,
            constant: 0))
    }

    private func makeConstraintsSnp()
    {
        let margin = 10;

        typeSwitcher.snp_makeConstraints { (make) -> Void in
            make.top.left.equalTo(self).offset(margin)
        }

        landscapeConstraintsSnp = leftMap.snp_prepareConstraints { (make) -> Void in
            make.top.equalTo(typeSwitcher.snp_bottom).offset(margin)
            make.left.equalTo(self).offset(margin)
            make.bottom.equalTo(self).offset(-margin)
            make.right.equalTo(rightMap.snp_left).offset(-margin)
        }
        
        landscapeConstraintsSnp += rightMap.snp_prepareConstraints { (make) -> Void in
            make.top.bottom.equalTo(leftMap)
            make.right.equalTo(self).offset(-margin)
            make.width.equalTo(leftMap)
        }
        
        for constraint in landscapeConstraintsSnp
        {
            //constraint.install()
            constraint.activate()
        }
    }
    
    // MARK: - Public Interface

    func setOrientation(orientation: UIInterfaceOrientation)
    {
        switch orientation
        {
            case .Portrait, .PortraitUpsideDown:
                NSLayoutConstraint.deactivateConstraints(landscapeConstraints)
                NSLayoutConstraint.activateConstraints(portraitConstraints)

            case .LandscapeLeft, .LandscapeRight:
                NSLayoutConstraint.deactivateConstraints(portraitConstraints)
                NSLayoutConstraint.activateConstraints(landscapeConstraints)
            
            default:
                assert(false, "Huh?")
        }
    }
}
