//
//  String+ANSII+Styles.swift
//  
//
//  Created by Tornike on 30/09/2023.
//

import Foundation

public extension String {
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
  
  var normal: String {
    return style(.normal)
  }
  
  var bold: String {
    return style(.bold)
  }
  
  var dim: String {
    return style(.dim)
  }
  
  var italic: String {
    return style(.italic)
  }
  
  var underline: String {
    return style(.underline)
  }
  
  var blink: String {
    return style(
      .blink
    )
  }
  
  var overline: String {
    return style(
      .overline
    )
  }
  
  var inverse: String {
    return style(
      .inverse
    )
  }
  
  var hidden: String {
    return style(
      .hidden
    )
  }
  
  var strike: String {
    return style(
      .strike
    )
  }
}
