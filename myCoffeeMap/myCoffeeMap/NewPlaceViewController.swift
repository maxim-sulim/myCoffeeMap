//
//  NewPlaceViewController.swift
//  myCoffeeMap
//
//  Created by Максим Сулим on 28.01.2023.
//

import UIKit

class NewPlaceViewController: UITableViewController {

    // свойство, в которое мы можем передать объект типа Place
    var currentPlace: Place?
   // var newPlace = Place()
    
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
        setupEditScreen()
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

   func savePlace() {
    
       var image: UIImage?
       
       let imageData = image?.pngData()
       
       let newPlace = Place(name: placeName.text!,
                            lacation: placeLacation.text,
                            type: placeType.text,
                            imageData: imageData)
       // если currentPlace != nil меняем текущие значения на новые
       if currentPlace != nil {
           
           try! realm.write {
               // присваивыем объекту currentPlace значения из полей newPlace
               currentPlace?.name = newPlace.name
               currentPlace?.lacation = newPlace.lacation
               currentPlace?.type = newPlace.type
               currentPlace?.imageData = newPlace.imageData
           }
       } else {
           StorageManager.saveObject(newPlace)
       }
       
    }
    
    private func setupEditScreen() {
        
        if currentPlace != nil {
            
            setupNavigationBar()
            // приводим значение типа Data к типу UIImage. Извлекаем с помощью оператора Guard значение типа Data и подставляем в объект типа UIImage.
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else { return }
            
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            placeName.text = currentPlace?.name
            placeLacation.text = currentPlace?.lacation
            placeType.text = currentPlace?.type
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        //убираем кнопку cancel
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
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
