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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func ResetButtonPressed(sender: UIButton) {
        sharedInfo.resetActive()
        tableView.reloadData()
        wheelView.updateWheel()
    }

    func updateTable() {
        tableView.reloadData()
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

