//
//  SGMapping.h
//  SGPlayer
//
//  Created by Single on 2018/1/26.
//  Copyright © 2018年 single. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGGLTextureUploader.h"
#import "SGGLViewport.h"
#import "SGGLProgram.h"
#import "SGDefines.h"
#import "SGGLModel.h"
#import "avutil.h"
#import "pixfmt.h"
#import "dict.h"

// FF/SG -> GL
SGGLModelType SGDisplay2Model(SGDisplayMode displayMode);
SGGLProgramType SGFormat2Program(enum AVPixelFormat format, CVPixelBufferRef pixelBuffer);
SGGLTextureType SGFormat2Texture(enum AVPixelFormat format, CVPixelBufferRef pixelBuffer);
SGGLViewportMode SGScaling2Viewport(SGScalingMode scalingMode);

// FF <-> SG
SGMediaType SGMediaTypeFF2SG(enum AVMediaType mediaType);
enum AVMediaType SGMediaTypeSG2FF(SGMediaType mediaType);

// FF <-> AV
OSType SGPixelFormatFF2AV(enum AVPixelFormat format);
enum AVPixelFormat SGPixelFormatAV2FF(OSType format);

// FF <-> NS
AVDictionary * SGDictionaryNS2FF(NSDictionary * dictionary);
NSDictionary * SGDictionaryFF2NS(AVDictionary * dictionary);
