#import "JLTTabSegue.h"

@implementation JLTTabSegue

- (id)initWithIdentifier:(NSString *)identifier
                  source:(UIViewController *)source
             destination:(UIViewController *)destination
{
    NSUInteger tabIndex = [self JLT_tabIndexForIdentifier:identifier];
    UIViewController *mydest = source.tabBarController.viewControllers[tabIndex];

    return [super initWithIdentifier:identifier source:source destination:mydest];
}

- (void)perform
{
    UIViewController *source = self.sourceViewController;
    source.tabBarController.selectedViewController = self.destinationViewController;
}

#pragma mark Private

static NSException *JLT_MalformedIdentifier(NSString *identifier)
{
    NSString *reasonFormat = @"The segue identifier \"%@\" does not contain a tab";
    return [NSException exceptionWithName:@"MalformedTabSegueIdentifier"
                                   reason:[NSString stringWithFormat:reasonFormat, identifier]
                                 userInfo:nil];
}

- (NSUInteger)JLT_tabIndexForIdentifier:(NSString *)identifier
{
    NSRange range = [identifier rangeOfString:@"Tab " options:NSCaseInsensitiveSearch];

    if (range.location == NSNotFound)
        @throw JLT_MalformedIdentifier(identifier);

    if (range.location > 0 && isalnum([identifier characterAtIndex:range.location - 1]))
        @throw JLT_MalformedIdentifier(identifier);

    NSUInteger location = range.location + range.length;
    NSUInteger restOfIdentifier = identifier.length - location;

    range = [identifier rangeOfString:@" " options:0 range:NSMakeRange(location, restOfIdentifier)];

    if (range.location == NSNotFound)
        range = NSMakeRange(identifier.length, 0);

    NSUInteger length = range.location - location;

    NSString *tabIndexString = [identifier substringWithRange:NSMakeRange(location, length)];
    return tabIndexString.integerValue;
}

@end
