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

struct QRCode: DataProviderBlocco {
    
    let content: String
    
    init(_ content: String) {
        self.content = content
    }
    
    func data(using encoding: String.Encoding) -> Data {
        var result = Data()
        
        result.append(Data(esc_pos: ESC_POS.justification(1),
                           ESC_POS.QRSetSize(),
                           ESC_POS.QRSetRecoveryLevel(),
                           ESC_POS.QRGetReadyToStore(text: content)))
        
        if let cd = content.data(using: encoding) {
            result.append(cd)
        }
        
        result.append(Data(esc_pos: .QRPrint()))
        
        return result
    }
}
