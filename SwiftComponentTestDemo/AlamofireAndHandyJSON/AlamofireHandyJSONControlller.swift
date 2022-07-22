//
//  AlamofireHandyJSONControlller.swift
//  SwiftComponentTestDemo
//
//  Created by Marshal on 2022/7/21.
//  使用 Alamofire、HandyJson、JsonDecode部分案例

import UIKit

import Alamofire
import HandyJSON

//JSONDecoder
//如果使用简单接口，数据比较符合我们接口，配合泛型，可以直接动态取出使用该模型
//但是碰到复杂的，嵌套，需要自行转化映射出新的数据结构，这个显然不能帮我们一步到位，需要新的json转模型
struct ResponseList: Codable {
    var status: Int = 0
    var message: String?
    
    struct item: Codable {
        var id: Int
        var name: String?
        var headimg: String?
        var description: String?
    }
    
    struct listPage: Codable {
        var page: Int
        var size: Int
        var list: [item]?
    }
    
    var data: listPage?
}


//handyJSON
//使用泛型，默认返回内容如下，我们直接剔除掉外面的信息,需要
struct APIResponse<T: HandyJSON>: HandyJSON {
    var status: Int = 0
    var message: String?
    
    var data: T?
    
    
//    //这里是是作为一个测试案例，这个案例不应当这么用
//    var page: Int = 0
//    var size: Int = 0
//    //如果不是对应层级，需要进行下面映射
//    //struct需要加上前面的突变，class不需要
//    mutating func mapping(mapper: HelpingMapper) {
//        mapper <<<
//            self.page <-- "data.page"
//
//        mapper <<<
//            self.size <-- "data.size"
//    }
}

//我们用到的基本模型，可能需要更多交互，使用class
class PageItem: HandyJSON {
    var id: Int?
    var name: String?
    var headimg: String?
    var description: String?
    
    required init() {}
   
}
class ListPageModel: HandyJSON {
    var page: Int = 0
    var size: Int = 0
    var list: [PageItem?]?
    
    required init() {}
}


//默认模型
struct LoginModel: Encodable {
    var username: String
    var password: String
}

class AlamofireHandyJSONControlller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.testJsonDecode()
        self.testHandyJson()
    }
    
    func testJsonDecode() {
        //自动返回decode模型
        AF.request("http://onapp.yahibo.top/public/?s=api/test/list", method: .post).responseDecodable {(res: AFDataResponse<ResponseList>) in
            switch res.result {
                case .failure(let error):
                    print("失败了", error)
                case .success(let model):
                    print("model", model)
            }
        }
        //默认传参使用字典
        let parameters = ["username": "wwwsssddd123", "password": "kweikjkkke12dsda"]
        AF.request("http://onapp.yahibo.top/public/?s=api/test/list", method: .post, parameters: parameters).response { res in
        }
        //也支持遵循 Encodable 协议的模型，这样就不用模型转字典了
        let loginInfo = LoginModel(username: "wwwsss", password: "sdfasdf")
        AF.request("http://onapp.yahibo.top/public/?s=api/test/list", method: .post, parameters: loginInfo, encoder: JSONParameterEncoder.default).response { res in
        }
    }
    
    func testHandyJson() {
        AF.request("http://onapp.yahibo.top/public/?s=api/test/list", method: .post).responseString { res in
            switch res.result {
                
            case .failure(let error):
                print("失败了", error)
            case .success(let json):
                //生成结果
                let model = JSONDeserializer<APIResponse<ListPageModel>>.deserializeFrom(json: json)
                
                print("result", model ?? "")
            }
        }
    }

}
