//
//  JLTReplaceSegue.h
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

#import <UIKit/UIKit.h>
@class JLTReplaceSegue;

#define JLTReplaceSeguePass NSNotFound

@protocol JLTReplaceSegueNavigationStackManipulator <NSObject>

- (NSUInteger)numberOfViewControllersPoppedByReplaceSegue:(JLTReplaceSegue *)replaceSegue;

@end

@interface JLTReplaceSegue : UIStoryboardSegue <JLTReplaceSegueNavigationStackManipulator>

+ (NSRegularExpression *)numberOfViewControllersToPopRegularExpression;

@end
