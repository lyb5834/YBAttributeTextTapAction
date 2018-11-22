//
//  HomeCell.h
//  UILabel+YBAttributeTapAction-Demo
//
//  Created by lyb on 2018/11/22.
//  Copyright © 2018年 LYB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const HomeCellID = @"HomeCellID";
@interface HomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *testTapLabel;

@end

NS_ASSUME_NONNULL_END
