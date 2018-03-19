//
//  LSentenceContainerView.h
//  englistening
//
//  Created by alex on 5/29/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Solver.h"

@interface LSentenceContainerView : UIView

- (CGFloat) setEntry: (Solver*) solver forWidth: (CGFloat) width;
- (CGFloat) refresh: (CGFloat) width;
- (CGFloat) refresh;
- (BOOL) checkMatches: (CGRect) rect inDragger: (UIView*) draggerView word: (NSString*) word;
@end
