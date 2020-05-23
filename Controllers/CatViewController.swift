//
//  CatViewController.swift
//  compProj
//
//  Created by Kirill Kalashnikov on 5/21/20.
//  Copyright © 2020 Kirill Kalashnikov. All rights reserved.
//

import Foundation
import UIKit
import CoreML

class CatViewController: UIViewController {
    
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var catDetail: UITextView!
    @IBOutlet weak var lifeSpan: UILabel!
    @IBOutlet weak var intellifence: UILabel!
    @IBOutlet weak var energyLevel: UILabel!
    @IBOutlet weak var catName: UILabel!
    
    
    var cat: Cat?
    var model: forest?
    var iris_data = [12,5,5]
    override func viewDidLoad() {
        super.viewDidLoad()
        //init and set all tbe fields
        let energyLevel = String(cat!.energyLevel)
        let intelligence = String(cat!.intelligence)
        catDetail.text = cat?.description
        lifeSpan.text = cat?.life_span
        intellifence.text = intelligence
        self.energyLevel.text = energyLevel
        catName.text = cat?.name
        catImage.load(url: URL(string: cat!.url)!)
    }
}
