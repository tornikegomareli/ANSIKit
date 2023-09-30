//  String+ANSII-Coloring-Extensions.swift
//
//  Created by Tornike on 30/09/2023.
//

import Foundation

public extension String {

  /// Applies an ANSI color to the string based on the given ANSI attribute.
  /// - Parameter aColor: The ANSI attribute to set as the text color.
  /// - Returns: A new string with the applied ANSI color.
  /// - Note: The color will persist if `isOpenedColor` is `true`.
  internal func color(_ aColor: ANSIAttr) -> String {
    guard !self.isEmpty else { return self }

    if isOpenedColor {
      return CSI+"\(aColor.rawValue)m" + self
    } else {
      return CSI+"\(aColor.rawValue)m" + self +
      CSI+"\(ANSIAttr.`default`.rawValue);\(ANSIAttr.onDefault.rawValue)m"
    }
  }

  /// Applies a foreground color to the string from the 256 xterm colors list.
  /// - Parameter aColor: The UInt8 value of the xterm color to set as the text color.
  /// - Returns: A new string with the applied xterm foreground color.
  /// - Note: The color will persist if `isOpenedColor` is `true`.
  func foreColor(_ aColor: UInt8) -> String {
    guard !self.isEmpty && (1...255 ~= aColor) else {
      return self
    }

    if isOpenedColor {
      return CSI+"\(ANSIAttr.fore256Color.rawValue);5;\(aColor)m" + self
    } else {
      return CSI+"\(ANSIAttr.fore256Color.rawValue);5;\(aColor)m" + self +
      CSI+"\(ANSIAttr.`default`.rawValue)m"
    }
  }

  /// Alias for `foreColor(_:)`.
  func withForeColor(_ aColor: UInt8) -> String {
    return foreColor(aColor)
  }

  /// Applies a background color to the string from the 256 xterm colors list.
  /// - Parameter aColor: The UInt8 value of the xterm color to set as the background color.
  /// - Returns: A new string with the applied xterm background color.
  /// - Note: The color will persist if `isOpenedColor` is `true`.
  func backColor(_ aColor: UInt8) -> String {
    guard !self.isEmpty && (1...255 ~= aColor) else {
      return self
    }

    if isOpenedColor {
      return CSI+"\(ANSIAttr.back256Color.rawValue);5;\(aColor)m" + self
    } else {
      return CSI+"\(ANSIAttr.back256Color.rawValue);5;\(aColor)m" + self +
      CSI+"\(ANSIAttr.onDefault.rawValue)m"
    }
  }

  /// Alias for `backColor(_:)`.
  func withBackColor(_ aColor: UInt8) -> String {
    return backColor(aColor)
  }

  /// Applies both foreground and background colors to the string from the 256 xterm colors list.
  /// - Parameters:
  ///   - fore: The UInt8 value of the xterm color to set as the foreground color.
  ///   - back: The UInt8 value of the xterm color to set as the background color.
  /// - Returns: A new string with the applied xterm foreground and background colors.
  /// - Note: The colors will persist if `isOpenedColor` is `true`.
  func colors(_ fore: UInt8, _ back: UInt8) -> String {
    guard !self.isEmpty && (1...255 ~= fore) && (1...255 ~= back) else {
      return self
    }

    if isOpenedColor {
      return CSI+"\(ANSIAttr.fore256Color.rawValue);5;\(fore)m" +
      CSI+"\(ANSIAttr.back256Color.rawValue);5;\(back)m" + self
    } else {
      return CSI+"\(ANSIAttr.fore256Color.rawValue);5;\(fore)m" +
      CSI+"\(ANSIAttr.back256Color.rawValue);5;\(back)m" + self +
      CSI+"\(ANSIAttr.`default`.rawValue);\(ANSIAttr.onDefault.rawValue)m"
    }
  }

  /// Alias for `colors(_:,_:)`.
  func withColors(_ fore: UInt8, _ back: UInt8) -> String {
    return colors(fore, back)
  }
}
