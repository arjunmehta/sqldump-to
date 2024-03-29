const BLOCK_COMMENT_END_BUFF = Buffer.from('*/');
const BLOCK_COMMENT_START_BUFF = Buffer.from('/*');
const BRACE_CLOSE_BUFF = Buffer.from(')');
const BRACE_OPEN_BUFF = Buffer.from('(');
const BRACKET_CLOSE_BUFF = Buffer.from(']');
const BRACKET_OPEN_BUFF = Buffer.from('[');
const COMMAND_EXEC_BUFF = Buffer.from(';');
const COMMENT_START_BUFF = Buffer.from('--');
const CREATE_TABLE_BUFF = Buffer.from('CREATE TABLE ');
const ESCAPE_CHAR_BUFF = Buffer.from('\\');
const INSERT_INTO_BUFF = Buffer.from('INSERT INTO ');
const NEWLINE_BUFF = Buffer.from('\n');
const STRING_OPENER_BUFF = Buffer.from('\'');
const USE_BUFF = Buffer.from('USE ');
const VALUES_BUFF = Buffer.from(' VALUES ');

const BRACE_CLOSE_OCTET = BRACE_CLOSE_BUFF[0];
const BRACE_OPEN_OCTET = BRACE_OPEN_BUFF[0];
const COMMAND_EXEC_OCTET = COMMAND_EXEC_BUFF[0];
const ESCAPE_CHAR_OCTET = ESCAPE_CHAR_BUFF[0];
const STRING_OPENER_OCTET = STRING_OPENER_BUFF[0];
const BRACKET_CLOSE_OCTET = BRACKET_CLOSE_BUFF[0];
const BRACKET_OPEN_OCTET = BRACKET_OPEN_BUFF[0];
const NEWLINE_OCTET = NEWLINE_BUFF[0];

const ESCAPE_TYPE_NONE = 0;
const ESCAPE_TYPE_BLOCK_COMMENT = 1;
const ESCAPE_TYPE_COMMENT = 2;
const ESCAPE_TYPE_CHAR = 3;
const ESCAPE_TYPE_QUOTE = 4;

// Class Definition

class SQLBuffer {
  constructor() {
    this.buffer = Buffer.from('');
    this.bufferPosition = 0;

    this.bracketStartPos = 0;
    this.bracketEndPos = 0;
    this.openBracketCount = 0;

    this.isWithinString = false;
    this.isEscaped = false;
  }

  // Getters and Setters

  get position() {
    return this.bufferPosition;
  }

  set position(position) {
    this.bufferPosition = position;
  }

  get isAtEnd() {
    return this.bufferPosition >= this.buffer.length - 1;
  }

  get length() {
    return this.buffer.length;
  }

  // Content Control

  add(chunk) {
    this.buffer = Buffer.concat([this.buffer, chunk]);
  }

  clean() {
    this.buffer = this.buffer.slice(this.bufferPosition, this.buffer.length);
    this.bufferPosition = 0;
  }

  // Retrieval

  slice(start, end) {
    return this.buffer.slice(start, end);
  }

  // Finding and navigation

  indexOf(searchBuf, start = this.bufferPosition, absolute = true) {
    if (absolute === true) {
      return this.buffer.indexOf(searchBuf, start);
    }

    return smartIndexOf(this.buffer, searchBuf, start);
  }

  getContentBetweenNext(startBuffer, endBuffer, options = {}) {
    const { moveToEnd } = options;

    const indexOfStart = smartIndexOf(this.buffer, startBuffer, this.bufferPosition);
    const indexOfEnd = this.buffer.indexOf(endBuffer, indexOfStart);
    const contentPos = indexOfStart + startBuffer.length + 1;

    if (indexOfEnd === -1) {
      return undefined;
    }

    if (moveToEnd) {
      this.bufferPosition = indexOfEnd + endBuffer.length - 1;
    }

    return this.buffer.slice(contentPos, indexOfEnd).toString();
  }

  getNextCommandParenSet() {
    while (this.bufferPosition < this.buffer.length) {
      if (this.isEscaped === false) {
        switch (this.buffer[this.bufferPosition]) {
          case ESCAPE_CHAR_OCTET:
            this.isEscaped = true;
            break;

          case STRING_OPENER_OCTET:
            this.isWithinString = !this.isWithinString;
            break;

          case BRACE_OPEN_OCTET:
            if (!this.isWithinString) {
              if (this.openBracketCount === 0) {
                this.bracketStartPos = this.bufferPosition;
              }

              this.openBracketCount += 1;
            }
            break;

          case BRACE_CLOSE_OCTET:
            if (!this.isWithinString) {
              this.openBracketCount -= 1;

              if (this.openBracketCount === 0) {
                this.bracketEndPos = this.bufferPosition;
                this.bufferPosition += 1;

                const bufferLength = 2 + (this.bracketEndPos - this.bracketStartPos);
                const rowBuffer = Buffer.allocUnsafe(bufferLength);

                rowBuffer[0] = BRACKET_OPEN_OCTET;
                rowBuffer[bufferLength - 2] = BRACKET_CLOSE_OCTET;
                rowBuffer[bufferLength - 1] = NEWLINE_OCTET;

                this.buffer.copy(rowBuffer, 1, this.bracketStartPos + 1, this.bracketEndPos);

                return rowBuffer;
              }
            }
            break;

          case COMMAND_EXEC_OCTET:
            if (!this.isWithinString) {
              this.bufferPosition += 1;
              return COMMAND_EXEC_BUFF;
            }
            break;

          default:
            break;
        }
      } else {
        this.isEscaped = false;
      }

      this.bufferPosition += 1;
    }

    return undefined;
  }

  skipToEndOfCommand() {
    while (this.bufferPosition < this.buffer.length) {
      if (this.isEscaped === false) {
        switch (this.buffer[this.bufferPosition]) {
          case ESCAPE_CHAR_OCTET:
            this.isEscaped = true;
            break;

          case STRING_OPENER_OCTET:
            this.isWithinString = !this.isWithinString;
            break;

          case COMMAND_EXEC_OCTET:
            if (!this.isWithinString) {
              this.bufferPosition += 1;
              return COMMAND_EXEC_BUFF;
            }
            break;

          default:
            break;
        }
      } else {
        this.isEscaped = false;
      }

      this.bufferPosition += 1;
    }

    return undefined;
  }
}

// Custom indexOf method to ignore content within escape characters

function smartIndexOf(buffer, searchForBuffer, startPos = 0) {
  const searchLength = searchForBuffer.length;
  let isEscaped = ESCAPE_TYPE_NONE;
  let bufferPosition = startPos - 1;
  let matchPosition = 0;

  while (bufferPosition < buffer.length - 1) {
    bufferPosition += 1;

    if (!isEscaped) {
      switch (buffer[bufferPosition]) {
        case ESCAPE_CHAR_BUFF[0]:
          isEscaped = ESCAPE_TYPE_CHAR;
          break;

        case BLOCK_COMMENT_START_BUFF[0]:
          if (buffer[bufferPosition + 1] === BLOCK_COMMENT_START_BUFF[1]) {
            isEscaped = ESCAPE_TYPE_BLOCK_COMMENT;
            bufferPosition += 1;
          }
          break;

        case COMMENT_START_BUFF[0]:
          if (buffer[bufferPosition + 1] === COMMENT_START_BUFF[1]) {
            isEscaped = ESCAPE_TYPE_COMMENT;
            bufferPosition += 1;
          }
          break;

        case STRING_OPENER_BUFF[0]:
          isEscaped = ESCAPE_TYPE_QUOTE;
          break;

        case searchForBuffer[matchPosition]:
          matchPosition += 1;
          break;

        default:
          matchPosition = 0;
          break;
      }

      if (matchPosition === searchLength) {
        return bufferPosition - searchLength + 1;
      }
    } else {
      switch (isEscaped) {
        case ESCAPE_TYPE_CHAR:
          isEscaped = ESCAPE_TYPE_NONE;
          break;

        case ESCAPE_TYPE_BLOCK_COMMENT:
          if (
            buffer[bufferPosition] === BLOCK_COMMENT_END_BUFF[0]
            && buffer[bufferPosition + 1] === BLOCK_COMMENT_END_BUFF[1]
          ) {
            isEscaped = ESCAPE_TYPE_NONE;
            bufferPosition += 1;
          }
          break;

        case ESCAPE_TYPE_QUOTE:
          if (
            buffer[bufferPosition] === STRING_OPENER_BUFF[0]
            && buffer[bufferPosition - 1] !== ESCAPE_CHAR_BUFF[0]
          ) {
            isEscaped = ESCAPE_TYPE_NONE;
          }
          break;

        case ESCAPE_TYPE_COMMENT:
          if (buffer[bufferPosition] === NEWLINE_BUFF[0]) {
            isEscaped = ESCAPE_TYPE_NONE;
          }
          break;

        default:
          matchPosition = 0;
          break;
      }
    }
  }

  return -1;
}

// Exports

module.exports = {
  SQLBuffer,
  smartIndexOf,

  BUFFERS: {
    BLOCK_COMMENT_END_BUFF,
    BLOCK_COMMENT_START_BUFF,
    BRACE_CLOSE_BUFF,
    BRACE_OPEN_BUFF,
    BRACKET_CLOSE_BUFF,
    BRACKET_OPEN_BUFF,
    COMMAND_EXEC_BUFF,
    COMMENT_START_BUFF,
    CREATE_TABLE_BUFF,
    ESCAPE_CHAR_BUFF,
    INSERT_INTO_BUFF,
    NEWLINE_BUFF,
    STRING_OPENER_BUFF,
    USE_BUFF,
    VALUES_BUFF,
  },
};
