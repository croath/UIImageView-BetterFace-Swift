//
//  ViewController.swift
//  bfswift
//
//  Created by croath on 6/4/14.
//  Copyright (c) 2014 croath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var view0 : UIImageView
    @IBOutlet var view1 : BFImageView
                            
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view0.layer.borderColor = UIColor.grayColor().CGColor
        self.view0.layer.borderWidth = 0.5
        self.view0.contentMode = UIViewContentMode.ScaleAspectFill
        self.view0.clipsToBounds = true
        
        self.view1.layer.borderColor = UIColor.grayColor().CGColor
        self.view1.layer.borderWidth = 0.5
        self.view1.contentMode = UIViewContentMode.ScaleAspectFill
        self.view1.clipsToBounds = true
        self.view1.needsBetterFace = true
        self.view1.fast = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tabPressed(sender : AnyObject) {
        var imageStr:String = ""
        switch sender.tag {
        case Int(0):
            imageStr = "up1.jpg"
        case Int(1):
            imageStr = "up2.jpg"
        case Int(2):
            imageStr = "up3.jpg"
        case Int(3):
            imageStr = "up4.jpg"
        case Int(4):
            imageStr = "l1.jpg"
        case Int(5):
            imageStr = "l2.jpg"
        case Int(6):
            imageStr = "l3.jpg"
        case Int(7):
            imageStr = "l4.jpg"
        case Int(8):
            imageStr = "m1.jpg"
        case Int(9):
            imageStr = "m2.jpg"
        default:
            imageStr = ""
        }
        
        self.view0.image = UIImage(named: imageStr)
        self.view1.image = UIImage(named: imageStr)

    }

}
