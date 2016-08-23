//
//  XHGuideViewController.swift
//  XHGuideViewController
//
//  Created by echo on 16/7/26.
//  Copyright © 2016年 羲和. All rights reserved.
//

import Foundation
import UIKit

public class XHGuideViewController: UIViewController, UIScrollViewDelegate {
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    let timeLabelWidth: CGFloat = 30.0
    let timeLabelHeight: CGFloat = 20.0
    let timeLabelY: CGFloat = 20.0
    
    let skipButtonWidth: CGFloat = 50.0
    let skipButtonHeight: CGFloat = 30.0
    
    let pageControlWidth: CGFloat = 100
    let pageControlHeight: CGFloat = 30
    let pageControlY: CGFloat = UIScreen.mainScreen().bounds.height - 100
    
    public var viewControllers: [UIViewController] = []
    public var autoClose: Bool = true
    public var showSkipButton: Bool = true
    public var showTime: Int = 5
    public var actionSkip: (()->())! = {}
    
    // MARK:lazy load
    
    // scrollView
    private lazy var scrollView: UIScrollView = {
        var newValue: UIScrollView = UIScrollView(frame: self.view.bounds)
        newValue.pagingEnabled = true
        newValue.backgroundColor = UIColor.clearColor()
        newValue.alwaysBounceHorizontal = true
        newValue.delegate = self
        return newValue
    }()
    
    // pageControl
    public lazy var pageControl: UIPageControl = {
        var newValue: UIPageControl = UIPageControl(frame: CGRectMake((self.screenWidth - self.pageControlWidth)/2, self.pageControlY, self.pageControlWidth, self.pageControlHeight))
        newValue.hidesForSinglePage = true
        newValue.addTarget(self, action: #selector(pageControlValueChanged(_:)), forControlEvents: .ValueChanged)
        return newValue
    }()
    
    // timeToCloseLabel
    public lazy var timeToCloseLabel: UILabel = {
        var newValue: UILabel = UILabel(frame: CGRectMake(self.screenWidth - self.timeLabelWidth - self.skipButtonWidth - 20, self.timeLabelY, self.timeLabelWidth, self.timeLabelHeight))
        newValue.font = UIFont.systemFontOfSize(12)
        newValue.textColor = UIColor.darkGrayColor()
        return newValue
    }()
    
    // skipButton
    public lazy var skipButton: UIButton = {
        var newValue: UIButton = UIButton(frame: CGRectMake(self.timeToCloseLabel.frame.maxX, self.timeToCloseLabel.frame.minY, self.skipButtonWidth, self.skipButtonHeight))
        newValue.setTitle("跳过", forState: .Normal)
        newValue.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        newValue.titleLabel?.font = UIFont.systemFontOfSize(12)
        newValue.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        newValue.layer.cornerRadius = 5
        newValue.layer.masksToBounds = true
        newValue .addTarget(self, action: #selector(skipButtonClicked(_:)), forControlEvents: .TouchUpInside)
        return newValue
    }()
    
    // backgroundImage
    public var backgroundImageView: UIImageView = UIImageView()
    
    
    // MARK: Initialize
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.loadSubViews()
        self.timeToCloseLabel.hidden = !self.autoClose
    }
    
    override public func viewDidAppear(animated: Bool) {
        if self.autoClose == true {
            
            let timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(XHGuideViewController.delayTimeChanged), userInfo: nil, repeats: true)
            timer.fire()
        }
    }
    
    private func loadSubViews() {
        self.backgroundImageView.frame = self.view.bounds
        self.view.addSubview(self.backgroundImageView)
        
        self.scrollView.contentSize = CGSizeMake(scrollView.frame.width * CGFloat(self.viewControllers.count), scrollView.frame.height)
        for i in 0 ..< self.viewControllers.count {
            let vc: XHGuideContentViewController = self.viewControllers[i] as! XHGuideContentViewController
            vc.index = i
            let view = vc.view
            view.frame = CGRectMake(CGFloat(i) * scrollView.frame.width, 0, scrollView.frame.width, scrollView.frame.height)
            self.scrollView.addSubview(view)
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
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetX: CGFloat = scrollView.contentOffset.x
        
        if (self.scrollView.contentSize.width - offsetX) < CGFloat(self.scrollView.frame.width - 60) {
            self.actionSkip()
        }
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let page: NSInteger = Int(scrollView.contentOffset.x/scrollView.frame.width)
        self.pageControl.currentPage = page
    }
    
    // MARK: Actions
    
    @objc private func pageControlValueChanged(sender: UIPageControl) {
        let page = sender.currentPage
        self.scrollView.contentOffset = CGPointMake(CGFloat(page) * self.scrollView.frame.width, self.scrollView.contentOffset.y)
    }
    
    @objc private func skipButtonClicked(sender: UIButton) {
        self.actionSkip()
    }
    
    @objc private func delayTimeChanged(timer: NSTimer) {
        self.timeToCloseLabel.text = "\(self.showTime<0 ? 0: self.showTime)s"
        if self.showTime <= 0 {
            timer.invalidate()
            self.actionSkip()
        }
        self.showTime -= 1
    }
}
