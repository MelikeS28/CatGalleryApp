//
//  ViewController.swift
//  CatGalleryApp
//
//  Created by Melike on 29.12.2025.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var catImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func getCatTapped(_ sender: Any) {
          fetchCat()
    }
    
    func fetchCat() {
        NetworkManager.shared.fetchCatImages { [weak self] result in
            switch result {

            case .success(let image):
                self?.catImageView.image = image

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

