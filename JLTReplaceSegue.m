//
//  JLTReplaceSegue.m
//  JLTSegue
//
//  Created by Jeffery Thomas on 2/20/13.
//  Copyright (c) 2013 JLTSource. No rights reserved. Do with it what you will.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "JLTReplaceSegue.h"

@implementation JLTReplaceSegue

+ (NSRegularExpression *)numberOfViewControllersToPopRegularExpression
{
    static NSRegularExpression *result = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        static NSString *pattern = @"(?:^|[- _])[Rr][Ee][Pp][Ll][Aa][Cc][Ee][Ss][- _]*([0-9]+)(?:[- _]|$)";
        result = [NSRegularExpression regularExpressionWithPattern:pattern
                                                           options:NSRegularExpressionCaseInsensitive
                                                             error:nil];
    });

    return result;
}

- (id)initWithIdentifier:(NSString *)identifier
                  source:(UIViewController *)source
             destination:(UIViewController *)destination
{
    if (!source.navigationController)
        @throw [JLTReplaceSegue JLT_noNavigationControllerExceptionWithViewController:source];

    return [super initWithIdentifier:identifier source:source destination:destination];
}

- (void)perform
{
    id source = self.sourceViewController;
    id destination = self.destinationViewController;
    UINavigationController *navController = [source navigationController];

    NSUInteger replaceCount = [self JLT_determineReplaceCountWithSource:source andDestination:destination];

    if (replaceCount == 0)
        [navController pushViewController:destination animated:YES];
    else
        [navController setViewControllers:[self JLT_stackAfterNumberReplaced:replaceCount] animated:YES];
}

#pragma mark JLTReplaceSegueNavigationStackManipulator

- (NSUInteger)numberOfViewControllersPoppedByReplaceSegue:(JLTReplaceSegue *)replaceSegue;
{
    NSRange range = [self JLT_rangeOfNumberToReplaceInIdentifier:replaceSegue.identifier];

    if (range.location == NSNotFound)
        return JLTReplaceSeguePass;

    return [[replaceSegue.identifier substringWithRange:range] integerValue];
}

#pragma mark Private

- (NSUInteger)JLT_determineReplaceCountWithSource:(id)source andDestination:(id)destination
{
    NSUInteger replaceCount = JLTReplaceSeguePass;

    if ([destination respondsToSelector:@selector(numberOfViewControllersPoppedByReplaceSegue:)])
        replaceCount = [destination numberOfViewControllersPoppedByReplaceSegue:self];

    if (replaceCount == JLTReplaceSeguePass)
        if ([source respondsToSelector:@selector(numberOfViewControllersPoppedByReplaceSegue:)])
            replaceCount = [source numberOfViewControllersPoppedByReplaceSegue:self];

    if (replaceCount == JLTReplaceSeguePass)
        replaceCount = [self numberOfViewControllersPoppedByReplaceSegue:self];

    if (replaceCount == JLTReplaceSeguePass)
        replaceCount = 1;

    return replaceCount;
}

- (NSArray *)JLT_stackAfterNumberReplaced:(NSUInteger)numberReplaced
{
    NSArray *stack = [[self.sourceViewController navigationController] viewControllers];

    if ([stack count] <= numberReplaced)
        stack = @[]; // NOTE: Replace all the view controllers in the navigation controller.
    else
        stack = [stack subarrayWithRange:NSMakeRange(0, [stack count] - numberReplaced)];

    return [stack arrayByAddingObject:self.destinationViewController];
}

- (NSRange)JLT_rangeOfNumberToReplaceInIdentifier:(NSString *)identifier
{
    if ([identifier length] == 0)
        return NSMakeRange(NSNotFound, 0);

    NSRegularExpression *regex = [[self class] numberOfViewControllersToPopRegularExpression];
    NSTextCheckingResult *match = [regex firstMatchInString:identifier options:0 range:NSMakeRange(0, [identifier length])];

    if (!match)
        return NSMakeRange(NSNotFound, 0);

    return [match rangeAtIndex:1];
}

+ (NSException *)JLT_noNavigationControllerExceptionWithViewController:(UIViewController *)viewController
{
    NSString *reasonFormat = @"The view controller %@ is not in a navigation controller";
    return [NSException exceptionWithName:@"NoNavigationController"
                                   reason:[NSString stringWithFormat:reasonFormat, viewController]
                                 userInfo:nil];
}

@end
