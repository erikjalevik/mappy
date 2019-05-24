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
    private let mapView = DualMapView(frame: CGRect.zero)

    // MARK: - Lifecycle

    init()
    {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        build()
        makeConstraints()
    }

    private func build()
    {
        view.backgroundColor = UIColor.black
        
        view.addSubview(mapView)
    }

    private func makeConstraints()
    {
        mapView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // We don't know our initial size until here
        setLayout(fromSize: view.frame.size)
    }

    // MARK: - Configuration

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Rotation

    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)

        setLayout(fromSize: size)
    }
    
    private func setLayout(fromSize size: CGSize)
    {
        let toPortrait = size.height > size.width
        mapView.setOrientation(toPortrait ? .portrait : .landscapeLeft)
    }

}

