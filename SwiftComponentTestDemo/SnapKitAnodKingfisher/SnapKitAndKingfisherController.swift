//
//  SnapKitAndKingfisherController.swift
//  SwiftComponentTestDemo
//
//  Created by Marshal on 2022/7/22.
//

import UIKit
import SnapKit
import Kingfisher

class SnapKitAndKingfisherController: UIViewController {
    var ivHeader: UIImageView = UIImageView()
    var lblUseName: UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.testSnapKit()
        self.testKingfisher()
    }
    
    func testSnapKit() {
        let bkg = UIView()
        bkg.backgroundColor = UIColor(named: "theme_color")
        
        
        self.view.addSubview(bkg)
        bkg.snp.makeConstraints { make in
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.top.equalTo(100)
        }
        
        bkg.addSubview(self.ivHeader)
        self.ivHeader.snp.makeConstraints { make in
            make.left.top.equalTo(10)
            make.bottom.equalTo(bkg).offset(-10) //相对于bkg的底部 10 像素，右和下贴近内部都是负的
            make.width.height.equalTo(120)
        }
        
        self.lblUseName.text = "哈哈哈哈哈哈"
        self.lblUseName.numberOfLines = 0;
        self.lblUseName.sizeToFit() //自适应
        self.view.addSubview(self.lblUseName)
        self.lblUseName.snp.makeConstraints { make in
            make.left.equalTo(self.ivHeader.snp.right).offset(10)
            make.centerY.equalTo(self.ivHeader.snp.centerY)
        }
        
        //第二个参数是指的方向.horizontal水平、.vertical垂直，第一个参数值的是权限
        //设置拥抱权限等级，有好几个，一般使用 .required、.defaultHigh、.defaultLow，中间也有其他一般这就够了
        //不设置默认为.required优先级1000，其他两个分别750、250，可以点进去看看
        //hug有拥抱的意思，指的是拥抱权限，即抗拉伸的权限
        self.lblUseName.setContentHuggingPriority(.required, for: .horizontal)
        //设置耐挤压，即抗挤压的权限
        self.lblUseName.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    
    func testKingfisher() {
        //使用默认图片
        let url = URL(string: "https://pic.leetcode-cn.com/1654836514-AIOwwN-1627640862-HgXcTO-Frame%201444.jpeg?x-oss-process=image%2Fformat%2Cwebp")
        //self.ivHeader.kf.setImage(with: url)
        
        //设置占位
        let image = UIImage(named: "logo");
        //self.ivHeader.kf.setImage(with: url, placeholder: image)
        
        //加工设置圆角,默认没有圆角，这样可以避免设置圆角的一些性能问题
        let processor = DownsamplingImageProcessor(size: CGSize(width: 120, height: 120))
                     |> RoundCornerImageProcessor(cornerRadius: 60)
        //可以设置很多属性，可以点进去查看
        self.ivHeader.kf.setImage(with: url, placeholder: image, options: [
            .processor(processor), //加工图像
            .scaleFactor(UIScreen.main.scale), //像素倍率scale
            .transition(.fade(1)), //渐变动画
            .loadDiskFileSynchronously,//从磁盘同步加载 .cacheMemoryOnly()仅仅内存缓存
            .cacheOriginalImage
        ]) { result in
            //加载结束后的回调，如果需要除了，可以在这里处理
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
        //设置指示器
        self.ivHeader.kf.indicatorType = .activity //.none没有
    }
}
