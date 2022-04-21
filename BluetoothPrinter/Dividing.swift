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

public protocol DividingPrivoider {
    func character(for current: Int, total: Int) -> Character
}

extension Character: DividingPrivoider {
    public func character(for current: Int, total: Int) -> Character {
        return self
    }
}

/// add Dividing on receipt
public struct Dividing: BlockDataProvider {
    
    let provider: DividingPrivoider
    
    let printDensity: Int
    let fontDensity: Int
    
    static var `default`: Dividing {
        return Dividing(provider: Character("-"), printDensity: 384, fontDensity: 12)
    }
    
    public func data(using encoding: String.Encoding) -> Data {
        let num = printDensity / fontDensity
        
        let content = stride(from: 0, to: num, by: 1).map { String(provider.character(for: $0, total: num) ) }.joined()
        
        return Text(content).data(using: encoding)
    }
}
