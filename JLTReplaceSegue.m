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
#import <objc/runtime.h>

static NSException *JLT_ViewControllerNotInNavigationController(UIViewController *viewController)
{
    NSString *reasonFormat = @"The view controller %@ is not in a navigation controller";
    return [NSException exceptionWithName:@"ViewControllerNotInNavigationController"
                                   reason:[NSString stringWithFormat:reasonFormat, viewController]
                                 userInfo:nil];
}

const NSUInteger JLTReplaceSeguePass = NSNotFound;

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

    NSUInteger numberReplaced = [self JLT_determineNumberReplacedWithSource:source andDestination:destination];

    if (numberReplaced == 0)
        [navController pushViewController:destination animated:YES];
    else
        [navController setViewControllers:[self JLT_stackAfterNumberReplaced:numberReplaced] animated:YES];
}

#pragma mark JLTReplaceSegueNavigationStackManipulator

- (NSUInteger)numberOfViewControllersReplacedBySegue:(UIStoryboardSegue *)segue
{
    return 1;
}

#pragma mark Private

- (NSUInteger)JLT_determineNumberReplacedWithSource:(id)source andDestination:(id)destination
{
    NSUInteger numberReplaced = JLTReplaceSeguePass;

    if ([destination respondsToSelector:@selector(numberOfViewControllersReplacedBySegue:)])
        numberReplaced = [destination numberOfViewControllersReplacedBySegue:self];

    if (numberReplaced == JLTReplaceSeguePass)
        if ([source respondsToSelector:@selector(numberOfViewControllersReplacedBySegue:)])
            numberReplaced = [source numberOfViewControllersReplacedBySegue:self];

    if (numberReplaced == JLTReplaceSeguePass)
        numberReplaced = [self numberOfViewControllersReplacedBySegue:self];

    if (numberReplaced == JLTReplaceSeguePass)
        return 0;

    return numberReplaced;
}

- (NSArray *)JLT_stackAfterNumberReplaced:(NSUInteger)numberReplaced
{
    NSArray *stack = [[self.sourceViewController navigationController] viewControllers];
    NSUInteger size = numberReplaced > [stack count] ? 0 : [stack count] - numberReplaced;
    id final = self.destinationViewController;

    return [[stack subarrayWithRange:NSMakeRange(0, size)] arrayByAddingObject:final];
}

@end
