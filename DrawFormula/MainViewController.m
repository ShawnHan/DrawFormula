//
//  DetailViewController.m
//  DrawFormula
//
//  Created by hanlong on 15/12/11.
//  Copyright © 2015年 hanlong. All rights reserved.
//

#import "MainViewController.h"
#import "DrawView.h"

@interface MainViewController ()<UIDynamicAnimatorDelegate>

@property (nonatomic, strong) DrawView *drawView;

@property (nonatomic, strong) NSArray *pathArray;

@property (nonatomic, strong) UILabel *resultLabel;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请输入数字";
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(rightBarBthAction)];
    clearItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = clearItem;
    
    UIBarButtonItem *calcu = [[UIBarButtonItem alloc] initWithTitle:@"Fx=" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarAction)];
    calcu.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = calcu;
    [self.view addSubview:self.drawView];
    [self.view addSubview:self.resultLabel];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)rightBarBthAction
{
    [self.drawView clearAll];
    self.resultLabel.hidden = YES;
}

- (void)leftBarAction
{
    [self screenShot];
    self.pathArray = self.drawView.pointArray;
    NSLog(@"pathArray = %@", self.pathArray);
}

//截图并且发送图片
- (void)screenShot
{
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(screenShot, 0.3);
    NSDictionary *dicParam = @{@"data": imageData};
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSString *url = @"https://cet-dev.uda100.com/cet/api/formula";
    
    [MBProgressHUD showMessage:@"计算中..." toView:self.navigationController.view];
    
    [mgr POST:url parameters:dicParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:dicParam[@"data"] name:@"file" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation,  id responseObject) {
        NSLog(@"%@, %@", operation.response, responseObject);
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        [self.drawView clearAll];
        self.resultLabel.hidden = NO;
        self.resultLabel.text = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"data"]];
        self.resultLabel.frame = CGRectZero;
        
        //显示结果的动画
        UIViewAnimationOptions op = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState;
        [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
            //_view.layer.transformScale = 0.97;
            _resultLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 50);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
                _resultLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
                     _resultLabel.frame = self.view.bounds;
                } completion:NULL];
            }];
        }];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view];
    }];
}

//旋转屏幕
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.drawView.frame = self.view.bounds;
    _resultLabel.frame = self.view.bounds;
}

#pragma mark - lazy load
- (DrawView *)drawView
{
	if(_drawView == nil) {
		_drawView = [[DrawView alloc] init];
        _drawView.frame = self.view.bounds;
	}
	return _drawView;
}

- (UILabel *)resultLabel {
	if(_resultLabel == nil) {
		_resultLabel = [[UILabel alloc] init];
        _resultLabel.frame = self.view.bounds;
        _resultLabel.hidden = YES;
        _resultLabel.font = [UIFont systemFontOfSize:50];
        _resultLabel.numberOfLines = 0;
        _resultLabel.textColor = [UIColor blackColor];
        _resultLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _resultLabel;
}

@end
