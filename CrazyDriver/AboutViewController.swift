//
//  AboutViewController.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 17/01/17.
//  Copyright © 2017 TA. All rights reserved.
//

import UIKit

protocol AboutViewControllerDelegate {
    
    func dismissPopover()
}

class AboutViewController: UIViewController {
    
    var delegate : AboutViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        delegate?.dismissPopover()
    }

    @IBAction func rateButtonTapped(_ sender: Any) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
