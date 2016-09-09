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
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.gray().cgColor, UIColor.white().cgColor]
        view.layer.insertSublayer(gradient, at: 0)
        //use startPoint and endPoint to change direction of gradient (http://stackoverflow.com/a/20387923/2057171)
        
        
        // set UIButton config
        configButton(button: startButton)
        configButton(button: resultsButton)
        configButton(button: helpButton)
        configButton(button: settingsButton)
    }
    
    
    func configButton(button : UIButton){
        // set UIButton config
        button.backgroundColor = UIColor.blue()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.blue().cgColor
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
