//
//  VideoListViewController.m
//  KKVideoPlayer
//
//  Created by yujianwu on 2022/5/3.
//

#import "VideoListViewController.h"
#import <Masonry/Masonry.h>
#import "VideoPlayerViewController.h"
#import <EasyMediaProc/FFmpegTools.h>

@interface VideoCell : UITableViewCell
@property(nonatomic)UILabel *nameLabel;
@property(nonatomic)UIImageView *videoImage;
- (void)updatePath:(NSString *)filePath;
@end

@implementation VideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.videoImage];
    [self.contentView addSubview:self.nameLabel];
    [self.videoImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(self.contentView).mas_offset(15).priority(998);
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.videoImage.mas_right).mas_offset(8);
        make.right.mas_equalTo(self.contentView).mas_offset(-15);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

- (void)updatePath:(NSString *)filePath {
    self.nameLabel.text = [[filePath pathComponents]lastObject];
    NSString *path = (NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *coverPath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@_corver.png", self.nameLabel.text]];
    if ([[NSFileManager defaultManager]fileExistsAtPath:coverPath]) {
        self.videoImage.image = [UIImage imageWithContentsOfFile:coverPath];
    } else {
        self.videoImage.image = nil;
    }
}

- (UIImageView *)videoImage {
    if (!_videoImage) {
        _videoImage = ({
            UIImageView *view = [UIImageView new];
            view.contentMode = UIViewContentModeScaleAspectFill;
            view.clipsToBounds = YES;
            view;
        });
    }
    return _videoImage;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = ({
            UILabel *view = [UILabel new];
            view.textColor = [UIColor blackColor];
            view.font = [UIFont systemFontOfSize:15];
            view.textAlignment = NSTextAlignmentLeft;
            view.lineBreakMode = NSLineBreakByTruncatingTail;
            view.numberOfLines = 1;
            view;
        });
    }
    return _nameLabel;
}

@end

@interface VideoListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic)UITableView *tableView;
@property(nonatomic)NSMutableArray<NSString *> *medias;
@property(nonatomic)dispatch_queue_t queue;
@end

@implementation VideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"VideoList";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.medias = @[
        [[NSBundle mainBundle] pathForResource:@"i-see-fire" ofType:@"mp4"],
        [[NSBundle mainBundle] pathForResource:@"The_Three_Diablos" ofType:@"avi"],
        [[NSBundle mainBundle] pathForResource:@"h264" ofType:@"MOV"],
        [[NSBundle mainBundle] pathForResource:@"hevc" ofType:@"MOV"],
        [[NSBundle mainBundle] pathForResource:@"TearsOfSteel_720p_h265" ofType:@"mkv"],
        [[NSBundle mainBundle] pathForResource:@"video_convert_asf" ofType:@"asf"],
        [[NSBundle mainBundle] pathForResource:@"video_convert_flv" ofType:@"flv"],
        [[NSBundle mainBundle] pathForResource:@"video_convert_mkv" ofType:@"mkv"],
        [[NSBundle mainBundle] pathForResource:@"video_convert_mov" ofType:@"mov"],
        [[NSBundle mainBundle] pathForResource:@"video_convert_mpeg" ofType:@"mpeg"],
        [[NSBundle mainBundle] pathForResource:@"video_convert_wmv" ofType:@"wmv"],
        [[NSBundle mainBundle] pathForResource:@"speed_play" ofType:@"mkv"],
        [[NSBundle mainBundle] pathForResource:@"audio_aac" ofType:@"aac"],
        [[NSBundle mainBundle] pathForResource:@"audio_flac" ofType:@"flac"],
        [[NSBundle mainBundle] pathForResource:@"video_h264" ofType:@"h264"],
        [[NSBundle mainBundle] pathForResource:@"audio_ogg" ofType:@"ogg"],
        [[NSBundle mainBundle] pathForResource:@"audio_aiff" ofType:@"aiff"],
        [[NSBundle mainBundle] pathForResource:@"audio_m4a" ofType:@"m4a"],
        [[NSBundle mainBundle] pathForResource:@"audio_wav" ofType:@"wav"],
        [[NSBundle mainBundle] pathForResource:@"audio_wma" ofType:@"wma"],
        [[NSBundle mainBundle] pathForResource:@"audio_ac3" ofType:@"ac3"],
    ].mutableCopy;
    
    NSString *path = (NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *videoPath = [path stringByAppendingString:@"/capture_test.asf"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:videoPath]) {
        [self.medias addObject:videoPath];
    }
    NSString *audioPath = [path stringByAppendingString:@"/capture_test.aac"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:audioPath]) {
        [self.medias addObject:audioPath];
    }
    
    self.queue = dispatch_queue_create("fetch video cover queue", DISPATCH_QUEUE_SERIAL);
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.tableView reloadData];
    [self loadVideoCover];
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
    [(VideoCell *)cell updatePath:[self.medias objectAtIndex:indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.medias.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoPlayerViewController *ctrl = [VideoPlayerViewController new];
    ctrl.filePath = [self.medias objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark -- 加载视频封面

- (void)loadVideoCover {
    for (NSInteger i = 0 ; i < self.medias.count; i++) {
        dispatch_async(_queue, ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            NSString *videoPath = [self.medias objectAtIndex:indexPath.row];
            NSString *videoName = [[videoPath pathComponents]lastObject];
            NSString *path = (NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *coverPath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@_corver.png", videoName]];
            if ([[NSFileManager defaultManager]fileExistsAtPath:coverPath]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                });
                return;
            }
            NSString *loadingKey = [NSString stringWithFormat:@"%@_loading", videoPath];
            BOOL isLoading = [[[NSUserDefaults standardUserDefaults]objectForKey:loadingKey]boolValue];
            if (isLoading) {
                return;
            }
            [[NSUserDefaults standardUserDefaults]setObject:@(YES) forKey:loadingKey];
            dispatch_semaphore_t s = dispatch_semaphore_create(0);
            [[FFmpegTools shareInstance]captureVideoCover:videoPath
                                     outputPath:coverPath
                                          range:nil
                                      completed:^(KKErrorType result) {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:loadingKey];
                if ([[NSFileManager defaultManager]fileExistsAtPath:coverPath]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    });
                }
                
                usleep(100 * 1000);
                
                dispatch_semaphore_signal(s);
            }];
            dispatch_semaphore_wait(s, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
        });
    }
}

#pragma mark -- getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = ({
            UITableView *view = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
            view.delegate = self;
            view.dataSource = self;
            [view registerClass:[VideoCell class] forCellReuseIdentifier:@"videoCell"];
            view.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            view.separatorInset = UIEdgeInsetsZero;
            view.layoutMargins = UIEdgeInsetsZero;
            view.delegate = self ;
            view.dataSource = self ;
            view.showsVerticalScrollIndicator = NO ;
            view.showsHorizontalScrollIndicator = NO ;
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
    }
    return _tableView;
}

@end

