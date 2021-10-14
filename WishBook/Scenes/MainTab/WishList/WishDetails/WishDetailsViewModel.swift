//
//  WishDetailsViewModel.swift
//  WishBook
//
//  Created by Vadym on 08.03.2021.
//

import Foundation
import Combine

protocol WishDetailsViewModelProtocol: ObservableObject {
    // Wrapped value
    var wishItem: WishListModel { get set }
    // (Published property wrapper)
    var wishItemPublished: Published<WishListModel> { get }
    // Publisher
    var wishItemPublisher: Published<WishListModel>.Publisher { get }
    var readOnly: Bool { get }
    
    func loadWishItem()
    func saveData()
}

final class WishDetailsViewModel: WishDetailsViewModelProtocol {
    @Published private var repository: WishListRepositoryProtocol
    @Published var wishItem: WishListModel
    var wishItemPublished: Published<WishListModel> { _wishItem }
    var wishItemPublisher: Published<WishListModel>.Publisher { $wishItem }
    private var cancellables = Set<AnyCancellable>()
    let readOnly: Bool
    
    init(repository: WishListRepositoryProtocol, wishItem: WishListModel? = nil, readOnly: Bool) {
        self.repository = repository
        self.wishItem = wishItem ?? WishListModel(title: "")
        self.readOnly = readOnly
    }
    
    func loadWishItem() {
        wishItemPublisher
            .compactMap { $0.title }
            .sink { title in
                print(title)
            }
            .store(in: &cancellables)
            
    }
    
    func saveData() {
        guard !wishItem.title.isEmpty else { return }
        if wishItem.id != nil {
            repository.updateData(wishItem)
        } else {
            repository.addData(wishItem)
        }
    }
}
