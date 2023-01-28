//
//  NewPlaceViewController.swift
//  myCoffeeMap
//
//  Created by Максим Сулим on 28.01.2023.
//

import UIKit

class NewPlaceViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }
//MARK: Table view Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else {
            view.endEditing(true)
        }
    }

}

// MARK: text filed delegate
extension NewPlaceViewController: UITextFieldDelegate {
    //сокрытие клавиатуры
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
