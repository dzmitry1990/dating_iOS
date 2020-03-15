//
//  IntialViewController.swift
//  DatingApp
//
//  Created by Dzmitry Zhuk on 06/12/17.
//  Copyright © 2017 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class IntialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let value = UserDefaults.standard.value(forKey: "UserExist") as? String{
            if(value == "1"){
                
                let secondViewController = (self.storyboard?.instantiateViewController(withIdentifier: "HomeVC"))! as UIViewController
                self.view.window?.rootViewController = secondViewController
                
            }
            else{
                let secondViewController = (self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController"))! as UIViewController
                self.view.window?.rootViewController = secondViewController
            }
            
        }
//        else{
//
//            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let initialScreen = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            let nvc: UINavigationController = UINavigationController(rootViewController: initialScreen)
//            self.window?.rootViewController = nvc
//            self.window?.rootViewController?.navigationController?.isNavigationBarHidden = false
//            self.window?.makeKeyAndVisible()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
