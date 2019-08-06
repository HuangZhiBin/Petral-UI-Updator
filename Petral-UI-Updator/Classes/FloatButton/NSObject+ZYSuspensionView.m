//
//  NSObject+ZYSuspensionView.m
//  ZYSuspensionView
//
//  Created by ripper on 16/7/20.
//  Copyright © 2016年 ripper. All rights reserved.
//

#import "NSObject+ZYSuspensionView.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>

const char *md5KeyChar = "md5KeyChar";

@implementation NSObject (ZYSuspensionView)

- (NSString *)md5Key
{
    NSString *str = objc_getAssociatedObject(self, md5KeyChar);
    if (str.length <= 0) {
        str = [self getCurrentMd5Key];
        objc_setAssociatedObject(self, md5KeyChar, str, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return str;
}

- (NSString *)getCurrentMd5Key
{
    NSString *str = self.description;
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    // CC_MD5对数据进行了MD5加密
    //MD5计算（也就是加密）
    //第一个参数：需要加密的字符串
    //第二个参数：需要加密的字符串的长度
    //第三个参数：加密完成之后的字符串存储的地方
    CC_MD5( cStr, (int)strlen(cStr), result );
    //声明一个可变字符串类型，用来拼接转换好的字符
    NSMutableString *resultString = [[NSMutableString alloc]init];
    //遍历所有的result数组，取出所有的字符来拼接
    for (int i = 0;i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultString  appendFormat:@"%02X",result[i]];
        //%02x：x 表示以十六进制形式输出，02 表示不足两位，前面补0输出；超出两位，不影响。当x小写的时候，返回的密文中的字母就是小写的，当X大写的时候返回的密文中的字母是大写的。
    }
    NSLog(@"resultString === %@,str = %@",resultString,str);
    return resultString;
    }

@end
