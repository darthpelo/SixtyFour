# SixtyFour

## Build and Run

### Xcode and iOS

Due the project uses Apple **CryptoKit** the minimum iOS version is 13.0.
The minimum Xcode version is 11.5.

### Swift Pagakage Dependencies

Before build and run the project, update Swift Packages to the latest version.

### Properties file

The project has a reference to a plist file that is not tracked, for security reason. You must add it localy before build and run the project.
The file name is *Preferences.plist* and it's located inside the *Resources* folder.
This file must have this struct:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>token</key>
<string>your-token</string>
</dict>
</plist>

```

## Project

### External Dependencies

The only external library used is [Moya](https://github.com/Moya/Moya) for the network layer, imported using Swift Pagakage Dependencies.
The implementation is tested in `MarloveServiceTests.swift`. 

#### SSL Pinning

In the same test class there is the SSL pinning test:

```swift
func testSSLPinning() {
    let provider = MoyaProvider<MarloveService>(session: MarloveService.getSession())

    let expectation = self.expectation(description: #function)

    provider.request(.items(sinceId: nil, maxId: nil)) { result in
        switch result {
        case let .success(moyaResponse):
            XCTAssertEqual(moyaResponse.statusCode, 200)
        case let .failure(moyaError):
            XCTAssert(false, moyaError.errorDescription ?? "Simple items request failed")
        }

        expectation.fulfill()
    }

    waitForExpectations(timeout: 2.0, handler: nil)
}
```

### Architecture

The architecture used is MVP + Coordinator.

### Dependency Container

The interval services are injected in any present thutough the Dependency Container, defined in `DependencyContainer.swift`.

### Local Storage Security

I used **CryptoKit** to encript the local storage, used in this project as basic local cache.

### Code Coverage

82.3%

### Fastlane

The peoject as a basic faslane setup, most as example/reference.
The lane **buildPullRequest** is the base for all the different pipelines your project has (DEV, UAT, SIT, PRODUCTION).
The variable for every envrioments/targets are passed using the default Fastlane files *.env.envName*. In this specific case:

```bash
SCHEME = ""
BUNDLE_IDENTIFIER = ""
PROVISION_NAME_DEV = ""
PROVISION_NAME_INHOUSE = ""
APP_NAME = ""
APP_IPA = ""
APP_DSYM = ""
APPCENTER_TOKEN = ""
```
