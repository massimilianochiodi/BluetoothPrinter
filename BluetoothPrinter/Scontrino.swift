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

public struct Scontrino {
    
    public var feedLinesOnTail: UInt8 = 3
    public var feedLinesOnHead: UInt8 = 0
    
    private var blocchi = [BloccoDati]()
    
    public init(_ blocchi: BloccoDati...) {
        self.blocchi = blocchi
    }
    
    public mutating func add(blocco: BloccoDati) {
        blocchi.append(blocco)
    }
    
    public func data(using encoding: String.Encoding) -> [Data] {
        
        var ds = blocchi.map { Data.reset + $0.data(using: encoding) }
        
        if feedLinesOnHead > 0 {
            ds.insert(Data(esc_pos: .printAndFeed(lines: feedLinesOnHead)), at: 0)
        }
        
        if feedLinesOnTail > 0 {
            ds.append(Data(esc_pos: .printAndFeed(lines: feedLinesOnTail)))
        }
        
        return ds
    }
}
