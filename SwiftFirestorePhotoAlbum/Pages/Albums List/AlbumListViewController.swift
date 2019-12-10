//
//  AlbumListViewController.swift
//  SwiftFirestorePhotoAlbum
//
//  Created by Alex Akrimpai on 03/09/2018.
//  Copyright © 2018 Alex Akrimpai. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FirebaseFirestore

class AlbumListViewController: UIViewController {
    
    var chuckNorrisJoke = "There must be a Chuck Norris Joke"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var albums: [AlbumEntity]?
    var queryListener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Joke Button
       
       
    @IBAction func chuckNorrisJokeButton(_ sender: Any) {
           
           //MARK: - Get data from JSON
           
           AF.request("https://api.chucknorris.io/jokes/random", method: .get).responseJSON { (response) in
               if response.value != nil {
                   print("We got Chuck Norris Joke, Yes!")
                   let data = JSON(response.value!)
                   let joke = data["value"].stringValue
                   self.chuckNorrisJoke = joke
                   print(joke)
                   self.jokeAlert()
               }else{
                   print("ERROR \(String(describing: response.error))")
                   self.jokeAlert()
               }
           }
       }
    
    //MARK: - Alert
    func jokeAlert(){
        let alert = UIAlertController(title: "Chuck Norris", message: chuckNorrisJoke, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        //Add imageview to alert
        let imgViewTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        imgViewTitle.image = UIImage(named:"chuck-norris.png")
        alert.view.addSubview(imgViewTitle)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        queryListener = AlbumService.shared.getAll { albums in
            self.albums = albums
            
            if albums.isEmpty {
                self.tableView.addNoDataLabel(text: "No Albums added\n\nPlease press the + button above to start")
            } else {
                self.tableView.removeNoDataLabel()
            }
            
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        queryListener.remove()
    }
    
    private func setupUI() {
        tableView.tableFooterView = UIView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AlbumDetailsSegue", let index = sender as? Int, let albumDetailsController = segue.destination as? AlbumDetailsViewController, let album = albums?[index] {
            albumDetailsController.album = album
        }
    }
    
    @IBAction func addAlbumTappedHandler(_ sender: Any) {
        let alertController = UIAlertController(title: "Add new album", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Album name"
        }
        
        let textField = alertController.textFields![0] as UITextField
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            self.activityIndicator.startAnimating()
            AlbumService.shared.addAlbumWith(name: textField.text ?? "No Name")
            alertController.dismiss(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true)
    }
    
}

