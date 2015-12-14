//
//  DrawModel.m
//  DrawFormula
//
//  Created by hanlong on 15/12/11.
//  Copyright © 2015年 hanlong. All rights reserved.
//

#import "DrawModel.h"

@implementation DrawModel

+ (id)viewModelWithColor:(UIColor *)color Path:(UIBezierPath *)path Width:(CGFloat)width
{
    DrawModel *drawModel = [[DrawModel alloc] init];
    
    drawModel.color = color;
    drawModel.path = path;
    drawModel.width = width;
    
    return drawModel;
}

@end
