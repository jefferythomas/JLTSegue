#import "JLTReplaceSegue.h"
#import <objc/runtime.h>

static NSException *JLT_ViewControllerNotInNavigationController(UIViewController *viewController)
{
    NSString *reasonFormat = @"The view controller %@ is not in a navigation controller";
    return [NSException exceptionWithName:@"ViewControllerNotInNavigationController"
                                   reason:[NSString stringWithFormat:reasonFormat, viewController]
                                 userInfo:nil];
}

const NSUInteger JLTReplaceSegueNotReplaced = NSNotFound;

@implementation JLTReplaceSegue

- (id)initWithIdentifier:(NSString *)identifier
                  source:(UIViewController *)source
             destination:(UIViewController *)destination
{
    if (!source.navigationController)
        @throw JLT_ViewControllerNotInNavigationController(source);

    return [super initWithIdentifier:identifier source:source destination:destination];
}

- (void)perform
{
    id source = self.sourceViewController;
    id destination = self.destinationViewController;
    UINavigationController *navController = [source navigationController];

    NSUInteger numberReplaced = JLTReplaceSegueNotReplaced;

    if ([destination respondsToSelector:@selector(numberOfViewControllersReplacedByReplaceSegue:)])
        numberReplaced = [destination numberOfViewControllersReplacedByReplaceSegue:self];

    if (numberReplaced == JLTReplaceSegueNotReplaced)
        if ([source respondsToSelector:@selector(numberOfViewControllersReplacedByReplaceSegue:)])
            numberReplaced = [source numberOfViewControllersReplacedByReplaceSegue:self];

    if (numberReplaced == JLTReplaceSegueNotReplaced)
        numberReplaced = [self numberOfViewControllersReplacedByReplaceSegue:self];

    if (numberReplaced == JLTReplaceSegueNotReplaced || numberReplaced == 0)
        [navController pushViewController:destination animated:YES];
    else
        [navController setViewControllers:[self JLT_stackAfterNumberReplaced:numberReplaced] animated:YES];
}

#pragma mark JLTReplaceSegueNavigationStackManipulator

- (NSUInteger)numberOfViewControllersReplacedByReplaceSegue:(UIStoryboardSegue *)segue
{
    return 1;
}

#pragma mark Private

- (NSArray *)JLT_stackAfterNumberReplaced:(NSUInteger)numberReplaced
{
    NSArray *stack = [[self.sourceViewController navigationController] viewControllers];
    NSUInteger size = numberReplaced > [stack count] ? 0 : [stack count] - numberReplaced;
    id final = self.destinationViewController;

    return [[stack subarrayWithRange:NSMakeRange(0, size)] arrayByAddingObject:final];
}

@end
