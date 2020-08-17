//
//  MyTabBarController.swift
//  MyLocation
//
//  Created by Jonathan Baird  on 17/08/2020.
//  Copyright © 2020 Jonathan Baird . All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return nil
    }
}
