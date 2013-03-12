#import <UIKit/UIKit.h>

extern const NSUInteger JLTReplaceSegueNotReplaced;

@protocol JLTReplaceSegueNavigationStackManipulator <NSObject>

- (NSUInteger)numberOfViewControllersReplacedByReplaceSegue:(UIStoryboardSegue *)segue;

@end

@interface JLTReplaceSegue : UIStoryboardSegue <JLTReplaceSegueNavigationStackManipulator>

@end
