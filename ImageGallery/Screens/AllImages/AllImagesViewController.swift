//
//  AllImagesViewController.swift
//  TestTask
//
//  Created by Serhiy on 5/21/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import UIKit
import Alamofire

class AllImagesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: AllImagesModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupView()
        setupNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        HUDRenderer.showHUD()
        
        viewModel.getImages(completion: { [weak self] result in
            HUDRenderer.hideHUD()
            
            guard let `self` = self else { return }
            
            switch result {
            case .error(let error):
                AlertHelper.showAlert(error.localizedDescription)
            case .result(let images):
                self.collectionView.reloadData()
            }
        })
    }
    
    private func setupView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView?.register(UINib(nibName: String(describing: ImageCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ImageCollectionViewCell.self))
    }
    
    private func setupNavigationController() {
        
    }
    
    @IBAction func playTouchUpInside(_ sender: UIButton) {
        if let controller: ShowGifViewController = Storyboard.main.instantiateViewController() {
            
            let navController = UINavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .overCurrentContext
            navController.modalTransitionStyle = .crossDissolve
            navController.navigationBar.isHidden = true
            controller.modalPresentationStyle = .overCurrentContext
            
            controller.viewModel = ShowGifModelFactory.default(provider: viewModel.imagesProvider)
            self.navigationController?.present(navController, animated: true, completion: nil)
        }
    }
    
    @IBAction func plusTouchUpInside(_ sender: UIButton) {
        if let controller: AddImageViewController = Storyboard.main.instantiateViewController() {
            controller.viewModel = AddImageModelFactory.default(provider: viewModel.imagesProvider)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
   
    @IBAction func logoutTouchUpInside(_ sender: UIButton) {
        if let controller: LoginViewController = Storyboard.landing.instantiateViewController() {
            navigationController?.setViewControllers([controller], animated: true)
        }
    }
    
    deinit {
        print("AllImagesViewController - deinit")
    }
}

extension AllImagesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCollectionViewCell.self), for: indexPath) as? ImageCollectionViewCell {
            cell.configure(with: viewModel.imageModels[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}

extension AllImagesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        let cellWidth: CGFloat = (width - 60) / 2
        let cellHeight: CGFloat = height / 3
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}

extension AllImagesViewController: StoryboardIdentifiable {}
