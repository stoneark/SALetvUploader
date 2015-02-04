//
//  SALetvUploader.m
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

#import "SALetvUploader.h"
#import "SALetvUploaderConst.h"
#import "CocoaSecurity.h"
#import "ASIFormDataRequest.h"

@interface SALetvUploader()
@property (nonatomic, retain) id<SALetvUploaderDelegate> delegate;
@property (nonatomic, strong) ASIFormDataRequest* request;
@property (nonatomic, assign) long long uploaded_bytes;
@property (nonatomic, strong) NSString* fileName;
@property (nonatomic, strong) NSData* videoData;
@property (nonatomic, strong) NSString* videoID;
@property (nonatomic, strong) NSString* videoUnique;
@property (nonatomic, strong) NSString* uploadURL;
@property (nonatomic, strong) NSString* progressURL;
@property (nonatomic, strong) NSString* token;
@end

@implementation SALetvUploader

static SALetvUploader *_sharedInstance = nil;

+ (SALetvUploader*)sharedInstance
{
    @synchronized(self)
    {
        if (!_sharedInstance)
        {
            NSLog(@"%@ Singleton alloc!",NSStringFromClass([self class]));
            _sharedInstance = [[SALetvUploader alloc]init];
        }
    }
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized (self)
    {
        if (!_sharedInstance)
        {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;
        }
    }
    return nil;
}

+ (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (void)loadVideoList
{
    NSMutableDictionary *dictPara = [[NSMutableDictionary alloc]initWithDictionary:LETV_COMMON_DICT];
    dictPara[@"api"] = LETV_VIDEO_LIST;
    NSURL *url = [self generateURL:dictPara];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"GET"];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setCachePolicy:ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setTimeOutSeconds:10];
    __weak typeof(request) weakRequest = request;
    [request setCompletionBlock:^{
        NSString *strResponse = [[NSString alloc]initWithData:[weakRequest responseData] encoding:NSUTF8StringEncoding];
        NSLog(@"%@",strResponse);
    }];
    [request setFailedBlock:^{
        NSLog(@"ERROR: %@",weakRequest.error);
    }];
    [request startAsynchronous];
}

- (NSString*)generateSign:(NSDictionary*)dict
{
    NSArray *arrKey = [dict allKeys];
    NSArray *arrKeySorted = [arrKey sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSLiteralSearch];
    }];
    NSMutableString *strSorted = [[NSMutableString alloc]init];
    for (NSString* strKey in arrKeySorted)
    {
        [strSorted appendString:strKey];
        [strSorted appendString:dict[strKey]];
    }
    [strSorted appendString:LETV_KEY];
    NSString *strSigned = [[CocoaSecurity md5:strSorted]hexLower];
    return strSigned;
}

- (NSURL*)generateURL:(NSDictionary*)dict
{
    NSMutableString *strURL = [[NSMutableString alloc]initWithString:LETV_API_URL];
    [strURL appendString:@"?"];
    for (NSString* strKey in [dict allKeys])
    {
        [strURL appendFormat:@"%@=%@&",strKey,[dict[strKey] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    [strURL appendFormat:@"sign=%@",[self generateSign:dict]];
    return [NSURL URLWithString:strURL];
}

- (void)upload:(NSString*)fileName videoData:(NSData*)data delegate:(id<SALetvUploaderDelegate>)delegate
{
    _delegate = delegate;
    _uploaded_bytes = 0;
    _fileName = fileName;
    _videoData = data;
    
    if (!fileName || fileName.length == 0)
    {
        NSError *error = [[NSError alloc]initWithDomain:@"org.stoneark.letvuploader" code:0 userInfo:@{NSLocalizedDescriptionKey:@"未传入文件名"}];
        [_delegate onUploadFailure:error];
        return;
    }
    if (!data || data.length == 0)
    {
        NSError *error = [[NSError alloc]initWithDomain:@"org.stoneark.letvuploader" code:0 userInfo:@{NSLocalizedDescriptionKey:@"未传入数据"}];
        [_delegate onUploadFailure:error];
        return;
    }
    if (LETV_USER_UNIQUE.length <= 0 || LETV_KEY.length <= 0)
    {
        NSError *error = [[NSError alloc]initWithDomain:@"org.stoneark.letvuploader" code:0 userInfo:@{NSLocalizedDescriptionKey:@"未配置 User Unique 和 Key"}];
        [_delegate onUploadFailure:error];
        return;
    }
    [self createVideo];
}

- (void)createVideo
{
    NSDictionary *dictPara = [[NSMutableDictionary alloc]initWithDictionary:LETV_COMMON_DICT];
    [dictPara setValue:LETV_UPLOAD_INIT forKey:@"api"];
    [dictPara setValue:_fileName forKey:@"video_name"];
    NSURL *url = [self generateURL:dictPara];
    _request = [ASIHTTPRequest requestWithURL:url];
    [_request setRequestMethod:@"GET"];
    __weak typeof(self) weakSelf = self;
    [_request setCompletionBlock:^{

        SALOG(@"Video create success: %@", weakSelf.request.responseString);
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:weakSelf.request.responseData options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dictData = dictResponse[@"data"];
        weakSelf.videoID = dictData[@"video_id"];
        weakSelf.videoUnique = dictData[@"video_unique"];
        weakSelf.uploadURL = dictData[@"upload_url"];
        weakSelf.progressURL = dictData[@"progress_url"];
        weakSelf.token = dictData[@"token"];
        [weakSelf uploadVideo];
    }];
    [_request setFailedBlock:^{
        SALOG(@"Video create failed: %@", weakSelf.request.error);
        NSError *error = [[NSError alloc]initWithDomain:@"org.stoneark.letvuploader" code:0 userInfo:@{NSLocalizedDescriptionKey:@"创建视频失败"}];
        [weakSelf.delegate onUploadFailure:error];
    }];
    [_request startAsynchronous];
}

- (void)uploadVideo
{
    _request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[_uploadURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSLog(@"upload: %@",_uploadURL);
    [_request setRequestMethod:@"POST"];
    [_request setData:_videoData forKey:@"video_file"];
    __weak typeof(self) weakSelf = self;
    [_request setStartedBlock:^{
        SALOG(@"Video upload start.");
    }];
    [_request setCompletionBlock:^{
        SALOG(@"Video upload finished: %@", weakSelf.videoUnique);
        [weakSelf.delegate onUploadProgressUpdate:100];
        [weakSelf.delegate onUploadSuccess:weakSelf.videoUnique];
    }];
    [_request setFailedBlock:^{
        SALOG(@"Video upload failed: %@", weakSelf.request.error);
        NSError *error = [[NSError alloc]initWithDomain:@"org.stoneark.letvuploader" code:0 userInfo:@{NSLocalizedDescriptionKey:@"上传失败"}];
        [weakSelf.delegate onUploadFailure:error];
    }];
    [_request setShowAccurateProgress:YES];
    [_request setUploadProgressDelegate:self];
    [_request startAsynchronous];
}

- (void)request:(ASIHTTPRequest*)request didSendBytes:(long long)bytes;
{
    _uploaded_bytes += bytes;
    int progress = MIN(100, (int)(self.uploaded_bytes * 100 / _videoData.length));
    SALOG(@"Uploaded bytes: %lld, progress: %d", _uploaded_bytes, progress);
    [self.delegate onUploadProgressUpdate:progress];
}

- (void)cancel
{
    [_request cancel];
}

void SALOG(NSString* format, ...)
{
    if (LETV_ENABLE_LOG)
    {
        va_list argList;
        va_start(argList, format);
        NSString *strLog = [[NSString alloc] initWithFormat:format arguments:argList];
        va_end(argList);
        NSLog(@"[SALetvUploader] %@",strLog);
    }
}

@end
