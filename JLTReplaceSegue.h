#import <UIKit/UIKit.h>

@interface JLTReplaceSegue : UIStoryboardSegue

@end

@interface UIViewController (JLTReplaceSegue)

@property (strong, nonatomic) NSString *identifierOfFinalReplacementSegue;

@end
