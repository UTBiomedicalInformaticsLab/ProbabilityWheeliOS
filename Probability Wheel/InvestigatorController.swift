//
//  InvestigatorController
//  Probability Wheel
//
//  Created by Allen Wang on 10/28/15.
//  Copyright © 2015 UT Biomedical Informatics Lab. All rights reserved.
//

import UIKit

class InvestigatorController: UIViewController, UITableViewDelegate, UITableViewDataSource, OptionCellUpdater {
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "optionCell"
    let sharedInfo = SharedInfo.sharedInstance
    
    @IBOutlet weak var percentageButton: UIButton!
    
    //-------------- Initializations/System functions -------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        sharedInfo.reset()
        //percentageButton.titleLabel?.numberOfLines = 1
        percentageButton.titleLabel?.adjustsFontSizeToFitWidth = true
        //percentageButton.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // Handles when switching between Investigator/Participant
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
    
    @IBAction func percentageButtonPressed(sender: UIButton) {
        if sender.titleLabel!.text == "Show %" {
            sender.setTitle("Hide %", forState: .Normal)
        } else {
            sender.setTitle("Show %", forState: .Normal)
        }
        sharedInfo.togglePercentageView()
    }

    //-------------- Table related functions -------------------
    // Delegate function for OptionTableViewCell
    func updateTable() {
        sharedInfo.updateInfo()
        tableView.reloadData()
    }
    
    // Tells the tableview how many entries it should have
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sharedInfo.options.count
    }
    
    // Converts an option model to a TableView Cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! OptionTableViewCell
        cell.delegate = self
        cell.option = sharedInfo.options[indexPath.row]
        return cell
    }
    
}

