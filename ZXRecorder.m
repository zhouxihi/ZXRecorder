//
//  ZXRecorder.m
//  RecordDemo
//
//  Created by Jackey on 2017/10/19.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "ZXRecorder.h"

#import <AVFoundation/AVFoundation.h>

@interface ZXRecorder ()

@property (nonatomic, strong) AVAudioRecorder   *recorder;
@property (nonatomic, strong) NSString          *basePath;
@property (nonatomic, assign) BOOL              meteringEnable;

@end

@implementation ZXRecorder

static ZXRecorder *_instance = nil;

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[super allocWithZone:NULL] init];
    });
    
    return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    
    return [ZXRecorder shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    
    return [ZXRecorder shareInstance];
}

- (void)setBaseFilePath:(NSString *)basePath {
    
    self.basePath = basePath;
}

- (NSString *)getBasePath {
    
    if (self.basePath) {
        
        BOOL exist;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:self.basePath isDirectory:&exist]) {
            
            [fileManager createDirectoryAtPath:self.basePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        return self.basePath;
    } else {
        
        NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        BOOL exist;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:[document stringByAppendingPathComponent:@"recorder"] isDirectory:&exist]) {
            
            [fileManager createDirectoryAtPath:[document stringByAppendingPathComponent:@"recorder"] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        return [document stringByAppendingPathComponent:@"recorder"];
    }
}

- (NSString *)getAudioFileWithName:(NSString *)name {
    
    NSString *path = [[self getBasePath] stringByAppendingPathComponent:name];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        
        return path;
    } return nil;
}

- (void)PrepareWithFileName:(NSString *)fileName formate:(AudioFormatID)format {
    
    if (self.recorder) {
        
        [self.recorder stop];
        self.recorder = nil;
    }
    
    NSDictionary *settings = @{AVFormatIDKey: @(format),
                               AVSampleRateKey: @22050.0f,
                               AVNumberOfChannelsKey: @1
                               };
    
    NSError *error;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:[[self getBasePath] stringByAppendingPathComponent:fileName]] settings:settings error:&error];
    
    NSLog(@"filePath: %@", [[self getBasePath] stringByAppendingPathComponent:fileName]);
    
    if (self.recorder) {
        
        self.recorder.meteringEnabled = self.meteringEnable;
        [self.recorder prepareToRecord];
    } else {
        
        NSLog(@"创建recorder失败");
    }
}

- (BOOL)record {
    
    if (self.recorder) {
        
        return [self.recorder record];
    }
    
    return false;
}

- (void)pause {
    
    if (self.recorder) {
        
        [self.recorder pause];
    }

}

- (void)stop {
    
    if (self.recorder) {
        
        [self.recorder stop];
    }
    
}

- (BOOL)recordAtTime:(NSTimeInterval)time {
    
    if (self.recorder) {
        
        return [self.recorder recordAtTime:time];
    }
    
    return false;
}

- (BOOL)recordForDuration:(NSTimeInterval)duration {
    
    if (self.recorder) {
        
        return [self.recorder recordForDuration:duration];
    }
    
    return false;
}

- (BOOL)deleteRecentFile {
    
    if (self.recorder) {
        
        return [self.recorder deleteRecording];
    }
    
    return false;
}

- (NSURL *)getRecentFilePath {
    
    if (self.recorder) {
        
        return [self.recorder url];
    }
    
    return nil;
}

- (NSInteger)getRecordTimeNow {
    
    if (self.recorder) {
        
        return (NSUInteger)[self.recorder currentTime];
    }
    
    return 0;
}

- (void)setMetering:(BOOL)enable {
    
    self.meteringEnable = enable;
}

- (CGFloat)getPeakPowerForChannel {
    
    if (self.recorder) {
        
        if (self.recorder.meteringEnabled) {
            
            [self.recorder updateMeters];
            return [self.recorder peakPowerForChannel:0];
        }
    }
    
    return 1;
}

- (CGFloat)getAveragePowerForChannel {

    if (self.recorder) {
        
        if (self.recorder.meteringEnabled) {
            
            [self.recorder updateMeters];
            return [self.recorder averagePowerForChannel:0];
        }
    }
    
    return 1;
}

@end
