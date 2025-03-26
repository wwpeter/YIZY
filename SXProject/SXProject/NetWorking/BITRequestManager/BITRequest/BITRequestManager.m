//
//  BITRequestManager.m
//  Pods
//
//  Created by jiaguoshang on 2017/10/31.
//
//
#import "NSData+Encryption.h"
#import "BITRequestManager.h"
#import "BITRequestConfig.h"
#import "BITRequestApi.h"
#import <BITCategories/BITFDCategories.h>
#import <objc/message.h>
#import "BITSingleObject.h"
#import <BGURLRouter/BITRouter.h>
#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif
#import "WTSConfigManager.h"
#import "FFDeviceName.h"

#import "WBRSA.h"
#import "AESUtil.h"
#import "RSAEncryptor.h"
#import "IPAddress.h"
#import "BITMacro.h"
#import "BITCommonMacro.h"
#import "SVProgressHUD.h"
#import "MJExtension/MJExtension.h"

#define PrivateKey @"MIIBOgIBAAJBAMfnMMXYp6EGUF2TiWMGvSC4f6hYt0NC+2GQaxeXOjv+y7MH4DFKwKv6v+pd6kQGDII6rsr5Xnr2a4jGYvV99I0CAwEAAQJBAMe8PkVQpp0DvATjx2BEeXBaKGNC0UnJgXcIX5igp7UMqtWhJWHUv/gtmd6aLVUJ+RNThUszkJyFOkpQ6/asjYECIQDjHO9TvFe2C9v1zLhfwct6T+LyrAs0AvOyrIs42SmXEQIhAOFURK7BNP68rz6KAFm6uS7KEyUIVoqsN+VEDdpF5J29AiBYAfpsBGwoy2etVGuOD9b9yr8zMqAUw6AT+PDqUpzfQQIgS5FyU1VSi5gGAahQg8c+cbWtg/7u3yTwvf/70VcdW9UCIG+4wWFD/mAJU1boQIBrDJROzz23QzhyOEEZZ04OLokt"
 
#define Token  [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]

#define Lock()   dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
#define Unlock() dispatch_semaphore_signal(_semaphore)

#if BITRequestLoggingEnabled
#define LogDebug(s, ...) NSLog( @"%@:%d %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )//分别是文件名，在文件的第几行，自定义输出内容

#else
#define LogDebug(frmt, ...)     {}
#endif

#define ResponseDataFormatErrorCode   -1111111111
//#define SpecialKeyValue @"1234567890"
#define SpecialKeyValue @"1234567890"
static NSString *const bocKeys = @"c6091428885d59621768176088293d95";


@interface NSDictionary (CheckSafty)

- (BOOL)containKey:(NSString *)key;

- (id)safeObjectForKey:(NSString *)aKey;

@end

@implementation NSDictionary (CheckSafty)

- (id)safeObjectForKey:(NSString *)aKey
{
    if (![self containKey:aKey]) {
        return nil;
    }
    return [self objectForKey:aKey];
}

- (BOOL)containKey:(NSString *)key
{
    return [[self allKeys] containsObject:key];
}

@end



@interface BITRequestManager ()

@property (nonatomic, strong) AFHTTPSessionManager     *sessionManager;

@property (nonatomic, strong) AFJSONResponseSerializer *jsonResponseSerializer;

@property (nonatomic, strong) dispatch_semaphore_t     semaphore;

@property (nonatomic, strong) NSMutableDictionary      *requestCostTimeDic;

@property (nonatomic, strong) NSMapTable               *requestMap;//存放请求的Map

@property (nonatomic, assign) NSUInteger               requestCount;//请求的总次数

@end

@implementation BITRequestManager

+ (BITRequestManager *)sharedManager
{
    static BITRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionManager = [AFHTTPSessionManager manager];
        self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];
        self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [self configurationHttpsRequest];
        _semaphore = dispatch_semaphore_create(1);
        _requestCostTimeDic = [NSMutableDictionary dictionary];
        _requestCount = 0;
    }
    return self;
}

- (NSMapTable *)requestMap
{
    if (!_requestMap) {
        _requestMap = [NSMapTable strongToWeakObjectsMapTable];
    }
    return _requestMap;
}

- (AFJSONResponseSerializer *)jsonResponseSerializer
{
    if (!_jsonResponseSerializer) {
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _jsonResponseSerializer;
        
}
    
- (NSString *)getCurrentLanguageCode {
    NSString *currentLanguageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    return currentLanguageCode;
}

- (AFHTTPRequestSerializer *)requestSerializerForRequest:(BITRequestApi *)requestApi {
    AFHTTPRequestSerializer *requestSerializer = nil;
    if (requestApi.requestSerializerType == BITRequestSerializerTypeHTTP) {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (requestApi.requestSerializerType == BITRequestSerializerTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    [requestSerializer setValue:Token forHTTPHeaderField:@"token"];
    NSLog(@"Token = %@",Token);
    [requestSerializer setValue:@"app" forHTTPHeaderField:@"client"];
    [requestSerializer setValue:@"ios" forHTTPHeaderField:@"platform"];
    [requestSerializer setValue:[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] forHTTPHeaderField:@"language"];
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSString * iponeM = [[UIDevice currentDevice] systemName];
    [NSString stringWithFormat:@"%@ - %@",iponeM,phoneVersion];
    NSString *phone_sys_version = [iponeM stringByAppendingString:phoneVersion];
    if (!IsEmptyString(phone_sys_version)) {
        [requestSerializer setValue:phone_sys_version forHTTPHeaderField:@"phone-sys-version"];
    }
    
    //语言

    NSString *languageCode = [self getCurrentLanguageCode];
    NSLog(@"当前语言版本代码：%@", languageCode);
 
    if ([languageCode isEqualToString:@"zh-Hans-CN"]) {
        NSString *lang = @"zh-CN";
        [requestSerializer setValue:lang forHTTPHeaderField:@"lang"];
    } else {
        NSString *lang = @"en-US";
        [requestSerializer setValue:lang forHTTPHeaderField:@"lang"];
    }
  
    //地区
    NSString *iot_instance = @"china";
    [requestSerializer setValue:iot_instance forHTTPHeaderField:@"iot-instance"];

    NSString * deviceName = [FFDeviceName getDeviceName];
    NSLog(@"deviceName = %@",deviceName);
    if (!wts_IsStrEmpty(deviceName)) {
        // url 编码 处理汉字问题
//        NSString *encodeUrl = [deviceName stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLPathAllowedCharacterSet];
        [requestSerializer setValue:deviceName forHTTPHeaderField:@"phone-model"];
    }
    [requestSerializer setValue:@"app" forHTTPHeaderField:@"client-name"];
    NSString *deviceId = [WTSConfigManager getDeviceId];
    if (!wts_IsStrEmpty(deviceId)) {
        [requestSerializer setValue:deviceId forHTTPHeaderField:@"UDID"];
    }
    [requestSerializer setValue:@"苹果" forHTTPHeaderField:@"deviceBrand"];
    [requestSerializer setValue:deviceName forHTTPHeaderField:@"systemModel"];
    [requestSerializer setValue:phone_sys_version forHTTPHeaderField:@"systemVersion"];
    
#pragma mark - wangyuexin
    [requestSerializer setValue:[IPAddress getIPAddress:YES] forHTTPHeaderField:@"ip"];
 
    NSString *bodyStr = [requestApi.params mj_JSONString];
    //对上述加密后密文进行SHA256withRSA签名算法进行签名
    NSString *signStr = [RSAEncryptor sign:bodyStr withPriKey:PrivateKey];//RAS私钥签名
    NSLog(@"signStr  =%@",signStr);
    [requestSerializer setValue:signStr forHTTPHeaderField:@"sx-sign-v"];
    
//    long long visitTime = [[BITSingleObject sharedInstance] getNowTime];
//    NSString *timestamp = [NSString stringWithFormat:@"%lld", visitTime];
//    [requestSerializer setValue:timestamp forHTTPHeaderField:@"sdj-timestampe"];//请求unix时间戳
    
    NSString *version = [WTSConfigManager getAppVersion];
    [requestSerializer setValue:version forHTTPHeaderField:@"version"];
   
//    [requestSerializer setValue:@"Bearer" forHTTPHeaderField:@"Authorization"];
//    NSString *authorizationStr = wts_getObjectFromUserDefault(@"Authorization");
//    if (!wts_IsStrEmpty(authorizationStr)) {
//        [requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",authorizationStr] forHTTPHeaderField:@"Authorization"];
//    }
//    
//    
//    NSString *um_device_token = wts_getObjectFromUserDefault(@"um_device_token");
//    if (!wts_IsStrEmpty(um_device_token)) {
//        [requestSerializer setValue:um_device_token forHTTPHeaderField:@"um-device-token"];
//    }
    
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    // 添加特殊业务请求参数
    NSInteger businessHeadType = [BITSingleObject sharedInstance].businessHeadType;
    switch (businessHeadType) {
        case BusinessHeadTypeRefreshJwt:{
            NSString *authorizationStr = wts_getObjectFromUserDefault(@"refresh");
            if (!wts_IsStrEmpty(authorizationStr)) {
                [requestSerializer setValue:@"Bearer " forHTTPHeaderField:@"Authorization"];
                [requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",authorizationStr] forHTTPHeaderField:@"Authorization"];
            }
            break;
        }
            
        case BusinessHeadTypeLogin:{
            [requestSerializer setValue:@"" forHTTPHeaderField:@""];
            break;
        }
        default:
            break;
    }
//    
//    NSString *token = Token;
//    if (token && ([token isKindOfClass:[NSString class]]) &&(token.length > 0)) {
//        [requestSerializer setValue:token forHTTPHeaderField:@"sx-token"];
//
//    }
//    else {
//        [requestSerializer setValue:@"" forHTTPHeaderField:@"sx-token"];
//
//    }
    requestSerializer.timeoutInterval = requestApi.timeoutInterval;
    
    return requestSerializer;
}

#pragma mark - 配置HTTPS请求

- (void)configurationHttpsRequest
{
    if ([BITRequestConfig sharedConfig].needHTTPS) {

#ifdef DEBUG
        //设置非校验证书模式,方便抓包
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
#else
        //AFSSLPinningModeCertificate 使用证书验证模式
        AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
#endif
        [self.sessionManager setSecurityPolicy:securityPolicy];
    }
}


#pragma mark - 开始请求

- (void)startRequestApi:(BITRequestApi *)requestApi
               filePath:(NSString *)filePath
               progress:(void (^)(NSProgress *))loadProgressBlock
constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))constructingBlock
        completeHandler:(void (^)(NSString *, NSError *))completeHandler
{
    NSError * __autoreleasing requestSerializationError = nil;
    requestApi.requestTask = [self sessionTaskForRequestApi:requestApi
                                                      error:&requestSerializationError
                                                   filePath:filePath
                                                   progress:loadProgressBlock
                                  constructingBodyWithBlock:constructingBlock
                                            completeHandler:completeHandler];
    [requestApi.requestTask resume];
}


//请求
- (NSURLSessionTask *)sessionTaskForRequestApi:(BITRequestApi *)requestApi
                                         error:(NSError * _Nullable __autoreleasing *)error
                                      filePath:(NSString *)filePath
                                      progress:(void (^)(NSProgress *))loadProgressBlock
                     constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))constructingBlock
                               completeHandler:(void (^)(NSString *, NSError *))completeHandler
{
    self.requestCount++;
    NSString *urlString = [requestApi.baseURL stringByAppendingString:requestApi.apiPath];
    NSLog(@"%@", urlString);
    //重新设置requestApi的请求参数
//    NSDictionary *requestParams = [self generateRequestParams:requestApi updateFlag:YES];
    id requestParams = requestApi.params;
    RequestMethodType requestType = requestApi.requestMethodType;
    NSString *url = [self buildRequestUrl:requestApi];
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:requestApi];
    switch (requestType) {
        case YX_Request_GET:
        {
            //filePath为空,不是下载
            if (!filePath || [filePath isEqual:[NSNull null]] || [filePath isEqualToString : @""]) {
                return [self dataTaskWithRequestApi:requestApi httpMethod:@"GET" requestSerializer:requestSerializer URLString:url parameters:requestParams error:error completeHandler:completeHandler];
            } else {
                return [self downloadTaskWithRequestApi:requestApi downloadPath:filePath requestSerializer:requestSerializer URLString:url parameters:requestParams progress:loadProgressBlock error:error completeHandler:completeHandler];
            }
        }
            break;
        case YX_Request_POST:
            return [self dataTaskWithRequestApi:requestApi httpMethod:@"POST" requestSerializer:requestSerializer URLString:url parameters:requestParams constructingBodyWithBlock:constructingBlock progress:loadProgressBlock error:error completeHandler:completeHandler];
            break;
        case YX_Request_PUT:
            return [self dataTaskWithRequestApi:requestApi httpMethod:@"PUT" requestSerializer:requestSerializer URLString:url parameters:requestParams error:error completeHandler:completeHandler];
            break;
        case YX_Request_DELETE:
            return [self dataTaskWithRequestApi:requestApi httpMethod:@"DELETE" requestSerializer:requestSerializer URLString:url parameters:requestParams error:error completeHandler:completeHandler];
            break;
        case YX_Request_HEAD:
            return [self dataTaskWithRequestApi:requestApi httpMethod:@"HEAD" requestSerializer:requestSerializer URLString:url parameters:requestParams error:error completeHandler:completeHandler];
            break;
        case YX_Request_PATCH:
            return [self dataTaskWithRequestApi:requestApi httpMethod:@"PATCH" requestSerializer:requestSerializer URLString:url parameters:requestParams error:error completeHandler:completeHandler];
            break;
        
        default:
            break;
    }
}
    
#pragma mark - 拼接请求参数

//拼接请求URL,可以在这里面做URL的拼接检查,避免因为URL的问题导致请求失败
    
- (NSString *)buildRequestUrl:(BITRequestApi *)requestApi
{
    NSString *apiPath = requestApi.apiPath;
    NSString *baseURL = requestApi.baseURL;
    NSString *urlString = [baseURL stringByAppendingString:apiPath];
#warning 这里可以校验格式
    NSURL *URL = [NSURL URLWithString:urlString];
    if (URL && URL.host && URL.scheme) {
        return urlString;
    }
    return @"";
}

//拼装请求参数
- (NSDictionary *)generateRequestParams:(BITRequestApi *)requestApi updateFlag:(BOOL)updateFlag
{
    //获取到外界设置进来的参数字典
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:requestApi.params];

    paramsDic = [NSMutableDictionary dictionaryWithDictionary:requestApi.params];
    [[BITRequestConfig sharedConfig].extraBuiltinParameterHandlers enumerateObjectsUsingBlock:^(ExtraBuiltinParametersHandler obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *result = obj();
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            [paramsDic addEntriesFromDictionary:result];
        }
    }];
    if ([BITRequestConfig sharedConfig].builtinParameters) {
        [paramsDic addEntriesFromDictionary:[BITRequestConfig sharedConfig].builtinParameters];
    }
   
    return [paramsDic copy];
}


#pragma mark -

- (NSURLSessionDataTask *)dataTaskWithRequestApi:(BITRequestApi *)requestApi
                                      httpMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                           error:(NSError * _Nullable __autoreleasing *)error
                                 completeHandler:(void (^)(NSString *, NSError *))completeHandler
{
    return [self dataTaskWithRequestApi:requestApi
                             httpMethod:method
                      requestSerializer:requestSerializer
                              URLString:URLString
                             parameters:parameters
              constructingBodyWithBlock:nil
                                  error:error
                        completeHandler:completeHandler];
}

- (NSURLSessionDataTask *)dataTaskWithRequestApi:(BITRequestApi *)requestApi
                                      httpMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                       constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                           error:(NSError * _Nullable __autoreleasing *)error
                                 completeHandler:(void (^)(NSString *, NSError *))completeHandler
{
    
    return [self dataTaskWithRequestApi:requestApi
                             httpMethod:method
                      requestSerializer:requestSerializer
                              URLString:URLString
                             parameters:parameters
              constructingBodyWithBlock:block
                               progress:nil
                                  error:error
                        completeHandler:completeHandler];
}


- (NSURLSessionDataTask *)dataTaskWithRequestApi:(BITRequestApi *)requestApi
                                      httpMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                       constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                        progress:(void (^)(NSProgress *))loadProgressBlock
                                           error:(NSError * _Nullable __autoreleasing *)error
                                 completeHandler:(void (^)(NSString *, NSError *))completeHandler
{
    NSMutableURLRequest *request = nil;
    
    if (block) {
        request = [requestSerializer multipartFormRequestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block error:error];
    } else {
        //一般传参数
        if ([method isEqualToString:@"GET"]) {
            
            request = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];
        }else{
            //ff传body参数
            NSString *bodyStr = [parameters mj_JSONString];
            //AES加密
            NSString *encryptStr = [AESUtil aesEncrypt: bodyStr];
#pragma -请求体加密
            NSDictionary *dic = parameters;
            NSLog(@"dic.count = %ld,dic = %@,bodyStr = %@",dic.count,dic,encryptStr);
            if (dic.count) {
                NSData *body = [encryptStr dataUsingEncoding:NSUTF8StringEncoding];
                request = [requestSerializer requestWithMethod:method URLString:URLString parameters:nil error:error];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:body];
            }else{
                request = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];
            }
            
        }
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request
                                         uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
                                             if (loadProgressBlock) {
                                                 loadProgressBlock(uploadProgress);
                                             }
                                         } downloadProgress:nil
                                      completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *_error) {
        
                                          [self handleRequestApi:requestApi
                                                     sessionTask:dataTask
                                                  responseObject:responseObject
                                                           error:_error
                                                 completeHandler:completeHandler
                                                      isDownload:NO];
                                      }];
    CFAbsoluteTime nowTime = CFAbsoluteTimeGetCurrent();
    Lock();
    [self.requestCostTimeDic setSafeObject:@(nowTime) forKey:@(dataTask.taskIdentifier)];
    Unlock();
    
    return dataTask;
}

-(NSError *)checkLogoutError:(NSError *)error
{
    NSError *logoutError = [NSError errorWithDomain:@"" code:error.code userInfo:nil];
    if(error.code == 401)
    {
        return logoutError;
    }
    NSString *notice = error.domain;
    if((error.code == 0) && notice && ![notice isEqualToString:@"<null>"] && ([notice rangeOfString:@"登录"].location != NSNotFound))
    {
        return logoutError;
    }
    return error;
}

#pragma mark - 处理请求结果,这个地方可以做返回数据的校验
- (void)handleRequestApi:(BITRequestApi *)requestApi
             sessionTask:(NSURLSessionTask *)task
          responseObject:(id)responseObject
                   error:(NSError *)error
         completeHandler:(void (^)(NSString *, NSError *))completeHandler
              isDownload:(BOOL)isDownload

{
    Lock();
    [self.requestMap removeObjectForKey:requestApi.uniqueIdentify];
    NSString *requestStartTime = self.requestCostTimeDic[@(task.taskIdentifier)];
    [self.requestCostTimeDic removeObjectForKey:@(task.taskIdentifier)];
    Unlock();
    double costTime = (CFAbsoluteTimeGetCurrent() - requestStartTime.doubleValue) * 1000;
    //重新设置requestApi的请求参数
    id requestParams = requestApi.params;

    NSString *bodyStr = [requestApi.params mj_JSONString];
    //AES加密
    bodyStr = [AESUtil aesEncrypt: bodyStr];

    LogDebug(@"url : %@;\n HTTPMethod:%@;\n header:%@;\n responseObject:%@ \n body:%@,bodyStr = %@",task.currentRequest.URL,task.currentRequest.HTTPMethod,task.currentRequest.allHTTPHeaderFields,responseObject,requestApi.params,bodyStr);
    
    NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    
    NSString *decryptResult = [AESUtil aesDecrypt:result];
    
    //
    NSLog(@"%@",decryptResult);
    
    NSData *jsonDataDec = [decryptResult dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonStr = decryptResult;
    NSDictionary *responeDic = nil;
    //Json解析
    if (jsonDataDec) {
        responeDic = [NSJSONSerialization JSONObjectWithData:jsonDataDec options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"从服务器获取到数据：%@--",responeDic);
    }

    id jsonDic;
    NSError * __autoreleasing serializationError = nil;
    NSError *__autoreleasing defaultError = nil;
    if ([responseObject isKindOfClass:[NSData class]]) {
        NSDictionary *resultDic = responeDic;
        if ([resultDic isKindOfClass:[NSDictionary class]]) {
            jsonDic = resultDic;
        }
    } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
        jsonDic = responseObject;
    }
    
    if (error) {
        defaultError = error;
        LogDebug(@"error.code:%ld\n error.userInfo:%@\n error:%@\n error.domain:%@\n", (long)(error.code),error.userInfo, error,error.domain);
        
    } else if (serializationError) {
//        defaultError = serializationError;
//        [self hiddenHub];
    } else {
    
        id jsonCode = [jsonDic safeObjectForKey:@"returnCode"];
        if(jsonCode)
        {
            NSMutableDictionary *dic = [self processWithJsonDic:jsonDic defaultError:defaultError];
            defaultError = dic[@"defaultError"];
            jsonDic = dic[@"jsonDic"];
        }
        else if([jsonDic safeObjectForKey:@"returnFlag"])
        {
            NSMutableDictionary *dic = [self processBinGoWithJsonDic:jsonDic defaultError:defaultError];
            defaultError = dic[@"defaultError"];
            jsonDic = dic[@"jsonDic"];
        }
        else
        {
            NSMutableDictionary *dic = [self processYixiangweipaiWithJsonDic:jsonDic defaultError:defaultError];
            defaultError = dic[@"defaultError"];
            jsonDic = dic[@"jsonDic"];
        }
    }
    defaultError = [self handleErrorCode:defaultError];
    if (completeHandler) {
        completeHandler(jsonStr, defaultError);
    }
}
/**
 APP_PARAM_VALIDATE_ERROR("APP_9998", "参数校验错误"),
 APP_VALIDATE_CODE_ERROR("APP_9997", "验证码错误或者已过期"),
 APP_PASSWORD_NOT_SAME("APP_9996", "密码不一致"),
 APP_PASSWORD_FORMAT_ERROR("APP_9995", "密码格式"),
 APP_PASSWORD_ERROR("APP_9994", "密码错误"),

 APP_USER_NOT_EXIST("APP_00004", "用户不存在"),
 APP_USER_EXIST("APP_00005", "用户已存在"),
 */
-(NSMutableDictionary *)processBinGoWithJsonDic:(NSDictionary *)jsonDic
                                    defaultError:(NSError *)defaultError
{
    id jsonCode = [jsonDic safeObjectForKey:@" success"];
    id result = nil;
    if ([jsonDic containKey:@" success"] && (([jsonCode isKindOfClass:[NSString class]] && [jsonCode isEqualToString:@"1"]) || ([jsonCode isKindOfClass:[NSNumber class]] && [[jsonCode stringValue] isEqualToString:@"1"]))) {//表示成功
        if (!jsonDic)
        {
            jsonDic = [NSDictionary dictionaryWithObject:@"" forKey:@"body"];
            result = nil;
        }
        else if ([jsonDic containKey:@"body"])
        {
            if([[jsonDic safeObjectForKey:@"body"] isKindOfClass:[NSDictionary class]])
            {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setSafeObject:[jsonDic safeObjectForKey:@"body"] forKey:@"body"];
                jsonDic = dic;
                result = [jsonDic safeObjectForKey:@"body"];
            }
            else if([[jsonDic safeObjectForKey:@"body"] isKindOfClass:[NSArray class]])
            {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setSafeObject:[jsonDic safeObjectForKey:@"body"] forKey:@"body"];
                jsonDic = dic;
                result = [jsonDic safeObjectForKey:@"body"];
            }
            else if([[jsonDic safeObjectForKey:@"body"] isKindOfClass:[NSString class]])
            {
                jsonDic = [NSDictionary dictionaryWithObject:[jsonDic safeObjectForKey:@"body"] forKey:@"body"];
                result = [jsonDic safeObjectForKey:@"body"];
            }
            else if([jsonDic safeObjectForKey:@"body"] == nil ||
                    ([[jsonDic safeObjectForKey:@"body"] isEqual:[NSNull null]]) ||
                    [([NSString stringWithFormat:@"%@", [jsonDic safeObjectForKey:@"body"]]) isEqualToString:@"<null>"] || [([NSString stringWithFormat:@"%@", [jsonDic safeObjectForKey:@"body"]]) isEqualToString:@""])
            {
                jsonDic = [NSDictionary dictionaryWithObject:@"" forKey:@"body"];
                result = nil;
            }
            else {
                defaultError = [NSError errorWithDomain:@"返回data格式错误" code:ResponseDataFormatErrorCode userInfo:nil];
                [self hiddenHub];
            }
            
        }
        else {
            jsonDic = [NSDictionary dictionaryWithObject:@"" forKey:@"body"];
            result = nil;

        }

    } else {
        [self hiddenHub];
        NSString *domain = @"";
        NSString *code = @"";
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];

        if ([jsonDic containKey:@"returnFlag"]) {
            code = [jsonDic safeObjectForKey:@"returnFlag"];
            if ([code isKindOfClass:[NSNumber class]]) {
                code = [[jsonDic safeObjectForKey:@"returnFlag"] stringValue];
            }
        }
        if ((jsonDic) && [jsonDic containKey:@"body"])
        {
            if([[jsonDic safeObjectForKey:@"body"] isKindOfClass:[NSDictionary class]])
            {
                userInfo = [NSMutableDictionary dictionaryWithDictionary:[jsonDic safeObjectForKey:@"body"]];
            }
            else if([[jsonDic safeObjectForKey:@"body"] isKindOfClass:[NSString class]])
            {
                userInfo = [NSMutableDictionary dictionaryWithObject:[jsonDic safeObjectForKey:@"body"] forKey:@"dataKey"];
            }
        }
        if ([jsonDic containKey:@"msg"]) {
            domain = [jsonDic safeObjectForKey:@"msg"];
            if(!IsEmptyString(domain))
            {
                [userInfo setValue:domain forKey:@"msg"];
            }
            
        }
        if(!IsEmptyString([BITSingleObject sharedInstance].logoutPageAddress) && ((([BITSingleObject sharedInstance].logoutErrorCode != 0) && ([BITSingleObject sharedInstance].logoutErrorCode == [code longLongValue])) || (([BITSingleObject sharedInstance].noTokenErrorCode != 0) && ([BITSingleObject sharedInstance].noTokenErrorCode == [code longLongValue]))))
        {
            if(![BITSingleObject sharedInstance].isLoginPage)
            {
                [BITSingleObject sharedInstance].isLoginPage = YES;
                [BITRouter openURL:[BITSingleObject sharedInstance].logoutPageAddress];
            }
            defaultError = [NSError errorWithDomain:@"" code:[code longLongValue] userInfo:userInfo];
        }
        else
        {
            defaultError = [NSError errorWithDomain:domain code:[code longLongValue] userInfo:userInfo];
        }
        
        
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(defaultError)
    {
       [dic setObject:defaultError forKey:@"defaultError"];
    }
    
    if(result)
    {
        [dic setObject:result forKey:@"jsonDic"];
    }
    
    return dic;
}



-(NSMutableDictionary *)processYixiangweipaiWithJsonDic:(NSDictionary *)jsonDic
                                           defaultError:(NSError *)defaultError
{
    if (!jsonDic)
    {
        jsonDic = [NSDictionary dictionaryWithObject:@"" forKey:@"data"];
    }
    else if ([jsonDic isKindOfClass:[NSDictionary class]])
    {
//        jsonDic = [jsonDic safeObjectForKey:@"data"];
    }
    else {
        defaultError = [NSError errorWithDomain:@"返回data格式错误" code:ResponseDataFormatErrorCode userInfo:nil];
        [self hiddenHub];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(defaultError)
    {
        [dic setObject:defaultError forKey:@"defaultError"];
    }
    
    if(jsonDic)
    {
        [dic setObject:jsonDic forKey:@"jsonDic"];
    }
    
    return dic;
}

-(NSMutableDictionary *)processWithJsonDic:(NSDictionary *)jsonDic
                   defaultError:(NSError *)defaultError
{
    id head = [jsonDic safeObjectForKey:@"head"];
//    id body = [jsonDic safeObjectForKey:@"body"];
    id jsonCode = [head safeObjectForKey:@"returnCode"];
    if ([jsonDic containKey:@"returnCode"] && (([jsonCode isKindOfClass:[NSString class]] && [jsonCode isEqualToString:@"000000"]) || ([jsonCode isKindOfClass:[NSNumber class]] && [[jsonCode stringValue] isEqualToString:@"000000"]))) {//表示成功
        if (!jsonDic)
        {
            jsonDic = [NSDictionary dictionaryWithObject:@"" forKey:@"body"];
        }
        else if ([jsonDic containKey:@"body"])
        {
            if([[jsonDic safeObjectForKey:@"body"] isKindOfClass:[NSDictionary class]])
            {
                jsonDic = [jsonDic safeObjectForKey:@"body"];
                //转换后的数据
//                jsonDic = [self setDecimalPointPrecisionProcessing:(NSMutableDictionary *) jsonDic];
            }
            else if([[jsonDic safeObjectForKey:@"body"] isKindOfClass:[NSArray class]])
            {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setSafeObject:[jsonDic safeObjectForKey:@"body"] forKey:@"body"];
                jsonDic = dic;
            }
            else if([[jsonDic safeObjectForKey:@"body"] isKindOfClass:[NSString class]])
            {
                BOOL secure = [[jsonDic safeObjectForKey:@"returnFlag"] boolValue];
                if(secure)
                {
                    NSString *content = [jsonDic safeObjectForKey:@"body"];
                    NSData *decryptionData = [[NSData alloc]initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    NSData *contentData = [decryptionData AES256NewDecryptWithKey:bocKeys];
                    NSDictionary *contentJSON = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingMutableContainers error:nil];
                    NSString *contentJsonString = [[NSString alloc]initWithData:contentData encoding:NSUTF8StringEncoding];
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    if (content.length==0) {
                        [dict setObject:@"" forKey:@"body"];
                    } else {
                        if (contentJSON == nil) {
                            if(contentJsonString == nil)
                            {
                                [dict setObject:@"" forKey:@"body"];
                            }
                            else
                            {
                                [dict setObject:contentJsonString forKey:@"body"];
                            }
                        } else {
                            if(contentJSON == nil)
                            {
                                [dict setObject:@"" forKey:@"body"];
                            }
                            else if(contentJSON && [contentJSON isKindOfClass:[NSDictionary class]])
                            {
                                dict = [NSMutableDictionary dictionaryWithDictionary:contentJSON];
                            }
                            else
                            {
                                [dict setObject:contentJSON forKey:@"body"];
                            }
                        }
                        jsonDic = dict;
                    }
                }
                else
                {
                    jsonDic = [NSDictionary dictionaryWithObject:[jsonDic safeObjectForKey:@"body"] forKey:@"body"];
                }
            }
            else if([jsonDic safeObjectForKey:@"body"] == nil ||
                    ([[jsonDic safeObjectForKey:@"body"] isEqual:[NSNull null]]) ||
                    [([NSString stringWithFormat:@"%@", [jsonDic safeObjectForKey:@"body"]]) isEqualToString:@"<null>"] || [([NSString stringWithFormat:@"%@", [jsonDic safeObjectForKey:@"body"]]) isEqualToString:@""])
            {
                jsonDic = [NSDictionary dictionaryWithObject:@"" forKey:@"body"];
            }
            else {
                defaultError = [NSError errorWithDomain:@"返回data格式错误" code:ResponseDataFormatErrorCode userInfo:nil];
                [self hiddenHub];
            }
            
        }
        else {
            defaultError = [NSError errorWithDomain:@"返回data格式错误" code:ResponseDataFormatErrorCode userInfo:nil];
            [self hiddenHub];
        }
    } else {
        [self hiddenHub];
        NSString *domain = @"";
        NSString *code = @"";
        NSDictionary *userInfo = [NSDictionary dictionary];
        id head = [jsonDic safeObjectForKey:@"head"];
        
        if ([head containKey:@"returnMessage"]) {
            domain = [head safeObjectForKey:@"returnMessage"];
        }
        if ([head containKey:@"returnCode"]) {
            code = [head safeObjectForKey:@"returnCode"];
            if ([code isKindOfClass:[NSNumber class]]) {
                code = [[head safeObjectForKey:@"returnCode"] stringValue];
            }
        }
        if ((jsonDic) && [jsonDic containKey:@"body"])
        {
            if([[jsonDic safeObjectForKey:@"body"] isKindOfClass:[NSDictionary class]])
            {
                userInfo = [jsonDic safeObjectForKey:@"body"];
            }
            else if([[jsonDic safeObjectForKey:@"body"] isKindOfClass:[NSString class]])
            {
                userInfo = [NSDictionary dictionaryWithObject:[jsonDic safeObjectForKey:@"body"] forKey:@"dataKey"];
            }
        }
        if (!([code longLongValue] == 000000)) {
            defaultError = [NSError errorWithDomain:domain code:[code longLongValue] userInfo:userInfo];
        }
        
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(defaultError)
    {
       [dic setObject:defaultError forKey:@"defaultError"];
    }
    
    if(jsonDic)
    {
        [dic setObject:jsonDic[@"body"] forKey:@"jsonDic"];
//        [dic setObject:jsonDic forKey:@"jsonDic"];
    }
    
    return dic;
}

-(void)hiddenHub
{
    if (!IsEmptyString([BITRequestConfig sharedConfig].hudClassName)) {
        ((void (*)(id, SEL))objc_msgSend)([NSClassFromString([BITRequestConfig sharedConfig].hudClassName) class], @selector(resetResponseDisplayFlag));
    } else {
        NSCAssert(NO, @"请配置HUD类名");
    }
    if ([BITRequestConfig sharedConfig].hudClassName) {
        ((void (*)(id, SEL))objc_msgSend)([NSClassFromString([BITRequestConfig sharedConfig].hudClassName) class], @selector(hide));
    }
    [SVProgressHUD dismiss];
}

#pragma mark -download

- (NSURLSessionDownloadTask *)downloadTaskWithRequestApi:(BITRequestApi *)requestApi
                                            downloadPath:(NSString *)downloadPath
                                       requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                               URLString:(NSString *)URLString
                                              parameters:(id)parameters
                                                progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                                   error:(NSError * _Nullable __autoreleasing *)error
                                         completeHandler:(void (^)(NSString *, NSError *))completeHandler
{
    NSMutableURLRequest *urlRequest = [requestSerializer requestWithMethod:@"GET" URLString:URLString parameters:parameters error:error];
    
    NSString *downloadTargetPath;
    BOOL isDirectory;
    if(![[NSFileManager defaultManager] fileExistsAtPath:downloadPath isDirectory:&isDirectory]) {
        isDirectory = NO;
    }
    if (isDirectory) {
        NSString *fileName = [urlRequest.URL lastPathComponent];
        downloadTargetPath = [NSString pathWithComponents:@[downloadPath, fileName]];
    } else {
        downloadTargetPath = downloadPath;
    }

    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadTargetPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:downloadTargetPath error:nil];
    }
    
    BOOL resumeDataFileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self incompleteDownloadTempPathForDownloadPath:downloadPath].path];
    NSData *data = [NSData dataWithContentsOfURL:[self incompleteDownloadTempPathForDownloadPath:downloadPath]];
    BOOL resumeDataIsValid = [[self class] validateResumeData:data];
    
    BOOL canBeResumed = resumeDataFileExists && resumeDataIsValid;
    BOOL resumeSucceeded = NO;
    __block NSURLSessionDownloadTask *downloadTask = nil;
    if (canBeResumed) {
        @try {
            downloadTask = [self.sessionManager downloadTaskWithResumeData:data progress:^(NSProgress * _Nonnull downloadProgress) {
                if (downloadProgressBlock) {
                    downloadProgressBlock(downloadProgress);
                }
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
            } completionHandler:
                            ^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                [self handleRequestApi:requestApi
                                           sessionTask:downloadTask
                                        responseObject:filePath
                                                 error:error
                                       completeHandler:completeHandler
                                            isDownload:YES];
                            }];
            resumeSucceeded = YES;
        } @catch (NSException *exception) {
            NSLog(@"Resume download failed, reason = %@", exception.reason);
            resumeSucceeded = NO;
        }
    }
    if (!resumeSucceeded) {
        downloadTask = [self.sessionManager downloadTaskWithRequest:urlRequest progress:^(NSProgress * _Nonnull downloadProgress) {
            if (downloadProgressBlock) {
                downloadProgressBlock(downloadProgress);
            }
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
        } completionHandler:
                        ^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                            [self handleRequestApi:requestApi
                                       sessionTask:downloadTask
                                    responseObject:filePath
                                             error:error
                                   completeHandler:completeHandler
                                        isDownload:YES];
                        }];
    }
    return downloadTask;

}

- (NSURL *)incompleteDownloadTempPathForDownloadPath:(NSString *)downloadPath {
    NSString *tempPath = nil;
    NSString *md5URLString = [downloadPath bitinfo_md5hashString];
    tempPath = [[self incompleteDownloadTempCacheFolder] stringByAppendingPathComponent:md5URLString];
    return [NSURL fileURLWithPath:tempPath];
}

- (NSString *)incompleteDownloadTempCacheFolder {
    NSFileManager *fileManager = [NSFileManager new];
    static NSString *cacheFolder;
    
    if (!cacheFolder) {
        NSString *cacheDir = NSTemporaryDirectory();
        cacheFolder = [cacheDir stringByAppendingPathComponent:@"Incomplete"];
    }
    
    NSError *error = nil;
    if(![fileManager createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
        NSLog(@"在%@创建目录失败", cacheFolder);
        cacheFolder = nil;
    }
    return cacheFolder;
}

+ (BOOL)validateResumeData:(NSData *)data {
    if (!data || [data length] < 1) return NO;
    
    NSError *error;
    NSDictionary *resumeDictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:&error];
    if (!resumeDictionary || error) return NO;
    
    // Before iOS 9 & Mac OS X 10.11
#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED < 90000)\
|| (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED < 101100)
    NSString *localFilePath = [resumeDictionary objectForKey:@"NSURLSessionResumeInfoLocalPath"];
    if ([localFilePath length] < 1) return NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:localFilePath];
#endif
    return YES;
}

#pragma mark - 生成对应的sign值

- (NSString *)generateProtectValueSign:(NSDictionary *)params
{
    //第一步,将key和value生成对应的字符串,存入数组中
    NSMutableArray *stringArray = [NSMutableArray array];
    [params enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [stringArray addSafeObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
    }];
    //第二步,将stringArray按照ASCII码从小到大排序
    NSStringCompareOptions comparisonOptions = NSNumericSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        NSRange range =NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    NSArray *ASCIIStringArray = [stringArray sortedArrayUsingComparator:sort];
    //第三步,拼接字符串
    NSMutableString *sortedString = [[NSMutableString alloc] initWithString:@""];
    [ASCIIStringArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == ASCIIStringArray.count - 1) {
            [sortedString appendString:obj];
        } else {
            [sortedString appendString:[NSString stringWithFormat:@"%@&", obj]];
        }
    }];
    //第四步,拼接上特殊的key,key=1234567890
    [sortedString appendString:[NSString stringWithFormat:@"&key=%@", SpecialKeyValue]];
    //第五步,MD5加密
    NSString *md5String = [sortedString bitinfo_md5hashString];
    //第六步,全部转大写
    return [md5String uppercaseString];
}

#pragma mark - 处理请求错误码

- (NSError *)handleErrorCode:(NSError *)defaultError
{
    NSError *underlyingError = defaultError.userInfo[NSUnderlyingErrorKey];
    
    NSInteger errorCode = defaultError.code;
    if (underlyingError) {
        errorCode = underlyingError.code;
    }
    NSError *error = nil;
    switch (errorCode) {
        case NSURLErrorTimedOut://超时
            error = [NSError errorWithDomain:@"请求超时,请稍后重试"
                                        code:NSURLErrorTimedOut
                                    userInfo:defaultError.userInfo];
            break;
        case 3840://解析失败
            error = [NSError errorWithDomain:@"json格式解析出错" code:3840 userInfo:defaultError.userInfo];
            break;
        case NSURLErrorNotConnectedToInternet://无网络连接
            error = [NSError errorWithDomain:@"暂无网络链接，请检查网络后再重试"
                                        code:NSURLErrorNotConnectedToInternet
                                    userInfo:defaultError.userInfo];
            break;
        case NSURLErrorUserCancelledAuthentication://无网络连接
                  error = [NSError errorWithDomain:@"连接失败，因为用户取消了所需的身份验证，请在设置里对应app访问权限中设置允许网"
                                              code:NSURLErrorUserCancelledAuthentication
                                          userInfo:defaultError.userInfo];
            break;
        case NSURLErrorUserAuthenticationRequired://无网络连接
                 error = [NSError errorWithDomain:@"连接失败，因为需要身份验证，若已经允许使用网络请重启app，若重启app还是无法联网，请开关网络"
                                             code:NSURLErrorUserAuthenticationRequired
                                         userInfo:defaultError.userInfo];
            break;
        case NSURLErrorCannotParseResponse://无网络连接
          error = [NSError errorWithDomain:@"暂无网络链接，数据无法解析，请检查网络后再重试"
                                      code:NSURLErrorCannotParseResponse
                                  userInfo:defaultError.userInfo];
            break;
        case NSURLErrorHTTPTooManyRedirects://重定向
           error = [NSError errorWithDomain:@"请求被重定向"
                                       code:NSURLErrorHTTPTooManyRedirects
                                   userInfo:defaultError.userInfo];
            break;
        case NSURLErrorBadServerResponse:
            error = [NSError errorWithDomain:@"服务器无响应"
                                        code:NSURLErrorBadServerResponse
                                    userInfo:defaultError.userInfo];
            break;
        case NSURLErrorCancelled:
            error = [NSError errorWithDomain:@"请求被取消"
                                        code:NSURLErrorCancelled
                                    userInfo:defaultError.userInfo];
            break;
        default:
            error = defaultError;
            break;
    }
    if(!IsEmptyString(error.domain) && [error.domain isEqualToString:@"NSURLErrorDomain"])
    {
        error = [NSError errorWithDomain:[NSString stringWithFormat:@"暂无网络链接，请检查网络后再重试 Code=%ld", (long)error.code]
                                    code:NSURLErrorNotConnectedToInternet
                                userInfo:defaultError.userInfo];
    }
    error = [self checkLogoutError:error];
    return error;
}


#pragma mark -取消某一个请求

- (void)cancelRequestApi:(BITRequestApi *)requestApi
{
    NSEnumerator *keyEnumerator = [self.requestMap keyEnumerator];
    NSString *key;
    while (key = [keyEnumerator nextObject]) {
        if ([key hasPrefix:requestApi.uniqueIdentify]) {
            [requestApi.requestTask cancel];
            break;
        }
    }
    Lock();
    [self.requestMap removeObjectForKey:key];
    Unlock();
}


- (void)cancelRequestApis:(NSArray<BITRequestApi *> *)apis
{
    for (BITRequestApi *api in apis) {
        NSEnumerator *keyEnumerator = [self.requestMap keyEnumerator];
        NSString *key;
        while (key = [keyEnumerator nextObject]) {
            if ([key hasPrefix:api.uniqueIdentify]) {
                [api.requestTask cancel];
                break;
            }
        }
        Lock();
        [self.requestMap removeObjectForKey:key];
        Unlock();
    }
}

- (void)cancelAllRequests
{
    NSEnumerator *objectEnumerator = [self.requestMap objectEnumerator];
    BITRequestApi *api;
    while (api = [objectEnumerator nextObject]) {
        [api.requestTask cancel];
    }
    Lock();
    self.requestCount = 0;
    [self.requestMap removeAllObjects];
    Unlock();
}
#pragma mark -- 小数点精度丢失问题处理
-(NSMutableDictionary *)setDecimalPointPrecisionProcessing:(NSMutableDictionary *)tmpDict{
    
    if(tmpDict){
        
        return [self setParseDict:tmpDict];
    }
    
    return nil;
}
-(NSMutableDictionary *)setParseDict:(NSMutableDictionary *)dict{
    
    NSArray * allKeys = [dict allKeys];
    
    for (int i = 0; i<allKeys.count; i++) {
        
        NSString * tmpKey = allKeys[i];
        
        id tmpValue = dict[tmpKey];
        
        if([tmpValue isKindOfClass:[NSNumber class]]){
            
            [dict setObject:[self reviseNum:tmpValue] forKey:tmpKey];
            
        }else if ([tmpValue isKindOfClass:[NSArray class]]){
            
            NSMutableArray * arr = [NSMutableArray arrayWithArray:tmpValue];
            
            [dict setObject:[self setParseArray:arr] forKey:tmpKey];
            
        }else if ([tmpValue isKindOfClass:[NSDictionary class]]){
            
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:tmpValue];
            
            [dict setObject:[self setParseDict:dic] forKey:tmpKey];
        }
    }
    
    return dict;
}
-(NSMutableArray *)setParseArray:(NSMutableArray *)tmpArr{
    
    for (int i = 0; i < tmpArr.count; i++) {
        
        id tmpValue = tmpArr[i];
        
        if([tmpValue isKindOfClass:[NSNumber class]]){
            
            [tmpArr replaceObjectAtIndex:i withObject:[self setPareseNumber:tmpValue]];
            
        }else if ([tmpValue isKindOfClass:[NSArray class]]){
            
            NSMutableArray * arr = [NSMutableArray arrayWithArray:tmpValue];
            
            [tmpArr replaceObjectAtIndex:i withObject:[self setParseArray:arr]];
            
        }else if ([tmpValue isKindOfClass:[NSDictionary class]]){
            
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:tmpValue];
            
            [tmpArr replaceObjectAtIndex:i withObject:[self setParseDict:dic]];
        }
    }
    
    return tmpArr;
}
-(NSDecimalNumber *)setPareseNumber:(NSNumber *)tmpNumber{
    
    return  [self reviseNum:tmpNumber];
}
-(NSDecimalNumber *)reviseNum:(NSNumber *)tmpNum{
    
    double tmpValue = [tmpNum doubleValue];
    
    NSString * tmpDoubleStr = [NSString stringWithFormat:@"%lf",tmpValue];
    
    NSDecimalNumber * tmpNumber = [NSDecimalNumber decimalNumberWithString:tmpDoubleStr];
    
    return tmpNumber;
}



@end

