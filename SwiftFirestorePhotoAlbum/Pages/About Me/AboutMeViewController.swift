//
//  AboutMeViewController.swift
//  SwiftFirestorePhotoAlbum
//
//  Created by Didzis Tupureins on 10/12/2019.
//  Copyright © 2019 Alex Akrimpai. All rights reserved.
//

import UIKit

class AboutMeViewController: UIViewController {

     
    @IBOutlet weak var aboutMeLabel: UILabel!
    
    
    var status = ""{
        didSet{aboutMeLabel.text = status}
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let asset = NSDataAsset(name: "aboutme") else {
            status = "Could not find the data"
            return
        }
        
        let options = [
            .documentType : NSAttributedString.DocumentType.rtf,
            .characterEncoding : String.Encoding.utf8
        ] as [NSAttributedString.DocumentReadingOptionKey : Any]
        
        do{
            let str = try NSAttributedString(data: asset.data, options: options, documentAttributes: nil)
            aboutMeLabel.attributedText = str
        } catch let err{
            status = "Error = \(err)"
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
