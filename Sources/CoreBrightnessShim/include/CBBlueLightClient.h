#import <Foundation/Foundation.h>

typedef struct {
    int hour;
    int minute;
} Time;

typedef struct {
    Time fromTime;
    Time toTime;
} Schedule;

typedef struct {
    char active;
    char enabled;
    char sunSchedulePermitted;
    int mode;
    Schedule schedule;
    unsigned long long disableFlags;
} StatusData;

@interface CBBlueLightClient : NSObject

+ (BOOL)supportsBlueLightReduction;

- (BOOL)setEnabled:(BOOL)enabled;
- (BOOL)setMode:(int)mode;
- (BOOL)getStrength:(float *)strength;
- (BOOL)setStrength:(float)strength commit:(BOOL)commit;
- (BOOL)getBlueLightStatus:(StatusData *)status;
- (void)setStatusNotificationBlock:(void (^)(void))block;

@end
