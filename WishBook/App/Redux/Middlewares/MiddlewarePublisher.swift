//
//  MiddlewarePublisher.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 23.12.2021.
//

import Foundation
import Combine

typealias PromiseClosure<Action> = (Result<Action, MiddlewareError>) -> Void
typealias MiddlewareClosure<Action> = (_ promise: @escaping PromiseClosure<Action>) -> Void

enum MiddlewareError: Error {
    case noAction
}

func middlewarePublisher<Action>(completion: @escaping MiddlewareClosure<Action>) -> AnyPublisher<Action, Never> {
    Deferred {
        Future<Action, MiddlewareError> { promise in
            //print("middlewarePublisher Future: \(Thread.current)")
            completion(promise)
        }
    }
    .subscribe(on: DispatchQueue.global())
    .catch { error -> Empty in
        switch error {
        case .noAction:
            return Empty()
        }
    }
    //.print("middlewarePublisher")
    .eraseToAnyPublisher()
}
