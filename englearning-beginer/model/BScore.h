//
//  BScore.h
//  englistening
//
//  Created by alex on 5/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BScore : NSObject

- (id) init: (NSString*)suffix;
- (int) calculatePoint;
- (int) calculateStars;
- (int) point;
- (int) stars;
- (void) takeSession1;
- (void) takeSession2;
- (void) takeQuiz1: (int) quiz1;
- (void) takeQuiz2: (int) quiz2;
- (int) pointsForQuiz1;
- (int) pointsForQuiz2;
- (void) save;

@end
