//
//  ViewController.swift
//  MenuButton
//
//  Created by Bassem Qoulta on 1/14/19.
//  Copyright © 2019 Bassem Qoulta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var button: MenuButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 38.0 / 255, green: 151.0 / 255, blue: 68.0 / 255, alpha: 1)
        self.button = MenuButton(frame: CGRect(origin: self.view.center, size: CGSize(width: 53, height: 53)))
        self.button.addTarget(self, action: #selector(ViewController.toggle(_:)), for:.touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func toggle(_ sender: AnyObject!) {
        self.button.toggle()
    }
}

