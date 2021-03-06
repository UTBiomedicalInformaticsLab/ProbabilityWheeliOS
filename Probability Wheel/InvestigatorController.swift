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
    
    @IBAction func percentageButtonPressed(sender: UIButton) {
        if sender.titleLabel!.text == "Show %" {
            sender.setTitle("Hide %", forState: .Normal)
        } else {
            sender.setTitle("Show %", forState: .Normal)
        }
        sharedInfo.togglePercentageView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sharedInfo.reset()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    func updateTable() {
        print("Reloading Data")
        sharedInfo.updateInfo()
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Delegate called. Options = \(sharedInfo.options.count)")
        return self.sharedInfo.options.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! OptionTableViewCell
        cell.delegate = self
        cell.option = sharedInfo.options[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
}

