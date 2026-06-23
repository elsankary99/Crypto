//
//  NetworkingManager.swift
//  Crypto
//
//  Created by Ahmed Elsankary on 23/06/2026.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError:LocalizedError {
        case badURLResponse(_ url:URL)
        case unknown
        
        var errorDescription:String? {
            switch self {
            case .badURLResponse(let error):
                return "[🔥] Bad Response From URL : \(error)"
            case .unknown:
                return "[⚠️] UNKnown error occured."
            }
        }
    }
    
    static func download(url:URL) -> AnyPublisher<Data, any Error> {
      return URLSession.shared.dataTaskPublisher(for: url)
           .subscribe(on: DispatchQueue.global(qos: .default))
           .receive(on: DispatchQueue.main)
           .tryMap({try handleURLResponse(output: $0,url: url)})
           .eraseToAnyPublisher()
    }
    
    
    static  func handleURLResponse(output:URLSession.DataTaskPublisher.Output,url:URL) throws -> Data {
        guard  let response = output.response as? HTTPURLResponse,
               response.statusCode >= 200 && response.statusCode < 300 else
          {
            throw NetworkingError.badURLResponse(url)
        }
          return output.data
    }
    
    static func handleCompeletion(compeletion: Subscribers.Completion<any Error>) {
        switch compeletion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
