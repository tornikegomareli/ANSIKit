//
//  ANSITerminal.swift
//
//
//  Created by Tornike on 30/09/2023.
//

import Foundation

#if os(Linux)
  import Glibc
#else
  import Darwin
#endif

// ANSI escape code constants
public let ESC = "\u{1B}"  // Escape character
public let SS2 = ESC+"N"   // Single Shift Select of G2 charset
public let SS3 = ESC+"O"   // Single Shift Select of G3 charset
public let DCS = ESC+"P"   // Device Control String
public let CSI = ESC+"["   // Control Sequence Introducer
public let OSC = ESC+"]"   // Operating System Command

// Special characters
public let RPT = "\u{e0b0}"  // right-pointing triangle
public let LPT = "\u{e0b2}"  // left-pointing triangle
public let RPA = "\u{e0b1}"  // right-pointing angle
public let LPA = "\u{e0b3}"  // left-pointing angle

// Terminal settings
internal private(set) var defaultTerminal = termios()
public   private(set) var isNonBlockingMode = false

/// Introduces a delay in the program execution.
/// - Parameter ms: Milliseconds to delay.
@inlinable public func delay(_ ms: Int) {
  usleep(UInt32(ms * 1000))
}

/// Converts an integer to a Unicode character.
/// - Parameter code: Integer representing the Unicode character.
/// - Returns: A Unicode character.
@inlinable public func unicode(_ code: Int) -> Unicode.Scalar {
  return Unicode.Scalar(code) ?? "\0"
}

/// Clears input/output buffers.
/// - Parameters:
///   - isOut: Whether to clear the output buffer.
///   - isIn: Whether to clear the input buffer.
@inlinable public func clearBuffer(isOut: Bool = true, isIn: Bool = true) {
  if isIn { fflush(stdin) }
  if isOut { fflush(stdout) }
}

/// Disables non-blocking terminal mode and restores default settings.
internal func disableNonBlockingTerminal() {
  tcsetattr(STDIN_FILENO, TCSANOW, &defaultTerminal)
  isNonBlockingMode = false
}

/// Enables non-blocking terminal mode.
/// - Parameter rawMode: Whether to use raw mode.
internal func enableNonBlockingTerminal(rawMode: Bool = false) {
  tcgetattr(STDIN_FILENO, &defaultTerminal)
  atexit(disableNonBlockingTerminal)
  isNonBlockingMode = true

  var nonBlockTerm = defaultTerminal
  if rawMode {
    cfmakeraw(&nonBlockTerm)
  } else {
    nonBlockTerm.c_lflag &= ~tcflag_t(ICANON | ECHO)
    nonBlockTerm.c_iflag &= ~tcflag_t(ICRNL | IUTF8)
  }
  tcsetattr(STDIN_FILENO, TCSANOW, &nonBlockTerm)
}

/// Checks if a key is pressed.
/// - Returns: `true` if a key is pressed, `false` otherwise.
public func keyPressed() -> Bool {
  var fds = [ pollfd(fd: STDIN_FILENO, events: Int16(POLLIN), revents: 0) ]
  return poll(&fds, 1, 0) > 0
}

/// Reads a character from standard input.
/// - Returns: The character read.
public func readChar() -> Character {
  var key: UInt8 = 0
  let res = read(STDIN_FILENO, &key, 1)
  return res < 0 ? "\0" : Character(UnicodeScalar(key))
}

/// Reads an ASCII code from standard input.
/// - Returns: The ASCII code read.
public func readCode() -> Int {
  var key: UInt8 = 0
  let res = read(STDIN_FILENO, &key, 1)
  return res < 0 ? 0 : Int(key)
}

/// Sends a request to the terminal and reads the response.
/// - Parameters:
///   - command: The ANSI escape command to send.
///   - endChar: The character indicating the end of the response.
/// - Returns: The terminal's response.
internal func ansiRequest(_ command: String, endChar: Character) -> String {
  let nonBlock = isNonBlockingMode
  if !nonBlock { enableNonBlockingTerminal() }
  write(STDOUT_FILENO, command, command.count)

  var res: String = ""
  var key: UInt8  = 0
  repeat {
    read(STDIN_FILENO, &key, 1)
    res.append(Character(UnicodeScalar(key)))
  } while key != endChar.asciiValue

  if !nonBlock { disableNonBlockingTerminal() }
  return res
}

/// Writes text to standard output.
/// - Parameters:
///   - text: Text to write.
///   - suspend: Milliseconds to pause after writing.
public func write(_ text: String..., suspend: Int = 0) {
  for txt in text { write(STDOUT_FILENO, txt, txt.utf8.count) }
  if suspend != 0 { delay(suspend) }
}

/// Writes text followed by a new line to standard output.
/// - Parameters:
///   - text: Text to write.
///   - suspend: Milliseconds to pause after writing.
public func writeln(_ text: String..., suspend: Int = 0) {
  for txt in text { write(STDOUT_FILENO, txt, txt.utf8.count) }
  write(STDOUT_FILENO, "\n", 1)
  if suspend != 0 { delay(suspend) }
}

/// Writes text at a specified row and column.
/// - Parameters:
///   - row: Row number.
///   - col: Column number.
///   - text: Text to write.
///   - suspend: Milliseconds to pause after writing.
public func writeAt(_ row: Int, _ col: Int, _ text: String..., suspend: Int = 0) {
  moveTo(row, col)
  for txt in text { write(STDOUT_FILENO, txt, txt.utf8.count) }
  if suspend != 0 { delay(suspend) }
}

/// Prompts the user with a question and returns the answer.
/// - Parameters:
///   - q: Question to ask.
///   - cleanUp: Whether to clear the buffer before reading.
/// - Returns: User's answer.
public func ask(_ q: String, cleanUp: Bool = false) -> String {
  print(q, terminator: "")
  if cleanUp { clearBuffer() }
  return readLine()!
}
