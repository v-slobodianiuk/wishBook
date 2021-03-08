//
//  WishListViewModel.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import Foundation
import Combine

protocol WishListViewModelProtocol: ObservableObject {

    var wishList: [WishListModel] { get }
    var wishListPublished: Published<[WishListModel]> { get }
    var wishListPublisher: Published<[WishListModel]>.Publisher { get }
    
    var router: WishListRouterProtocol { get }
    func getData()
    func deleteItem(id: String?)
}

final class WishListViewModel: WishListViewModelProtocol {
    let router: WishListRouterProtocol
    @Published private var repository: WishListRepositoryProtocol
    @Published var wishList = [WishListModel]()
    var wishListPublished: Published<[WishListModel]> { _wishList }
    var wishListPublisher: Published<[WishListModel]>.Publisher { $wishList }
    private var cancellables = Set<AnyCancellable>()
    
    init(router: WishListRouterProtocol, repository: WishListRepositoryProtocol) {
        self.router = router
        self.repository = repository
    }
    
    func getData() {
        repository.loadData()
        repository.wishListPublisher
            .assign(to: \.wishList, on: self)
            .store(in: &cancellables)
    }
    
    func deleteItem(id: String?) {
        repository.delete(id: id)
    }
}
