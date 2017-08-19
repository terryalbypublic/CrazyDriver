//
//  LevelViewController.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 31/01/17.
//  Copyright © 2017 TA. All rights reserved.
//

import UIKit

class LevelViewController: UITableViewController {
    
    let levelsList = LevelsListModel.sharedReference
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        levelsList.loadUnlockedLevels()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return levelsList.nrOfLevels
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : LevelTableViewCell
        
        if(levelsList.unlockedLevels[indexPath.row]){
            cell = tableView.dequeueReusableCell(withIdentifier: "LevelTableViewCellUnlocked", for: indexPath) as! LevelTableViewCell
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "LevelTableViewCellLocked", for: indexPath) as! LevelTableViewCell
        }
        
        cell.levelFilename = levelsList.levelsFilenames[indexPath.row]
        cell.levelNameLabel.text = levelsList.levelsNames[indexPath.row]
        
        if(!levelsList.unlockedLevels[indexPath.row]){
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if(!levelsList.unlockedLevels[indexPath.row]){
            return nil
        }
        return indexPath
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameViewController = segue.destination as? GameMainViewController {
            gameViewController.levelFileName = (sender as! LevelTableViewCell).levelFilename
        }
    }
 

}
