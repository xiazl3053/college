//
//  UploadImageService.m
//  XCMonit_Ip
//
//  Created by 夏钟林 on 14/10/22.
//  Copyright (c) 2014年 夏钟林. All rights reserved.
//

#import "UploadImageService.h"
#import "UserInfo.h"
#define BOUNDARY @"----------cH2gL6ei4Ef1KM7cH2KM7ae0ei4gL6"

@implementation UploadImageService


-(void)requestUpload:(UIImage*)image
{
    NSString *strUrl = [[NSString alloc] initWithFormat:@"%@pub/uploadUserPicture?token=%@&userid=%@&type=jpg",KHttpServer,[UserInfo sharedUserInfo].strToken,[UserInfo sharedUserInfo].strUserId];
    NSData *imageData = UIImageJPEGRepresentation(image,0.9);
    NSString *strPath = [NSTemporaryDirectory() stringByAppendingString:@"avatar.jpg"];
    
    [imageData writeToFile:strPath atomically:YES];
    
    FileDetail *file = [FileDetail fileWithName:strPath data:imageData];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:file,@"imageFile",nil];
    [self upload:strUrl widthParams:params];
}

-(void)upload:(NSString *)url widthParams:(NSDictionary *)params
{
    NSMutableURLRequest *myRequest = [ [NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:0];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setValue:[@"multipart/form-data; boundary=" stringByAppendingString:BOUNDARY] forHTTPHeaderField:@"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    for(NSString *key in params)
    {
        id content = [params objectForKey:key];
        if ([content isKindOfClass:[NSString class]] || [content isKindOfClass:[NSNumber class]])
        {
            NSString *param = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",BOUNDARY,key,content,nil];
            [body appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else if([content isKindOfClass:[FileDetail class]])
        {
            FileDetail *file = (FileDetail *)content;
            NSString *param = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\nContent-Type: application/octet-stream\r\n\r\n",BOUNDARY,key,file.name,nil];
            [body appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:file.data];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    NSString *endString = [NSString stringWithFormat:@"--%@--",BOUNDARY];
    [body appendData:[endString dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequest setHTTPBody:body];
    
    __block UploadImageService *weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:myRequest queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError){
         UploadImageService *strongLogin = weakSelf;
         if (strongLogin) {
             [strongLogin reciveLoginInfo:response data:data error:connectionError];
         }
     }];
}
-(void)reciveLoginInfo:(NSURLResponse*) response data:(NSData*)data error:(NSError*)connectionError
{
    NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
    
    if (!connectionError && responseCode == 200)
    {
        NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //解密后的字符串
        DLog(@"str:%@",str);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        DLog(@"dic:%@",dic);
        if (_httpBlock)
        {
            _httpBlock(1);
        }
    }
    else
    {
        if (_httpBlock)
        {
            _httpBlock((int)responseCode);
        }
        DLog(@"responseCode:%d",(int)responseCode);
    }
}

@end

@implementation FileDetail

+(FileDetail *)fileWithName:(NSString *)name data:(NSData *)data
{
    FileDetail *file = [[self alloc] init];
    file.name = name;
    file.data = data;
    return file;
}

@end





