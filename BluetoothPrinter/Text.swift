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

import UIKit

public struct Text: BlockDataProvider {
    
    let content: String
    let attributes: [Attribute]?
    
    public init(_ content: String, attributes: [Attribute]? = nil) {
        self.content = content
        self.attributes = attributes
    }
    
    public func data(using encoding: String.Encoding) -> Data {
        var result = Data()
        
        if let attrs = attributes {
            result.append(Data(attrs.flatMap { $0.attribute }))
        }
        
        if let cd = content.data(using: encoding) {
            result.append(cd)
        }
        
        return result
    }
}

public extension Text {
    
    enum PredefinedAttribute: Attribute {
        
        public enum ScaleLevel: UInt8 {
            
            case l0 = 0x00
            case l1 = 0x11
            case l2 = 0x22
            case l3 = 0x33
            case l4 = 0x44
            case l5 = 0x55
            case l6 = 0x66
            case l7 = 0x77
        }
        
        case alignment(NSTextAlignment)
        case bold
        case small
        case light
        case scale(ScaleLevel)
        case feed(UInt8)
        
        public var attribute: [UInt8] {
            switch self {
            case let .alignment(v):
                return ESC_POSCommand.justification(v == .left ? 0 : v == .center ? 1 : 2).rawValue
            case .bold:
                return ESC_POSCommand.emphasize(mode: true).rawValue
            case .small:
                return ESC_POSCommand.font(1).rawValue
            case .light:
                return ESC_POSCommand.color(n: 1).rawValue
            case let .scale(v):
                return [0x1D, 0x21, v.rawValue]
            case let .feed(v):
                return ESC_POSCommand.feed(points: v).rawValue
            }
        }
    }
}

public extension Text {
    
    init(content: String, predefined attributes: PredefinedAttribute...) {
        self.init(content, attributes: attributes)
    }
}

public extension Text {
    
    static func title(_ content: String) -> Text {
        return Text(content: content, predefined: .scale(.l1), .alignment(.center))
    }
    
    
    
    static func kv(printDensity: Int = 354, fontDensity: Int = 12, k: String, v: String, attributes: [Attribute]? = nil) -> Text {
        
        var num = printDensity / fontDensity
        
        let string = k + v
        
        for c in string {
            if (c >= "\u{2E80}" && c <= "\u{FE4F}") || c == "\u{FFE5}"{
                num -= 2
            } else  {
                num -= 1
            }
        }
        
        var contents = stride(from: 0, to: num, by: 1).map { _ in " " }
        
        contents.insert(k, at: 0)
        contents.append(v)
        
        return Text(contents.joined(), attributes: attributes)
    }
}
