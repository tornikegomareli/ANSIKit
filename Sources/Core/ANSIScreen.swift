//
//  ANSIScreen.swift
//
//
//  Created by Tornike on 05/10/2023.
//

import Foundation

/// Indicates whether the terminal is in replacing mode.
public private(set) var isReplacingMode = false

/// Indicates whether the cursor is visible.
public private(set) var isCursorVisible = true

// Reference: https://invisible-island.net/xterm/ctlseqs/ctlseqs.html

/// Defines various styles for the cursor.
public enum CursorStyle: UInt8 {
  case block = 1
  case line  = 3
  case bar   = 5
}

/// Changes the style of the terminal cursor.
///
/// - Parameters:
///   - style: The new cursor style.
///   - blinking: Whether the cursor should blink.
public func setCursorStyle(
    _ style: CursorStyle,
    blinking: Bool = true
) {
    if blinking {
        write(
            CSI+"\(style.rawValue) q"
        )
    } else {
        write(
            CSI+"\(style.rawValue + 1) q"
        )
  }
}

/// Stores the current position of the cursor.
///
/// - Parameter isANSI: Whether to use ANSI escape codes.
#if os(macOS)
public func storeCursorPosition(isANSI: Bool = false) {
  if isANSI {
      write(CSI, "s")
  } else {
      write(ESC, "7")
  }
}
#else
public func storeCursorPosition(isANSI: Bool = true) {
    if isANSI {
        write(CSI, "s")
    } else {
        write(ESC, "7")
    }
}
#endif

/// Restores the cursor to its previously stored position.
///
/// - Parameter isANSI: Whether to use ANSI escape codes.
#if os(macOS)
public func restoreCursorPosition(isANSI: Bool = false) {
    if isANSI {
        write(
            CSI,
            "u"
        )
    } else {
        write(
            ESC,
            "8"
        )
    }
}
#else
public func restoreCursorPosition(isANSI: Bool = true) {
    if isANSI {
        write(
            CSI,
            "u"
        )
    } else {
        write(
            ESC,
            "8"
        )
    }
}
#endif

/// Clears the terminal screen below the cursor.
public func clearBelow() {
  write(CSI, "0J")
}

/// Clears the terminal screen above the cursor.
public func clearAbove() {
  write(CSI, "1J")
}

/// Clears the entire terminal screen.
public func clearScreen() {
  write(CSI, "2J", CSI, "H")
}

/// Clears from the cursor to the end of the line.
public func clearToEndOfLine() {
  write(CSI, "0K")
}

/// Clears from the cursor to the start of the line.
public func clearToStartOfLine() {
  write(CSI, "1K")
}

/// Clears the entire line that the cursor is on.
public func clearLine() {
  write(CSI, "2K")
}

/// Moves the cursor up by a given number of rows.
///
/// - Parameter row: The number of rows to move the cursor up by.
public func moveUp(_ row: Int = 1) {
  write(CSI, "\(row)A")
}

/// Moves the cursor down by a given number of rows.
///
/// - Parameter row: The number of rows to move the cursor down by.
public func moveDown(_ row: Int = 1) {
    write(CSI + "\(row)B")
}

/// Moves the cursor right by a given number of columns.
///
/// - Parameter col: The number of columns to move the cursor right by.
public func moveRight(_ col: Int = 1) {
    write(CSI + "\(col)C")
}

/// Moves the cursor left by a given number of columns.
///
/// - Parameter col: The number of columns to move the cursor left by.
public func moveLeft(_ col: Int = 1) {
    write(CSI + "\(col)D")
}

/// Moves the cursor down to the start of a new line.
///
/// - Parameter row: The number of lines to move the cursor down by.
public func moveLineDown(_ row: Int = 1) {
    write(CSI + "\(row)E")
}

/// Moves the cursor up to the start of a new line.
///
/// - Parameter row: The number of lines to move the cursor up by.
public func moveLineUp(_ row: Int = 1) {
    write(CSI + "\(row)F")
}

/// Moves the cursor to a specified column.
///
/// - Parameter col: The column to move the cursor to.
public func moveToColumn(_ col: Int) {
    write(CSI + "\(col)G")
}

/// Moves the cursor to a specified row and column.
///
/// - Parameters:
///   - row: The row to move the cursor to.
///   - col: The column to move the cursor to.
public func moveTo(_ row: Int, _ col: Int) {
    write(CSI + "\(row);\(col)H")
}

/// Inserts a new line at the cursor position.
///
/// - Parameter row: The number of lines to insert.
public func insertLine(_ row: Int = 1) {
    write(CSI + "\(row)L")
}

/// Deletes a line at the cursor position.
///
/// - Parameter row: The number of lines to delete.
public func deleteLine(_ row: Int = 1) {
    write(CSI + "\(row)M")
}

/// Deletes characters starting from the cursor position.
///
/// - Parameter char: The number of characters to delete.
public func deleteChar(_ char: Int = 1) {
    write(CSI + "\(char)P")
}

/// Enables replace mode in the terminal.
public func enableReplaceMode() {
    write(CSI + "4l")
    isReplacingMode = true
}

/// Disables replace mode in the terminal.
public func disableReplaceMode() {
    write(CSI + "4h")
    isReplacingMode = false
}

/// Hides the cursor.
public func cursorOff() {
    write(CSI + "?25l")
    isCursorVisible = false
}

/// Shows the cursor.
public func cursorOn() {
    write(CSI + "?25h")
    isCursorVisible = true
}

/// Sets the scrolling region of the terminal.
///
/// - Parameters:
///   - top: The top row of the scrolling region.
///   - bottom: The bottom row of the scrolling region.
public func scrollRegion(top: Int, bottom: Int) {
    write(CSI + "\(top);\(bottom)r")
}

/// Reads the current position of the cursor.
///
/// - Returns: A tuple containing the row and column of the cursor.
public func readCursorPos() -> (row: Int, col: Int) {
  let str = ansiRequest(CSI+"6n", endChar: "R")  // returns ^[row;colR
  if str.isEmpty { return (-1, -1) }

  let esc = str.firstIndex(of: "[")!
  let del = str.firstIndex(of: ";")!
  let end = str.firstIndex(of: "R")!
  let row = String(str[str.index(after: esc)...str.index(before: del)])
  let col = String(str[str.index(after: del)...str.index(before: end)])
  return (Int(row)!, Int(col)!)
}

/// Reads the size of the terminal screen.
///
/// - Returns: A tuple containing the number of rows and columns.
public func readScreenSize() -> (row: Int, col: Int) {
  var str = ansiRequest(CSI+"18t", endChar: "t")  // returns ^[8;row;colt
  if str.isEmpty {
      return (-1, -1)
  }

  str = String(str.dropFirst(4))  // remove ^[8;
  let del = str.firstIndex(of: ";")!
  let end = str.firstIndex(of: "t")!
  let row = String(str[...str.index(before: del)])
  let col = String(str[str.index(after: del)...str.index(before: end)])
  return (Int(row)!, Int(col)!)
}
