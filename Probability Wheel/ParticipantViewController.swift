//
//  ParticipantViewController.swift
//  Probability Wheel
//
//  Created by Allen Wang on 10/28/15.
//  Copyright © 2015 UT Biomedical Informatics Lab. All rights reserved.
//

import UIKit

class ParticipantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WheelViewUpdater {

    let sharedInfo = SharedInfo.sharedInstance
    let cellIdentifier = "participantOption"
    @IBOutlet weak var wheelView: WheelView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resetButton: UIButton!
    
    //-------------- Initializations/System functions -------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //resetButton.titleLabel?.numberOfLines = 1
        resetButton.titleLabel?.adjustsFontSizeToFitWidth = true
        //resetButton.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // Handles switching between Investigator/Participant
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if sharedInfo.resetWheel {
            wheelView.updateWheel()
            sharedInfo.resetWheel = false
        } else {
            wheelView.drawWheel()
        }
        wheelView.delegate = self
        tableView.reloadData()
    }
    
    // The following two functions prevent landscape mode
    override func shouldAutorotate() -> Bool {
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.Unknown) {
                return false;
        }
        else {
            return true;
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    @IBAction func ResetButtonPressed(sender: UIButton) {
        sharedInfo.resetActive()
        tableView.reloadData()
        wheelView.updateWheel()
    }

    func updateTable() {
        tableView.reloadData()
    }
    

    //-------------- Table related functions -------------------
    
    // Tells the tableView how many entries it should have
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sharedInfo.activeOptionsCount()
    }
    
    // Converts an option model to a TableView cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ParticipantOptionCell
        cell.option = sharedInfo.getActiveOptions()[indexPath.row]
        return cell
    }
    
}

