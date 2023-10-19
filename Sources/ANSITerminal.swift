#if os(Linux)
import Glibc
#else
import Darwin
#endif

// ANSI escape code constants
public let ESC = "\u{1B}"  // Escape character (27 or 1B)
public let SS2 = ESC+"N"   // Single Shift Select of G2 charset
public let SS3 = ESC+"O"   // Single Shift Select of G3 charset
public let DCS = ESC+"P"   // Device Control String
public let CSI = ESC+"["   // Control Sequence Introducer
public let OSC = ESC+"]"   // Operating System Command

// Special characters
public let RPT = "\u{e0b0}"   // right pointing triangle
public let LPT = "\u{e0b2}"   // left pointing triangle
public let RPA = "\u{e0b1}"   // right pointing angle
public let LPA = "\u{e0b3}"   // left pointing angle

// Terminal settings
internal private(set) var defaultTerminal = termios()
public private(set) var isNonBlockingMode = false

/// Introduces a delay in the program execution.
/// - Parameter ms: Milliseconds to delay.
@inlinable public func delay(_ ms: Int) {
  usleep(UInt32(ms * 1000))  // convert to milliseconds
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
  if isIn {
    fflush(stdin)
  }

  if isOut {
    fflush(stdout)
  }
}

/// Disables non-blocking terminal mode and restores default settings.
public func disableNonBlockingTerminal() {
  // restore default terminal mode
  tcsetattr(STDIN_FILENO, TCSANOW, &defaultTerminal)
  isNonBlockingMode = false
}

/// Enables non-blocking terminal mode.
/// - Parameter rawMode: Whether to use raw mode.
public func enableNonBlockingTerminal(rawMode: Bool = false) {
  // store current terminal mode
  tcgetattr(STDIN_FILENO, &defaultTerminal)
  atexit(disableNonBlockingTerminal)
  isNonBlockingMode = true

  // configure non-blocking and non-echoing terminal mode
  var nonBlockTerm = defaultTerminal
  if rawMode {
    //! full raw mode without any input processing at all
    cfmakeraw(&nonBlockTerm)
  } else {
    // disable CANONical mode and ECHO-ing input
    nonBlockTerm.c_lflag &= ~tcflag_t(ICANON | ECHO)
    // acknowledge CRNL line ending and UTF8 input
    nonBlockTerm.c_iflag &= ~tcflag_t(ICRNL | IUTF8)
  }

  // enable new terminal mode
  tcsetattr(STDIN_FILENO, TCSANOW, &nonBlockTerm)
}

/// Checks if a key is pressed.
/// - Returns: `true` if a key is pressed, `false` otherwise.
public func keyPressed() -> Bool {
  if !isNonBlockingMode {
    enableNonBlockingTerminal()
  }

  var fds = [ pollfd(fd: STDIN_FILENO, events: Int16(POLLIN), revents: 0) ]
  return poll(&fds, 1, 0) > 0
}

public var internalBuffer: [UInt8] = []

/// Reads a character from standard input.
/// - Returns: The character read.
public func readChar() -> Character {
  if !internalBuffer.isEmpty {
    let char = internalBuffer.removeFirst()
    return Character(UnicodeScalar(char))
  }

  var key: UInt8 = 0
  let res = read(STDIN_FILENO, &key, 1)
  return res < 0 ? "\0" : Character(UnicodeScalar(key))
}

//public func safeReadChar() -> Character {
//  var buffer: UInt8 = 0
//  let bytesRead = read(STDIN_FILENO, &buffer, 1)
//
//  if bytesRead < 0 {
//    return "\0"
//  }
//
//  if buffer == 27 {
//    // Skip two more bytes assuming it's an arrow key
//    _ = read(STDIN_FILENO, &buffer, 1)
//    _ = read(STDIN_FILENO, &buffer, 1)
//    return safeReadChar()
//  }
//
//  return Character(UnicodeScalar(buffer))
//}

public func readMultipleCharInsideReadBuffer() -> Character {
  var buffer: [UInt8] = Array(repeating: 0, count: 3)
  let bytesRead = read(STDIN_FILENO, &buffer, 3)

  if bytesRead < 0 {
    return "\0"
  }

  if buffer[0] == 27 && buffer[1] == 91 {
    // It's an arrow key, so we ignore it.
    internalBuffer.append(contentsOf: buffer[2..<bytesRead])
    return safeReadChar()
  } else {
    internalBuffer.append(contentsOf: buffer[1..<bytesRead])
    return Character(UnicodeScalar(buffer[0]))
  }
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
  // store current input mode
  let nonBlock = isNonBlockingMode
  if !nonBlock {
    enableNonBlockingTerminal()
  }

  // send request
  write(STDOUT_FILENO, command, command.count)

  // read response
  var res: String = ""
  var key: UInt8  = 0
  repeat {
    read(STDIN_FILENO, &key, 1)
    if key < 32 {
      res.append("^")  // replace non-printable ascii
    } else {
      res.append(Character(UnicodeScalar(key)))
    }
  } while key != endChar.asciiValue

  // restore input mode and return response value
  if !nonBlock {
    disableNonBlockingTerminal()
  }
  return res
}

/// Writes text to standard output.
/// - Parameters:
///   - text: Text to write.
///   - suspend: Milliseconds to pause after writing.
public func write(_ text: String..., suspend: Int = 0) {
  for txt in text { write(STDOUT_FILENO, txt, txt.utf8.count) }
  if suspend > 0 {
    delay(suspend)
  }

  if suspend < 0 {
    clearBuffer()
  }
}

/// Writes text followed by a new line to standard output.
/// - Parameters:
///   - text: Text to write.
///   - suspend: Milliseconds to pause after writing.
public func writeln(_ text: String..., suspend: Int = 0) {
  for txt in text { write(STDOUT_FILENO, txt, txt.utf8.count) }
  write(STDOUT_FILENO, "\n", 1)
  if suspend > 0 {
    delay(suspend)
  }

  if suspend < 0 {
    clearBuffer()
  }
}

public func writeln(suspend: Int = 0) {
  write(STDOUT_FILENO, "\n", 1)
  if suspend > 0 {
    delay(suspend)
  }

  if suspend < 0 {
    clearBuffer()
  }
}

/// Prompts the user with a question and returns the answer.
/// - Parameters:
///   - q: Question to ask.
///   - cleanUp: Whether to clear the buffer before reading.
/// - Returns: User's answer.
public func ask(_ q: String, cleanUp: Bool = false) -> String {
  print(q, terminator: "")
  if cleanUp {
    clearBuffer()
  }
  return readLine()!
}
