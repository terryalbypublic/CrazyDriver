//
//  MenuViewController.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 09/09/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UIPopoverPresentationControllerDelegate, AboutViewControllerDelegate {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resultsButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    private var aboutViewController : AboutViewController? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        
        // Do any additional setup after loading the view.
    }
    
    
    func buildUI(){
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
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
        configButton(button: settingsButton,color: color)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsPopoverSegue" {
            aboutViewController = segue.destination as? AboutViewController
            
            aboutViewController?.popoverPresentationController?.sourceView = view;
            aboutViewController?.popoverPresentationController?.sourceRect = CGRect(x: view.frame.width/2-125, y: view.frame.height/2-75, width: 250, height: 150)

            aboutViewController?.modalPresentationStyle = UIModalPresentationStyle.popover
            aboutViewController?.popoverPresentationController!.delegate = self
            aboutViewController?.delegate = self
            UIView.animate(withDuration: 0.3, animations: {
                self.view.alpha = 0.5
            })
        }
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 1
        })
    }
    
    // MARK: - AboutViewControllerDelegate
    func dismissPopover(){
        aboutViewController?.dismiss(animated: true, completion: {})
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 1
        })
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
