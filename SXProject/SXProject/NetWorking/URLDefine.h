//
//  URLDefine.h
//  SXProject
//
//  Created by 王威 on 2024/4/18.
//

#ifndef URLDefine_h
#define URLDefine_h

//RSA 秘钥
#define PrivateKey @"MIIBOgIBAAJBAMfnMMXYp6EGUF2TiWMGvSC4f6hYt0NC+2GQaxeXOjv+y7MH4DFKwKv6v+pd6kQGDII6rsr5Xnr2a4jGYvV99I0CAwEAAQJBAMe8PkVQpp0DvATjx2BEeXBaKGNC0UnJgXcIX5igp7UMqtWhJWHUv/gtmd6aLVUJ+RNThUszkJyFOkpQ6/asjYECIQDjHO9TvFe2C9v1zLhfwct6T+LyrAs0AvOyrIs42SmXEQIhAOFURK7BNP68rz6KAFm6uS7KEyUIVoqsN+VEDdpF5J29AiBYAfpsBGwoy2etVGuOD9b9yr8zMqAUw6AT+PDqUpzfQQIgS5FyU1VSi5gGAahQg8c+cbWtg/7u3yTwvf/70VcdW9UCIG+4wWFD/mAJU1boQIBrDJROzz23QzhyOEEZZ04OLokt"

#define Lock()   dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
#define Unlock() dispatch_semaphore_signal(_semaphore)

#if BITRequestLoggingEnabled
#define LogDebug(s, ...) NSLog( @"%@:%d %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )//分别是文件名，在文件的第几行，自定义输出内容

#else
#define LogDebug(frmt, ...)     {}
#endif


#define kPageSize  @"10"

#define ENVIRONMENT 0 //  0－开发/1－正式

#if ENVIRONMENT == 0
/* ************************  开发服务器接口地址  *********************************** */
//扫地机 http://marvel-sit.booleancloud.cn/
//http://192.168.2.162:18081/
//#define kBaseURL @"http://marvel-sit.booleancloud.cn"
//#define kBaseURL @"http://marvel-dev.booleancloud.cn"

#define SX_WebBaseUrl  @"http://app_web.cloudsmart.store/"

// 0测试|1开发环境 2生产环境
// 获取标准的 UserDefaults 实例

#define HostDisUrl  [[NSUserDefaults standardUserDefaults] boolForKey:@"httpUrl"]

// 0测试|1生产环境
#define kBaseURL HostDisUrl? NSLocalizedString(@"http://marvel-dev.booleancloud.cn", @""): NSLocalizedString(@"http://marvel-sit.booleancloud.cn", @"")

/*******************************************************************************************/

#elif ENVIRONMENT == 1

/* ************************  发布正式服务器接口地址  *********************************** */

//192.168.2.162:18081/
#define kBaseURL @"http://marvel.booleancloud.cn"

#define SX_WebBaseUrl  @"http://app_web.cloudsmart.store/"

/*******************************************************************************************/

#endif
/* ************************  设备添加相关接口  *********************************** */
//设备添加成功时候的状态
#define SX_AddDeviceStatus @"app/device/management/queryWifiConfigRecord"



#endif /* URLDefine_h */
