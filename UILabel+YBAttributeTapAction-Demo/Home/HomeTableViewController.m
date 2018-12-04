//
//  HomeTableViewController.m
//  UILabel+YBAttributeTapAction-Demo
//
//  Created by lyb on 2018/11/21.
//  Copyright © 2018年 LYB. All rights reserved.
//

#import "HomeTableViewController.h"
#import "HomeCell.h"
#import "UILabel+YBAttributeTextTapAction.h"

#define YBAlertShow(messageText,buttonName) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:(messageText) \
delegate:nil cancelButtonTitle:(buttonName) otherButtonTitles: nil];\
[alert show];
@interface HomeTableViewController ()
<
YBAttributeTapActionDelegate
>
@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, assign) BOOL isShowTotal;

@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI
{
    self.tableView.tableFooterView = [UIView new];
    self.tableView.sectionHeaderHeight = 30;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:HomeCellID];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)dealloc
{
    NSLog(@"HomeTableViewController 释放了");
}

#pragma mark - lazyloads
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[
                       @"点击展开/收起",
                       @"点击的几个字符相同",
                       @"点击的字符不同",
                       @"label上加手势",
                       @"点击的字符字体不一",
                       @"连续跳转"
                       ];
    }
    return _dataArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30)];
    backView.backgroundColor = [UIColor blackColor];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.tableView.bounds.size.width - 30, 30)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = self.dataArray[section];
    [backView addSubview:label];
    
    return backView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeCellID forIndexPath:indexPath];
    //框架已经做过处理，点击label会响应cell的点击事件，点击具体的字会响应框架的方法
    if (indexPath.section == 0) {
        cell.testTapLabel.tag = 100;
        NSString * totalText = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_1" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        totalText = [totalText substringToIndex:totalText.length - 1];//去掉文本最后的一个/n符
        if (self.isShowTotal) {
            NSString * showText = [NSString stringWithFormat:@"%@收起",totalText];
            NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:showText];
            NSDictionary * attDic = @{
                                      NSFontAttributeName : [UIFont systemFontOfSize:15],
                                      NSForegroundColorAttributeName : [UIColor darkGrayColor]
                                      };
            [attString setAttributes:attDic range:NSMakeRange(0, showText.length)];
            [attString setAttributes:@{NSForegroundColorAttributeName : [UIColor blueColor]} range:NSMakeRange(showText.length - 2, 2)];
            cell.testTapLabel.attributedText = attString;
            
            //这里要用delegate，block不好处理，每次都要重新写这个方法，因为attributedText有变动了
            [cell.testTapLabel yb_addAttributeTapActionWithRanges:@[NSStringFromRange(NSMakeRange(showText.length - 2, 2))] delegate:self];
        }else {
            NSString * showText = [NSString stringWithFormat:@"%@展开",[totalText substringToIndex:80]];
            NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:showText];
            NSDictionary * attDic = @{
                                      NSFontAttributeName : [UIFont systemFontOfSize:15],
                                      NSForegroundColorAttributeName : [UIColor darkGrayColor]
                                      };
            [attString setAttributes:attDic range:NSMakeRange(0, showText.length)];
            [attString setAttributes:@{NSForegroundColorAttributeName : [UIColor blueColor]} range:NSMakeRange(showText.length - 2, 2)];
            cell.testTapLabel.attributedText = attString;
            
            [cell.testTapLabel yb_addAttributeTapActionWithRanges:@[NSStringFromRange(NSMakeRange(showText.length - 2, 2))] delegate:self];
        }
    }else if (indexPath.section == 1) {
        NSString * showText = @"如您有任何疑问，请联系lyb5834@126.com,\n\n\n\n\n\n\n如您有任何疑问，请联系lyb5834@126.com,\n\n\n\n\n如您有任何疑问，请联系lyb5834@126.com";
        cell.testTapLabel.attributedText = [self getAttributeWith:@[@"lyb5834@126.com",@"lyb5834@126.com",@"lyb5834@126.com"] string:showText orginFont:15 orginColor:[UIColor darkGrayColor] attributeFont:18 attributeColor:[UIColor blueColor]];
        
        [cell.testTapLabel yb_addAttributeTapActionWithStrings:@[@"lyb5834@126.com",@"lyb5834@126.com",@"lyb5834@126.com"] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
            
            NSString * message = [NSString stringWithFormat:@"点击了\"%@\"字符\nrange:%@\n在数组中是第%ld个",string,NSStringFromRange(range),index + 1];
            YBAlertShow(message, @"知道了");
        }];
    }else if (indexPath.section == 2) {
        NSString * showText = @"你的快递包裹到了，签收人：张三，电话：13987654321，送货员：李四，电话：15888888888，收件地址：火星";
        cell.testTapLabel.attributedText = [self getAttributeWith:@[@"13987654321",@"15888888888"] string:showText orginFont:15 orginColor:[UIColor darkGrayColor] attributeFont:15 attributeColor:[UIColor blueColor]];
        
        [cell.testTapLabel yb_addAttributeTapActionWithStrings:@[@"13987654321",@"15888888888"] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
            
            NSString * message = [NSString stringWithFormat:@"点击了\"%@\"字符\nrange:%@\n在数组中是第%ld个",string,NSStringFromRange(range),index + 1];
            YBAlertShow(message, @"知道了");
        }];
    }else if (indexPath.section == 3) {
        NSString * showText = @"点击红色字体会走代理方法，测试点击，点label会响应手势事件，查看控制台输出";//手势比较特别，会同时响应框架代理和手势方法
        cell.testTapLabel.attributedText = [self getAttributeWith:@[@"测试点击"] string:showText orginFont:15 orginColor:[UIColor darkGrayColor] attributeFont:15 attributeColor:[UIColor redColor]];
        cell.testTapLabel.tag = 200;
        [cell.testTapLabel yb_addAttributeTapActionWithStrings:@[@"测试点击"] delegate:self];
        
        UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTestGestureRecognizerAction:)];
        cell.testTapLabel.userInteractionEnabled = YES;
        [cell.testTapLabel addGestureRecognizer:tapGes];
    }else if (indexPath.section == 4) {
        NSString * showText = @"恭喜您获得了一张￥50优惠券，赶快去钱包看看并下单使用吧~";
        NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:showText];
        NSDictionary * attDic = @{
                                  NSFontAttributeName : [UIFont systemFontOfSize:15],
                                  NSForegroundColorAttributeName : [UIColor darkGrayColor]
                                  };
        [attString setAttributes:attDic range:NSMakeRange(0, showText.length)];
        [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} range:NSMakeRange(8, 1)];
        [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:22]} range:NSMakeRange(9, 2)];
        [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(8, 3)];
        cell.testTapLabel.attributedText = attString;
        
        [cell.testTapLabel yb_addAttributeTapActionWithStrings:@[@"￥50"] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
            NSString * message = [NSString stringWithFormat:@"点击了\"%@\"字符\nrange:%@\n在数组中是第%ld个",string,NSStringFromRange(range),index + 1];
            YBAlertShow(message, @"知道了");
        }];
    }else if (indexPath.section == 5) {
        NSString * showText = @"点击\"点我跳下一页\"进入下一页";
        cell.testTapLabel.attributedText = [self getAttributeWith:@[@"\"点我跳下一页\""] string:showText orginFont:15 orginColor:[UIColor darkGrayColor] attributeFont:15 attributeColor:[UIColor blueColor]];
        cell.testTapLabel.tag = 300;
        [cell.testTapLabel yb_addAttributeTapActionWithStrings:@[@"\"点我跳下一页\""] delegate:self];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了cell");
}

#pragma mark - YBAttributeTapActionDelegate
- (void)yb_tapAttributeInLabel:(UILabel *)label string:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    if (label.tag == 100) {
        self.isShowTotal = !self.isShowTotal;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }else if (label.tag == 200) {
        NSString * message = [NSString stringWithFormat:@"点击了\"%@\"字符\nrange:%@\n在数组中是第%ld个",string,NSStringFromRange(range),index + 1];
        YBAlertShow(message, @"知道了");
    }else if (label.tag == 300) {
        HomeTableViewController * homeVC = [[HomeTableViewController alloc] init];
        [self.navigationController pushViewController:homeVC animated:YES];
    }
}

#pragma mark - func
- (void)onTestGestureRecognizerAction:(UITapGestureRecognizer *)tapGes
{
    NSLog(@"点击了手势事件");
}

- (NSAttributedString *)getAttributeWith:(id)sender
                                  string:(NSString *)string
                               orginFont:(CGFloat)orginFont
                              orginColor:(UIColor *)orginColor
                           attributeFont:(CGFloat)attributeFont
                          attributeColor:(UIColor *)attributeColor
{
    __block  NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] initWithString:string];
    [totalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:orginFont] range:NSMakeRange(0, string.length)];
    [totalStr addAttribute:NSForegroundColorAttributeName value:orginColor range:NSMakeRange(0, string.length)];
    
    if ([sender isKindOfClass:[NSArray class]]) {
        
        __block NSString *oringinStr = string;
        __weak typeof(self) weakSelf = self;
        
        [sender enumerateObjectsUsingBlock:^(NSString *  _Nonnull str, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSRange range = [oringinStr rangeOfString:str];
            [totalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:attributeFont] range:range];
            [totalStr addAttribute:NSForegroundColorAttributeName value:attributeColor range:range];
            oringinStr = [oringinStr stringByReplacingCharactersInRange:range withString:[weakSelf getStringWithRange:range]];
        }];
        
    }else if ([sender isKindOfClass:[NSString class]]) {
        
        NSRange range = [string rangeOfString:sender];
        
        [totalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:attributeFont] range:range];
        [totalStr addAttribute:NSForegroundColorAttributeName value:attributeColor range:range];
    }
    return totalStr;
}

- (NSString *)getStringWithRange:(NSRange)range
{
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < range.length ; i++) {
        [string appendString:@" "];
    }
    return string;
}

@end
