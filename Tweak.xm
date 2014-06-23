#include <objc/runtime.h>

#define prefFilePath @"/var/mobile/Library/Preferences/tw.hiraku.linehideme.plist"

@interface NLChatListCell : UITableViewCell
@property(assign, nonatomic) UILabel* nameLabel;
@end

@interface FriendsTableViewCell : UITableViewCell
@property(assign, nonatomic) UILabel* nameLabel;
@end

@interface ChatListViewController : UIViewController
@property(retain, nonatomic) UITableView* tableView;
@end

@interface TalkUserObject : NSObject
-(id)displayUserName;
@end

@interface MessageViewController : UIViewController
@property(retain, nonatomic) TalkUserObject* friendObject;
@end

@interface EachTalkSettingsViewController : UITableViewController
@property(assign, nonatomic) MessageViewController* parentController;
@end

NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:prefFilePath];

%hook ChatListViewController
%new
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  	float heightForRow = 70;
  	NLChatListCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
  	if ([[plistDict objectForKey:cell.nameLabel.text] boolValue] == YES && [[plistDict objectForKey:@"Enable"] boolValue] == YES)
	  	return 0;
  	return heightForRow;
}
%end

%hook FriendsViewController
%new
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  	float heightForRow = 50;
  	FriendsTableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
  	if ([cell respondsToSelector:@selector(nameLabel)]){
  		if ([[plistDict objectForKey:cell.nameLabel.text] boolValue] == YES && [[plistDict objectForKey:@"Enable"] boolValue] == YES)
	  		return 0;
  	}
  	return heightForRow;
}
%end

%hook EachTalkSettingsViewController
-(void)viewDidLoad {
	NSString *user = [self.parentController.friendObject displayUserName];
	UIButton *hideMe = [[UIButton alloc] initWithFrame:CGRectMake(0,300,320,50)];
	[hideMe setBackgroundColor:[UIColor whiteColor]];
	if (![self checkHide:user]) {
		[hideMe setTitle:[NSString stringWithFormat:@"Hide %@",user] forState:UIControlStateNormal];
		[hideMe addTarget:self action:@selector(hideUser:) forControlEvents:UIControlEventTouchUpInside];
	}
	else {
		[hideMe setTitle:[NSString stringWithFormat:@"Unhide %@",user] forState:UIControlStateNormal];
		[hideMe addTarget:self action:@selector(unhideUser:) forControlEvents:UIControlEventTouchUpInside];
	}
	[hideMe setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	
	[self.view addSubview:hideMe];
	%orig;
}

%new
-(void)hideUser:(UIButton *)sender {
	NSString *name = [sender.titleLabel.text substringFromIndex:5];
	[plistDict setObject:@YES forKey:name];
	[plistDict writeToFile:prefFilePath atomically:YES];
	[sender setTitle:[NSString stringWithFormat:@"Unhide %@",name] forState:UIControlStateNormal];
	[sender removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
	[sender addTarget:self action:@selector(unhideUser:) forControlEvents:UIControlEventTouchUpInside];
}

%new
-(void)unhideUser:(UIButton *)sender {
	NSString *name = [sender.titleLabel.text substringFromIndex:7];
	[plistDict setObject:@NO forKey:name];
	[plistDict writeToFile:prefFilePath atomically:YES];
	[sender setTitle:[NSString stringWithFormat:@"Hide %@",name] forState:UIControlStateNormal];
	[sender removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
	[sender addTarget:self action:@selector(hideUser:) forControlEvents:UIControlEventTouchUpInside];
}

%new 
-(BOOL)checkHide:(NSString *)name {
	if ([plistDict objectForKey:name] == nil || [[plistDict objectForKey:name] boolValue] == NO)
		return NO;
	return YES;
}
%end

%ctor {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    %init;
    if (![[NSFileManager defaultManager] fileExistsAtPath:prefFilePath]) {
    	NSDictionary* pref = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@NO,@"Enable",nil];
 		[pref writeToFile:prefFilePath atomically:YES];
    }
    [pool release];
}