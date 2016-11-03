//
//  CustomTabViewController.swift
//  Probability Wheel
//
//  Created by Allen Wang on 11/5/15.
//  Copyright © 2015 UT Biomedical Informatics Lab. All rights reserved.
//

import UIKit

class CustomTabViewController: UITabBarController {

    let sharedInfo = SharedInfo.sharedInstance
    let participantIdentifier = "ParticipantView"
    let investigatorIdentifier = "IdentifierView"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
