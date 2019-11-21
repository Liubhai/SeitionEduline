//
//  BRDownHelpManager.m
//  YunKeTang
//
//  Created by git burning on 2019/6/16.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "BRDownHelpManager.h"
#import "BRWeakMutableArray.h"
#import "ZBLM3u8Manager.h"
#import "ZBLM3u8FileManager.h"
@interface BRDownHelpManager()
@property (nonatomic, strong) BRWeakMutableArray *delegatesArray;
@property (nonatomic, strong) dispatch_queue_t ioQueue;

@end
@implementation BRDownHelpManager
+(instancetype)manager{
    static BRDownHelpManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BRDownHelpManager alloc] init];
    });
    return manager;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.delegatesArray = [[BRWeakMutableArray alloc] init];
        _ioQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    }
    return self;
}
-(void)br_addDelegates:(id<BRUpdateDownProgressDelegate>)delegate{
    if (![self.delegatesArray.allObjects containsObject:delegate]) {
        [self.delegatesArray addObject:delegate];
    }
}

- (void)br_startDownUrl:(NSString *)url dictInfo:(nonnull NSDictionary *)info{
    if (url.length > 0) {
        __weak BRDownHelpManager *help = self;
        [[ZBLM3u8Manager shareInstance] downloadVideoWithUrlString:url downloadProgressHandler:^(float progress, NSString *oriUrl) {
            [help br_updateProgressUrl:oriUrl progress:progress localPlayUrlString:nil courseInfo:info];
        } downloadSuccessBlock:^(NSString *localPlayUrlString, NSString *oriUrl) {
            [help br_updateProgressUrl:oriUrl progress:1 localPlayUrlString:localPlayUrlString courseInfo:info];

        }];
    }
}

- (void)br_updateProgressUrl:(NSString *)oriUrl progress:(float)progress localPlayUrlString:(NSString *)localUrl courseInfo:(NSDictionary *)courseInfo {
    [self.delegatesArray.allObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj conformsToProtocol:@protocol(BRUpdateDownProgressDelegate)]) {
            id<BRUpdateDownProgressDelegate> a_delegate = obj;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (localUrl.length > 0) {
                    [a_delegate downHelpUpdateProgress:progress url:oriUrl isDownFinish:YES courseInfo:courseInfo];
                }
                else{
                    [a_delegate downHelpUpdateProgress:progress url:oriUrl isDownFinish:NO courseInfo:courseInfo];
                }
            });
        }
    }];
}


#pragma mark --- 保存课程信息
-(void)br_saveCoureData:(NSDictionary *)data coureInfo:(NSDictionary *)info{
    NSString *id_str =[info valueForKey:@"id"];
    if (id_str) {
        NSString *videoInfoPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"videoInfo"];
        NSString *folderPath = videoInfoPath;
        videoInfoPath = [videoInfoPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_down.data",id_str]];
        [[NSFileManager defaultManager] removeItemAtPath:videoInfoPath error:nil];
//        videoInfoPath = [NSString stringWithFormat:@"%@/%@_down.data",videoInfoPath,id_str];
        if ([ZBLM3u8FileManager exitItemWithPath:videoInfoPath]) {
            [ZBLM3u8FileManager tryGreateDir:folderPath];
            dispatch_async(_ioQueue, ^{
                NSData *json_str_data = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
                NSString *json_str = [[NSString alloc] initWithData:json_str_data encoding:NSUTF8StringEncoding];
                NSError *error;
                json_str = [json_str stringByReplacingOccurrencesOfString:@"null" withString:@"\" \""];
                json_str = [json_str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                json_str = [json_str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                
                BOOL end =  [json_str writeToFile:videoInfoPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
                if (end) {
                    NSLog(@"写入成功");
                }
                else{
                    NSLog(@"写入失败");
                    [[NSFileManager defaultManager] removeItemAtPath:videoInfoPath error:nil];
                }
            });
        }
        else{
            [ZBLM3u8FileManager tryGreateDir:folderPath];
            dispatch_async(_ioQueue, ^{
                NSData *json_str_data = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
                NSString *json_str = [[NSString alloc] initWithData:json_str_data encoding:NSUTF8StringEncoding];
                NSError *error;
                json_str = [json_str stringByReplacingOccurrencesOfString:@"null" withString:@"\" \""];
                json_str = [json_str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                json_str = [json_str stringByReplacingOccurrencesOfString:@"\r" withString:@""];

                BOOL end =  [json_str writeToFile:videoInfoPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
                if (end) {
                    NSLog(@"写入成功");
                }
                else{
                    NSLog(@"写入失败");
                    [[NSFileManager defaultManager] removeItemAtPath:videoInfoPath error:nil];
                }
            });

            
        }
    }
}
-(NSDictionary *)br_getCourseInfoWithListCourseInfo:(NSDictionary *)info{
    NSString *id_str =[info valueForKey:@"id"];
    if (id_str) {
        NSString *videoInfoPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"videoInfo"];
        videoInfoPath = [videoInfoPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_down.data",id_str]];
//        videoInfoPath = [NSString stringWithFormat:@"%@/%@_down.data",videoInfoPath,id_str];

        if ([ZBLM3u8FileManager exitItemWithPath:videoInfoPath]) {
            NSString *str = [NSString stringWithContentsOfFile:videoInfoPath encoding:NSUTF8StringEncoding error:nil];
            NSData * str_data = [str dataUsingEncoding:NSUTF8StringEncoding];
           // NSArray *temp = [[NSArray alloc] initWithContentsOfFile:videoInfoPath];
            NSError *eroor;
            id info = [NSJSONSerialization JSONObjectWithData:str_data options:NSJSONReadingAllowFragments error:&eroor];
           
            return info;
        }
        else{
            return nil;
        }
    }
    else{
        return nil;
    }
}
@end
