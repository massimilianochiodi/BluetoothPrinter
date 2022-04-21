/*
 *      _   _ _______  ___ ____    __  __ _ _
 *     | \ | | ____\ \/ (_)  _ \  |  \/  (_) | __ _ _ __   ___
 *     |  \| |  _|  \  /| | | | | | |\/| | | |/ _` | '_ \ / _ \
 *     | |\  | |___ /  \| | |_| | | |  | | | | (_| | | | | (_) |
 *     |_| \_|_____/_/\_\_|____/  |_|  |_|_|_|\__,_|_| |_|\___/
 *     Digital Xperiences
 *     Via Fabio Filzi, 27 - (8°piano) - 20124 Milano
 *     Telefono: +39 02 2666490 - Mail: info@nexid.it
 *
 *
 *
 *  Created by Massimiliano Chiodi on 21/04/22.
 *
 */

import Foundation
import UIKit

public protocol Printable {
    func data(using encoding: String.Encoding) -> Data
}

public protocol BlockDataProvider: Printable { }

public protocol Attribute {
    var attribute: [UInt8] { get }
}

public struct Block: Printable {

    public static var defaultFeedPoints: UInt8 = 20
    
    private let feedPoints: UInt8
    private let dataProvider: BlockDataProvider
    
    public init(_ dataProvider: BlockDataProvider, feedPoints: UInt8 = Block.defaultFeedPoints) {
        self.feedPoints = feedPoints
        self.dataProvider = dataProvider
    }
    
    public func data(using encoding: String.Encoding) -> Data {
        return dataProvider.data(using: encoding) + Data.stampa(feedPoints)
    }
}

public extension Block {
    // blank line
    static var blank = Block(Blank())
    
    static func blank(_ line: UInt8) -> Block {
        return Block(Blank(), feedPoints: Block.defaultFeedPoints * line)
    }
    
    // qr
    static func qr(_ content: String) -> Block {
        return Block(QRCode(content))
    }
    
    // title
    static func title(_ content: String) -> Block {
        return Block(Text.title(content))
    }
    
    // plain text
    static func plainText(_ content: String) -> Block {
        return Block(Text.init(content))
    }
    
    static func text(_ text: Text) -> Block {
        return Block(text)
    }
    
    // key    value
    static func kv(k: String, v: String) -> Block {
        return Block(Text.kv(k: k, v: v))
    }
    
    static func kvs(k: String, v: String, attributes: [Attribute]) -> Block {
        return Block(Text.kv(k: k, v: v, attributes: attributes))
    }
    
    // dividing
    static var dividing = Block(Dividing.default)
    
    // image
    static func image(_ im: Image, attributes: TicketImage.PredefinedAttribute...) -> Block {
        return Block(TicketImage(im, attributes: attributes))
    }
    
}
