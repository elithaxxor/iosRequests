//
// Created by Adel Al-Aali on 6/19/22.
/// https://stackoverflow.com/questions/35513734/approach-for-reading-arbitrary-number-of-bits-in-swift


import Foundation

//class readData() {
//    BitReader = BitReader()
//    BitReader.init(data: T##[UInt8])
//}

struct BitReader {

    private let data: [UInt8]
    private var byteOffset: Int
    private var bitOffset: Int

    init(data: [UInt8]) {
        self.data = data
        self.byteOffset = 0
        self.bitOffset = 0
    }

    func remainingBits() -> Int {
        return 8 * (data.count - byteOffset) - bitOffset
    }

    mutating func nextBits(numBits: Int) -> UInt {
        precondition(numBits <= remainingBits(), "attempt to read more bits than available")

        var bits = numBits     // remaining bits to read
        var result: UInt = 0  // result accumulator

        // Read remaining bits from current byte:
        if bitOffset > 0 {
            if bitOffset + bits < 8 {
                result = (UInt(data[byteOffset]) & UInt(0xFF >> bitOffset)) >> UInt(8 - bitOffset - bits)
                bitOffset += bits
                return result
            } else {
                result = UInt(data[byteOffset]) & UInt(0xFF >> bitOffset)
                bits = bits - (8 - bitOffset)
                bitOffset = 0
                byteOffset = byteOffset + 1
            }
        }

        // Read entire bytes:
        while bits >= 8 {
            result = (result << UInt(8)) + UInt(data[byteOffset])
            byteOffset = byteOffset + 1
            bits = bits - 8
        }

        // Read remaining bits:
        if bits > 0 {
            result = (result << UInt(bits)) + (UInt(data[byteOffset]) >> UInt(8 - bits))
            bitOffset = bits
        }

        return result
    }
}
