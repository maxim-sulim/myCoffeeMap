//
//  NewPlaceViewController.swift
//  myCoffeeMap
//
//  Created by Максим Сулим on 28.01.2023.
//

import UIKit

class NewPlaceViewController: UITableViewController {

    var newPlace: Place?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLacation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
//MARK: Table view Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) {_ in
                
                self.chooseImagePicker(source: UIImagePickerController.SourceType.camera)
            }
            let photo = UIAlertAction(title: "Photo", style: .default) {_ in
                
                self.chooseImagePicker(source: UIImagePickerController.SourceType.photoLibrary)
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }

    func saveNewPlace() {
        
        newPlace = Place(name: placeName.text!, lacation: placeLacation.text,
                         type: placeType.text,
                         image: placeImage.image,
                         restaurantImage: nil)
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: text filed delegate
extension NewPlaceViewController: UITextFieldDelegate {
    //сокрытие клавиатуры
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged () {
        
        if placeName.text?.isEmpty == false {
            
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        
    }
    
}

// MARK: work with image
extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker , animated: true)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleToFill
        placeImage.clipsToBounds = true
        dismiss(animated: true)
    }
    
}
