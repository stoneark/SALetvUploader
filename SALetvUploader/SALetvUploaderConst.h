//
//  SALetvUploaderConst.h
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

#ifndef SALetvUploader_Const_h
#define SALetvUploader_Const_h

#define LETV_API_URL @"http://api.letvcloud.com/open.php"
#define LETV_USER_UNIQUE @""
#define LETV_KEY @""
#define LETV_FORMAT @"json"
#define LETV_VER @"2.0"
#define LETV_UPLOAD_INIT @"video.upload.init"
#define LETV_VIDEO_LIST @"video.list"
#define TIMESTAMP_NOW [NSString stringWithFormat:@"%ld",(long)[[NSDate date]timeIntervalSince1970]]
#define LETV_COMMON_DICT @{@"user_unique":LETV_USER_UNIQUE,@"timestamp":TIMESTAMP_NOW,@"format":LETV_FORMAT,@"ver":LETV_VER}
BOOL LETV_ENABLE_LOG = YES;

#endif