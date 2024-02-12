//
//  NetworkLogger.swift
//  YBNetwork
//
//  Created by 태태's MacBook on 1/16/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Moya

public final class NetworkLogger: PluginType {
    public init() {}
    public func willSend(_ request: RequestType, target: TargetType) {
        #if DEBUG
        print("\n---------- [REQUEST] ----------\n")
        print("API Endpoint : \(target.baseURL.absoluteString + target.path)")
        print("Headers : \(target.headers ?? [:])")
        print("Task : \(target.task)")
        print("--------------------------------\n")
        #endif
    }

    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        #if DEBUG
        switch result {
        case let .success(response):
            guard let httpURLResponse = response.response else {
                break
            }
            print("\n---------- [RESPONSE] ----------\n")
            print("API Endpoint : \(target.baseURL.absoluteString + target.path)")
            print("Headers : \(httpURLResponse.allHeaderFields)")
            print("Response JSON : \(String(describing: try? response.mapJSON()))")
            print("---------------------------------\n")
        case let .failure(error):
            print("\n---------- [ERROR RESPONSE] ----------\n")
            print("API Endpoint : \(target.baseURL.absoluteString + target.path)")
            print("Headers : \(target.headers ?? [:])")
            print("Task : \(target.task)")
            print("Error : \(error)")
            if let responseData = error.response?.data {
                let responseString = String(data: responseData, encoding: .utf8) ?? "Unable to decode response"
                print("Raw Response : \(responseString)")
            }
            print("--------------------------------\n")

        }
        #endif
    }

}
