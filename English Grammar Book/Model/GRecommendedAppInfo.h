//
//  RecommendedAppInfo.h
//  English Grammar Book
//
//  Created by Han Jinghe (skype: hkhcch851212) on 2016-10-12
//  Copyright © 2016 Han. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRecommendedAppInfo : NSObject
@property (nonatomic, strong) NSString* appLogo;
@property (nonatomic, strong) NSString* appTitle;
@property (nonatomic, strong) NSString* appDescription;
@property (nonatomic, strong) NSString* appId;

+ (NSArray*) recommendedApps;
@end
