//
//  NetworkManager.swift
//  PokeDexApp
//
//  Created by 내일배움캠프 on 12/27/24.
//

import Foundation
import Moya
import RxMoya
import RxSwift

enum NetworkError: Error {
    case invalidUrl
    case dataFetchFail
    case decodingFail
}

// API의 엔드포인트 정의
enum PokeDexAPI {
    case fetchData(endpoint: String)
}

extension PokeDexAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://pokeapi.co/api/v2")! // 기본 URL
    }
    
    var path: String {
        switch self {
        case .fetchData(let endpoint):
            return endpoint
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .fetchData:
            return .requestPlain // 파라미터가 없는 GET 요청
        }
        
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

// Moya를 사용하는 싱글톤 네트워크 매니저
class NetworkManager {
    static let shared = NetworkManager()
    private let provider = MoyaProvider<PokeDexAPI>() // MoyaProvider 생성
    private init() {}
    
    // 네트워크 요청 메서드
    func fetch<T: Decodable>(endpoint: String) -> Single<T> {
        return Single.create { [weak self] observer in
            self?.provider.request(.fetchData(endpoint: endpoint)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: response.data)
                        observer(.success(decodedData))
                    } catch {
                        observer(.failure(NetworkError.decodingFail))
                    }
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
}
