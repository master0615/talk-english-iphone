//
//  Compose.m
//  englistening
//
//  Created by alex on 5/6/16.
//  Copyright © 2016 steve. All rights reserved.
//

#import "BStudy.h"

@implementation BStudy

- (NSString*) stringValue {
    return [NSString stringWithFormat: @"%d - %@ - %@ - %@", _order, _text, _image, _audio];
}
- (void) setImage: (NSString *) image {
    _image = [[image stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] lowercaseString];
}
- (void) setAudio: (NSString *) audio {
    _audio = [[audio stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] lowercaseString];
}
@end
