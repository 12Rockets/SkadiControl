#SkadiControl by 12Rockets
`SkadiControl` is a `UIView`-based component designed to support user interactions with a given `UIView` though rotating, scaling and moving. Given `UIView` can be an `UIImage` or some other subclassed `UIView`. This library is designed to be light-weight and addable to any view.

Changes by user interaction are communicated through delegate pattern while changing the `SkadiControl` is done by simply setting it's properties.

## Preview
<p align="center" >
<img src="https://github.com/12Rockets/SkadiControl/blob/master/screenshot.jpg" width="250">
<img src="https://github.com/12Rockets/SkadiControl/blob/master/skadiPreview.jpg" width="250">
</p>

---
##Installing SkadiControl
You can install `SkadiControl` in your project by simply copying source files from SkadiControl directory. Simply import `SkadiControl` in classes you wish to use it:

```Objective-C
#import "SkadiControl.h"
```

---
##Creating a SkadiControl
Creating a `SkadiControl` is as easy as creating a `UIView`.

In desired `UIViewController`:
```Objective-C
[[SkadiControl alloc] initWithsuperview:self.skadiView controlsDelegate:self imageNamed:@"12rockets"]]
```

There are several constructors available, check the `SkadiControl` header file.

Note: There are two read-only variables in `SkadiControl`: `minScale` and `maxScale` which tells user what is the minimum and the maximum scale of the control. These variables are different for the different views which the control is holding.

---
##Features

###Setting Selection
`SkadiControl` can be selected or deselected by setting the `selected` property.

<p align="center" >
<img src="https://github.com/12Rockets/SkadiControl/blob/master/skadiSelect.gif" width="250">
</p>

```Objective-C
[skadiControl isComponentSelected];
[skadiControl setSelected:YES];
```

###Setting Rotation Angle
`SkadiControl`'s rotation angle can be set by changing `rotationAngle` property.

<p align="center" >
<img src="https://github.com/12Rockets/SkadiControl/blob/master/skadiRotate.gif" width="250">
</p>

```Objective-C
[skadiControl setRotationAngle:value];
```

###Setting Scale Factor
`SkadiControl`'s scale can be set by changing `scale` property.

<p align="center" >
<img src="https://github.com/12Rockets/SkadiControl/blob/master/skadiScale.gif" width="250">
</p>

```Objective-C
[skadiControl setScale:value];
```

###Setting Center
`SkadiControl`'s center can be set by changing `controlCenter` property.

<p align="center" >
<img src="https://github.com/12Rockets/SkadiControl/blob/master/skadiMove.gif" width="250">
</p>

```Objective-C
[skadiControl setControlCenter:newCenter];
```
###Setting Custom Control Buttons
`SkadiControl`'s control buttons can be set by calling `setAssetsWithNameForConfirm: forRotation: forScaling: andForDeletion:`.

<p align="center" >
<img src="https://github.com/12Rockets/SkadiControl/blob/master/skadiControls.gif" width="250">
</p>

```Objective-C
[skadiControl  setAssetsWithNameForConfirm:@"skadi-confirm-green"
                               forRotation:@"skadi-rotate-green"
                                forScaling:@"skadi-scale-green"
                            andForDeletion:@"skadi-delete-green"];
```

####SkadiControl Protocol
`SkadiControl` should have delegate which will be notified when user interacts with the control.

```Objective-C
@protocol SkadiControlDelegate

- (void)skadiControlDidSelect:(id)sender;
- (void)skadiControlWillRemove:(id)sender;
- (void)skadiControlDidConfirm:(id)sender;
- (void)skadiControlDidScale:(id)sender;
- (void)skadiControlDidRotate:(id)sender;
- (void)skadiControlDidTranslate:(id)sender;

@end
```
---
##Credit
Designed and Developed by [12Rockets](http://12rockets.com):

###Development

* [Aleksandra Stevović](https://github.com/orgs/12Rockets/people/aleksandra12)
* [Marko Čančar](https://rs.linkedin.com/in/markocancar)

---
##Feedback
Send us your feedback at hello@12rockets.com or hit us up on [Twitter](https://twitter.com/TwelveRockets).

---
##License
`SkadiControl` is available under the MIT license. See the LICENSE file for more info.
