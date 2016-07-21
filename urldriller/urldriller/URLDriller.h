//
//  URLDriller.h
//  URLDriller
//
//  Created by Alvarlega on 21/07/16.
//  Copyright © 2016 Pubnative. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol URLDrillerDelegate <NSObject>

- (void)didStartWithURLString:(NSString*)urlString;
- (void)didRedirectURLString:(NSString*)urlString;
- (void)didFinishURLString:(NSString*)urlString;
- (void)didFailURLString:(NSString*)urlString andError:(NSError*)error;

@end

@interface URLDriller : NSObject

- (void)startDrillWithURLString:(NSString*)urlString delegate:(NSObject<URLDrillerDelegate>*)delegate;

@end
