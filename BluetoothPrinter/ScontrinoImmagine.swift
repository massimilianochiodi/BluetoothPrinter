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

public struct ScontrinoImmagine: DataProviderBlocco {
    
    private let immagine: Immagine
    private let attributi: [Attributi]?
    
    public init(_ immagine: Immagine, attributi: [Attributi]? = nil) {
        self.immagine = immagine
        self.attributi = attributi
    }
    
    public func data(using encoding: String.Encoding) -> Data {
        var result = Data()
       
        if let attrs = attributi {
            result.append(Data(attrs.flatMap { $0.attributi }))
        }
        
        if let data = immagine.scontrinodata {
            result.append(data)
        }
        
        return result
    }
}

public extension ScontrinoImmagine {
    
    enum AttributiPredefiniti: Attributi {
        
        case alignment(NSTextAlignment)
        
        public var attributi: [UInt8] {
            switch self {
            case let .alignment(v):
                return ESC_POS.justification(v == .left ? 0 : v == .center ? 1 : 2).rawValue
            }
        }
    }
    
}
