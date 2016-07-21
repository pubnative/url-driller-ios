//
//  URLDriller.m
//  URLDriller
//
//  Created by Alvarlega on 21/07/16.
//  Copyright © 2016 Pubnative. All rights reserved.
//

#import "URLDriller.h"

@interface URLDriller () <NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, weak)NSObject<URLDrillerDelegate> *delegate;

@end

@implementation URLDriller

- (void)startDrillWithURLString:(NSString *)urlString
{
    if (urlString && urlString.length > 0) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                            timeoutInterval:60];
        request.HTTPMethod = @"GET";
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate didFailURLString:urlString andError:error];
                });
            }
            
            if (response != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate didFinishURLString:urlString];
                });
            } else {
                NSError *error = [[NSError alloc] initWithDomain:@"Respons is empty" code:0 userInfo:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate didFailURLString:urlString andError:error];
                });
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate didStartWithURLString:urlString];
        });
        [task resume];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate didRedirectURLString:[request.URL absoluteString]];
    });
}

@end
