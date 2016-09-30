//
//  XHGuideContentViewController.swift
//  XHGuideViewController
//
//  Created by echo on 16/7/26.
//  Copyright © 2016年 羲和. All rights reserved.
//

import Foundation
import UIKit

public enum XHGuideImageType: Int {
    case system = 0     // 应用内图片
    case document = 1   // 沙盒Document下图片
    case url = 2        // 网络图片
}

open class XHGuideContentViewController: UIViewController {
    fileprivate let screenWidth = UIScreen.main.bounds.width
    fileprivate let screenHeight = UIScreen.main.bounds.height
    fileprivate let leftMargin: CGFloat = 0.0
    fileprivate let rightMargin: CGFloat = 0.0
    fileprivate let topMargin: CGFloat = 0.0
    fileprivate let bottomMargin: CGFloat = 0.0
    
    fileprivate let buttonWidth: CGFloat = 100.0
    fileprivate let buttonHeight: CGFloat = 40.0
    fileprivate let buttonBottomPadding: CGFloat = 100.0
    
    fileprivate var imageNameOrUrl: String?
    fileprivate var buttonTitle: String?
    fileprivate var imageType: XHGuideImageType = .system
    
    open var index: Int = 0
    open var buttonAction: (()->())?
    open var tapAtIndex: ((_ index: Int)->())?
    
    // imageView
    open lazy var imageView: UIImageView = {
        let newValue: UIImageView = UIImageView(frame: CGRect(x: self.leftMargin, y: self.topMargin, width: self.screenWidth, height: self.screenHeight))
        newValue.backgroundColor = UIColor.clear
        newValue.contentMode = .scaleAspectFill
        newValue.clipsToBounds = true
        return newValue
    }()
    // actionButton
    open lazy var actionButton: UIButton = {
        var newValue: UIButton = UIButton(frame: CGRect(x: (self.screenWidth - self.buttonWidth)/2, y: self.screenHeight - 100 - self.buttonHeight, width: self.buttonWidth, height: self.buttonHeight))
        newValue.setTitle("开始", for: UIControlState())
        newValue.setTitleColor(UIColor.darkGray, for: UIControlState())
        newValue.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        newValue.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        newValue.layer.cornerRadius = 5
        newValue.layer.masksToBounds = true
        newValue.addTarget(self, action: #selector(XHGuideContentViewController.actionButtonClicked), for: .touchUpInside)
        return newValue
    }()
    
    public convenience init(imageNameOrUrl:String?, imageType:XHGuideImageType, buttonTitle: String?) {
        self.init()
        self.imageNameOrUrl = imageNameOrUrl
        self.buttonTitle = buttonTitle
        self.imageType = imageType
    }
    
    override open func viewDidLoad() {
        self.view.backgroundColor = UIColor.clear
        self.view.clipsToBounds = true
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionTapAt))
        self.view.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(self.imageView)
        // 加载图片
        self.loadImageView()
        
        if let buttonTitle = self.buttonTitle {
            self.actionButton.setTitle(buttonTitle, for: UIControlState())
            self.actionButton.setTitleColor(UIColor.black, for: UIControlState())
            self.view.addSubview(self.actionButton)
        }
    }
    
    /**
     * 加载图片
     */
    @objc fileprivate func loadImageView() {
        if self.imageNameOrUrl != nil {
            if self.imageType == .system {
                self.imageView.image = UIImage(named: self.imageNameOrUrl!)
            }
            else if self.imageType == .document {
                weak var weakSelf = self
                
                DispatchQueue.global().async {
                    let paths: [String] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                    var path: String = paths.first!
                    path = "\(path)/\(self.imageNameOrUrl!)"
                    if FileManager.default.fileExists(atPath: path) {
                        let data:Data? = try? Data(contentsOf: URL(fileURLWithPath: path))
                        if let data = data {
                            let image: UIImage? = UIImage(data: data)
                            if image != nil {
                                DispatchQueue.main.async(execute: {
                                    weakSelf!.imageView.image = image
                                })
                            }
                        }
                    }
                }
            }
            else if self.imageType == .url {
                weak var weakSelf = self
                
                DispatchQueue.global().async {
                    var data: Data!
                    if self.imageNameOrUrl?.hasPrefix("http://") == true || weakSelf!.imageNameOrUrl?.hasPrefix("https://") == true {
                        let url: URL! = URL(string: weakSelf!.imageNameOrUrl!)
                        data = try? Data(contentsOf: url)
                    }
                    if let data = data {
                        let image: UIImage? = UIImage(data: data)
                        if image != nil {
                            DispatchQueue.main.async(execute: {
                                weakSelf!.imageView.image = image
                            })
                        }
                    }
                }
            }
        }
    }
    
    @objc fileprivate func actionButtonClicked(_ sender: UIButton) {
        if self.buttonAction != nil {
            self.buttonAction!()
        }
    }
    
    @objc fileprivate func actionTapAt(_ sender: UITapGestureRecognizer) {
        if self.tapAtIndex != nil {
            self.tapAtIndex!(self.index)
        }
    }
}
