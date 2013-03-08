#import "JLTTabSegue.h"

@implementation JLTTabSegue

+ (NSRegularExpression *)indexOfDestinationViewControllerRegularExpression
{
    static NSRegularExpression *result = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        result = [NSRegularExpression regularExpressionWithPattern:@"\\btab[ -_]*([0-9]+)\\b"
                                                           options:NSRegularExpressionCaseInsensitive
                                                             error:nil];
    });

    return result;
}

#pragma mark UIStoryboardSegue

- (id)initWithIdentifier:(NSString *)identifier
                  source:(UIViewController *)source
             destination:(UIViewController *)destination
{
    NSUInteger index = NSNotFound;

    if ([source respondsToSelector:@selector(indexOfDestinationViewControllerForTabSegueIdentifier:)])
        index = [(id)source indexOfDestinationViewControllerForTabSegueIdentifier:identifier];
    if (index == NSNotFound)
        index = [self indexOfDestinationViewControllerForTabSegueIdentifier:identifier];
    if (index == NSNotFound)
        @throw [[self class] JLT_malformedTabSegueIdentifierExceptionWithIdentifier:identifier];

    UIViewController *mydest = source.tabBarController.viewControllers[index];

    return [super initWithIdentifier:identifier source:source destination:mydest];
}

- (void)perform
{
    UIViewController *source = self.sourceViewController;
    source.tabBarController.selectedViewController = self.destinationViewController;
}

#pragma mark JLTTabSegueViewControllerChooser

- (NSUInteger)indexOfDestinationViewControllerForTabSegueIdentifier:(NSString *)identifier
{
    NSRegularExpression *regex = [[self class] indexOfDestinationViewControllerRegularExpression];
    NSTextCheckingResult *match = [regex firstMatchInString:identifier options:0 range:NSMakeRange(0, [identifier length])];

    if (!match)
        return NSNotFound;

    NSRange range = [match rangeAtIndex:1];

    if (range.location == NSNotFound)
        return NSNotFound;

    NSString *indexString = [identifier substringWithRange:range];
    return [indexString integerValue];
}

#pragma mark Private

+ (NSException *)JLT_malformedTabSegueIdentifierExceptionWithIdentifier:(NSString *)identifier
{
    NSString *reasonFormat = @"The segue identifier \"%@\" does not contain a tab";
    return [NSException exceptionWithName:@"MalformedTabSegueIdentifier"
                                   reason:[NSString stringWithFormat:reasonFormat, identifier]
                                 userInfo:nil];
}

@end
