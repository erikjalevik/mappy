//
//  RootController.swift
//  Mappy
//
//  Created by Erik Jälevik on 23/07/15.
//  Copyright (c) 2015 Futurice. All rights reserved.
//

import UIKit

class RootController: UIViewController
{
    let mapView = DualMapView(frame: CGRectZero)

    // MARK: - Lifecycle

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    init()
    {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        build()
        makeConstraints()
    }

    private func build()
    {
        self.view.backgroundColor = UIColor.blackColor()
        
        self.view.addSubview(mapView)
    }

    private func makeConstraints()
    {
        mapView.snp_makeConstraints { (make) -> Void in
            // HACK: top layout guide seems broken in SnapKit with Swift 2.0, using workaround for now
            //make.top.equalTo(self.snp_topLayoutGuideBottom)
            make.top.equalTo(self.view).offset(20)
            make.left.right.bottom.equalTo(self.view)
        }
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // We don't know our initial size until here
        setLayout(fromSize: self.view.frame.size)
    }

    // MARK: - Configuration

    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }

    // MARK: - Rotation

    override func viewWillTransitionToSize(
        size: CGSize,
        withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

        setLayout(fromSize: size)
    }
    
    private func setLayout(fromSize size: CGSize)
    {
        let toPortrait = size.height > size.width
        self.mapView.setOrientation(toPortrait ? .Portrait : .LandscapeLeft)
    }

}

