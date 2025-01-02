import Foundation
import Alamofire
import RxSwift
import Kingfisher
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
            
            // Kingfisher를 사용하여 이미지 요청
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let value):
                    observer(.success(value.image)) // 이미지 로드 성공 시
                case .failure:
                    observer(.failure(NetworkError.dataFetchFail)) // 실패 시
                }
            }
            
            return Disposables.create()
        }
    }
}
