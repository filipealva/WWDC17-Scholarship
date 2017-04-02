//
//  StartViewController.swift
//  Filipe Alvarenga
//
//  Created by Filipe Alvarenga on 26/03/17.
//  Copyright (c) 2015 Filipe Alvarenga. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    // MARK: - Properties
    
    let frameToDisplay = CGRect(x: 0, y: 0, width: 500, height: 500)
    lazy var startView: UIView = {
        let startView =  Bundle.main.loadNibNamed("StartView", owner: self, options: nil)![0] as! UIView
        startView.frame = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: self.frameToDisplay.size)
        startView.startButton.addTarget(self, action: #selector(StartViewController.start), for: .touchUpInside)
        
        return startView
    }()
    var setNeedsDisplayIntro: (() -> Void)?

    override public func loadView() {
        let rootView = UIView(frame: self.frameToDisplay)
        rootView.backgroundColor = UIColor.white
        rootView.addSubview(startView)
        view = rootView
    }
    
    // MARK: - Actions
    
    func start() {
        if let setNeedsDisplayIntro = setNeedsDisplayIntro {
            setNeedsDisplayIntro()
        }
        
        modalTransitionStyle = .crossDissolve
        self.dismiss(animated: true, completion: nil)
    }

}
