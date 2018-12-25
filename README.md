# YBAttributeTextTapAction
 * 一行代码添加文本点击事件

# 效果图
![(演示效果)](https://lyb5834.github.io/Images/attributeTapAction.gif)

# Swfit版本（最新版还未更新）
https://github.com/lyb5834/YBAttributeTextTapForSwfit.git

# 使用方法
  * `#import "UILabel+YBAttributeTextTapAction.h"`
  * 先设置 `label.attributedText = ？？？？？` 
  * 有2种回调方法，第一种是用代理回调，第二种是用block回调
  * 代理回调
  *  1.传入要点击的字符串数组
   ```
   [label yb_addAttributeTapActionWithStrings:@[@"xxx",@"xxx"] delegate:self];
   ```
  *  2.传入要点击的range数组
   ```
   [label yb_addAttributeTapActionWithRanges:@[NSStringFromRange(range1),NSStringFromRange(range2)] delegate:self]
   ```
  * block回调
  * 1.传入要点击的字符串数组 
   ```
   [label yb_addAttributeTapActionWithStrings:@[@"xxx",@"xxx"] tapClicked:^(UILabel *label,NSString *string, NSRange range,NSInteger index) {  coding more... }];
   ```
  * 2.传入要点击的range数组 
   ```
   [label yb_addAttributeTapActionWithRanges:@[NSStringFromRange(range1),NSStringFromRange(range2)] tapClicked:^(UILabel *label,NSString *string, NSRange range,NSInteger index) {  coding more... }];
   ```

# CocoaPods支持
  * 只需在podfile中输入 `pod 'YBAttributeTextTapAction'` 即可

# V3.0.3版本
  * 增加`yb_removeAttributeTapActions`方法，可以删除label上所有的附加点击事件，一般用于复用的cell，防止label上还存在不必要的点击事件

# V3.0.2版本
  * 修复了在8.0系统上crash 的bug

# V3.0.1版本
  * 修复字符串中有多个"\n"符号时计算不准确的bug
  
# V3.0.0版本
  * 重构计算文字坐标的算法，点击准确率大大提升（再大的文本都不怕啦）
  * 重构API，回调参数更多
  * 增加传入range数组的API，可以指定range进行触发
  * 增加设置点击高亮色和是否扩大点击区域的API，麻麻再也不用担心我手指粗点不到啦
  * 重构demo，介绍更详细，用法更丰富
  * 修复一个页面多次调用会相互影响的bug
  * 修复在label上添加手势无效的bug

# V2.0.5修复
  * 修复内存泄漏

# V2.0.0重大更新
  * 修复字体变小时，坐标计算不正确导致无法点击的bug

# V2.1.0更新
  * 增加点击效果，默认是开启，关闭只需设置`label.enabledTapEffect = NO`即可
  
# 问题总结
  *  因为UILabel的封装，有些属性不能实现，在此说一下一些提的比较多的问题
  * 关于文字排版的正确设置方式，设置`label.textAlignment = NSTextAlignmentCenter`会导致点击失效，正确的设置方法是    
  ```
      NSMutableParagraphStyle *sty = [[NSMutableParagraphStyle alloc] init];
     sty.alignment = NSTextAlignmentCenter;
     [attributedString addAttribute:NSParagraphStyleAttributeName value:sty range:NSMakeRange(0, text.length)];
   ```

# 版本支持
  * `xcode6.0+`

  * 如果您在使用本库的过程中发现任何bug或者有更好建议，欢迎[@issues](https://github.com/lyb5834/YBAttributeTextTapAction/issues) 或联系本人email  lyb5834@126.com

