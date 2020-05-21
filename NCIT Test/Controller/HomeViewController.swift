//
//  HomeViewController.swift
//  NCIT Test
//
//  Created by Eslam Ahmed on 5/21/20.
//  Copyright © 2020 Eslam Ahmed. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {



    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "FirstViewController")
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController , animated: true)
    }
    
}
