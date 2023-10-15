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

# Features

## String Extensions for ANSI Coloring

The library extends Swift's `String` type to include ANSI color properties. To apply a color to text, simply append the color name to the string. For instance, using `'text'.blue` will display the text in blue. To set a background color, use the `on` prefix along with the color name, like `'text'.onCyan`, which will set a cyan background behind black text.

You can also combine both text and background colors. For example, `'text'.blue.onCyan` will display blue text on a cyan background. If you prefer more descriptive property names, you can use the `as` prefix, as in `'text'.asBlue`.

### 256-Color Support

For a broader range of color options, the library supports ANSI's 256-color palette through type extension methods. Use `foreColor(_:)` to set the text color and `backColor(_:)` for the background color. For example, `'text'.foreColor(196)` will display the text in red. Descriptive method names are also available, like `'text'.withForeColor(196)`.

### Color Persistence and Reset

By default, the color settings are applied only to the specific text and revert to the default settings afterward. If you need more control, you can use `setColor(fore: back:)` for the 16-color systems and `setColors(_: _)` for the 256-color systems. These methods won't reset the color, so remember to call `setDefault(color: style:)` to revert to the default settings.

### Default ANSI Color Palettes

The library is compatible with standard ANSI color palettes. If you're using the 256-color palette, you'll need to refer to the ANSI color chart to find the appropriate color index.

## Text Styling Through String Extensions

The library further extends Swift's `String` type to include properties for text styling. To add a style, simply append the style name to the string. For instance, `'text'.bold` will render the text in bold, while `'text'.italic` will display it in italics. Although ANSI terminals offer up to 10 different styles, not all are universally supported. The most commonly supported styles are normal, bold, italic, and inverse. If you intend to use less common styles, verify that your users' terminals support them.

### Combining Color and Style

Both color and style are ANSI attributes, allowing for their combination. For example, `'text'.blue.bold` will produce bold blue text. If you wish to set a style that persists, you can use the `setStyle(_:)` function. To revert any changes and return to the default settings, use the `setDefault(color: style:)` function.

## Managing Cursor and Screen

### Cursor Functions

- `storeCursorPosition()`: Saves the current cursor location.
- `restoreCursorPosition()`: Returns the cursor to its last saved location. Note that this may also revert color and style settings on some terminals.
- `cursorOn()`: Makes the cursor visible.
- `cursorOff()`: Hides the cursor.
- `moveTo(_: _:)`: Moves the cursor to a specified row and column.
- `readCursorPosition()`: Fetches the current cursor location as `(row: col:)`.

### Screen Functions

- `clearScreen()`: Wipes the screen clean and sets the cursor to the home position.
- `clearLine()`: Erases the line where the cursor currently resides.
- `clearToEndOfLine()`: Erases content from the current cursor position to the end of the line.
- `scrollRegion(top: bottom:)`: Sets the scrollable area of the screen.
- `readScreenSize()`: Retrieves the screen dimensions as `(row: col:)`. Not supported on some emulated terminals like VS Code's integrated terminal.

### Keyboard Input Functions

- `keyPressed()`: Checks if any keys have been pressed.
- `readCode()`: Reads individual keyboard inputs as ASCII codes.
- `readChar()`: Reads individual keyboard inputs as characters.
- `readKey()`: Reads advanced keyboard inputs, including meta keys like shift, control, and alt. Useful for handling complex key combinations.

### Additional Functions

- `delay(_:)`: Pauses the program for a given number of milliseconds.
- `clearBuffer(isOut: isIn:)`: Clears the standard input/output buffer.
- `write(_:... suspend:)`: Writes text directly to standard output, optionally with a delay. A variant `writeln(_:... suspend:)` adds a newline.
- `stripAttributes(from:)`: Removes all color and style attributes from a string, useful for determining the actual length of a styled text.
- `ask(_:)`: A quick way to prompt the user for input.

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

