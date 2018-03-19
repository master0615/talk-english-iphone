//
//  BRecommendedAppInfo.h
//  englistening
//
//  Created by alex on 6/8/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRecommendedAppInfo : NSObject
@property (nonatomic, strong) NSString* appLogo;
@property (nonatomic, strong) NSString* appTitle;
@property (nonatomic, strong) NSString* appDescription;
@property (nonatomic, strong) NSString* appId;

+ (NSArray*) recommendedApps;
@end
