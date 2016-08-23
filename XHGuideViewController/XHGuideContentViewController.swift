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
    case System = 0     // 应用内图片
    case Document = 1   // 沙盒Document下图片
    case Url = 2        // 网络图片
}

public class XHGuideContentViewController: UIViewController {
    private let screenWidth = UIScreen.mainScreen().bounds.width
    private let screenHeight = UIScreen.mainScreen().bounds.height
    private let leftMargin: CGFloat = 0.0
    private let rightMargin: CGFloat = 0.0
    private let topMargin: CGFloat = 0.0
    private let bottomMargin: CGFloat = 0.0
    
    private let buttonWidth: CGFloat = 100.0
    private let buttonHeight: CGFloat = 40.0
    private let buttonBottomPadding: CGFloat = 100.0
    
    private var imageNameOrUrl: String?
    private var buttonTitle: String?
    private var imageType: XHGuideImageType = .System
    
    public var index: Int = 0
    public var buttonAction: (()->())?
    public var tapAtIndex: ((index: Int)->())?
    
    // imageView
    public lazy var imageView: UIImageView = {
        let newValue: UIImageView = UIImageView(frame: CGRectMake(self.leftMargin, self.topMargin, self.screenWidth, self.screenHeight))
        newValue.backgroundColor = UIColor.clearColor()
        newValue.contentMode = .ScaleAspectFill
        newValue.clipsToBounds = true
        return newValue
    }()
    // actionButton
    public lazy var actionButton: UIButton = {
        var newValue: UIButton = UIButton(frame: CGRectMake((self.screenWidth - self.buttonWidth)/2, self.screenHeight - 100 - self.buttonHeight, self.buttonWidth, self.buttonHeight))
        newValue.setTitle("开始", forState: .Normal)
        newValue.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        newValue.titleLabel?.font = UIFont.systemFontOfSize(12)
        newValue.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        newValue.layer.cornerRadius = 5
        newValue.layer.masksToBounds = true
        newValue.addTarget(self, action: #selector(XHGuideContentViewController.actionButtonClicked), forControlEvents: .TouchUpInside)
        return newValue
    }()
    
    public convenience init(imageNameOrUrl:String?, imageType:XHGuideImageType, buttonTitle: String?) {
        self.init()
        self.imageNameOrUrl = imageNameOrUrl
        self.buttonTitle = buttonTitle
        self.imageType = imageType
    }
    
    override public func viewDidLoad() {
        UIScreen.mainScreen().bounds.width
        self.view.backgroundColor = UIColor.clearColor()
        self.view.clipsToBounds = true
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionTapAt))
        self.view.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(self.imageView)
        // 加载图片
        self.loadImageView()
        
        if let buttonTitle = self.buttonTitle {
            self.actionButton.setTitle(buttonTitle, forState: .Normal)
            self.actionButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            self.view.addSubview(self.actionButton)
        }
    }
    
    /**
     * 加载图片
     */
    @objc private func loadImageView() {
        if self.imageNameOrUrl != nil {
            if self.imageType == .System {
                self.imageView.image = UIImage(named: self.imageNameOrUrl!)
            }
            else if self.imageType == .Document {
                weak var weakSelf = self
                dispatch_async(dispatch_get_global_queue(0, 0), {
                    let paths: [String] = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                    var path: String = paths.first!
                    path = "\(path)/\(self.imageNameOrUrl!)"
                    if NSFileManager.defaultManager().fileExistsAtPath(path) {
                        let data:NSData? = NSData(contentsOfFile: path)
                        if let data = data {
                            let image: UIImage? = UIImage(data: data)
                            if image != nil {
                                dispatch_async(dispatch_get_main_queue(), {
                                    weakSelf!.imageView.image = image
                                })
                            }
                        }
                    }
                })
            }
            else if self.imageType == .Url {
                weak var weakSelf = self
                dispatch_async(dispatch_get_global_queue(0, 0), {
                    var data: NSData!
                    if self.imageNameOrUrl?.hasPrefix("http://") == true || weakSelf!.imageNameOrUrl?.hasPrefix("https://") == true {
                        let url: NSURL! = NSURL(string: weakSelf!.imageNameOrUrl!)
                        data = NSData(contentsOfURL: url)
                    }
                    if let data = data {
                        let image: UIImage? = UIImage(data: data)
                        if image != nil {
                            dispatch_async(dispatch_get_main_queue(), {
                                weakSelf!.imageView.image = image
                            })
                        }
                    }
                })
            }
        }
    }
    
    @objc private func actionButtonClicked(sender: UIButton) {
        if self.buttonAction != nil {
            self.buttonAction!()
        }
    }
    
    @objc private func actionTapAt(sender: UITapGestureRecognizer) {
        if self.tapAtIndex != nil {
            self.tapAtIndex!(index: self.index)
        }
    }
}
