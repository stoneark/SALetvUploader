//
//  UploadViewController.m
//  SALetvUploaderDemo
//
//  Created by StoneArk on 14/12/6.
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

#import "UploadViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>


@interface UploadViewController ()

@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCaptureClick:(UIButton *)sender
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"抱歉，您的设备没有摄像头" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
        return;
    }
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
    [controller setMediaTypes:@[(NSString*)kUTTypeMovie]];
    [controller setAllowsEditing:NO];
//    [controller setVideoMaximumDuration:10.f];
    [controller setVideoQuality:UIImagePickerControllerQualityTypeMedium];
    [controller setDelegate:self];
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *strMediaType = info[@"UIImagePickerControllerMediaType"];
    NSURL *urlMedia = info[@"UIImagePickerControllerMediaURL"];
    NSData *data = [NSData dataWithContentsOfURL:urlMedia];
    [[SALetvUploader sharedInstance]upload:[NSString stringWithFormat:@"%d",(int)[[NSDate date]timeIntervalSince1970]] videoData:data delegate:self];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)onUploadFailure:(NSError *)error
{
    NSLog(@"LETV FAILURE:%@",error.localizedDescription);
}

-(void)onUploadProgressUpdate:(int)progress
{
    NSLog(@"LETV PROGRESS:%d",progress);
}

- (void)onUploadStart
{
    NSLog(@"LETV START");
}

-(void)onUploadSuccess:(NSString *)videoUnique
{
    NSLog(@"LETV SUCCESS");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
