#import "JLTReplaceSegue.h"
#import <objc/runtime.h>

static NSException *JLT_ViewControllerNotInNavigationController(UIViewController *viewController)
{
    NSString *reasonFormat = @"The view controller %@ is not in a navigation controller";
    return [NSException exceptionWithName:@"ViewControllerNotInNavigationController"
                                   reason:[NSString stringWithFormat:reasonFormat, viewController]
                                 userInfo:nil];
}

@interface UIViewController (JLTReplaceSegue_Private)

@property (strong, nonatomic) NSNumber *JLT_stackSizeOfReplacementSegue;

@end

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
    UIViewController *source = self.sourceViewController;
    UIViewController *destination = self.destinationViewController;

    if (!source.identifierOfFinalReplacementSegue)
        source.identifierOfFinalReplacementSegue = self.identifier;

    if ([self JLT_isFinalIdentifier:source.identifierOfFinalReplacementSegue]) {
        [source.navigationController setViewControllers:[self JLT_stackAfterPush] animated:YES];
    } else {
        destination.JLT_stackSizeOfReplacementSegue = source.JLT_stackSizeOfReplacementSegue;
        destination.identifierOfFinalReplacementSegue = source.identifierOfFinalReplacementSegue;
        [source.navigationController pushViewController:destination animated:YES];
    }
}

#pragma mark Private

- (NSArray *)JLT_stackAfterPush
{
    NSUInteger size = [[self.sourceViewController JLT_stackSizeOfReplacementSegue] unsignedIntegerValue];
    NSArray *stack = [[self.sourceViewController navigationController] viewControllers];
    id final = self.destinationViewController;

    return [[stack subarrayWithRange:NSMakeRange(0, size)] arrayByAddingObject:final];
}

- (BOOL)JLT_isFinalIdentifier:(NSString *)finalIdentifier
{
    if (!finalIdentifier)
        return YES;

    return [self.identifier isEqualToString:finalIdentifier];
}

@end

@implementation UIViewController (JLTReplaceSegue)

static char JLT_identifierKey;

- (NSString *)identifierOfFinalReplacementSegue
{
    return objc_getAssociatedObject(self, &JLT_identifierKey);
}

- (void)setIdentifierOfFinalReplacementSegue:(NSString *)identifier
{
    objc_setAssociatedObject(self, &JLT_identifierKey, identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if (!self.JLT_stackSizeOfReplacementSegue)
        self.JLT_stackSizeOfReplacementSegue = @(self.navigationController.viewControllers.count - 1);
}

@end

@implementation UIViewController (JLTReplaceSegue_Private)

static char JLT_stackSizeKey;

- (NSNumber *)JLT_stackSizeOfReplacementSegue
{
    return objc_getAssociatedObject(self, &JLT_stackSizeKey);
}

- (void)setJLT_stackSizeOfReplacementSegue:(NSNumber *)stackSize
{
    objc_setAssociatedObject(self, &JLT_stackSizeKey, stackSize, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
