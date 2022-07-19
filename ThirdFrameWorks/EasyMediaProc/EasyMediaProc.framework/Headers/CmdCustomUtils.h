//
//  CmdCustomUtils.h
//  EasyMediaProc
//
//  Created by kkfinger on 2022/4/26.
//

typedef void(^ProgressHandler)(float progress);

///获取输入源文件的时长
void fftools_set_duration(long long duration);
// 设置倍速
void fftools_set_speed(float speed);
///获取当前的处理进度
void fftools_update_current_time_from_progress_info(char *progressInfo);
// 当前进度回调
void fftools_register_progress_handler(ProgressHandler handler);
// 处理字符串空格问题
const char *fftools_dealWith_blankspace(const char *strs);
