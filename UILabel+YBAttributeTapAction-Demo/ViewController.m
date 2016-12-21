//
//  ViewController.m
//  UILabel+YBAttributeTapAction-Demo
//
//  Created by LYB on 16/7/1.
//  Copyright © 2016年 LYB. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+YBAttributeTextTapAction.h"

#define YBAlertShow(messageText,buttonName) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:(messageText) \
delegate:nil cancelButtonTitle:(buttonName) otherButtonTitles: nil];\
[alert show];

@interface ViewController ()<YBAttributeTapActionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //需要点击的字符相同
    NSString *label_text1 = @"我是个抽奖Label， 点我有奖，点我没奖哦";
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc]initWithString:label_text1];
    [attributedString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, label_text1.length)];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(12, 2)];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(17, 2)];
    //最好设置一下行高，不设的话默认是0
    NSMutableParagraphStyle *sty = [[NSMutableParagraphStyle alloc] init];
    sty.alignment = NSTextAlignmentCenter;
    sty.lineSpacing = 5;
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:sty range:NSMakeRange(0, label_text1.length)];
    
    UILabel *ybLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, self.view.bounds.size.width - 20, 60)];
    ybLabel1.backgroundColor = [UIColor yellowColor];
    ybLabel1.numberOfLines = 2;
    ybLabel1.attributedText = attributedString1;
    [self.view addSubview:ybLabel1];
    
    [ybLabel1 yb_addAttributeTapActionWithStrings:@[@"点我",@"点我"] delegate:self];
    
    //需要点击的字符不同
    NSString *label_text2 = @"您好！您是小明吗？你中奖了，领取地址“www.yb.com”,领奖码“9527”";
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:label_text2];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, label_text2.length)];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(19, 10)];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(35, 4)];
    
    UILabel *ybLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, self.view.bounds.size.width - 20, 60)];
    ybLabel2.backgroundColor = [UIColor greenColor];
    ybLabel2.numberOfLines = 2;
    ybLabel2.attributedText = attributedString2;
    [self.view addSubview:ybLabel2];
    
    [ybLabel2 yb_addAttributeTapActionWithStrings:@[@"www.yb.com",@"9527"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        NSString *message = [NSString stringWithFormat:@"点击了“%@”字符\nrange: %@\nindex: %ld",string,NSStringFromRange(range),index];
        YBAlertShow(message, @"取消");
    }];
    //设置是否有点击效果，默认是YES
    ybLabel2.enabledTapEffect = NO;
}

//delegate
- (void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
//    NSString *message = [NSString stringWithFormat:@"点击了“%@”字符\nrange: %@\nindex: %ld",string,NSStringFromRange(range),index];
//    YBAlertShow(message, @"取消");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
