#import <UIKit/UIKit.h>
#import <spawn.h>
#import <AudioToolbox/AudioServices.h>

@interface SBRingerControl
- (void)safeModeMuteToggle1;
- (void)safeModeMuteToggle2;
- (void)safeModeMuteToggle3;
@end

BOOL toggledMute;

%hook SBRingerControl
- (void)setRingerMuted:(BOOL)arg1 {
    %orig;
    toggledMute = arg1;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self safeModeMuteToggle1];
    });
}

%new
- (void)safeModeMuteToggle1 {
    if (toggledMute) return;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self safeModeMuteToggle2];
    });
}

%new
- (void)safeModeMuteToggle2 {
    if (!toggledMute) return;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self safeModeMuteToggle3];
    });
}

%new
- (void)safeModeMuteToggle3 {
    AudioServicesPlaySystemSound(1521);

    pid_t pid;
    const char *args[] = {"killall", "-SEGV", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char * const *)args, NULL);
}
%end
