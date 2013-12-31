//
//  JLTTabSegue.m
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

#import "JLTTabSegue.h"

@implementation JLTTabSegue

+ (NSRegularExpression *)indexOfDestinationViewControllerRegularExpression
{
    static NSRegularExpression *result = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        static NSString *pattern = @"(?:^|[- _])[Tt][Aa][Bb][- _]*([0-9]+)(?:[- _]|$)";
        result = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
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
    NSTextCheckingResult *match = [regex firstMatchInString:identifier options:0
                                                      range:NSMakeRange(0, [identifier length])];

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
