//
//  SlideMenuController.m
//  EnglishConversation
//
//  Created by SongJiang on 3/3/16.
//  Copyright © 2016 David. All rights reserved.
//

#import "PSlideMenuController.h"
#import "PSlideMenuOptions.h"
#import "PLeftPanState.h"
#import "PRightPanState.h"

@implementation PSlideMenuController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [super initWithCoder:aDecoder];
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (instancetype)init:(UIViewController*)mainViewController leftMenuViewController:(UIViewController*)leftMenuViewController{
    self = [super init];
    self.mainViewController = mainViewController;
    self.leftViewController = leftMenuViewController;
    [self initView];
    return self;
}

- (instancetype)init:(UIViewController*)mainViewController rightMenuViewController:(UIViewController*)rightMenuViewController{
    self = [self init];
    self.mainViewController = mainViewController;
    self.rightViewController = rightMenuViewController;
    [self initView];
    return self;
}

- (instancetype)init:(UIViewController*)mainViewController leftMenuViewController:(UIViewController*)leftMenuViewController rightMenuViewController:(UIViewController*)rightMenuViewController{
    self = [self init];
    self.mainViewController = mainViewController;
    self.leftViewController = leftMenuViewController;
    self.rightViewController = rightMenuViewController;
    [self initView];
    return self;
}

- (void) initView{
    self.mainContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.mainContainerView.backgroundColor = [UIColor clearColor];
    self.mainContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:self.mainContainerView atIndex:0];
    
    CGRect opacityframe = self.view.bounds;
    CGFloat opacityOffset = 0;
    opacityframe.origin.y = opacityframe.origin.y + opacityOffset;
    opacityframe.size.height = opacityframe.size.height - opacityOffset;
    self.opacityView = [[UIView alloc] initWithFrame:opacityframe];
    self.opacityView.backgroundColor = [PSlideMenuOptions sharedInstance].opacityViewBackgroundColor;
    self.opacityView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.opacityView.layer.opacity = 0.0;
    [self.view insertSubview:self.opacityView atIndex:1];
    
    CGRect leftFrame = self.view.bounds;
    leftFrame.size.width = [PSlideMenuOptions sharedInstance].leftViewWidth;
    leftFrame.origin.x = [self leftMinOrigin];
    CGFloat leftOffset = 0;
    leftFrame.origin.y = leftFrame.origin.y + leftOffset;
    leftFrame.size.height = leftFrame.size.height - leftOffset;
    self.leftContainerView = [[UIView alloc] initWithFrame:leftFrame];
    self.leftContainerView.backgroundColor = [UIColor clearColor];
    self.leftContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:self.leftContainerView atIndex:2];
    
    CGRect rightFrame = self.view.bounds;
    rightFrame.size.width = [PSlideMenuOptions sharedInstance].rightViewWidth;
    rightFrame.origin.x = [self rightMinOrigin];
    CGFloat rightOffset = 0;
    rightFrame.origin.y = rightFrame.origin.y + rightOffset;
    rightFrame.size.height = rightFrame.size.height - rightOffset;
    self.rightContainerView = [[UIView alloc] initWithFrame:rightFrame];
    self.rightContainerView.backgroundColor = [UIColor clearColor];
    self.rightContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:self.rightContainerView atIndex:3];
    
    [self addLeftGestures];
    [self addRightGestures];
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    self.mainContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    self.leftContainerView.hidden = YES;
    self.rightContainerView.hidden = YES;
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self closeLeftNonAnimation];
        [self closeRightNonAnimation];
        self.leftContainerView.hidden = NO;
        self.rightContainerView.hidden = NO;
        if (self.leftPanGesture != nil && self.leftTapGesture != nil) {
            [self removeLeftGestures];
            [self addLeftGestures];
        }
        if (self.rightPanGesture != nil && self.rightTapGesture != nil) {
            [self removeRightGestures];
            [self addRightGestures];
        }
    }];
}

- (void) viewDidLoad{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations{
    if (self.mainViewController) {
        return [self.mainViewController supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskAll;
}

- (void) viewWillLayoutSubviews{
    [self setUpViewController:self.mainContainerView targetViewController:self.mainViewController];
    [self setUpViewController:self.leftContainerView targetViewController:self.leftViewController];
    [self setUpViewController:self.rightContainerView targetViewController:self.rightViewController];
}

- (void) openLeft{
    [self setOpenWindowLevel];
    
    [self.leftViewController beginAppearanceTransition:[self isLeftHidden] animated:YES];
    [self openLeftWithVelocity:0.0];
    
    [self track:TapOpen];
}

- (void) openRight{
    [self setOpenWindowLevel];
    
    [self.rightViewController beginAppearanceTransition:[self isRightHidden] animated:YES];
    [self openRightWithVelocity:0.0];
}

- (void) closeLeft{
    [self.leftViewController beginAppearanceTransition:[self isLeftHidden] animated:YES];
    [self closeLeftWithVelocity:0.0];
    [self setCloseWindowLevel];
}

- (void) closeRight{
    [self.rightViewController beginAppearanceTransition:[self isRightHidden] animated:YES];
    [self closeRightWithVelocity:0.0];
    [self setCloseWindowLevel];
}

- (void) addLeftGestures{
    if (self.leftViewController != nil) {
        if (self.leftPanGesture == nil) {
            self.leftPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftPanGesture:)];
            self.leftPanGesture.delegate = self;
            [self.view addGestureRecognizer:self.leftPanGesture];
        }
        
        if (self.leftTapGesture == nil) {
            self.leftTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleLeft)];
            self.leftTapGesture.delegate = self;
            [self.view addGestureRecognizer:self.leftTapGesture];
        }
    }
}

- (void) addRightGestures{
    if (self.rightViewController != nil) {
        if (self.rightPanGesture == nil) {
            self.rightPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightPanGesture:)];
            self.rightPanGesture.delegate = self;
            [self.view addGestureRecognizer:self.rightPanGesture];
        }
        
        if (self.rightTapGesture == nil) {
            self.rightTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleRight)];
            self.rightTapGesture.delegate = self;
            [self.view addGestureRecognizer:self.rightTapGesture];
        }
    }
}

- (void) removeLeftGestures{
    if (self.leftPanGesture != nil) {
        [self.view removeGestureRecognizer:self.leftPanGesture];
        self.leftPanGesture = nil;
    }
    
    if (self.leftTapGesture != nil) {
        [self.view removeGestureRecognizer:self.leftTapGesture];
        self.leftTapGesture = nil;
    }
}

- (void) removeRightGestures{
    if (self.rightPanGesture != nil) {
        [self.view removeGestureRecognizer:self.rightPanGesture];
        self.rightPanGesture = nil;
    }
    
    if (self.rightTapGesture != nil) {
        [self.view removeGestureRecognizer:self.rightTapGesture];
        self.rightTapGesture = nil;
    }
}

- (bool) isTargetViewController{
    return YES;
}

- (void) track:(TrackAction) trackAction{
    
}

- (void) handleLeftPanGesture:(UIPanGestureRecognizer*)panGesture{
    if (![self isTargetViewController]) {
        return;
    }
    if ([self isRightOpen]) {
        return;
    }
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            [PLeftPanState sharedInstance].frameAtStartOfPan = self.leftContainerView.frame;
            [PLeftPanState sharedInstance].startPointOfPan = [panGesture locationInView:self.view];
            [PLeftPanState sharedInstance].wasOpenAtStartOfPan = [self isLeftOpen];
            [PLeftPanState sharedInstance].wasHiddenAtStartOfPan = [self isLeftHidden];
            
            [self.leftViewController beginAppearanceTransition:[PLeftPanState sharedInstance].wasHiddenAtStartOfPan animated:YES];
            [self addShadowToView:self.leftContainerView];
            [self setOpenWindowLevel];
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGesture translationInView:panGesture.view];
            self.leftContainerView.frame = [self applyLeftTranslation:translation toFrame:[PLeftPanState sharedInstance].frameAtStartOfPan];
            [self applyLeftOpacity];
            [self applyLeftContentViewScale];
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint velocity = [panGesture velocityInView:panGesture.view];
            PanInfo panInfo = [self panLeftResultInfoForVelocity:velocity];
            if (panInfo.actionSlide == OPEN) {
                if (![PLeftPanState sharedInstance].wasHiddenAtStartOfPan) {
                    [self.leftViewController beginAppearanceTransition:YES animated:YES];
                }
                [self openLeftWithVelocity:panInfo.velocity];
                [self track:FlickOpen];
            } else {
                if ([PLeftPanState sharedInstance].wasHiddenAtStartOfPan) {
                    [self.leftViewController beginAppearanceTransition:NO animated:YES];
                }
                [self closeLeftWithVelocity:panInfo.velocity];
                [self setCloseWindowLevel];
                [self track:FlickClose];
            }
        }
            
        default:
            break;
    }
}

- (void) handleRightPanGesture:(UIPanGestureRecognizer*)panGesture{
    if (![self isTargetViewController]) {
        return;
    }
    if ([self isLeftOpen]) {
        return;
    }
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            [PRightPanState sharedInstance].frameAtStartOfPan = self.rightContainerView.frame;
            [PRightPanState sharedInstance].startPointOfPan = [panGesture locationInView:self.view];
            [PRightPanState sharedInstance].wasOpenAtStartOfPan = [self isRightOpen];
            [PRightPanState sharedInstance].wasHiddenAtStartOfPan = [self isRightHidden];
            
            [self.rightViewController beginAppearanceTransition:[PRightPanState sharedInstance].wasHiddenAtStartOfPan animated:YES];
            [self addShadowToView:self.rightContainerView];
            [self setOpenWindowLevel];
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGesture translationInView:panGesture.view];
            self.rightContainerView.frame = [self applyRightTranslation:translation toFrame:[PRightPanState sharedInstance].frameAtStartOfPan];
            [self applyRightOpactiy];
            [self applyRightContentViewScale];
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint velocity = [panGesture velocityInView:panGesture.view];
            PanInfo panInfo = [self panRightResultInfoForVelocity:velocity];
            if (panInfo.actionSlide == OPEN) {
                if (![PRightPanState sharedInstance].wasHiddenAtStartOfPan) {
                    [self.rightViewController beginAppearanceTransition:YES animated:YES];
                }
                [self openRightWithVelocity:panInfo.velocity];
            } else {
                if ([PRightPanState sharedInstance].wasHiddenAtStartOfPan) {
                    [self.rightViewController beginAppearanceTransition:NO animated:YES];
                }
                [self closeRightWithVelocity:panInfo.velocity];
                [self setCloseWindowLevel];
            }
        }
            
        default:
            break;
    }
}

- (void) openLeftWithVelocity:(CGFloat)velocity{
    CGFloat xOrigin = self.leftContainerView.frame.origin.x;
    CGFloat finalXOrigin = 0.0;
    
    CGRect frame = self.leftContainerView.frame;
    frame.origin.x = finalXOrigin;
    
    NSTimeInterval duration = [PSlideMenuOptions sharedInstance].animationDuration;
    if (velocity != 0.0) {
        duration = fabs(xOrigin - finalXOrigin) / velocity;
        duration = fmax(0.1, fmin(1.0, duration));
    }
    
    [self addShadowToView:self.leftContainerView];
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self) {
            self.leftContainerView.frame = frame;
            self.opacityView.layer.opacity = [PSlideMenuOptions sharedInstance].contentViewOpacity;
            self.mainContainerView.transform = CGAffineTransformMakeScale([PSlideMenuOptions sharedInstance].contentViewScale, [PSlideMenuOptions sharedInstance].contentViewScale);
        }
    } completion:^(BOOL finished) {
        if (self) {
            [self disableContentInteraction];
            [self.leftViewController endAppearanceTransition];
        }
    }];
}


- (void) openRightWithVelocity:(CGFloat)velocity{
    CGFloat xOrigin = self.rightContainerView.frame.origin.x;
    CGFloat finalXOrigin = CGRectGetWidth(self.view.bounds) - self.rightContainerView.frame.size.width;
    
    CGRect frame = self.rightContainerView.frame;
    frame.origin.x = finalXOrigin;
    
    NSTimeInterval duration = [PSlideMenuOptions sharedInstance].animationDuration;
    if (velocity != 0.0) {
        duration = fabs(xOrigin - CGRectGetWidth(self.view.bounds)) / velocity;
        duration = fmax(0.1, fmin(1.0, duration));
    }
    
    [self addShadowToView:self.rightContainerView];
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self) {
            self.rightContainerView.frame = frame;
            self.opacityView.layer.opacity = [PSlideMenuOptions sharedInstance].contentViewOpacity;
            self.mainContainerView.transform = CGAffineTransformMakeScale([PSlideMenuOptions sharedInstance].contentViewScale, [PSlideMenuOptions sharedInstance].contentViewScale);
        }
    } completion:^(BOOL finished) {
        if (self) {
            [self disableContentInteraction];
            [self.rightViewController endAppearanceTransition];
        }
    }];
}

- (void) closeLeftWithVelocity:(CGFloat) velocity{
    CGFloat xOrigin = self.leftContainerView.frame.origin.x;
    CGFloat finalXOrigin = [self leftMinOrigin];
    
    CGRect frame = self.leftContainerView.frame;
    frame.origin.x = finalXOrigin;
    
    NSTimeInterval duration = [PSlideMenuOptions sharedInstance].animationDuration;
    if (velocity != 0.0) {
        duration = fabs(xOrigin - finalXOrigin) / velocity;
        duration = fmax(0.1, fmin(1.0, duration));
    }
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self) {
            self.leftContainerView.frame = frame;
            self.opacityView.layer.opacity = 0.0;
            self.mainContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }
    } completion:^(BOOL finished) {
        if (self) {
            [self removeShadow:self.leftContainerView];
            [self enableContentInteraction];
            [self.leftViewController endAppearanceTransition];
        }
    }];
}

- (void) closeRightWithVelocity:(CGFloat) velocity{
    CGFloat xOrigin = self.rightContainerView.frame.origin.x;
    CGFloat finalXOrigin = CGRectGetWidth(self.view.bounds);
    
    CGRect frame = self.rightContainerView.frame;
    frame.origin.x = finalXOrigin;
    
    NSTimeInterval duration = [PSlideMenuOptions sharedInstance].animationDuration;
    if (velocity != 0.0) {
        duration = fabs(xOrigin - CGRectGetWidth(self.view.bounds)) / velocity;
        duration = fmax(0.1, fmin(1.0, duration));
    }
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self) {
            self.rightContainerView.frame = frame;
            self.opacityView.layer.opacity = 0.0;
            self.mainContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }
    } completion:^(BOOL finished) {
        if (self) {
            [self removeShadow:self.rightContainerView];
            [self enableContentInteraction];
            [self.rightViewController endAppearanceTransition];
        }
    }];
}

- (void) toggleLeft{
    if ([self isLeftOpen]) {
        [self closeLeft];
        [self setCloseWindowLevel];
        
        [self track:TapClose];
    } else {
        [self openLeft];
    }
}

- (bool) isLeftOpen{
    return self.leftContainerView.frame.origin.x == 0.0;
}

- (bool) isLeftHidden{
    return self.leftContainerView.frame.origin.x <= [self leftMinOrigin];
}

- (void) toggleRight{
    if ([self isRightOpen]) {
        [self closeRight];
        [self setCloseWindowLevel];
    } else {
        [self openRight];
    }
}

- (bool) isRightOpen{
    return self.rightContainerView.frame.origin.x == CGRectGetWidth(self.view.bounds) - self.rightContainerView.frame.size.width;
}

- (bool) isRightHidden{
    return self.rightContainerView.frame.origin.x >= CGRectGetWidth(self.view.bounds);
}

- (void) changeMainViewController:(UIViewController*)mainViewController close:(bool) close{
    [self removeViewController:self.mainViewController];
    self.mainViewController = mainViewController;
    [self setUpViewController:self.mainContainerView targetViewController:mainViewController];
    if (close) {
        [self closeLeft];
        [self closeRight];
    }
}

- (void) changeLeftViewWidth:(CGFloat) width{
    [PSlideMenuOptions sharedInstance].leftViewWidth = width;
    CGRect leftFrame = self.view.bounds;
    leftFrame.size.width = width;
    leftFrame.origin.x = [self leftMinOrigin];
    CGFloat leftOffset = 0;
    leftFrame.origin.y = leftFrame.origin.y + leftOffset;
    leftFrame.size.height = leftFrame.size.height - leftOffset;
    self.leftContainerView.frame = leftFrame;
}

- (void) changeRightViewWidth:(CGFloat) width{
    [PSlideMenuOptions sharedInstance].rightBezelWidth = width;
    CGRect rightFrame = self.view.bounds;
    rightFrame.size.width = width;
    rightFrame.origin.x = [self rightMinOrigin];
    CGFloat rightOffset = 0;
    rightFrame.origin.y = rightFrame.origin.y + rightOffset;
    rightFrame.size.height = rightFrame.size.height - rightOffset;
    self.rightContainerView.frame = rightFrame;
}

- (void) changeLeftViewController:(UIViewController*)leftViewController closeLeft:(bool)closeLeft{
    [self removeViewController:self.leftViewController];
    self.leftViewController = leftViewController;
    [self setUpViewController:self.leftContainerView targetViewController:self.leftViewController];
    if(closeLeft){
        [self closeLeft];
    }
}

- (void) changeRightViewController:(UIViewController*)rightViewController closeRight:(bool)closeRight{
    [self removeViewController:self.rightViewController];
    self.rightViewController = rightViewController;
    [self setUpViewController:self.rightContainerView targetViewController:rightViewController];
    if (closeRight) {
        [self closeRight];
    }
}

- (CGFloat)leftMinOrigin{
    return -[PSlideMenuOptions sharedInstance].leftViewWidth;
}

- (CGFloat)rightMinOrigin{
    return CGRectGetWidth(self.view.bounds);
}

- (PanInfo)panLeftResultInfoForVelocity:(CGPoint)velocity{
    CGFloat thresholdVelocity = 1000.0;
    CGFloat pointOfNoReture = floor([self leftMinOrigin]) + [PSlideMenuOptions sharedInstance].pointOfNoReturnWidth;
    CGFloat leftOrigin = self.leftContainerView.frame.origin.x;
    PanInfo panInfo;
    panInfo.actionSlide = CLOSE;
    panInfo.shouldBounce = NO;
    panInfo.velocity = 0.0;
    panInfo.actionSlide = leftOrigin <= pointOfNoReture ? CLOSE : OPEN;
    if (velocity.x >= thresholdVelocity) {
        panInfo.actionSlide = OPEN;
        panInfo.velocity = velocity.x;
    } else if (velocity.x <= (-1.0 * thresholdVelocity)) {
        panInfo.actionSlide = CLOSE;
        panInfo.velocity = velocity.x;
    }
    
    return panInfo;
}

- (PanInfo)panRightResultInfoForVelocity:(CGPoint) velocity{
    CGFloat thresholdVelocity = -1000.0;
    CGFloat pointOfNoReture = floor(CGRectGetWidth(self.view.bounds)) - [PSlideMenuOptions sharedInstance].pointOfNoReturnWidth;
    CGFloat rightOrigin = self.rightContainerView.frame.origin.x;
    PanInfo panInfo;
    panInfo.actionSlide = CLOSE;
    panInfo.shouldBounce = NO;
    panInfo.velocity = 0.0;
    panInfo.actionSlide = rightOrigin >= pointOfNoReture ? CLOSE : OPEN;
    if (velocity.x <= thresholdVelocity) {
        panInfo.actionSlide = OPEN;
        panInfo.velocity = velocity.x;
    } else if (velocity.x >= (-1.0 * thresholdVelocity)) {
        panInfo.actionSlide = CLOSE;
        panInfo.velocity = velocity.x;
    }
    return panInfo;
}

- (CGRect) applyLeftTranslation:(CGPoint) translation toFrame:(CGRect) toFrame{
    CGFloat newOrigin = toFrame.origin.x;
    newOrigin += translation.x;
    
    CGFloat minOrigin = [self leftMinOrigin];
    CGFloat maxOrigin = 0;
    CGRect newFrame = toFrame;
    
    if (newOrigin < minOrigin) {
        newOrigin = minOrigin;
    } else if (newOrigin > maxOrigin) {
        newOrigin = maxOrigin;
    }
    
    newFrame.origin.x = newOrigin;
    return newFrame;
}

- (CGRect) applyRightTranslation:(CGPoint) translation toFrame:(CGRect) toFrame{
    CGFloat newOrigin = toFrame.origin.x;
    newOrigin += translation.x;
    
    CGFloat minOrigin = [self rightMinOrigin];
    CGFloat maxOrigin = [self rightMinOrigin] - self.rightContainerView.frame.size.width;
    CGRect newFrame = toFrame;
    
    if (newOrigin > minOrigin) {
        newOrigin = minOrigin;
    } else if (newOrigin < maxOrigin) {
        newOrigin = maxOrigin;
    }
    
    newFrame.origin.x = newOrigin;
    return newFrame;
}

- (CGFloat) getOpenedLeftRatio{
    CGFloat width = self.leftContainerView.frame.size.width;
    CGFloat currentPosition = self.leftContainerView.frame.origin.x - [self leftMinOrigin];
    return currentPosition / width;
}

-(CGFloat) getOpenedRightRatio{
    CGFloat width = self.rightContainerView.frame.size.width;
    CGFloat currentPosition = self.rightContainerView.frame.origin.x;
    return -(currentPosition - CGRectGetWidth(self.view.bounds)) / width;
}

- (void) applyLeftOpacity{
    CGFloat openedLeftRatio = [self getOpenedLeftRatio];
    CGFloat opacity = [PSlideMenuOptions sharedInstance].contentViewOpacity * openedLeftRatio;
    self.opacityView.layer.opacity = opacity;
}

- (void) applyRightOpactiy{
    CGFloat openedRightRatio = [self getOpenedRightRatio];
    CGFloat opacity = [PSlideMenuOptions sharedInstance].contentViewOpacity * openedRightRatio;
    self.opacityView.layer.opacity = opacity;
}

- (void) applyLeftContentViewScale{
    CGFloat openedLeftRatio = [self getOpenedLeftRatio];
    CGFloat scale = 1.0 - ((1.0 - [PSlideMenuOptions sharedInstance].contentViewScale) * openedLeftRatio);
    self.mainContainerView.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void) applyRightContentViewScale{
    CGFloat openedRightRatio = [self getOpenedRightRatio];
    CGFloat scale = 1.0 - ((1.0 - [PSlideMenuOptions sharedInstance].contentViewScale) * openedRightRatio);
    self.mainContainerView.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void) addShadowToView:(UIView*) targetContainerView{
    targetContainerView.layer.masksToBounds = NO;
    targetContainerView.layer.shadowOffset = [PSlideMenuOptions sharedInstance].shadowOffset;
    targetContainerView.layer.shadowOpacity = [PSlideMenuOptions sharedInstance].shadowOpacity;
    targetContainerView.layer.shadowRadius = [PSlideMenuOptions sharedInstance].shadowRadius;
    targetContainerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:targetContainerView.bounds].CGPath;
}


- (void) removeShadow:(UIView*) targetContainerView{
    targetContainerView.layer.masksToBounds = true;
    self.mainContainerView.layer.opacity = 1.0;
}

- (void) removeContentOpacity{
    self.opacityView.layer.opacity = 0.0;
}

- (void) addContentOpacity {
    self.opacityView.layer.opacity = [PSlideMenuOptions sharedInstance].contentViewOpacity;
}

- (void) disableContentInteraction {
    self.mainContainerView.userInteractionEnabled = NO;
}
- (void) enableContentInteraction {
    self.mainContainerView.userInteractionEnabled = YES;
}

- (void) setOpenWindowLevel {
    if ([PSlideMenuOptions sharedInstance].hideStatusBar) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([UIApplication sharedApplication].keyWindow) {
//                [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelStatusBar + 1;
                [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelNormal;

            }
        });
    }
}

- (void) setCloseWindowLevel {
    if ([PSlideMenuOptions sharedInstance].hideStatusBar) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([UIApplication sharedApplication].keyWindow) {
                [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelNormal;
            }
        });
    }
}

- (void) setUpViewController:(UIView*)targetView targetViewController:(UIViewController*) targetViewController{
    if (targetViewController) {
        [self addChildViewController:targetViewController];
        targetViewController.view.frame = targetView.bounds;
        [targetView addSubview:targetViewController.view];
        [targetViewController didMoveToParentViewController:self];
    }
}

- (void) removeViewController:(UIViewController*) viewController{
    if (viewController) {
        [viewController.view.layer removeAllAnimations];
        [viewController willMoveToParentViewController:nil];
        [viewController.view removeFromSuperview];
        [viewController removeFromParentViewController];
    }
}

- (void) closeLeftNonAnimation{
    [self setCloseWindowLevel];
    CGFloat finalXOrigin = [self leftMinOrigin];
    CGRect frame = self.leftContainerView.frame;
    frame.origin.x = finalXOrigin;
    self.leftContainerView.frame = frame;
    self.opacityView.layer.opacity = 0.0;
    self.mainContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [self removeShadow:self.leftContainerView];
    [self enableContentInteraction];
}

- (void) closeRightNonAnimation{
    [self setCloseWindowLevel];
    CGFloat finalXOrigin = CGRectGetWidth(self.view.bounds);
    CGRect frame = self.rightContainerView.frame;
    frame.origin.x = finalXOrigin;
    self.rightContainerView.frame = frame;
    self.opacityView.layer.opacity = 0.0;
    self.mainContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [self removeShadow:self.rightContainerView];
    [self enableContentInteraction];
}

// MARK: UIGestureRecognizerDelegate
- (BOOL) gestureRecognizer:(UIGestureRecognizer*) gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch{
    CGPoint point = [touch locationInView:self.view];
    if (gestureRecognizer == self.leftPanGesture) {
        return [self slideLeftForGestureRecognizer:gestureRecognizer point:point];
    } else if (gestureRecognizer == self.rightPanGesture){
        return [self slideRightViewForGestureRecognizer:gestureRecognizer point:point];
    } else if (gestureRecognizer == self.leftTapGesture){
        return [self isLeftOpen] && ![self isPointContainedWithinLeftRect:point];
    } else if (gestureRecognizer == self.rightTapGesture){
        return [self isRightOpen] && ![self isPointContainedWithinRightRect:point];
    }
    return YES;
}

// returning true here helps if the main view is fullwidth with a scrollview
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return [PSlideMenuOptions sharedInstance].simultaneousGestureRecognizers;
}

- (BOOL) slideLeftForGestureRecognizer:(UIGestureRecognizer*)gesture point:(CGPoint)point{
    return [self isLeftOpen] || ([PSlideMenuOptions sharedInstance].panFromBezel && [self isLeftPointContainedWithinBezelRect:point]);
}


- (bool) isLeftPointContainedWithinBezelRect:(CGPoint)point{
    CGFloat bezelWidth = [PSlideMenuOptions sharedInstance].leftBezelWidth;
    if (bezelWidth) {
        CGRect leftBezelRect = CGRectZero;
        CGRect tempRect = CGRectZero;
        CGRectDivide(self.view.bounds, &leftBezelRect, &tempRect, bezelWidth, CGRectMinXEdge);
        return CGRectContainsPoint(leftBezelRect, point);
    } else {
        return YES;
    }
}


- (bool) isPointContainedWithinLeftRect:(CGPoint) point{
    return CGRectContainsPoint(self.leftContainerView.frame, point);
}

- (bool) slideRightViewForGestureRecognizer:(UIGestureRecognizer*)gesture point:(CGPoint)point{
    return [self isRightOpen] || ([PSlideMenuOptions sharedInstance].rightPanFromBezel && [self isRightPointContainedWithinBezelRect:point]);
}


- (bool) isRightPointContainedWithinBezelRect:(CGPoint)point{
    CGFloat rightBezelWidth = [PSlideMenuOptions sharedInstance].rightBezelWidth;
    if (rightBezelWidth) {
        CGRect rightBezelRect = CGRectZero;
        CGRect tempRect = CGRectZero;
        CGFloat bezelWidth = CGRectGetWidth(self.view.bounds) - rightBezelWidth;
        CGRectDivide(self.view.bounds, &tempRect, &rightBezelRect, bezelWidth, CGRectMinXEdge);
        return CGRectContainsPoint(rightBezelRect, point);
    } else {
        return YES;
    }
}

- (bool) isPointContainedWithinRightRect:(CGPoint) point{
    return CGRectContainsPoint(self.rightContainerView.frame, point);
}


@end
