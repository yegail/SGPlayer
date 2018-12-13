//
//  SGAudioFrame.m
//  SGPlayer
//
//  Created by Single on 2018/1/19.
//  Copyright © 2018年 single. All rights reserved.
//

#import "SGAudioFrame.h"
#import "SGFrame+Internal.h"
#import "SGObjectPool.h"

@interface SGAudioFrame ()

{
    int _linesize[SGFramePlaneCount];
    uint8_t *_data[SGFramePlaneCount];
}

@end

@implementation SGAudioFrame

+ (instancetype)audioFrameWithDescription:(SGAudioDescription *)description numberOfSamples:(int)numberOfSamples
{
    SGAudioFrame *frame = [[SGObjectPool sharedPool] objectWithClass:[SGAudioFrame class]];
    frame.core->format = description.format;
    frame.core->sample_rate = description.sampleRate;
    frame.core->channels = description.numberOfChannels;
    frame.core->channel_layout = description.channelLayout;
    frame.core->nb_samples = numberOfSamples;
    int linesize = [description linesize:numberOfSamples];
    int numberOfPlanes = description.numberOfPlanes;
    for (int i = 0; i < numberOfPlanes; i++) {
        uint8_t *data = av_mallocz(linesize);
        memset(data, 0, linesize);
        AVBufferRef *buffer = av_buffer_create(data, linesize, av_buffer_default_free, NULL, 0);
        frame.core->buf[i] = buffer;
        frame.core->data[i] = buffer->data;
        frame.core->linesize[i] = buffer->size;
    }
    return frame;
}

#pragma mark - Setter & Getter

- (SGMediaType)type
{
    return SGMediaTypeAudio;
}

- (int *)linesize
{
    return self->_linesize;
}

- (uint8_t **)data
{
    return self->_data;
}

#pragma mark - Data

- (void)clear
{
    [super clear];
    self->_numberOfSamples = 0;
    for (int i = 0; i < SGFramePlaneCount; i++) {
        self->_data[i] = nil;
        self->_linesize[i] = 0;
    }
    self->_audioDescription = nil;
}

#pragma mark - Control

- (void)fill
{
    [super fill];
    AVFrame *frame = self.core;
    self->_numberOfSamples = frame->nb_samples;
    for (int i = 0; i < SGFramePlaneCount; i++) {
        self->_data[i] = frame->data[i];
        self->_linesize[i] = frame->linesize[i];
    }
    CMTime scale = CMTimeMake(1, 1);
    for (SGTimeLayout *obj in self.codecDescription.timeLayouts) {
        scale = SGCMTimeMultiply(scale, obj.scale);
    }
    self->_audioDescription = [[SGAudioDescription alloc] init];
    self->_audioDescription.format = frame->format;
    self->_audioDescription.sampleRate = frame->sample_rate / CMTimeGetSeconds(scale);
    self->_audioDescription.numberOfChannels = frame->channels;
    self->_audioDescription.channelLayout = frame->channel_layout ? frame->channel_layout : av_get_default_channel_layout(frame->channels);
}

@end
