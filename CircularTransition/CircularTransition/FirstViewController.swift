//
//  FirstViewController.swift
//  CircularTransition
//
//  Created by Arek on 30.04.2017.
//  Copyright © 2017 Arek. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    let transition = CircularTransition();
    
    @IBOutlet weak var menuButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondVC = segue.destination as! SecondViewController;
        secondVC.transitioningDelegate = self;
        secondVC.modalPresentationStyle = .custom;
    }
    

}
extension FirstViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present;
        transition.startingPoint = menuButton.center;
        transition.circleColor = menuButton.backgroundColor!;
        
        return transition;
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss;
        transition.startingPoint = menuButton.center;
        transition.circleColor = menuButton.backgroundColor!;
        
        return transition;
    }
}
