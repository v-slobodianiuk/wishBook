//
//  FirebaseStorageService.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.08.2021.
//

import UIKit
import Firebase
import Combine

protocol FirebaseStorageServiceProtocol {
    func upload(imageData: Data, userId: String) -> AnyPublisher<URL?, Error>
}

final class FirebaseStorageService: FirebaseStorageServiceProtocol {
    
    private let storage = Storage.storage()
    private let photoRootFolder: String = Globals.photoRootFolder
    
    func upload(imageData: Data, userId: String) -> AnyPublisher<URL?, Error> {
        Deferred {
            Future { [weak self] promise in
                guard let self = self else { return }
                // Create a storage reference
                let storageRef = self.storage.reference().child("\(self.photoRootFolder)/\(userId)/\(userId).jpg")
                
                // Change the content type to jpg. If you don't, it'll be saved as application/octet-stream type
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                
                // Upload the image
                storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
                    if let error = error {
                        print("Error while uploading file: ", error)
                        promise(.failure(error))
                        return
                    }
                    
                    guard let metadata = metadata, let path = metadata.path else {
                        promise(.success(nil))
                        return
                    }
                    
                    let starsRef = self.storage.reference().child(path)
                    starsRef.downloadURL { url, error in
                        if let error = error {
                            // Handle any errors
                            promise(.failure(error))
                        }
                        promise(.success(url))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}
