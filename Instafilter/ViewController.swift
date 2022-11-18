//
//  ViewController.swift
//  Instafilter
//
//  Created by Melis Yazıcı on 12.11.22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var filterButton: UIButton!
    
    var currentImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
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
    }
    
    
    @IBAction func changeFilter(_ sender: UIButton) {
        
    }
    
    
    @IBAction func save(_ sender: Any) {
        
    }
    
    
    @IBAction func intensityChanged(_ sender: Any) {
        
    }
    

}

