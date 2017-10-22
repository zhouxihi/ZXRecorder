//
//  ZXRecorder.h
//  RecordDemo
//
//  Created by Jackey on 2017/10/19.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ZXRecorder : NSObject

/**
 创建单例

 @return 单例
 */
+ (instancetype)shareInstance;

/**
 初始化录音模块

 @param fileName 录音文件名(推荐.caf后缀)
 @param format 录音格式, iOS支持的格式有以下这些:
 CF_ENUM(AudioFormatID)
 {
 kAudioFormatLinearPCM               = 'lpcm',
 kAudioFormatAC3                     = 'ac-3',
 kAudioFormat60958AC3                = 'cac3',
 kAudioFormatAppleIMA4               = 'ima4',
 kAudioFormatMPEG4AAC                = 'aac ',
 kAudioFormatMPEG4CELP               = 'celp',
 kAudioFormatMPEG4HVXC               = 'hvxc',
 kAudioFormatMPEG4TwinVQ             = 'twvq',
 kAudioFormatMACE3                   = 'MAC3',
 kAudioFormatMACE6                   = 'MAC6',
 kAudioFormatULaw                    = 'ulaw',
 kAudioFormatALaw                    = 'alaw',
 kAudioFormatQDesign                 = 'QDMC',
 kAudioFormatQDesign2                = 'QDM2',
 kAudioFormatQUALCOMM                = 'Qclp',
 kAudioFormatMPEGLayer1              = '.mp1',
 kAudioFormatMPEGLayer2              = '.mp2',
 kAudioFormatMPEGLayer3              = '.mp3',
 kAudioFormatTimeCode                = 'time',
 kAudioFormatMIDIStream              = 'midi',
 kAudioFormatParameterValueStream    = 'apvs',
 kAudioFormatAppleLossless           = 'alac',
 kAudioFormatMPEG4AAC_HE             = 'aach',
 kAudioFormatMPEG4AAC_LD             = 'aacl',
 kAudioFormatMPEG4AAC_ELD            = 'aace',
 kAudioFormatMPEG4AAC_ELD_SBR        = 'aacf',
 kAudioFormatMPEG4AAC_ELD_V2         = 'aacg',
 kAudioFormatMPEG4AAC_HE_V2          = 'aacp',
 kAudioFormatMPEG4AAC_Spatial        = 'aacs',
 kAudioFormatAMR                     = 'samr',
 kAudioFormatAMR_WB                  = 'sawb',
 kAudioFormatAudible                 = 'AUDB',
 kAudioFormatiLBC                    = 'ilbc',
 kAudioFormatDVIIntelIMA             = 0x6D730011,
 kAudioFormatMicrosoftGSM            = 0x6D730031,
 kAudioFormatAES3                    = 'aes3',
 kAudioFormatEnhancedAC3             = 'ec-3',
 kAudioFormatFLAC                    = 'flac',
 kAudioFormatOpus                    = 'opus'
 };

 */
- (void)PrepareWithFileName:(NSString *)fileName formate:(AudioFormatID)format;

- (BOOL)record; // 开始录音 或 恢复录音

- (void)pause;  // 暂停录音

- (void)stop;   // 结束录音

- (BOOL)recordAtTime:(NSTimeInterval)time;  // 定时录音

- (BOOL)recordForDuration:(NSTimeInterval)duration; // 录指定时长

- (void)setBaseFilePath:(NSString *)basePath;   // 设置录音文件存储位置, 默认document/recorder/下

- (BOOL)deleteRecentFile;   // 删除刚录制的音频文件

- (NSURL *)getRecentFilePath;   // 获取刚录制的文件地址

- (NSInteger)getRecordTimeNow;  // 获取当前录音时间

- (NSString *)getAudioFileWithName:(NSString *)name; // 获取指定录音文件名的位置

- (void)setMetering:(BOOL)enable;   // 设置是否开启音频测量, 需要在Prepare方法前调用

- (CGFloat)getAveragePowerForChannel;   // 获取评价音频强度

- (CGFloat)getPeakPowerForChannel;  // 获取最大音频强度

@end
