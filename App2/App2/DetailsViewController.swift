//
//  DetailsViewController.swift
//  App2
//
//  Created by cda2019 on 2019-07-26.
//  Copyright © 2019 SMU. All rights reserved.
//

import UIKit
import CoreLocation

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var w_name: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var w_desc: UILabel!
    @IBOutlet weak var w_rating: UILabel!
    @IBOutlet weak var w_coordinates: UILabel!
    @IBOutlet weak var w_imgeURL: UIImageView!
    
    var details: [Wonders] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        w_name.text = details[0].name
        w_desc.text = details[0].wonderDescription ?? "Description (Empty)"
        w_rating.text = String(details[0].userRating)
        w_coordinates.text = "Lat: " + String(details[0].coordinates[0]) + " Long: " + String(details[0].coordinates[1])
        
        
        downloaded(from: URL(string: details[0].imageURL)!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(DetailsViewController.tappedMe))
        w_imgeURL.addGestureRecognizer(tap)
        w_imgeURL.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    
    @objc func tappedMe()
    {
        showAlert()
    }
    
    func showAlert() {
        let copyURL = UIAlertAction(title: "Copy Img URL", style: .default) { (action:UIAlertAction!) in
            // Code in this block will trigger when OK button tapped.
            UIPasteboard.general.string = self.details[0].imageURL
        }
        let alert = UIAlertController(title: "Info", message: "The Image URL is available for download.", preferredStyle: .alert)
        alert.addAction(copyURL)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func ShowMap(_ sender: Any) {
    }
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.w_imgeURL.image  = image
            }
            }.resume()
    }
    
    func loadingView(shouldSpin status: Bool){
        if status == true {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            
            activityIndicator.isHidden = true
            activityIndicator.startAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapSegue" {
            let mapViewController = segue.destination as? MapViewController
            mapViewController?.wonderLocation = CLLocation(latitude: (details[0].coordinates[1]), longitude: (details[0].coordinates[0]))
            mapViewController?.wonderName = details[0].name
            mapViewController?.wonderLocation2 = CLLocation(latitude: ((details[0].coordinates[1]) - 0.01) , longitude: (details[0].coordinates[0]))
        }
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


