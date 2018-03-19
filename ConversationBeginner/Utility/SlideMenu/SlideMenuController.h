//
//  SlideMenuController.h
//  EnglishConversation
//
//  Created by SongJiang on 3/3/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    OPEN,
    CLOSE
} SlideAction;

typedef enum{
    TapOpen,
    TapClose,
    FlickOpen,
    FlickClose
} TrackAction;

typedef struct {
    SlideAction actionSlide;
    bool shouldBounce;
    CGFloat velocity;
} PanInfo;


@interface SlideMenuController : UIViewController<UIGestureRecognizerDelegate>
@property(strong, nonatomic) UIView* opacityView;
@property(strong, nonatomic) UIView* mainContainerView;
@property(strong, nonatomic) UIView* leftContainerView;
@property(strong, nonatomic) UIView* rightContainerView;
@property(strong, nonatomic) UIViewController* mainViewController;
@property(strong, nonatomic) UIViewController* leftViewController;
@property(strong, nonatomic) UIPanGestureRecognizer* leftPanGesture;
@property(strong, nonatomic) UITapGestureRecognizer* leftTapGesture;
@property(strong, nonatomic) UIViewController* rightViewController;
@property(strong, nonatomic) UIPanGestureRecognizer* rightPanGesture;
@property(strong, nonatomic) UITapGestureRecognizer* rightTapGesture;




- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (instancetype)init:(UIViewController*)mainViewController leftMenuViewController:(UIViewController*)leftMenuViewController;
- (instancetype)init:(UIViewController*)mainViewController rightMenuViewController:(UIViewController*)rightMenuViewController;
- (instancetype)init:(UIViewController*)mainViewController leftMenuViewController:(UIViewController*)leftMenuViewController rightMenuViewController:(UIViewController*)rightMenuViewController;
- (void) viewWillLayoutSubviews;
- (void) openLeft;
- (void) openRight;
- (void) closeLeft;
- (void) closeRight;
- (void) addLeftGestures;
- (void) addRightGestures;
- (void) removeLeftGestures;
- (void) removeRightGestures;
- (bool) isTargetViewController;
- (void) track:(TrackAction) trackAction;
- (void) handleLeftPanGesture:(UIPanGestureRecognizer*)panGesture;
- (void) handleRightPanGesture:(UIPanGestureRecognizer*)panGesture;
- (void) openLeftWithVelocity:(CGFloat)velocity;
- (void) openRightWithVelocity:(CGFloat)velocity;
- (void) closeLeftWithVelocity:(CGFloat) velocity;
- (void) closeRightWithVelocity:(CGFloat) velocity;
- (void) toggleLeft;
- (bool) isLeftOpen;
- (bool) isLeftHidden;
- (void) toggleRight;
- (bool) isRightOpen;
- (bool) isRightHidden;
- (void) changeMainViewController:(UIViewController*)mainViewController close:(bool) close;
- (void) changeLeftViewWidth:(CGFloat) width;
- (void) changeRightViewWidth:(CGFloat) width;
- (void) changeLeftViewController:(UIViewController*)leftViewController closeLeft:(bool)closeLeft;
- (void) changeRightViewController:(UIViewController*)rightViewController closeRight:(bool)closeRight;
- (CGFloat)leftMinOrigin;
- (CGFloat)rightMinOrigin;
- (PanInfo)panLeftResultInfoForVelocity:(CGPoint)velocity;
- (PanInfo)panRightResultInfoForVelocity:(CGPoint) velocity;
- (CGRect) applyLeftTranslation:(CGPoint) translation toFrame:(CGRect) toFrame;
- (CGRect) applyRightTranslation:(CGPoint) translation toFrame:(CGRect) toFrame;
- (CGFloat) getOpenedLeftRatio;
-(CGFloat) getOpenedRightRatio;
- (void) applyLeftOpacity;
- (void) applyRightOpactiy;
- (void) applyLeftContentViewScale;
- (void) applyRightContentViewScale;
- (void) addShadowToView:(UIView*) targetContainerView;

- (void) removeShadow:(UIView*) targetContainerView;
- (void) removeContentOpacity;
- (void) addContentOpacity;
- (void) disableContentInteraction;
- (void) enableContentInteraction;
- (void) setOpenWindowLevel;
- (void) setCloseWindowLevel;
- (void) setUpViewController:(UIView*)targetView targetViewController:(UIViewController*) targetViewController;
- (void) removeViewController:(UIViewController*) viewController;
- (void) closeLeftNonAnimation;
- (void) closeRightNonAnimation;
// MARK: UIGestureRecognizerDelegate
- (BOOL) gestureRecognizer:(UIGestureRecognizer*) gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch;
// returning true here helps if the main view is fullwidth with a scrollview
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
- (BOOL) slideLeftForGestureRecognizer:(UIGestureRecognizer *) gesture point:(CGPoint) point;

- (bool) isLeftPointContainedWithinBezelRect:(CGPoint)point;

- (bool) isPointContainedWithinLeftRect:(CGPoint) point;
- (bool) slideRightViewForGestureRecognizer:(UIGestureRecognizer*)gesture point:(CGPoint)point;
- (bool) isRightPointContainedWithinBezelRect:(CGPoint)point;
- (bool) isPointContainedWithinRightRect:(CGPoint) point;

@end
