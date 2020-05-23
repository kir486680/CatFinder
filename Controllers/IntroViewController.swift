//
//  IntroViewController.swift
//  compProj
//
//  Created by Kirill Kalashnikov on 5/23/20.
//  Copyright © 2020 Kirill Kalashnikov. All rights reserved.
//

import Foundation
import UIKit

class IntroViewController: UIViewController {

    @IBOutlet weak var titleText: UILabel!
    override func viewDidLoad() {
        titleText.text = ""
        var charIndex = 0
        let textTitle = "🐈Cat Finder"
        for letter in textTitle{
            Timer.scheduledTimer(withTimeInterval: 0.1*Double(charIndex), repeats: false) { (timer) in
                self.titleText.text?.append(letter)
            }
            charIndex+=1
        }
        
    }
}
