//
//  HomeViewController.swift
//  BodyDetection
//
//  Created by user on 2023/12/09.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var scaleButton: UIButton!
    @IBOutlet weak var numButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPopupButton()
        
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toView2" {
            if let view2 = segue.destination as? ViewController2 {
                view2.scaleData = self.scaleButton.title(for: .normal) ?? "Default Title"
                print(view2.scaleData)
                view2.numData = self.numButton.title(for: .normal) ?? "Default Title"
                print(view2.numData)
            }
        }
    }

    
   
    
    //Mark: Funciton
    func setPopupButton(){
        
        let optionClosure = {(action:UIAction) in
            print(action.title)
        }
        let optionClosure2 = {(action2:UIAction) in
            print(action2.title)}
        
        
        if #available(iOS 15.0, *) {
            numButton.menu = UIMenu(children : [
                UIAction(title:"1",state:.on,handler:optionClosure),
                UIAction(title:"2",handler:optionClosure),
                UIAction(title:"4",handler:optionClosure)])
            numButton.showsMenuAsPrimaryAction = true
            numButton.changesSelectionAsPrimaryAction = true
            
            scaleButton.menu = UIMenu(children : [
                UIAction(title:"0.5",state:.on,handler:optionClosure2),
                UIAction(title:"1",handler:optionClosure2),
                UIAction(title:"2",handler:optionClosure2),
                UIAction(title:"3",handler:optionClosure2)])
            scaleButton.showsMenuAsPrimaryAction = true
            scaleButton.changesSelectionAsPrimaryAction = true
            
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    
    
    
}
