//
//  TabEditTableViewController.swift
//  My Browser
//
//  Created by Kiwon on 18/09/2019.
//  Copyright © 2019 Sidory. All rights reserved.
//

import UIKit

class TabEditTableViewController: UITableViewController {
    
    var tabItems = [Tab]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = CoreDataManager.loadAllCoreData(entity: Const.CoreData.Tab.entity.name) as? [Tab] {
            self.tabItems = items
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tabItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TabEditCell", for: indexPath)
        cell.textLabel?.text = self.tabItems[indexPath.row].name ?? ""
        cell.detailTextLabel?.text = self.tabItems[indexPath.row].url ?? ""
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
