//
//  LoginRequest.swift
//  SwiftComponentTestDemo
//
//  Created by Marshal on 2022/7/21.
//  演示api的封装，自己应用加上注释，可以形成一种接口文档

import Foundation
import Alamofire

class Request {
    
    //cmd + option + / 生成注释模块
    /// 登陆，参数如果是以模型方式保存，也可以以模型方式上传，避免了二次生成字典传问题
    /// - Parameters:
    ///   - username: 用户名
    ///   - password: 密码
    ///   - successBlock: 成功回调
    ///   - failureBlock: 失败回调
    static func login(username: String,
                      password: String,
                      successBlock: @escaping ()->Void,
                      failureBlock: @escaping ()->Void) {
        let paramters = [
            "username": username,
            "password": password
        ]
        AFNetwork.post("https://www.baidu.com", parameters: paramters).response { res in
            print(res)
            successBlock()
            failureBlock()
        }
    }
    
    //cmd + option + / 生成注释模块
    /// 登陆，参数如果是以模型方式保存，也可以以模型方式上传，避免了二次生成字典传问题
    /// - Parameters:
    ///   - loginInfo: 用户信息
    ///   - successBlock: 成功回调
    ///   - failureBlock: 失败回调
    static func login(loginInfo: LoginModel,
                      successBlock: @escaping ()->Void,
                      failureBlock: @escaping ()->Void) {
        AFNetwork.post("https://www.baidu.com", body: loginInfo).response { res in
            print(res)
            successBlock()
            failureBlock()
        }
    }
}


