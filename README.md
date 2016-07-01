# UILabel-YBAttributeTapAction
 * 一行代码添加文本点击事件

# 效果图
![(演示效果)](http://7xt3dd.com1.z0.glb.clouddn.com/attributeAction.gif)

#使用方法
  * `#import "UILabel+YBAttributeTapAction.h"`
  * 设置 `label.attributedText = ？？？？？` 
  * 有2种回调方法，第一种是用代理回调，第二种是用block回调
  * 第一种 `[label yb_addAttributeTapActionWithStrings:@[@"xxx",@"xxx"] delegate:self];` 
  * 第二种 `[label yb_addAttributeTapActionWithStrings:@[@"xxx",@"xxx"] tapClicked:^(NSString *string, NSRange range,NSInteger index) {  coding more... }];`
  * PS:数组里输入的要点击的字符可以重复

#版本支持
  * `xcode6.0+`

  * 如果您在使用本库的过程中发现任何bug或者有更好建议，欢迎联系本人email  lyb5834@126.com

