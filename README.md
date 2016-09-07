# XHGuideViewController
![image](https://github.com/zhuyunfeng1224/XHImageStore/blob/master/XHGuideController/XHGuideController_screenshot.gif)
![image](https://github.com/zhuyunfeng1224/XHImageStore/blob/master/XHGuideController/XHGuideController_screenshot2.gif)<br>
XHGuideViewController是一个用swift写的开机启动引导页，可设置每页图片，并按需求添加倒计时、跳过、最后一页滑动关闭功能

# 安装
## 手工导入
下载或者clone XHGuideViewController，将XHGuideContentViewController.swift和XHGuideViewController.swift引入工程即可
## cocoapods
在podfile中添加 ```pod 'XHGuideViewController', '~> 0.0.3'``` 
# 例子
## 初始化```XHGuideContentViewController```
```
let vc1: XHGuideContentViewController = XHGuideContentViewController(imageNameOrUrl: "1.jpg", imageType: .System, buttonTitle: nil)
```
### 图片显示模式
```
vc1.imageView.contentMode = .ScaleAspectFit
```
### 点击事件
```
vc1.tapAtIndex = {(index: Int) in
            print("tap at index:\(index)")
        }
```

## 初始化```XHGuideViewController```
```
let guideVC: XHGuideViewController = XHGuideViewController()
guideVC.viewControllers = [vc1, vc2, vc3]
```
### 显示背景图片
```
guideVC.backgroundImageView.image = UIImage(named: "bg.jpg")
guideVC.backgroundImageView.alpha = 0.3
```
### 显示跳转按钮
```guideVC.showSkipButton = true```
### 开启倒计时功能
```guideVC.autoClose = true```
```guideVC.showTime = 30```设置倒计时时间<br>
倒计时结束自动关闭
### 跳转动作
```
guideVC.actionSkip = {
  let vc: ViewController = ViewController()
  vc.modalTransitionStyle = .CrossDissolve
  guideVC.presentViewController(vc, animated: true, completion: nil)
}
```   

# License
MIT license.
