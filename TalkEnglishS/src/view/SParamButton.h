//
//  ParamButton.h
//  Puchikan
//
//  Created by Yoo YongHa on 2014. 9. 5..
//  Copyright (c) 2014년 Gen X Hippies Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SParamButton : UIButton

@property (readwrite, strong) id parameter;

@property (readwrite, strong) void (^clickBlock)(id sender);

@end
