#import <UIKit/UIKit.h>

extern const NSUInteger JLTReplaceSeguePass;

@protocol JLTReplaceSegueNavigationStackManipulator <NSObject>

- (NSUInteger)numberOfViewControllersReplacedBySegue:(UIStoryboardSegue *)segue;

@end

@interface JLTReplaceSegue : UIStoryboardSegue <JLTReplaceSegueNavigationStackManipulator>

@end
