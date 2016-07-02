//
//  UILabel+YBAttributeTextTapAction.m
//
//  Created by LYB on 16/7/1.
//  Copyright © 2016年 LYB. All rights reserved.
//

#import "UILabel+YBAttributeTextTapAction.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>

@implementation YBAttributeModel

@end

@implementation UILabel (YBAttributeTextTapAction)

#pragma mark - AssociatedObjects

- (NSMutableArray *)attributeStrings
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAttributeStrings:(NSMutableArray *)attributeStrings
{
    objc_setAssociatedObject(self, @selector(attributeStrings), attributeStrings, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(NSString *, NSRange, NSInteger))tapBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTapBlock:(void (^)(NSString *, NSRange, NSInteger))tapBlock
{
    objc_setAssociatedObject(self, @selector(tapBlock), tapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id<YBAttributeTapActionDelegate>)delegate
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDelegate:(id<YBAttributeTapActionDelegate>)delegate
{
    objc_setAssociatedObject(self, @selector(delegate), delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - mainFunction
- (void)yb_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings tapClicked:(void (^) (NSString *string , NSRange range , NSInteger index))tapClick
{
    [self yb_getRangesWithStrings:strings];
    
    if (self.tapBlock != tapClick) {
        self.tapBlock = tapClick;
    }
}

- (void)yb_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                                   delegate:(id <YBAttributeTapActionDelegate> )delegate
{
    [self yb_getRangesWithStrings:strings];
    
    if (self.delegate != delegate) {
        self.delegate = delegate;
    }
}

#pragma mark - touchAction
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    __weak typeof(self) weakSelf = self;
    
    [self yb_getTapFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
        
        if (weakSelf.tapBlock) {
            weakSelf.tapBlock (string , range , index);
        }
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(yb_attributeTapReturnString:range:index:)]) {
            [weakSelf.delegate yb_attributeTapReturnString:string range:range index:index];
        }
        
    }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self yb_getTapFrameWithTouchPoint:point result:nil]) {
        return self;
    }
    return nil;
}

#pragma mark - getTapFrame
- (BOOL)yb_getTapFrameWithTouchPoint:(CGPoint)point result:(void (^) (NSString *string , NSRange range , NSInteger index))resultBlock
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    
    CGMutablePathRef Path = CGPathCreateMutable();
    
    CGPathAddRect(Path, NULL, self.bounds);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    if (!lines) {
        return NO;
    }
    
    CFIndex count = CFArrayGetCount(lines);
    
    CGPoint origins[count];
    
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    CGAffineTransform transform = [self yb_transformForCoreText];
    
    CGFloat verticalOffset = 0;
    
    for (CFIndex i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CGRect flippedRect = [self yb_getLineBounds:line point:linePoint];
        
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        rect = CGRectInset(rect, 0, 0);
        
        rect = CGRectOffset(rect, 0, verticalOffset);
        
        if (CGRectContainsPoint(rect, point)) {
            
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            
            CGFloat offset;
            
            CTLineGetOffsetForStringIndex(line, index, &offset);
            
            if (offset > relativePoint.x) {
                index = index - 1;
            }
            
            NSInteger link_count = self.attributeStrings.count;
            
            for (int j = 0; j < link_count; j++) {
                
                YBAttributeModel *model = self.attributeStrings[j];
                
                NSRange link_range = model.range;
                if (NSLocationInRange(index, link_range)) {
                    if (resultBlock) {
                        resultBlock (model.str , model.range , (NSInteger)j);
                    }
                    return YES;
                }
            }
        }
    }
    return NO;
}

- (CGAffineTransform)yb_transformForCoreText
{
    return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
}

- (CGRect)yb_getLineBounds:(CTLineRef)line point:(CGPoint)point
{
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    
    return CGRectMake(point.x, point.y - descent, width, height);
}

#pragma mark - getRange
- (void)yb_getRangesWithStrings:(NSArray <NSString *>  *)strings
{
    __block  NSString *totalStr = self.attributedText.string;
    
    self.attributeStrings = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    
    [strings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSRange range = [totalStr rangeOfString:obj];
        
        if (range.length != 0) {
            YBAttributeModel *model = [YBAttributeModel new];
            model.range = range;
            model.str = obj;
            [weakSelf.attributeStrings addObject:model];
            
            totalStr = [totalStr stringByReplacingCharactersInRange:range withString:[weakSelf yb_getStringWithRange:range]];
        }
    }];
}

- (NSString *)yb_getStringWithRange:(NSRange)range
{
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < range.length ; i++) {
        [string appendString:@" "];
    }
    return string;
}

@end
