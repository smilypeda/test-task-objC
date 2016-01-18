//
//  MessagesMapper.m
//  Test-Task-Alex-Peda-ObjC
//
//  Created by Alex Peda on 1/17/16.
//  Copyright © 2016 Alex Peda. All rights reserved.
//

#import "MessagesMapper.h"

#import "Message.h"

@implementation MessagesMapper

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        NSMutableArray *messages = [NSMutableArray new];
        NSArray* protoMessages = dictionary[@"Data"];
        for (NSDictionary *protoMessage in protoMessages) {
            NSString *ID = [NSString stringWithFormat:@"%@", protoMessage[@"Id"]];
            NSString *rawJSON = [self utf8toNString:[protoMessage description]];
            
            Message *message = [[Message alloc] initWithID:ID text:protoMessage[@"Text"] rawJSON:rawJSON];
            [messages addObject:message];
        }
        _messages = [messages copy];
    }
    return self;
}

- (NSString*)utf8toNString:(NSString*)inputString {
    NSString* outputString= [inputString stringByReplacingOccurrencesOfString:@"\\U" withString:@"\\u"];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)outputString, NULL, transform, YES);
    return outputString;
}

@end
