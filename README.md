# SALetvUploader

SALetvUploader is an easy-to-use Objective-C implementation of uploading video to Letv cloud via [its open API](http://www.letvcloud.com/api/aboutinfo).

## Usage
1. Set macro `LETV_USER_UNIQUE` and `LETV_KEY`in `SALetvUploaderConst.h`.
2. You can enable or disable the log output by setting `LETV_ENABLE_LOG` in `SALetvUploaderConst.h`.
3. When you need to upload a video, just import `SALetvUploader.h`, implement SALetvUploaderDelegate, then simply call:
```
[[SALetvUploader sharedInstance] upload:@"filename" videoData:data delegate:self];
```
4. You can use methods of SALetvUploaderDelegate to get the status of uploading:
```
- (void)onUploadStart;
- (void)onUploadProgressUpdate:(int)progress;
- (void)onUploadSuccess:(NSString*)videoUnique;
- (void)onUploadFailure:(NSError*)error;
```
5. Cancel uploading:
```
[[SALetvUploader sharedInstance] cancel];
```
6. You can expand functions if you like, for example `- (void)loadVideoList;`.

## License

[MIT License](http://opensource.org/licenses/mit-license.php)

This project use [ASIHTTPRequest](https://github.com/pokeb/asi-http-request), [CocoaSecurity](https://github.com/kelp404/CocoaSecurity), and [Base64](https://github.com/nicklockwood/Base64). Thanks.

@StoneArk