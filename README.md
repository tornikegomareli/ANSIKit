# ANSIKit

ANSIKit is a Swift library designed to simplify working with ANSI escape codes. Whether you're building a CLI tool or enhancing terminal interactions, 
it provides a clean and functional API to communicate with your terminal.

# Motivation

Swift is often pigeonholed as a language solely for building UI applications on iOS, macOS, and other Apple platforms. 
However, this overlooks Swift's capabilities as a robust system-level programming language, well-suited for a variety of tasks beyond the UI layer. 
One such domain where Swift excels is in the creation of Command Line Interface (CLI) tools. 
Despite this, there's a noticeable gap in the ecosystem when it comes to libraries and tools designed to facilitate CLI development in Swift

# Solution

Many terminal libraries rely on [ncurses](https://www.gnu.org/software/ncurses/) for terminal control, which can be more than what's needed for text formatting, colorization tasks and cursor/keyboard handling. 
ANSIKit offers a different approach. It provides functionalities directly within your console with ANSI escape codes, without taking over the entire terminal interface. 
This allows you to integrate terminal features into your Swift CLI tools without the complexity that comes with using ncurses-based solutions

## Features

- ANSI Attributes: Easily manipulate text attributes like color, background, and styles.
- ANSI Keyboard: Handle keyboard events in a terminal environment.
- ANSI Screen: Control the terminal screen, including clearing and positioning cursor and control buffer.

## Installation

### Swift Package Manager

Add the following dependency to your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/tornikegomareli/ANSIKit.git", branch: "main")
]
```

Also add it as dependency in your executable target

```swift
targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "YourTarget",
            dependencies: [
                "ANSIKit"
            ]
        ),
    ]
```

