//
//  MenuViewController.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 09/09/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit
import StoreKit

class MenuViewController: UIViewController, SKStoreProductViewControllerDelegate {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resultsButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func buildUI(){
        
        // set background
        UIGraphicsBeginImageContext(self.view.frame.size);
        UIImage(named: "Speed")?.draw(in: self.view.bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        view.backgroundColor = UIColor(patternImage: image!)
    
        
        // set UIButton config
        let color = UIColor.black
        configButton(button: startButton, color: color)
        configButton(button: resultsButton,color: color)
        configButton(button: helpButton,color: color)
        configButton(button: rateButton,color: color)
    }
    
    
    func configButton(button : UIButton, color : UIColor){
        // set UIButton config
        button.backgroundColor = color
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = color.cgColor
        button.setTitleColor(UIColor.white, for: UIControlState.application)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - App Store rating
    
    @IBAction func rateButtonTapped(_ sender: Any) {
        openStoreProductWithiTunesItemIdentifier(identifier: "1207546303")
    }
    
    func openStoreProductWithiTunesItemIdentifier(identifier: String) {
        let iTunesLink = "itms://itunes.apple.com/us/app/apple-store/id"+identifier+"?mt=8";
        UIApplication.shared.open(URL(string: iTunesLink)!)
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
