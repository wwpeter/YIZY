//
//  NSData+Base64.m
//  LCIphone
//
//  Created by Loseanson on 2017/8/26.
//  Copyright © 2017年 dahua. All rights reserved.
//

#import "NSData+Base64.h"

@implementation NSData (Base64)

- (NSString *)base64String
{
    NSString *base64Str = [self base64EncodedStringWithOptions:0];
    return base64Str;
}

@end
