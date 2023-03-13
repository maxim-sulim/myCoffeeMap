//
//  MainViewController.swift
//  myCoffeeMap
//
//  Created by Максим Сулим on 21.01.2023.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {

    //resalts - автообновляемый тип контейнера, который возвращает запрашиваемые объекты (позволяет работать с обЪектами в реальном времени)
    var places: Results<Place>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //подразумеваем именно тип данных place 
        places = realm.objects(Place.self)
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.isEmpty ? 0 : places.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let place = places[indexPath.row]
        
        cell.nameLable.text = place.name
        cell.lacationLable.text = place.lacation
        cell.typeLable.text = place.type
        
        if place.imageData == nil {
            cell.imageOfPlace.image = UIImage(named: "She")
        } else {
            cell.imageOfPlace.image = UIImage(data: place.imageData!)
        }
        //cell.imageOfPlace.image = UIImage(data: place.imageData!)
       
        
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace.clipsToBounds = true
        return cell
    }
    
    //MARK: Table View delegate
    
    
    func delete(rowIndexPath indexPath: IndexPath) -> UIContextualAction {
        
        let place = places[indexPath.row]
        
        let action = UIContextualAction(style: .normal, title: "Delete") {_,_,_ in
            StorageManager.deleteObject(place)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
        }
        return action
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
       let delete = delete(rowIndexPath: indexPath)
       let swipe = UISwipeActionsConfiguration(actions: [delete])
       return swipe
    }
    
   /*
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let place = places[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {
            (_, _ ) in
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        return [deleteAction]
    }
*/
    
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //передаем значение ячейки по сигвэю на вию контроллер
        if segue.identifier == "showDetail" {
            //определяем индекс выбранной ячейки (метод indexPathForSelectedRow возвращает опциональное значение, извлекаем через guard это значение)
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            //зная индекс строки мы можем извлечь объект типа Place по этому же индексу
            let place = places[indexPath.row]
            // создаем экземпляр вию контроллера на который будем передовать объект
            let newPlaceVC = segue.destination as! NewPlaceViewController
            // обращаемся к свойтву нашего экземпляра. Передали выбранный объект типом плейс на ньюПлейсВиюКонтроллер
            newPlaceVC.currentPlace = place
            
        }
    }
    
    
    
    //передача данные от одного вию контроллера к другому
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        //создаем экземпляр класса NewPlaceViewController и кастим полученный вию контроллер до класса НПВК
        guard let newPlaceVC = segue.source as? NewPlaceViewController else { return }
        //через экземпляр класса можем вызвать метод saveNewPlace
        newPlaceVC.savePlace()
        //теперь экземпляр имеет конкретные значения и можно добавить его в модель
     //   places.append(newPlaceVC.newPlace!)
        //обновляем интервейс
        tableView.reloadData()
        
    }
}
