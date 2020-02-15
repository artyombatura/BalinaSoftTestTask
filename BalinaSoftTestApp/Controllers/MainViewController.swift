//
//  MainViewController.swift
//  BalinaSoftTestApp
//
//  Created by Artyom on 2/14/20.
//  Copyright © 2020 Artyom. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var developersTableView: UITableView!
    
    //MARK: - Let's & Var's
    private var developers = [Developer]()
    private var pickedDeveloper: Developer!
    private var pageToLoad: Int = 0
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //TableView Configurating
        developersTableView.delegate = self
        developersTableView.dataSource = self
        
        //First Api Call
        fetchDataGET()
        
        //Image Picker Configuration
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
    }
    
}

//MARK: - Fetch Data
extension MainViewController {
    
    func fetchDataGET() {
        
        let apiRouter = ApiRouter.Get(page: pageToLoad)
        
        apiRouter.getRequest { [weak self] (developers) in
            
            if let developers = developers {
                self?.developers += developers
            }
            
            DispatchQueue.main.async {
                self?.developersTableView.reloadData()
            }
        }
    }
}

//MARK: - configureCell func implementing
extension MainViewController {
    
    func configureCell(cell: InfoTableViewCell, for indexPath: IndexPath) {
    
        let developer = developers[indexPath.row]
        
        guard let developerName = developer.name,
            let developerId = developer.id else { return }

        cell.nameLabel.text = "Name: \(developerName)"
        cell.idLable.text = "Id: \(developerId)"
    }
}

//MARK: - table view data source
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return developers.count != 0 ? developers.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = developersTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InfoTableViewCell
        
        configureCell(cell: cell, for: indexPath)
        
        return cell
    }
    
}


//MARK: - table view delegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    //Catching when last row is drawing and calling api to get additional info
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastRow = indexPath.row
        
        if lastRow == self.developers.count - 1 {
            
            self.pageToLoad += 1
            fetchDataGET()
        
        }
    
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pickedDeveloper = self.developers[indexPath.row]
        present(imagePicker, animated: true, completion: nil)
    }
    
}

//MARK: - UIImagePickerDelegate
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Getting image from camera
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let imageJPEGFormat: Data? = image.pngData()
        
        //Do .POST request to API. Upload photo
        if let name = self.pickedDeveloper.name,
            let id = self.pickedDeveloper.id,
            let imageData = imageJPEGFormat     {
            
            let apiRouter = ApiRouter.Post(id: id, name: name, image: imageData)
            
//            apiRouter.postRequest(imageData: imageData)
        }
        
        //Camera closing
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        //Camera closing
        picker.dismiss(animated: true, completion: nil)
    }
}
