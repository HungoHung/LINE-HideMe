#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"
#import <notify.h>
static NSString * const PREF_PATH = @"/var/mobile/Library/Preferences/tw.hiraku.linehideme.plist";
static NSString * const kSwitchKey = @"Enable";

@interface LINE_HideMe_FlipSwitch : NSObject <FSSwitchDataSource>
@end

@implementation LINE_HideMe_FlipSwitch

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:PREF_PATH];
    id enable = [dict objectForKey:kSwitchKey];
    BOOL isEnabled = enable ? [enable boolValue] : YES;
    return isEnabled ? FSSwitchStateOn : FSSwitchStateOff;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:PREF_PATH];
    NSMutableDictionary *mutableDict = dict ? [[dict mutableCopy] autorelease] : [NSMutableDictionary dictionary];
    switch (newState) {
        case FSSwitchStateIndeterminate:
            return;
        case FSSwitchStateOn:
            [mutableDict setValue:@YES forKey:kSwitchKey];
            break;
        case FSSwitchStateOff:
            [mutableDict setValue:@NO forKey:kSwitchKey];
            break;
    }
    [mutableDict writeToFile:PREF_PATH atomically:YES];
    system("killall LINE");
}

@end
