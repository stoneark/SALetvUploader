//
//  SALetvUploader.h
//  SALetvUploader
//
//  Created by StoneArk on 14/12/4.
//  Copyright (c) 2014年 StoneArk. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>

@protocol SALetvUploaderDelegate <NSObject>
@required
- (void)onUploadStart;
- (void)onUploadProgressUpdate:(int)progress;
- (void)onUploadSuccess:(NSString*)videoUnique;
- (void)onUploadFailure:(NSError*)error;
@end

@interface SALetvUploader : NSObject
+ (SALetvUploader*)sharedInstance;
- (void)loadVideoList;
- (void)upload:(NSString*)fileName videoData:(NSData*)data delegate:(id<SALetvUploaderDelegate>)delegate;
- (void)cancel;
@end
