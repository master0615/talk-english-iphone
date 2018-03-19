//
//  SlideMenuOptions.h
//  EnglishConversation
//
//  Created by SongJiang on 3/3/16.
//  Copyright © 2016 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIViewController+SlideMenu.h"

@interface SlideMenuOptions : NSObject
@property(nonatomic, assign) CGFloat leftViewWidth;
@property(nonatomic, assign) CGFloat leftBezelWidth;
@property(nonatomic, assign) CGFloat contentViewScale;
@property(nonatomic, assign) CGFloat contentViewOpacity;
@property(nonatomic, assign) CGFloat shadowOpacity;
@property(nonatomic, assign) CGFloat shadowRadius;
@property(nonatomic, assign) CGSize shadowOffset;
@property(nonatomic, assign) bool panFromBezel;
@property(nonatomic, assign) CGFloat animationDuration;
@property(nonatomic, assign) CGFloat rightViewWidth;
@property(nonatomic, assign) CGFloat rightBezelWidth;
@property(nonatomic, assign) bool rightPanFromBezel;
@property(nonatomic, assign) bool hideStatusBar;
@property(nonatomic, assign) CGFloat pointOfNoReturnWidth;
@property(nonatomic, assign) bool simultaneousGestureRecognizers;
@property(nonatomic, assign) UIColor *opacityViewBackgroundColor;

+ (SlideMenuOptions*)sharedInstance;
@end
