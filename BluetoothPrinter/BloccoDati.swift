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

public protocol Stampabile {
    func data(using encoding: String.Encoding) -> Data
}

public protocol DataProviderBlocco: Stampabile { }

public protocol Attributi {
    var attributi: [UInt8] { get }
}

public struct BloccoDati: Stampabile {

    public static var defaultFeedPoints: UInt8 = 20
    
    private let feedPoints: UInt8
    private let dataProvider: DataProviderBlocco
    
    public init(_ dataProvider: DataProviderBlocco, feedPoints: UInt8 = BloccoDati.defaultFeedPoints) {
        self.feedPoints = feedPoints
        self.dataProvider = dataProvider
    }
    
    public func data(using encoding: String.Encoding) -> Data {
        return dataProvider.data(using: encoding) + Data.stampa(feedPoints)
    }
}

public extension BloccoDati {
    // linea vuota
    static var vuoto = BloccoDati(Vuoto())
    
    static func vuoto(_ line: UInt8) -> BloccoDati {
        return BloccoDati(Vuoto(), feedPoints: BloccoDati.defaultFeedPoints * line)
    }
    
    // qr
    static func qr(_ content: String) -> BloccoDati {
        return BloccoDati(QRCode(content))
    }
    
    // titolo
    static func titolo(_ content: String) -> BloccoDati {
        return BloccoDati(Testo.title(content))
    }
    
    //  text
    static func testonormale(_ content: String) -> BloccoDati {
        return BloccoDati(Testo.init(content))
    }
    
    static func testo(_ text: Testo) -> BloccoDati {
        return BloccoDati(text)
    }
    
    // key    value
    static func testoincolonna(k: String, v: String) -> BloccoDati {
        return BloccoDati(Testo.kv(k: k, v: v))
    }
    
    static func testoincolonnagrassetto(k: String, v: String, attributi: [Attributi]) -> BloccoDati {
        return BloccoDati(Testo.kv(k: k, v: v, attributi: attributi))
    }
    
    // dividing
    static var divisore = BloccoDati(Divisore.default)
    
    // image
    static func image(_ im: Immagine, attributes: ScontrinoImmagine.AttributiPredefiniti...) -> BloccoDati {
        return BloccoDati(ScontrinoImmagine(im, attributi: attributes))
    }
    
}
