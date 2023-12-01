// Copyright (c) 2023 Timofey Solomko
// Licensed under MIT License
//
// See LICENSE for license information

import Foundation
import BitByteData

extension LittleEndianByteReader {

    /**
     Reads an `Int` field from TAR container. The end of the field is defined by either:
     1. NULL or SPACE (in containers created by certain old implementations) character.
     2. Reaching specified maximum length.

     Integers are encoded in TAR as ASCII text. We are treating them as UTF-8 encoded strings since UTF-8 is backwards
     compatible with ASCII.
     */
    func safeByte() throws -> UInt8 {
        guard self.bytesLeft > 0 else { 
            throw LZMAError.rangeDecoderInitError
        }
        return self.byte()
    }

}
