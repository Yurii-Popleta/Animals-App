//
//  ViewController.swift
//  animals
//
//  Created by Admin on 12/09/2022.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageOnScrean: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickerController = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imageOnScrean.image = userPickerController
            
            guard let ciImage = CIImage(image: userPickerController) else {
                fatalError("UImage not convert into ciImage")
            }
            
            detect(image: ciImage)
            
        }
        
        imagePicker.dismiss(animated: true)
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: MyImageClassifier_1(configuration: MLModelConfiguration()).model) else {
            fatalError("Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { request, erorr in
            
            guard let whatIs = request.results as? [VNClassificationObservation] else {
                fatalError("")
            }
            
            if let firstResult = whatIs.first {
                self.navigationItem.title = firstResult.identifier.capitalized
            }
        }
   
        let handler = VNImageRequestHandler(ciImage: image)
        do {
        try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    @IBAction func cameraButton(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

