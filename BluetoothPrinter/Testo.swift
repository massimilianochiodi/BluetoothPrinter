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

public struct Testo: DataProviderBlocco {
    
    let content: String
    let attributi: [Attributi]?
    
    public init(_ content: String, attributi: [Attributi]? = nil) {
        self.content = content
        self.attributi = attributi
    }
    
    public func data(using encoding: String.Encoding) -> Data {
        var result = Data()
        
        if let attrs = attributi {
            result.append(Data(attrs.flatMap { $0.attributi }))
        }
        
        if let cd = content.data(using: encoding) {
            result.append(cd)
        }
        
        return result
    }
}

public extension Testo {
    
    enum AttributiPredefiniti: Attributi {
        
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
        
        public var attributi: [UInt8] {
            switch self {
            case let .alignment(v):
                return ESC_POS.justification(v == .left ? 0 : v == .center ? 1 : 2).rawValue
            case .bold:
                return ESC_POS.emphasize(mode: true).rawValue
            case .small:
                return ESC_POS.font(1).rawValue
            case .light:
                return ESC_POS.color(n: 1).rawValue
            case let .scale(v):
                return [0x1D, 0x21, v.rawValue]
            case let .feed(v):
                return ESC_POS.feed(points: v).rawValue
            }
        }
    }
}

public extension Testo {
    
    init(content: String, predefined attributi: AttributiPredefiniti...) {
        self.init(content, attributi: attributi)
    }
}

public extension Testo {
    
    static func title(_ content: String) -> Testo {
        return Testo(content: content, predefined: .scale(.l1), .alignment(.center))
    }
    
    
    
    static func kv(printDensity: Int = 354, fontDensity: Int = 12, k: String, v: String, attributi: [Attributi]? = nil) -> Testo {
        
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
        
        return Testo(contents.joined(), attributi: attributi)
    }
}
