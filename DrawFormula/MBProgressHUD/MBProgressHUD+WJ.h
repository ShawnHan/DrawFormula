//
//  MBProgressHUD+WJ.h
//  优答
//
//  Created by weijia on 14/12/18.
//  Copyright (c) 2014年 微学明日. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (WJ)

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)showSuccess:(NSString *)success;

+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (MBProgressHUD *)showMessage:(NSString *)message duration:(NSTimeInterval)seconds;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view duration:(NSTimeInterval)seconds;

+ (void)hideHUDForView:(UIView *)view;

+ (void)hideHUD;

@end
