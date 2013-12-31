#JLTSegue

Custom segues are fun and useful.

##JLTReplaceSegue

The current view controller is replaced in the navigation controller by a new
view controller after a push animation.

###Simple Usage

Create a custom segue from source view controller to the destination view
controller. Set the segue class to `JLTReplaceSegue`. Set the segue identifier
to be the number of navigation view controllers you wish to pop.

For example, to replace the top 2 view controllers, set the segue identifier to
`"Replaces2"`. You can also use `"replaces 2"`, `"REPLACES-2"`, or
`"rEpLaCeS_2"`. The word replaces is case insensitive and the number can be
separated by a space, a hyphen or an underscore. In fact, any segue identifier
which matches the regular expression:

    /(?:^|[- _])[Rr][Ee][Pp][Ll][Aa][Cc][Ee][Ss][- _]*([0-9]+)(?:[- _]|$)/

This means you can set set the segue identifier to `"Show Profile: Replaces 2
View Controllers"`. `Replaces 2` will get picked out of the segue identifier.

If you wish to replace only the top view controller, then you don't need a
special segue identifier. For example, the segue identifier `"Show Profile"`
replaces the top view controller with the destination view controller.

###Advanced Usage

In the destination view controller, implement
`-numberOfViewControllersPoppedByReplaceSegue:`. The replace segue is passed.
Return the number of view controllers to pop. Create a custom segue from the
source view controller to the destination view controller. Set the segue class
to `JLTReplaceSegue`. You can use any segue identifier you choose.

    - (NSUInteger)numberOfViewControllersPoppedByReplaceSegue:(JLTReplaceSegue *)replaceSegue
    {
        if ([replaceSegue.identifier isEqualToString:@"MySegue1"]) {
            return 2; // Replace top 2 view controllers
        } else if ([replaceSegue.identifier isEqualToString:@"MySegue2"]) {
            return 1; // Replace the top view controller
        } else {
            return 0; // Replace no view controllers, just a normal push
        }
    }

##JLTTabSegue

Instead of segueing to a new view controller, segue to a different tab in the
tab bar controller.

###Simple Usage

Create a custom segue from source view controller to the destination view
controller. Set the segue class to `JLTTabSegue`. Set the segue identifier to
be the tab index you wish to switch to.

For example, to switch to tab 1, set the segue identifier to `"Tab1"`. You can
also use `"TAB 1"`, `"tab-1"`, or `"tAb_1"`. The word tab is case insensitive
and the number can be separated by a space, a hyphen or an underscore. In fact,
any segue identifier which matches the regular expression:

    /(?:^|[- _])[Tt][Aa][Bb][- _]*([0-9]+)(?:[- _]|$)/

This means you can set set the segue identifier to `"Show Tab 1 From Profile"`.
`Tab 1` will get picked out of the segue identifier.

Please remember that tab index begin with 0, so tab 1 is the second tab.

###Advanced Usage

In the source view controller, implement
`-indexOfDestinationViewControllerForTabSegueIdentifier:`. The segue identifier
is passed. Return the tab index to switch to. Create a custom segue from the
source view controller to the destination view controller. Set the segue class
to `JLTTabSegue`. You can use any segue identifier you choose.

    - (NSUInteger)indexOfDestinationViewControllerForTabSegueIdentifier:(NSString *)identifier
    {
        if ([identifier isEqualToString:@"MySegue1"]) {
            return 0; // Tab Index 0
        } else if ([identifier isEqualToString:@"MySegue2"]) {
            return 1; // Tab Index 1
        } else {
            return 2; // Tab Index 2
        }
    }
