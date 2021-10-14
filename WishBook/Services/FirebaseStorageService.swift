//
//  FirebaseStorageService.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.08.2021.
//

import UIKit
import Firebase

protocol FirebaseStorageServiceProtocol {
    // Wrapped value
    var photoUrl: URL? { get }
    // (Published property wrapper)
    var photoUrlPublished: Published<URL?> { get }
    // Publisher
    var photoUrlPublisher: Published<URL?>.Publisher { get }
    
    func upload(imageData: Data?, userId: String, completion: @escaping ((Result<Bool, Error>) -> Void))
    func getImage(userId: String, completion: @escaping ((URL?) -> Void))
}

final class FirebaseStorageService: FirebaseStorageServiceProtocol, ObservableObject {
    
    private let storage = Storage.storage()
    private lazy var user = Auth.auth().currentUser
    private let photoRootFolder: String = "photos"
    
    @Published var photoUrl: URL? = nil
    var photoUrlPublished: Published<URL?> { _photoUrl }
    var photoUrlPublisher: Published<URL?>.Publisher { $photoUrl }
    
    func upload(imageData: Data?, userId: String, completion: @escaping ((Result<Bool, Error>) -> Void)) {
        // Create a storage reference
        let storageRef = storage.reference().child("\(photoRootFolder)/\(userId)/\(userId).jpg")
        
        // Change the content type to jpg. If you don't, it'll be saved as application/octet-stream type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // Upload the image
        if let data = imageData {
            storageRef.putData(data, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error while uploading file: ", error)
                    completion(.failure(error))
                }
                
                if let metadata = metadata {
                    print("Metadata: ", metadata)
                    completion(.success(true))
                }
            }
        }
    }
    
    func getImage(userId: String, completion: @escaping ((URL?) -> Void)) {
        // Create a reference to the file you want to download
        let starsRef = storage.reference().child("\(photoRootFolder)/\(userId)/\(userId).jpg")
        
        // Fetch the download URL
        starsRef.downloadURL { [weak self] url, error in
            if let error = error {
                // Handle any errors
                print(error.localizedDescription)
            }
            
            self?.photoUrl = url
            completion(url)
        }
        
    }
}
