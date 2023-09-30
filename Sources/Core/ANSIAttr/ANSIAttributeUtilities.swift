//  ANSIAttributeUtilities.swift
//
//  Created by Tornike on 30/09/2023.
//

import Foundation

/// Sets the text style based on the given ANSI attribute.
/// - Parameter style: The ANSI attribute to set as the text style.
/// - Note: This function will set `isOpenedStyle` to `true`.
public func setStyle(_ style: ANSIAttr = .normal) {
  guard 1...9 ~= style.rawValue || 21...29 ~= style.rawValue else {
    return
  }

  write(CSI+"\(style.rawValue)m")
  isOpenedStyle = true
}

/// Checks if a given UInt8 value is a valid ANSI text style.
/// - Parameter style: The value to check.
/// - Returns: `true` if the value is a valid ANSI text style, `false` otherwise.
public func isStyle(_ style: UInt8) -> Bool {
  return (style > 0 && style < 10) ||
  (style > 20 && style < 30)
}

/// Sets the foreground and background color based on the given ANSI attributes.
/// - Parameters:
///   - fore: The ANSI attribute for the foreground color.
///   - back: The ANSI attribute for the background color.
/// - Note: This function will set `isOpenedColor` to `true`.
public func setColor(fore: ANSIAttr = .`default`, back: ANSIAttr = .onDefault) {
  // Check for foreground color value
  if fore.rawValue >= 30 && fore.rawValue <= 37 ||
     fore.rawValue >= 90 && fore.rawValue <= 97 ||
     fore.rawValue == ANSIAttr.`default`.rawValue {
    write(CSI+"\(fore.rawValue)m")
  }
  // Check for background color value
  if back.rawValue >=  40 && back.rawValue <=  47 ||
     back.rawValue >= 100 && back.rawValue <= 107 ||
     back.rawValue == ANSIAttr.onDefault.rawValue {
    write(CSI+"\(back.rawValue)m")
  }
  isOpenedColor = true
}

/// Sets both the foreground and background color based on given UInt8 values.
/// - Parameters:
///   - fore: The UInt8 value for the foreground color.
///   - back: The UInt8 value for the background color.
/// - Note: This function will set `isOpenedColor` to `true`.
public func setColors(_ fore: UInt8, on back: UInt8) {
  guard 1...255 ~= fore && 1...255 ~= back else {
    return
  }

  write(CSI+"\(ANSIAttr.fore256Color.rawValue);5;\(fore)m" +
        CSI+"\(ANSIAttr.back256Color.rawValue);5;\(back)m")
  isOpenedColor = true
}

/// Resets the text color and/or style to default.
/// - Parameters:
///   - color: A boolean indicating whether to reset the color.
///   - style: A boolean indicating whether to reset the style.
public func setDefault(color: Bool = true, style: Bool = false) {
  if color {
    write(CSI+"\(ANSIAttr.`default`.rawValue);\(ANSIAttr.onDefault.rawValue)m")
    isOpenedColor = false
  }

  if style {
    write(CSI+"\(ANSIAttr.normal.rawValue)m")
    isOpenedStyle = false
  }
}

/// Checks if a given UInt8 value is a valid ANSI foreground color.
/// - Parameter color: The value to check.
/// - Returns: `true` if the value is a valid ANSI foreground color, `false` otherwise.
public func isForeColor(_ color: UInt8) -> Bool {
  return (color >= 30 && color <= 37) ||
  (color >= 90 && color <= 97)
}

/// Checks if a given UInt8 value is a valid ANSI background color.
/// - Parameter color: The value to check.
/// - Returns: `true` if the value is a valid ANSI background color, `false` otherwise.
public func isBackColor(_ color: UInt8) -> Bool {
  return (color >= 40 && color <= 47) ||
  (color >= 100 && color <= 107)
}

/// Checks if a given UInt8 value is a valid ANSI color.
/// - Parameter color: The value to check.
/// - Returns: `true` if the value is a valid ANSI color, `false` otherwise.
public func isColor(_ color: UInt8) -> Bool {
  return isForeColor(color) || isBackColor(color)
}

/// Converts a given ANSI foreground color to its corresponding background color.
/// - Parameter color: The ANSI foreground color to convert.
/// - Returns: The corresponding ANSI background color.
public func foreToBack(_ color: ANSIAttr) -> ANSIAttr {
  if color.rawValue >= 30 && color.rawValue <= 37 ||
     color.rawValue >= 90 && color.rawValue <= 97 ||
     color.rawValue == ANSIAttr.onDefault.rawValue {
    return ANSIAttr(rawValue: color.rawValue+10)!
  } else {
    return color
  }
}

/// Converts a given ANSI background color to its corresponding foreground color.
/// - Parameter color: The ANSI background color to convert.
/// - Returns: The corresponding ANSI foreground color.
public func backToFore(_ color: ANSIAttr) -> ANSIAttr {
  if color.rawValue >=  40 && color.rawValue <=  47 ||
     color.rawValue >= 100 && color.rawValue <= 107 ||
     color.rawValue == ANSIAttr.onDefault.rawValue {
    return ANSIAttr(rawValue: color.rawValue-10)!
  } else {
    return color
  }
}

/// Removes all ANSI attributes from a given text string.
/// - Parameter text: The text string to strip of ANSI attributes.
/// - Returns: The text string without ANSI attributes.
public func stripAttributes(from text: String) -> String {
  guard !text.isEmpty else { return text }

  // ANSI attribute is always started with ESC and ended by `m`
  var txt = text.split(separator: NonPrintableChar.escape.char())
  for (i, sub) in txt.enumerated() {
    if let end = sub.firstIndex(of: "m") {
      txt[i] = sub[sub.index(after: end)...]
    }
  }
  return txt.joined()
}
