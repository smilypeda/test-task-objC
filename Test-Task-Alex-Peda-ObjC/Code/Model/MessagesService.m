//
//  MessagesService.m
//  Test-Task-Alex-Peda-ObjC
//
//  Created by Alex Peda on 1/17/16.
//  Copyright © 2016 Alex Peda. All rights reserved.
//

#import "MessagesService.h"

#import <AFNetworking/AFNetworking.h>
#import "MessagesMapper.h"
#import "Message.h"

@implementation MessagesService

- (void)loadMessagesWithCompletion:(void (^)(NSArray<Message *> *messages, NSError *error))completion {
    NSURL *baseURL = [NSURL URLWithString:@"https://gaterest.fxclub.org/"];
    NSString *path = @"Backend/Dicts/IOS/messages/ru_RU/data";
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    [manager GET:path parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSArray<Message *> *messages = nil;
             NSError *error = nil;
             if ([responseObject isKindOfClass:[NSDictionary class]]) {
                 MessagesMapper *mapper = [[MessagesMapper alloc] initWithDictionary:responseObject];
                 messages = mapper.messages;
                 error = mapper.error;
             }
             if (completion) {
                 completion(messages, error);
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (completion) {
                 completion(nil, error);
             }
         }];
}

@end
