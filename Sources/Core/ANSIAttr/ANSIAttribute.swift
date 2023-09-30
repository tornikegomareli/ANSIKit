//  ANSIAttribute.swift
//
//  Created by Tornike on 30/09/2023.
//

import Foundation

/// Represents ANSI attributes for text styling and coloring.
/// These attributes can be applied to strings for console output.
public enum ANSIAttr: UInt8 {

    // MARK: - Text Styling

    /// Normal text, without any styling.
    case normal         = 0
    /// Bold text.
    case bold           = 1
    /// Dimmed text.
    case dim            = 2
    /// Italic text.
    case italic         = 3
    /// Underlined text.
    case underline      = 4
    /// Blinking text.
    case blink          = 5
    /// Overlined text.
    case overline       = 6
    /// Inverted text.
    case inverse        = 7
    /// Hidden text.
    case hidden         = 8
    /// Strike-through text.
    case strike         = 9
    /// Disable bold.
    case noBold         = 21
    /// Disable dim.
    case noDim          = 22
    /// Disable italic.
    case noItalic       = 23
    /// Disable underline.
    case noUnderline    = 24
    /// Disable blink.
    case noBlink        = 25
    /// Disable overline.
    case noOverline     = 26
    /// Disable inverse.
    case noInverse      = 27
    /// Disable hidden.
    case noHidden       = 28
    /// Disable strike-through.
    case noStrike       = 29

    // MARK: - Foreground Text Coloring

    /// Black text color.
    case black          = 30
    /// Red text color.
    case red            = 31
    /// Green text color.
    case green          = 32
    /// Brown text color.
    case brown          = 33
    /// Blue text color.
    case blue           = 34
    /// Magenta text color.
    case magenta        = 35
    /// Cyan text color.
    case cyan           = 36
    /// Gray text color.
    case gray           = 37
    /// Foreground 256-color.
    case fore256Color   = 38
    /// Default text color.
    case `default`      = 39
    /// Dark gray text color.
    case darkGray       = 90
    /// Light red text color.
    case lightRed       = 91
    /// Light green text color.
    case lightGreen     = 92
    /// Yellow text color.
    case yellow         = 93
    /// Light blue text color.
    case lightBlue      = 94
    /// Light magenta text color.
    case lightMagenta   = 95
    /// Light cyan text color.
    case lightCyan      = 96
    /// White text color.
    case white          = 97

    // MARK: - Background Text Coloring

    /// Black background color.
    case onBlack        = 40
    /// Red background color.
    case onRed          = 41
    /// Green background color.
    case onGreen        = 42
    /// Brown background color.
    case onBrown        = 43
    /// Blue background color.
    case onBlue         = 44
    /// Magenta background color.
    case onMagenta      = 45
    /// Cyan background color.
    case onCyan         = 46
    /// Gray background color.
    case onGray         = 47
    /// Background 256-color.
    case back256Color   = 48
    /// Default background color.
    case onDefault      = 49
    /// Dark gray background color.
    case onDarkGray     = 100
    /// Light red background color.
    case onLightRed     = 101
    /// Light green background color.
    case onLightGreen   = 102
    /// Yellow background color.
    case onYellow       = 103
    /// Light blue background color.
    case onLightBlue    = 104
    /// Light magenta background color.
    case onLightMagenta = 105
    /// Light cyan background color.
    case onLightCyan    = 106
    /// White background color.
    case onWhite        = 107
}
