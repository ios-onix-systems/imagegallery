//
//  ShowGifViewController.swift
//  ImageGallery
//
//  Created by Serhiy on 5/25/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftGifOrigin

class ShowGifViewController: UIViewController {

    @IBOutlet weak var gifContainer: UIImageView!
    var viewModel: ShowGifModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    private func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        HUDRenderer.showHUD()
        
        viewModel.loadGifUrl(completion: { [weak self] result in
            HUDRenderer.hideHUD()
            
            switch result {
            case .result(let model):
                self?.gifContainer.image = UIImage.gif(url: model.gif)
            case .error(let error):
                AlertHelper.showAlert(error.localizedDescription)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ShowGifViewController: StoryboardIdentifiable {}
