# EasyMediaProcDemo
iOS平台上音视频播放Demo

# 主要功能
1、支持大多数常见的音/视频格式播放<br>
2、支持OpenGLES、Metal两种方式的视频渲染<br>
3、支持FFmpeg音视频软解码<br>
4、支持H264、HEVC的VideoToolBox硬件编解码<br>
5、支持0.5x~3.0x范围内的动态倍速调整<br>
6、支持动态添加图片水印<br>
7、支持音视频录制，视频数据H264&HEVC硬件编码，音频数据AAC硬件编码<br>
8、支持ffmpeg的常见命令在iOS平台上的应用，包括但不限于以下功能
  * 支持常见的视频格式转换<br>
  * 支持常见的音频格式转换<br>
  * 支持播放倍速调整<br>
  * 支持音视频裁剪、缩放、旋转<br>
  * 支持获取任意位置的视频封面<br>
    
# SDK集成

项目依赖EasyMediaProc.framework，framework位于项目的ThirdFrameWorks目录下<br>
<br>
1、添加以下依赖库<br>
   * VideoToolbox.framework<br>
   * AudioToolbox.framework<br>
   * EasyMediaProc.framework<br>
   * libbz2.tbd<br>
   * libiconv.tbd<br>
   * libz.tbd<br>

2、将ThirdFrameWorks目录中的EasyMediaProc.bundle添加到项目中<br>
   
