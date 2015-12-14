//
//  DrawView.h
//  DrawFormula
//
//  Created by hanlong on 15/12/11.
//  Copyright © 2015年 hanlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

@property (nonatomic, assign) CGFloat lineWith;

@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, strong) NSMutableArray *pointArray;

- (void)clearAll;

@end
