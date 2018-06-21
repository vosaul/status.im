---
id: version-0.0.1-build_status_osx
title: Building Status on OSX
original_id: build_status_osx
---

### 1.1 Install the dependencies - Node.js and npm 

There are several ways of installing Node.js on your machine. 
One of the most convenient and easy is by using [Node Version Manager (nvm)](https://github.com/creationix/nvm).

Versions of both node and npm don't really matter, but there are known issues with some of them.
In this manual we're going to install **node v7.10.1** and **npm 5.5.1**, just because these versions are guaranteed to work.

Install nvm first (refer to [the official documentation](https://github.com/creationix/nvm/blob/master/README.md#install-script) to install the latest version):

```
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
```

Install the proper version of node and give it a nice name:

```
nvm install v7.10.1
nvm alias status-im v7.10.1
nvm use status-im
```

### 1.2. Automated script for everything else

To install everything else, just run the following command:

```
scripts/setup
```

### 1.3. Make sure you use the right version of Cocoapods

There is a chance that the latest version of Cocoapods was installed. 
It's a known issue. Just run the following commands to fix it:
```
sudo gem install cocoapods -v 1.3.1
cd ios && pod install && cd ..
```

### 1.4. Clojure command line tools

```
brew install clojure
```

## 2. Development

### 2.1. Build process

Just run the following in the first terminal window:

```
clj -R:repl build.clj figwheel --platform ios,android --ios-device simulator --android-device genymotion --nrepl-port 3456
```

This command starts the compilation of Clojure sources and runs re-frisk (a tool for debugging).

Please, check the documentation of [clj-rn](https://github.com/status-im/clj-rn) for more information.

### 2.2. React Native packager

Do the following in the second terminal window:

```
react-native start
```

### 2.3. Build and run the application itself!

#### 2.3.1. iOS

There are two ways of running Status on iOS:

1. From XCode. Just open `ios/StatusIm.xcworkspace` in XCode, select a device/simulator and click Run.
2. From console. `react-native run-ios` should work.

#### 2.3.2. Android

*WIP: Install SDK, `react-native run-android`, etc*
