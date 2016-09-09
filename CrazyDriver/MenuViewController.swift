//
//  MenuViewController.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 09/09/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resultsButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        
        
        

        // Do any additional setup after loading the view.
    }
    
    
    func buildUI(){
        
        // set background
        UIGraphicsBeginImageContext(self.view.frame.size);
        UIImage(named: "Speed")?.draw(in: self.view.bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        view.backgroundColor = UIColor(patternImage: image!)
    
        
        // set UIButton config
        let color = UIColor.black()
        configButton(button: startButton, color: color)
        configButton(button: resultsButton,color: color)
        configButton(button: helpButton,color: color)
        configButton(button: settingsButton,color: color)
    }
    
    
    func configButton(button : UIButton, color : UIColor){
        // set UIButton config
        button.backgroundColor = color
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = color.cgColor
        button.setTitleColor(UIColor.white(), for: UIControlState.application)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
