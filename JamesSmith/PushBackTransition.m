//
//  PushBackTransition.m
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import "PushBackTransition.h"

@implementation PushBackTransition

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    // Gather Information from the context
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    // To View Controller
    CGRect to_FinalFrame = [transitionContext finalFrameForViewController:toVC];
    CGFloat delta = 40.0;
    CGRect to_initialFrame = CGRectInset(to_FinalFrame, delta, delta);
    UIView *fake_toView = [toVC.view snapshotViewAfterScreenUpdates:YES];
    fake_toView.contentMode = UIViewContentModeScaleAspectFit;
    [containerView insertSubview:fake_toView belowSubview:fromVC.view];
    fake_toView.frame = to_initialFrame;
    fake_toView.alpha = 0.4;
    
    // From View Controller
    CGRect from_FinalFrame = CGRectMake(containerView.bounds.size.width * 1.5, fromVC.view.frame.origin.y, fromVC.view.frame.size.width, fromVC.view.frame.size.height);
    
    // Animate final View States
    [UIView animateWithDuration:duration animations:^{
        fromVC.view.frame = from_FinalFrame;
        fake_toView.frame = to_FinalFrame;
        fake_toView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [containerView addSubview:toVC.view];
        toVC.view.frame = to_FinalFrame;
        [fake_toView removeFromSuperview];
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}

@end
