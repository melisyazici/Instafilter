//
//  ViewController.swift
//  Instafilter
//
//  Created by Melis Yazıcı on 12.11.22.
//

import CoreImage
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var filterButton: UIButton!
    
    var currentImage: UIImage!
    
    var context: CIContext! // CIContext is the Core Image component that handles rendering
    var currentFilter: CIFilter! // CIFilter is a Core Image filter and will store whatever filter the user has activated
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext() // creates a default Core Image context
        currentFilter = CIFilter(name: "CISepiaTone") // creates an example filter that will apply a sepia tone effect to images
        
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image // set currentImage image to be the one selected in the image picker so that it can have a copy of what was originally imported.
        
        let beginImage = CIImage(image: currentImage) // create a CIImage from a UIImage
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey) // send the result into the current Core Image Filter using the kCIInputImageKey
        applyProcessing() // called as soon as the image is imported
    }
    
    
    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose Filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        present(ac, animated: true)
    }
    
    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        guard let actionTitle = action.title else { return }
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        filterButton.setTitle("\(actionTitle)", for: .normal)
        
        applyProcessing()
    }
    
    
    @IBAction func save(_ sender: Any) {
        
    }
    
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing() // called whenever the slider is moved
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) // uses the value of intensity slider to set the kCIInputIntensityKey value of current Core Image filter
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return } // safely reads the output image from our current filter
        // create cgImage from core image filter, specify which part we want to render but using image.extent means read the whole image
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) { // creates a new data type called CGImage from the output image of the current filter - specify which part of the image, using image.extent means "all of it" - Until this method is called, no actual processing is done - returns an optional CGImage
            let processedImage = UIImage(cgImage: cgImage) // creates a new UIImage from the CGImage
            imageView.image = processedImage // assigns that UIImage to the image view
        }
    }
    

}

