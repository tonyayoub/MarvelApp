//
//  TableViewController.swift
//  MarvelApp
//
//  Created by Tony Sameh on 10/14/18.
//  Copyright © 2018 Amahy. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, DataManagerDelegate {

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        DataManager.shared.delegate = self
        DataManager.shared.downloadData(ofsset: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didFinishDownloading(sender: DataManager)
    {
        print("need to update table")
        tableView.reloadData()
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let numberOfRowsSections = DataManager.shared.chars.count
        print("Number of Rows: \(numberOfRowsSections)")
        return DataManager.shared.chars.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CharCell", for: indexPath) as! TableViewCell
        let char = DataManager.shared.chars[indexPath.row]
        cell.charLabel.text = char.name
        let charImage = DataManager.shared.images[char.imagePath]
        cell.charImage.image = charImage
        return cell

    }
 
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == DataManager.shared.chars.count
        {
            DataManager.shared.downloadData(ofsset: 20)
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "detail")
        {
            let detailVC = segue.destination as! DetailViewController
            if let indexPath = self.tableView.indexPathForSelectedRow
            {
                detailVC.char = DataManager.shared.chars[indexPath.row]
            }
        }
    }
    

}
