#import "JLTReplaceSegue.h"
#import <objc/runtime.h>

@interface UIViewController (JLTReplaceSegue_Private)
@property (strong, nonatomic) NSNumber *JLT_stackSizeOfReplacementSegue;
@end

@implementation JLTReplaceSegue

- (void)perform
{
    UIViewController *source = self.sourceViewController;
    UIViewController *destination = self.destinationViewController;

    NSAssert(source.identifierOfFinalReplacementSegue, @"ReplaceSegue must have final identifier");

    if ([self.identifier isEqualToString:source.identifierOfFinalReplacementSegue]) {
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
        self.JLT_stackSizeOfReplacementSegue = @(self.navigationController.viewControllers.count);
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
