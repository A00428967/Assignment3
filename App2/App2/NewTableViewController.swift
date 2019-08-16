//
//  NewTableViewController.swift
//  App2
//
//  Created by cda2019 on 2019-08-10.
//  Copyright © 2019 SMU. All rights reserved.
//
import UIKit

class NewWondersTableViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var wonders: [Wonder] = []
    var dataToSave = Data()
    
    // MARK: - Get document directory
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Wonder")
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveWondersSegue" {
            let savedWondersViewController = segue.destination as? SavedWondersViewController
            savedWondersViewController?.savedWonders = loadListFromLocalStorage()
        }
    }
    
    func loadInitialData() {
        guard let fileName = Bundle.main.path(forResource: "wonders", ofType: "json")
            else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        guard
            let data = optionalData,
            let json = try? JSONSerialization.jsonObject(with: data),
            let dictionary = json as? [String: Any],
            let wondersData = dictionary["features"] as? [[String: Any]]
            else { return }
        let validWonders = wondersData.compactMap { Wonder(wonder: $0) }
        wonders.append(contentsOf: validWonders)
        
        if wonders.count > 1 {
            saveToLocalStorage(wonders: wonders)
        }
    }
    
    func saveToLocalStorage(wonders: [Wonder]) {
        do {
            dataToSave = try NSKeyedArchiver.archivedData(withRootObject: wonders, requiringSecureCoding: false)
            try dataToSave.write(to: NewWondersTableViewController.ArchiveURL)
        } catch {
            print("Couldn't write file")
        }
    }
    
    func loadListFromLocalStorage() -> [Wonder] {
        var savedArray: [Wonder] = []
        do {
            if let loadedStrings = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dataToSave) as? [Wonder] {
                savedArray = loadedStrings
            }
        } catch {
            print("Couldn't read file.")
        }
        return savedArray
    }
}

extension NewWondersTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wonders.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewWondersTableViewCell", for: indexPath) as? NewWondersTableViewCell else { return UITableViewCell() }
        if indexPath.item % 2 == 0 {
            cell.backgroundColor = UIColor(red: 0.62, green: 0.62, blue: 0.57, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor(red: 0.79, green: 0.84, blue: 0.71, alpha: 1.0)
        }
        cell.wondersLabel.font = UIFont(name: "Noteworthy", size: 20)
        cell.wondersLabel.textColor = UIColor(red: 0.31, green: 0.24, blue: 0.26, alpha: 1.0)
        cell.wondersLabel.text = wonders[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailViewController = UIStoryboard(name: "Wonders", bundle: nil).instantiateViewController(withIdentifier: "NewWondersDetailViewController") as? NewWondersDetailViewController else { return }
        detailViewController.wonder = wonders[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}


}
