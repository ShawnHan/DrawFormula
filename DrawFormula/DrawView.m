//
//  DrawView.m
//  DrawFormula
//
//  Created by hanlong on 15/12/11.
//  Copyright © 2015年 hanlong. All rights reserved.
//

#import "DrawView.h"
#import "DrawModel.h"

@interface DrawView ()

@property (nonatomic, assign) CGMutablePathRef path;

@property (nonatomic, strong) NSMutableArray *pathArray;

@property (nonatomic, assign) BOOL isHavePath;

@property (nonatomic, assign) CGRect rect;

@end

@implementation DrawView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = YDColor(243, 248, 249);
        self.lineWith = 5.f;
        self.lineColor = [UIColor blackColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawView:context];
}

- (void)drawView:(CGContextRef)context
{
    for (DrawModel *model in self.pathArray) {
        CGContextAddPath(context, model.path.CGPath);
        [model.color set];
        CGContextSetLineWidth(context, model.width);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextDrawPath(context, kCGPathStroke);
    }
    if (_isHavePath) {
        CGContextAddPath(context, self.path);
        [_lineColor set];
        CGContextSetLineWidth(context, self.lineWith);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextDrawPath(context, kCGPathStroke);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    self.path = CGPathCreateMutable();
    _isHavePath = YES;
    CGPathMoveToPoint(self.path, NULL, location.x, location.y);
    [self addPoints:location];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPathAddLineToPoint(self.path, NULL, location.x, location.y);
    [self addPoints:location];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.pathArray == nil) {
        self.pathArray = [NSMutableArray array];
    }
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    [self addPoints:location];

    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:self.path];
    DrawModel *model = [DrawModel viewModelWithColor:self.lineColor Path:path Width:self.lineWith];
    [self.pathArray addObject:model];
    
    CGPathRelease(self.path);
    _isHavePath = NO;
}

- (void)clearAll
{
    [self.pathArray removeAllObjects];
    [self.pointArray removeAllObjects];
    [self setNeedsDisplay];
}

- (void)addPoints:(CGPoint)location
{
    [self.pointArray addObject:[NSString stringWithFormat:@"%.f, %.f",location.x, location.y]];
    NSLog(@"pointArray == %@",self.pointArray);
}

#pragma mark - lazy load
- (NSMutableArray *)pointArray {
	if(_pointArray == nil) {
		_pointArray = [[NSMutableArray alloc] init];
	}
	return _pointArray;
}

@end
