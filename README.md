# itly-sdk-ios
Iteratively Analytics SDK for iOS — Swift &amp; Objective-C

All modules are located within one Xcode workspace: `ItlySDK.xcworkspace`.

## Tests
- Open the `ItlySDK.xcworkspace`
- Run a Test scheme to perform tests of a specific module

## Publishing
The common way for versioning is tagging. The CocoaPods provides more flixibility in tagging whereas the Carthage has some limits according to [Taging Convention](https://github.com/Carthage/Carthage#tag-stable-releases). Taking into account that all plugins are contained in the one repository, we have only one way of versioning for Carthage: a tag share the same version for all (means that version of all plugins will be bumped even if it's necessary to change only one plugin). As for the CocoaPods we can use a slightly different way of version tagging by using prefixes.
Summing up, it's possible to use the same shared version tagging for both Carthage and CocoaPods or keep Carthage versioning separately from Cocoapods versioning.

As for now let's use the shared version tagging to keep things simplier.

Tags should be of format "v1.0.0"

### Carthage publishing
Just tag the release commit, no more steps are required.

### Cocoapods publishing
- To publish specs it's necessary to [register an account](https://guides.cocoapods.org/making/getting-setup-with-trunk.html)
- Updating of the related .podspec should be performed at least to change the `spec.version`
- Tag the commit
- `pod trunk push [NAME.podspec]` will deploy the podspec

## Integrations
Examples of intergation can be found in the **SampleApp** directory 

### Carthage integration:
- Go to **SampleApp** directory
- Run `./carthage.sh update --platform iOS` and then `./carthage.sh build --platform iOS`
- Open the SampleApp_Carthage.xcodeproj
- Build and run

### CocoaPods integration:
If the podspecs aren't published yet it's possible to use [Private Spec Repo](https://guides.cocoapods.org/making/private-cocoapods.html) to test the integration. After creating the Private Spec Repo, uncomment the *source* lines of the *SampleApp/Podfile* file replacing the first with a path to the private spec repo.

- Go to **SampleApp** directory
- Run `pod install`
- Open the SampleApp_CocoaPods.xcworkspace
- Build and run

