//
//  XHGuideViewController.swift
//  XHGuideViewController
//
//  Created by echo on 16/7/26.
//  Copyright © 2016年 羲和. All rights reserved.
//

import Foundation
import UIKit

open class XHGuideViewController: UIViewController, UIScrollViewDelegate {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let timeLabelWidth: CGFloat = 30.0
    let timeLabelHeight: CGFloat = 20.0
    let timeLabelY: CGFloat = 20.0
    
    let skipButtonWidth: CGFloat = 50.0
    let skipButtonHeight: CGFloat = 30.0
    
    let pageControlWidth: CGFloat = 100
    let pageControlHeight: CGFloat = 30
    let pageControlY: CGFloat = UIScreen.main.bounds.height - 100
    
    open var viewControllers: [UIViewController] = []
    open var autoClose: Bool = true
    open var showSkipButton: Bool = true
    open var showTime: Int = 5
    open var actionSkip: (()->())! = {}
    
    // MARK:lazy load
    
    // scrollView
    fileprivate lazy var scrollView: UIScrollView = {
        var newValue: UIScrollView = UIScrollView(frame: self.view.bounds)
        newValue.isPagingEnabled = true
        newValue.backgroundColor = UIColor.clear
        newValue.alwaysBounceHorizontal = true
        newValue.delegate = self
        return newValue
    }()
    
    // pageControl
    open lazy var pageControl: UIPageControl = {
        var newValue: UIPageControl = UIPageControl(frame: CGRect(x: (self.screenWidth - self.pageControlWidth)/2, y: self.pageControlY, width: self.pageControlWidth, height: self.pageControlHeight))
        newValue.hidesForSinglePage = true
        newValue.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)
        return newValue
    }()
    
    // timeToCloseLabel
    open lazy var timeToCloseLabel: UILabel = {
        var newValue: UILabel = UILabel(frame: CGRect(x: self.screenWidth - self.timeLabelWidth - self.skipButtonWidth - 20, y: self.timeLabelY, width: self.timeLabelWidth, height: self.timeLabelHeight))
        newValue.font = UIFont.systemFont(ofSize: 12)
        newValue.textColor = UIColor.darkGray
        return newValue
    }()
    
    // skipButton
    open lazy var skipButton: UIButton = {
        var newValue: UIButton = UIButton(frame: CGRect(x: self.timeToCloseLabel.frame.maxX, y: self.timeToCloseLabel.frame.minY, width: self.skipButtonWidth, height: self.skipButtonHeight))
        newValue.setTitle("跳过", for: UIControlState())
        newValue.setTitleColor(UIColor.darkGray, for: UIControlState())
        newValue.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        newValue.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        newValue.layer.cornerRadius = 5
        newValue.layer.masksToBounds = true
        newValue .addTarget(self, action: #selector(skipButtonClicked(_:)), for: .touchUpInside)
        return newValue
    }()
    
    // backgroundImage
    open var backgroundImageView: UIImageView = UIImageView()
    
    
    // MARK: Initialize
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.loadSubViews()
        self.timeToCloseLabel.isHidden = !self.autoClose
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        if self.autoClose == true {
            
            let timer: Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(XHGuideViewController.delayTimeChanged), userInfo: nil, repeats: true)
            timer.fire()
        }
    }
    
    fileprivate func loadSubViews() {
        self.backgroundImageView.frame = self.view.bounds
        self.view.addSubview(self.backgroundImageView)
        
        self.scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(self.viewControllers.count), height: scrollView.frame.height)
        for i in 0 ..< self.viewControllers.count {
            let vc: XHGuideContentViewController = self.viewControllers[i] as! XHGuideContentViewController
            vc.index = i
            let view = vc.view
            view?.frame = CGRect(x: CGFloat(i) * scrollView.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            self.scrollView.addSubview(view!)
        }
        self.view.addSubview(self.scrollView)
        
        self.pageControl.numberOfPages = self.viewControllers.count
        self.view.addSubview(self.pageControl)
        
        self.view.addSubview(self.timeToCloseLabel)
        
        if self.showSkipButton == true {
            self.view.addSubview(self.skipButton)
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetX: CGFloat = scrollView.contentOffset.x
        
        if (self.scrollView.contentSize.width - offsetX) < CGFloat(self.scrollView.frame.width - 60) {
            self.actionSkip()
        }
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page: NSInteger = Int(scrollView.contentOffset.x/scrollView.frame.width)
        self.pageControl.currentPage = page
    }
    
    // MARK: Actions
    
    @objc fileprivate func pageControlValueChanged(_ sender: UIPageControl) {
        let page = sender.currentPage
        self.scrollView.contentOffset = CGPoint(x: CGFloat(page) * self.scrollView.frame.width, y: self.scrollView.contentOffset.y)
    }
    
    @objc fileprivate func skipButtonClicked(_ sender: UIButton) {
        self.actionSkip()
    }
    
    @objc fileprivate func delayTimeChanged(_ timer: Timer) {
        self.timeToCloseLabel.text = "\(self.showTime<0 ? 0: self.showTime)s"
        if self.showTime <= 0 {
            timer.invalidate()
            self.actionSkip()
        }
        self.showTime -= 1
    }
}
