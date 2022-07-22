//
//  AFNetwork.swift
//  SwiftComponentTestDemo
//
//  Created by Marshal on 2022/7/20.
//  封装

//平时使用，其实默认的就已经够了，但是我们会有默认的header要添加，每次都要手动和很麻烦，因此需要二次封装
//这里只是一个简易的二次封装，这里只是演示一部分，如果 response不喜欢系统的，也可以统一处理，以及一部分内容
//个人感觉这就够了，如果需要统一处理 response 一些状态码之类的，可以引入一个加工类走回调即可

import Foundation
import Alamofire

class AFNetwork {
    
    static func get(_ convertible: URLConvertible,
                    parameters: Parameters? = nil,
                    encoding: ParameterEncoding = URLEncoding.default,
                    headers: HTTPHeaders? = nil,
                    interceptor: RequestInterceptor? = nil) -> DataRequest {
        let url = "\(HOST)\(convertible)"
        var headers = HTTPHeaders();
        headers.add(name: "content-type", value: "x-www-form-urlencoded")
        headers.add(name: "type", value: "ios")
        headers.add(name: "timestamp", value: "\(NSDate().timeIntervalSince1970)")
        return AF.request(url, method: .get, parameters: parameters, encoding: encoding, headers: headers, interceptor: interceptor, requestModifier: nil)
    }
    
    //post上传比较特殊，默认传递body，有时也会query和body一起上传
    static func post(_ convertible: URLConvertible,
                     body: Parameters? = nil,
                     parameters: Parameters? = nil,
                     headers: HTTPHeaders? = nil,
                     interceptor: RequestInterceptor? = nil) -> DataRequest {
        var url = "\(HOST)\(convertible)"
        if let parameters = parameters {
            url = "\(url)?"
            var index = 0
            for (key, value) in parameters {
                if index == 0 {
                    url = "\(url)?\(key)=\(value)"
                }else {
                    url = "\(url)&\(key)=\(value)"
                }
                index += 1
            }
        }
        var headers = HTTPHeaders();
        headers.add(name: "content-type", value: "x-www-form-urlencoded")
        headers.add(name: "type", value: "ios")
        headers.add(name: "timestamp", value: "\(NSDate().timeIntervalSince1970)")
        return AF.request(url , method: .post, parameters: body, encoding: URLEncoding.default, headers: headers, interceptor: interceptor, requestModifier: nil)
    }
    
    //默认以model形式传递
    static func post<Parameters: Encodable>(_ convertible: URLConvertible,
                     body: Parameters? = nil,
                     headers: HTTPHeaders? = nil,
                     interceptor: RequestInterceptor? = nil) -> DataRequest {
        let url = "\(HOST)\(convertible)"
        var headers = HTTPHeaders();
        headers.add(name: "content-type", value: "x-www-form-urlencoded")
        headers.add(name: "type", value: "ios")
        headers.add(name: "timestamp", value: "\(NSDate().timeIntervalSince1970)")
        return AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers, interceptor: interceptor, requestModifier: nil)
    }
    
    //上传文件信息，也可以带着其他信息，以form-data的形式传递
    static func upload(multipartFormData: @escaping (MultipartFormData) -> Void,
                       to url: URLConvertible,
                       parameters: [String: Data]?, //二进制的key-value信息
                       usingThreshold encodingMemoryThreshold: UInt64 = MultipartFormData.encodingMemoryThreshold,
                       method: HTTPMethod = .post,
                       headers: HTTPHeaders? = nil,
                       interceptor: RequestInterceptor? = nil,
                       fileManager: FileManager = .default) -> UploadRequest
    {
        let url = "\(HOST)\(url)"
        var headers = HTTPHeaders()
        headers.add(name: "content-type", value: "x-www-form-urlencoded")
        headers.add(name: "type", value: "ios")
        headers.add(name: "timestamp", value: "\(NSDate().timeIntervalSince1970)")
    
        return AF.upload(multipartFormData: multipartFormData, to: url, usingThreshold: encodingMemoryThreshold, method: .post, headers: headers, interceptor: interceptor, fileManager: fileManager, requestModifier: nil)
        //案例
//        AF.upload(multipartFormData: { multipartFormData in
//            if let params = parameters {
//                for (key, value) in params {
//                    multipartFormData.append(value, withName: key )
//                }
//            }
//        }, to: url, usingThreshold: encodingMemoryThreshold, method: .post, headers: headers, interceptor: interceptor, fileManager: fileManager, requestModifier: nil)
    }
}
