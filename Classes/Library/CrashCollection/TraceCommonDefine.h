//
//  Header.h
//  ElongClient
//
//  Created by chenggong on 13-9-29.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#ifndef ElongClient_TRACE_Header_h
#define ElongClient_TRACE_Header_h

#define kTraceButtonCLickThreshold      40
#define kTraceButtonClickTarget         @"ButtonClickTarget"
#define kTraceButtonCLickAction         @"ButtonClickAction"

#define Event_TraceButtonClick          @"Event_ButtonClick"                                //用户点击按钮

//#define kUserClickTraceLogFilename      @"LocalCache/ClickTrace"
#define kUserClickTraceLogFilename      @"Hoptoad Notices/ClickTrace.plist"
#define kUserClickTraceLogTime          @"TraceLog1Time"
#define kUserClickTraceLogTarget        @"TraceLog2Target"
#define kUserClickTraceLogAction        @"TraceLog3Action"

#endif
