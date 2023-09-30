//
//  String+ANSII+Styles.swift
//
//
//  Created by Tornike on 30/09/2023.
//

import Foundation

public extension String {

  /// Applies an ANSI style to the string based on the given ANSI attribute.
  /// - Parameter aStyle: The ANSI attribute to set as the text style.
  /// - Returns: A new string with the applied ANSI style.
  /// - Note: If the style is `normal`, it resets any other active styles.
  ///         The style will persist if `isOpenedStyle` is `true`.
  private func style(_ aStyle: ANSIAttr) -> String {
    guard !self.isEmpty else { return self }

    if aStyle == .normal {
      return CSI+"\(aStyle.rawValue)m" + self
    } else {
      if isOpenedStyle {
        return CSI+"\(aStyle.rawValue)m" + self
      } else {
        return CSI+"\(aStyle.rawValue)m" + self + CSI+"\(ANSIAttr.normal.rawValue)m"
      }
    }
  }

  /// Returns the string with the ANSI 'normal' style applied.
  var normal: String {
    return style(.normal)
  }

  /// Returns the string with the ANSI 'bold' style applied.
  var bold: String {
    return style(.bold)
  }

  /// Returns the string with the ANSI 'dim' style applied.
  var dim: String {
    return style(.dim)
  }

  /// Returns the string with the ANSI 'italic' style applied.
  var italic: String {
    return style(.italic)
  }

  /// Returns the string with the ANSI 'underline' style applied.
  var underline: String {
    return style(.underline)
  }

  /// Returns the string with the ANSI 'blink' style applied.
  var blink: String {
    return style(.blink)
  }

  /// Returns the string with the ANSI 'overline' style applied.
  var overline: String {
    return style(.overline)
  }

  /// Returns the string with the ANSI 'inverse' style applied.
  var inverse: String {
    return style(.inverse)
  }

  /// Returns the string with the ANSI 'hidden' style applied.
  var hidden: String {
    return style(.hidden)
  }

  /// Returns the string with the ANSI 'strike' style applied.
  var strike: String {
    return style(.strike)
  }
}
