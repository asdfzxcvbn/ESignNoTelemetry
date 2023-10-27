#import <Foundation/Foundation.h>
%config(generator=internal);

// based off https://zxcvbn.fyi/esign-servers.txt
NSArray *blocked = @[
    @"yyyue.xyz",
    @"nuosike.com",
    @"qq.com",
    @"umeng.com",
    @"umengcloud.com"
];

// not 0.0.0.0 so that installs will keep working without having to change to local install mode (i think)
NSURLRequest *blockedReq = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1"]];

%hook NSURLSession
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(id)handler {
    for (NSString *str in blocked) {
        if ([request.URL.absoluteString containsString:str]) {
            return %orig(blockedReq, handler);
        };
    };

    return %orig(request, handler);
}
%end

// hey u should keep this here.. pls.. or not ...
%hook UITableViewLabel
- (void)setText:(NSString *)a {
    if ([a isEqualToString:@"Privacy Policy"]) { a = @"telemetry blocked by zxcvbn!"; }
    %orig;
}
%end

