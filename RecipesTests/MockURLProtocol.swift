//
//  MockURLProtocol.swift
//  RecipesTests
//
//  Created by Mbusi Hlatshwayo on 3/10/25.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var responseData: Data?
    static var responseError: Error?
    static var responseCode: Int = 200
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.responseError {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: MockURLProtocol.responseCode,
                httpVersion: nil,
                headerFields: nil
            )!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if let data = MockURLProtocol.responseData {
                client?.urlProtocol(self, didLoad: data)
            }
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
