//
//  ChooseViewController.swift
//  compProj
//
//  Created by Kirill Kalashnikov on 5/21/20.
//  Copyright © 2020 Kirill Kalashnikov. All rights reserved.
//

import Foundation
import UIKit
import CoreML

class ChooseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    private var model: forest?
    private var predictedCat:Cat! = nil
    @IBOutlet weak var pickerView1: UIPickerView!
    @IBOutlet weak var pickerView2: UIPickerView!
    @IBOutlet weak var pickerView3: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //setup pickers
        self.pickerView1.delegate = self
        self.pickerView1.dataSource = self
        self.pickerView2.delegate = self
        self.pickerView2.dataSource = self
        self.pickerView3.delegate = self
        self.pickerView3.dataSource = self
    }
    @IBAction func MakeInference(_ sender: Any) {
        let pciker1Val = Double(picker1Options[pickerView1.selectedRow(inComponent: 0)])
        let pciker2Val = Double(picker2Options[pickerView2.selectedRow(inComponent: 0)])
        let pciker3Val = Double(picker3Options[pickerView3.selectedRow(inComponent: 0)])
        let iris_data = [pciker1Val,pciker2Val,pciker3Val]
        //init the model
        model = forest()
        guard let input = try? MLMultiArray(shape:[1,3], dataType: MLMultiArrayDataType.double) else {
            fatalError("Unexpected runtime error. MLMultiArray")
        }
        for (index, element) in iris_data.enumerated() {
            input[index] = NSNumber(floatLiteral: Double(element!))
        }
        guard let prediction = try? model?.prediction(input: input) else {
        return
        }
        //debug message
        print("Predicted class: \(Int(prediction.prediction)) ")
        predictedCat = cats[Int(prediction.prediction)]
        performSegue(withIdentifier: "showPredDetails", sender: self)

    }
    //get data for the predicted cat
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CatViewController{
            destination.cat = predictedCat
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //picker view setup
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return picker1Options.count
        } else if pickerView.tag==2 {
            return picker2Options.count
        }else{
            return picker3Options.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return picker1Options[row]
        } else if pickerView.tag == 2{
            return picker2Options[row]
        }else{
            return picker3Options[row]
        }
    }
    

}
