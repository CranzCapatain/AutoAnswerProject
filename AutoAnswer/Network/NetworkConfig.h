//
//  NetworkConfig.h
//  SJOnLine
//
//  Created by 金峰 on 2017/5/27.
//  Copyright © 2017年 金峰. All rights reserved.
//

#ifndef NetworkConfig_h
#define NetworkConfig_h

// fetch URL
#ifdef DEBUG
#define Request_Host    @"140.143.49.31" // 140.143.49.31
#define Request_Port    @"" //端口号 91
// socket
#define Socket_Host     Request_Host
#define Socket_Port     @"9999"
#else
#define Request_Host    @"140.143.49.31"
#define Request_Port    @"" //端口号
// socket
#define Socket_Host     Request_Host
#define Socket_Port     @"9999"
#endif

#define kHTTP_HEADER_Referer @"http://nb.sa.sogou.com/"
#define kHTTP_HEADER_User_Agent @"Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_3 like Mac OS X) AppleWebKit/603.3.8 (KHTML, like Gecko) Mobile/14G60 Sogousearch/Ios/5.9.7"

#endif /* NetworkConfig_h */
