//
//  MainViewController.swift
//  myCoffeeMap
//
//  Created by Максим Сулим on 21.01.2023.
//

import UIKit

class MainViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    var places = Place.getPlaces()
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let place = places[indexPath.row]
        
        cell.nameLable.text = place.name
        cell.lacationLable.text = place.lacation
        cell.typeLable.text = place.type
        
        if place.image == nil {
            cell.imageOfPlace.image = UIImage(named: place.restaurantImage!)
        } else {
            cell.imageOfPlace.image = place.image
        }
        
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace.clipsToBounds = true
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
*/
    //передача данные от одного вию контроллера к другому
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        //создаем экземпляр класса NewPlaceViewController и кастим полученный вию контроллер до класса НПВК
        guard let newPlaceVC = segue.source as? NewPlaceViewController else { return }
        //через экземпляр класса можем вызвать метод saveNewPlace
        newPlaceVC.saveNewPlace()
        //теперь экземпляр имеет конкретные значения и можно добавить его в модель
        places.append(newPlaceVC.newPlace!)
        //обновляем интервейс
        tableView.reloadData()
        
    }
}
