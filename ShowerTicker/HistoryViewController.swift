//
//  HistoryViewController.swift
//  Shower Ticker
//  Brian Steuber and Tyler Gonzalez
//  Final Project
//
//  Created by Nancy Gonzalez on 11/27/20.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var showerArray = [Shower]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsDirectoryURL)
        print(showerArray)
        loadShowers()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return showerArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let shower = showerArray[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowerCell", for: indexPath) as! ShowerTableViewCell
        cell.update(with: shower)
        return cell
    }
    
    func loadShowers() {
        let request: NSFetchRequest<Shower> = Shower.fetchRequest()
        do {
            showerArray = try context.fetch(request)
        }
        catch {
            print("Error loading showers \(error)")
        }
        if tableView != nil
        {
            tableView.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
