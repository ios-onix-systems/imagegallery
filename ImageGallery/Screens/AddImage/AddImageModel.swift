//
//  AddImageViewModel.swift
//  TestTask
//
//  Created by Serhiy on 5/22/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation

protocol AddImageModelType {
    var imageData: Data? { get set }
    var longitude: Double? { get set }
    var latitude: Double? { get set }
    
    var closure: ((LocationErrorType) -> ())? { get }
    
    func subscribeOnLocationError(closure : @escaping (LocationErrorType) -> ())
    func uploadImage(imageForm: ImageForm, completion: @escaping ImageCompletionType)
}

class AddImageModel: AddImageModelType {
    var closure: ((LocationErrorType) -> ())?
    
    var imagesProvider: ImagesProviderType
    var locationService: LocationService
    
    var longitude: Double?
    var latitude: Double?
    var imageData: Data?
    
    init(imagesProvider: ImagesProviderType, locationService: LocationService) {
        self.imagesProvider = imagesProvider
        self.locationService = locationService
        
        self.locationService.subscribeOnLocationChanges(closure: { location in
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
        })
        
        self.locationService.delegate = self
        
        locationService.startRetrieveLocation()
    }
    
    func subscribeOnLocationError(closure: @escaping (LocationErrorType) -> ()) {
        self.closure = closure
    }
    
    func uploadImage(imageForm: ImageForm, completion: @escaping ImageCompletionType) {
        imagesProvider.uploadImage(imageForm: imageForm, completion: { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .result(let image):
                completion(.result(image))
            case .error(let error):
                completion(.error(error))
            }
        })
    }
    
    deinit {
        print("AddImageViewModel - deinit")
    }
}

extension AddImageModel: LocationServiceProtocol {
    func onError(e: LocationErrorType) {
        self.closure?(e)
    }
    
}

class AddImageModelFactory {
    static func `default`(provider: ImagesProviderType) -> AddImageModel {
        return AddImageModel(imagesProvider: provider,
                             locationService: LocationServiceFactory.default())
    }
}
