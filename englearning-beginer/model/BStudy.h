//
//  Compose.h
//  englistening
//
//  Created by alex on 5/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SharedPref.h"
#import "BBDb.h"

@interface BStudy : NSObject {
    
}

@property (nonatomic, assign) int order;
@property (nonatomic, strong) NSString* image;
@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSString* audio;

- (NSString*) stringValue;

@end
