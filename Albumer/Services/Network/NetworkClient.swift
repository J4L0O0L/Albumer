//
//  NetworkClient.swift
//  Albumer
//
//  Created by Marjan Khodadad on 9/24/22.
//

import Foundation
import Combine

final class SharedMediaClient: BaseAPI {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func getFeed(_ feedKind: SharedMediaFeed) -> AnyPublisher<SharedMediaFeedResult, Error> {
        execute(feedKind.request, decodingType: SharedMediaFeedResult.self, retries: 2)
    }
}


