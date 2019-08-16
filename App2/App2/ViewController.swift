//
//  ViewController.swift
//  App2
//
//  Created by cda2019 on 2019-07-26.
//  Copyright © 2019 SMU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var wonders: [Wonders] = []

//    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadJsonFile()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loadJsonFile() {
        guard let jsonFile = Bundle.main.path(forResource: "wonders", ofType: "json") else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: jsonFile))
        guard
            let data = optionalData,
            let json = try? JSONSerialization.jsonObject(with: data),
            let dictioary = json as? [String:Any],
            let wondersDictionary  = dictioary["features"] as? [[String: Any]]
            else { return }
        let validWonders = wondersDictionary.compactMap{ Wonders(wonder: $0) }
        wonders.append(contentsOf: validWonders)
    }


}

extension ViewController:UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wonders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? cellTableViewCell
        cell?.label.text = wonders[indexPath.row].name
//        cell?.img.image = UIImage(named: name[indexPath.row])÷
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        
        view?.details = [wonders[indexPath.row]]
        
        self.navigationController?.pushViewController(view!, animated: true)
    }
}
