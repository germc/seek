//
//  PanInteractiveTransitionController.h
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

@import UIKit;

@interface PanInteractiveTransitionController : UIPercentDrivenInteractiveTransition

@property(nonatomic, assign)BOOL interactionInProgress;

-(void)attachToViewController:(UIViewController *)viewController;

@end
