//////
////// Created by Adel Al-Aali on 6/19/22.
/////// https://stackoverflow.com/questions/35513734/approach-for-reading-arbitrary-number-of-bits-in-swift
////
////
////import Foundation
////
//
//
//import Dispatch
//import Foundation
//import UIKit
//
//extension Array where Element == UInt8 {
//    
//    /// Creates a `[UInt8]` from the given buffer. The entire readable portion of the buffer will be read.
//    /// - parameter buffer: The buffer to read.
//    @inlinable
//    public init(buffer: ByteBuffer) {
//        var buffer = buffer
//        self = buffer.readBytes(length: buffer.readableBytes)!
//    }
//    
//}
//
//extension String {
//    
//    /// Creates a `String` from a given `ByteBuffer`. The entire readable portion of the buffer will be read.
//    /// - parameter buffer: The buffer to read.
//    @inlinable
//    public init(buffer: ByteBuffer) {
//        var buffer = buffer
//        self = buffer.readString(length: buffer.readableBytes)!
//    }
//    
//}

//
//
//extension ByteBuffer {
//    /// Attempts to decode the `length` bytes from `index` using the `JSONDecoder` `decoder` as `T`.
//    ///
//    /// - parameters:
//    ///    - type: The type type that is attempted to be decoded.
//    ///    - decoder: The `JSONDecoder` that is used for the decoding.
//    ///    - index: The index of the first byte to decode.
//    ///    - length: The number of bytes to decode.
//    /// - returns: The decoded value if successful or `nil` if there are not enough readable bytes available.
//    @inlinable
//    public func getJSONDecodable<T: Decodable>(_ type: T.Type,
//                                               decoder: JSONDecoder = JSONDecoder(),
//                                               at index: Int, length: Int) throws -> T? {
//        guard let data = self.getData(at: index, length: length, byteTransferStrategy: .noCopy) else {
//            return nil
//        }
//        return try decoder.decode(T.self, from: data)
//    }
//
//    /// Reads `length` bytes from this `ByteBuffer` and then attempts to decode them using the `JSONDecoder` `decoder`.
//    ///
//    /// - parameters:
//    ///    - type: The type type that is attempted to be decoded.
//    ///    - decoder: The `JSONDecoder` that is used for the decoding.
//    ///    - length: The number of bytes to decode.
//    /// - returns: The decoded value is successful or `nil` if there are not enough readable bytes available.
//    @inlinable
//    public mutating func readJSONDecodable<T: Decodable>(_ type: T.Type,
//                                                         decoder: JSONDecoder = JSONDecoder(),
//                                                         length: Int) throws -> T? {
//        guard let decoded = try self.getJSONDecodable(T.self,
//                                                      decoder: decoder,
//                                                      at: self.readerIndex,
//                                                      length: length) else {
//            return nil
//        }
//        self.moveReaderIndex(forwardBy: length)
//        return decoded
//    }
//
//    /// Encodes `value` using the `JSONEncoder` `encoder` and set the resulting bytes into this `ByteBuffer` at the
//    /// given `index`.
//    ///
//    /// - note: The `writerIndex` remains unchanged.
//    ///
//    /// - parameters:
//    ///     - value: An `Encodable` value to encode.
//    ///     - encoder: The `JSONEncoder` to encode `value` with.
//    /// - returns: The number of bytes written.
//    @inlinable
//    @discardableResult
//    public mutating func setJSONEncodable<T: Encodable>(_ value: T,
//                                                        encoder: JSONEncoder = JSONEncoder(),
//                                                        at index: Int) throws -> Int {
//        let data = try encoder.encode(value)
//        return self.setBytes(data, at: index)
//    }
//
//    /// Encodes `value` using the `JSONEncoder` `encoder` and writes the resulting bytes into this `ByteBuffer`.
//    ///
//    /// If successful, this will move the writer index forward by the number of bytes written.
//    ///
//    /// - parameters:
//    ///     - value: An `Encodable` value to encode.
//    ///     - encoder: The `JSONEncoder` to encode `value` with.
//    /// - returns: The number of bytes written.
//    @inlinable
//    @discardableResult
//    public mutating func writeJSONEncodable<T: Encodable>(_ value: T,
//                                                          encoder: JSONEncoder = JSONEncoder()) throws -> Int {
//        let result = try self.setJSONEncodable(value, encoder: encoder, at: self.writerIndex)
//        self.moveWriterIndex(forwardBy: result)
//        return result
//    }
//}
//
//extension JSONDecoder {
//    /// Returns a value of the type you specify, decoded from a JSON object inside the readable bytes of a `ByteBuffer`.
//    ///
//    /// If the `ByteBuffer` does not contain valid JSON, this method throws the
//    /// `DecodingError.dataCorrupted(_:)` error. If a value within the JSON
//    /// fails to decode, this method throws the corresponding error.
//    ///
//    /// - note: The provided `ByteBuffer` remains unchanged, neither the `readerIndex` nor the `writerIndex` will move.
//    ///         If you would like the `readerIndex` to move, consider using `ByteBuffer.readJSONDecodable(_:length:)`.
//    ///
//    /// - parameters:
//    ///     - type: The type of the value to decode from the supplied JSON object.
//    ///     - buffer: The `ByteBuffer` that contains JSON object to decode.
//    /// - returns: The decoded object.
//    public func decode<T: Decodable>(_ type: T.Type, from buffer: ByteBuffer) throws -> T {
//        return try buffer.getJSONDecodable(T.self,
//                                           decoder: self,
//                                           at: buffer.readerIndex,
//                                           length: buffer.readableBytes)! // must work, enough readable bytes
//    }
//}
//
//extension JSONEncoder {
//    /// Writes a JSON-encoded representation of the value you supply into the supplied `ByteBuffer`.
//    ///
//    /// - parameters:
//    ///     - value: The value to encode as JSON.
//    ///     - buffer: The `ByteBuffer` to encode into.
//    public func encode<T: Encodable>(_ value: T,
//                                     into buffer: inout ByteBuffer) throws {
//        try buffer.writeJSONEncodable(value, encoder: self)
//    }
//
//    /// Writes a JSON-encoded representation of the value you supply into a `ByteBuffer` that is freshly allocated.
//    ///
//    /// - parameters:
//    ///     - value: The value to encode as JSON.
//    ///     - allocator: The `ByteBufferAllocator` which is used to allocate the `ByteBuffer` to be returned.
//    /// - returns: The `ByteBuffer` containing the encoded JSON.
//    public func encodeAsByteBuffer<T: Encodable>(_ value: T, allocator: ByteBufferAllocator) throws -> ByteBuffer {
//        let data = try self.encode(value)
//        var buffer = allocator.buffer(capacity: data.count)
//        buffer.writeBytes(data)
//        return buffer
//    }
//}
//
//
//
////class readData {
////    
////    fileprivate static var read = BitReader()
////    
////    BitReader.init(data: [UInt8]) {
////        self.data = data
////    }
////    
////    internal func printData() {
////        print("[!] initiated the [DOWNDSTREAM] print sequence \n \()")
////        
////    }
////}
//
//struct BitReader {
//
//    private let data: [UInt8]
//    private var ByteBuffer: Int
//    private var bitOffset: Int
//
//    init(data: [UInt8]) {
//        self.data = data
//        self.ByteBuffer = 0
//        self.bitOffset = 0
//    }
//
//    internal func remainingBits() -> Int {
//        return 8 * (data.count - ByteBuffer) - bitOffset
//    }
//
//    internal mutating func nextBits(numBits: Int) -> UInt {
//        precondition(numBits <= remainingBits(), "attempt to read more bits than available")
//
//        var bits = numBits     // remaining bits to read
//        var result: UInt = 0  // result accumulator
//
//        // Read remaining bits from current byte:
//        if bitOffset > 0 {
//            if bitOffset + bits < 8 {
//                result = (UInt(data[ByteBuffer]) & UInt(0xFF >> bitOffset)) >> UInt(8 - bitOffset - bits)
//                bitOffset += bits
//                return result
//            } else {
//                result = UInt(data[ByteBuffer]) & UInt(0xFF >> bitOffset)
//                bits = bits - (8 - bitOffset)
//                bitOffset = 0
//                ByteBuffer = ByteBuffer + 1
//            }
//        }
//
//        // Read entire bytes:
//        while bits >= 8 {
//            result = (result << UInt(8)) + UInt(data[ByteBuffer])
//            ByteBuffer = ByteBuffer + 1
//            bits = bits - 8
//        }
//
//        // Read remaining bits:
//        if bits > 0 {
//            result = (result << UInt(bits)) + (UInt(data[ByteBuffer]) >> UInt(8 - bits))
//            bitOffset = bits
//        }
//        return result
//    }
//}
