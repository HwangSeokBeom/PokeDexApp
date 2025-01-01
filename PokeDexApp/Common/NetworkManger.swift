//
//  NetworkManager.swift
//  PokeDexApp
//
//  Created by 내일배움캠프 on 12/27/24.
//

import Foundation
import Alamofire
import RxSwift
import UIKit

enum NetworkError: Error {
    case invalidUrl
    case dataFetchFail
    case decodingFail
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func fetch<T: Decodable>(url: URL) -> Single<T> {
        return Single.create { observer in
            AF.request(url)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let decodedData):
                        observer(.success(decodedData))
                    case .failure(let error):
                        if let afError = error.asAFError, afError.isResponseValidationError {
                            observer(.failure(NetworkError.dataFetchFail))
                        } else {
                            observer(.failure(NetworkError.decodingFail))
                        }
                    }
                }
            return Disposables.create()
        }
    }
    
    func fetchPokemonImage(for id: Int) -> Single<UIImage> {
        return Single<UIImage>.create { observer in
            guard let url = APIEndpoint.pokemonImageURL(for: id) else {
                observer(.failure(NetworkError.invalidUrl))
                return Disposables.create()
            }
            
            AF.request(url).responseData { response in
                switch response.result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        observer(.success(image))
                    } else {
                        observer(.failure(NetworkError.decodingFail))
                    }
                case .failure:
                    observer(.failure(NetworkError.dataFetchFail))
                }
            }
            return Disposables.create()
        }
    }
}
