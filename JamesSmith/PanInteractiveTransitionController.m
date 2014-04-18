//
//  PanInteractiveTransitionController.m
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import "PanInteractiveTransitionController.h"

@implementation PanInteractiveTransitionController {
    BOOL _shouldCompleteTransition;
    UINavigationController *_navigationController;
}

-(void)attachToViewController:(UIViewController *)viewController {
    _navigationController = viewController.navigationController;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(panned:)];
    //pan.edges = UIRectEdgeLeft;
    [viewController.view addGestureRecognizer:pan];
}

-(CGFloat)completionSpeed {
    return 0.5;
}

-(void)panned:(UIPanGestureRecognizer *)pan {
    CGPoint translationInView = [pan translationInView:pan.view.superview];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            self.interactionInProgress = YES;
            [_navigationController popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged: {
            
            CGFloat fraction = (translationInView.x / 450);
            fraction = fminf(fmaxf(fraction, 0.0), 1.0);
            
            _shouldCompleteTransition = (fraction > 0.3);
            
            [self updateInteractiveTransition:fraction];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            self.interactionInProgress = NO;
            
            if (!_shouldCompleteTransition || pan.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            }
            else {
                [self finishInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}


@end
