//
//  ViewController.m
//  AnamationGroup
//
//  Created by 阳永辉 on 16/3/8.
//  Copyright © 2016年 HuiDe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    CALayer * _layer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *backgroupImage = [UIImage imageNamed:@"background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroupImage];
    
    _layer = [[CALayer alloc] init];
    _layer.bounds = CGRectMake(0, 0, 10, 20);
    _layer.position = CGPointMake(50, 150);
    _layer.contents = (id)[UIImage imageNamed:@"greenPin.png"].CGImage;
    [self.view.layer addSublayer:_layer];
    
    [self groupAnimation];
}

- (CABasicAnimation *)rotaionAnimation {
    CABasicAnimation *basicAniamtion = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    CGFloat tovalue = M_PI_2 *3;
    basicAniamtion.toValue = [NSNumber numberWithFloat:M_PI_2*3];
    
    basicAniamtion.autoreverses = true;
    basicAniamtion.repeatCount = HUGE_VALF;
    basicAniamtion.removedOnCompletion = NO;
    [basicAniamtion setValue:[NSNumber numberWithFloat:tovalue] forKey:@"KCBasicAnimationProperty.ToValue"];
    return basicAniamtion;
}

- (CAKeyframeAnimation *)translationAnimation {
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGPoint endPoint = CGPointMake(55, 400);
    CGPathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, _layer.position.x, _layer.position.y);
    CGPathAddCurveToPoint(path, NULL, 160, 280, -30,300, endPoint.x, endPoint.y);
    keyframeAnimation.path = path;
    CGPathRelease(path);
    
    [keyframeAnimation setValue:[NSValue valueWithCGPoint:endPoint] forKey:@"KCKeyframeAnimationProperty_EndPositon"];
    return keyframeAnimation;
}

- (void)groupAnimation {
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    
    CABasicAnimation *basicAnimation = [self rotaionAnimation];
    CAKeyframeAnimation *keyframeAnimation = [self translationAnimation];
    animationGroup.animations = @[basicAnimation,keyframeAnimation];
    
    animationGroup.delegate =self;
    animationGroup.duration = 10.0;
    animationGroup.beginTime = CACurrentMediaTime() + 5;
    [_layer addAnimation:animationGroup forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CAAnimationGroup *animationGroup = (CAAnimationGroup *)anim;
    CABasicAnimation *basicAnimation = animationGroup.animations[0];
    CAKeyframeAnimation *keyframeAnimaton = animationGroup.animations[1];
    CGFloat toValue = [[basicAnimation valueForKey:@"KCBasicAnimationProperty_ToValue"] floatValue];
    
    CGPoint endPoint = [[keyframeAnimaton valueForKey:@"KCKeyframeAnimationProperty_EndPosition"]CGPointValue];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    _layer.position = endPoint;
    _layer.transform = CATransform3DMakeRotation(toValue, 0, 0, 1);
    [CATransaction commit];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
