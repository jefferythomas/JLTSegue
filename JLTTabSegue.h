#import <UIKit/UIKit.h>

@protocol JLTTabSegueViewControllerChooser <NSObject>

- (NSUInteger)indexOfDestinationViewControllerForTabSegueIdentifier:(NSString *)identifier;

@end

@interface JLTTabSegue : UIStoryboardSegue <JLTTabSegueViewControllerChooser>

+ (NSRegularExpression *)indexOfDestinationViewControllerRegularExpression;

@end
