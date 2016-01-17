//
//  Message.m
//  Test-Task-Alex-Peda-ObjC
//
//  Created by Alex Peda on 1/17/16.
//  Copyright © 2016 Alex Peda. All rights reserved.
//

#import "Message.h"

@implementation Message

- (instancetype)initWithID:(NSString *)ID text:(NSString *)text rawJSON:(NSString *)rawJSON {
    self = [super init];
    if (self) {
        _idString = ID;
        _text = text;
        _rawJSON = rawJSON;
    }
    return self;
}

@end
