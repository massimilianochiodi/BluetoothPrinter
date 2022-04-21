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

public class BluetoothPrinterSelectTableViewController: UITableViewController {

    public weak var printerManager: BluetoothPrinterManager?

    public var sectionTitle: String? // convenience property
    
    var dataSource = [BluetoothPrinter]()

    override public func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        dataSource = printerManager?.nearbyPrinters ?? []
        printerManager?.delegate = self        
    }

    override public func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataSource.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        guard indexPath.row < dataSource.count else {
            return cell
        }

        let printer = dataSource[indexPath.row]

        cell.textLabel?.text = printer.name ?? "unknow"
        cell.accessoryType = printer.state == .connected ? .checkmark : .none

        if printer.isConnecting {
            let v = UIActivityIndicatorView(style: .gray)
            v.startAnimating()
            cell.accessoryView = v
        } else {
            cell.accessoryView = nil
            cell.setEditing(false, animated: false)
        }

        return cell
    }

    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard printerManager != nil else {
            fatalError("printer manager must not be nil.")
        }
        return sectionTitle ?? "Seleziona Stampante"
    }

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let p = dataSource[indexPath.row]

        if p.state == .connected {
            printerManager?.disconnect(p)
        } else {
            printerManager?.connect(p)
        }
    }

}

extension BluetoothPrinterSelectTableViewController: PrinterManagerDelegate {

    public func nearbyPrinterDidChange(_ change: NearbyPrinterChange) {

        tableView.beginUpdates()

        switch change {
        case let .add(p):
            let indexPath = IndexPath(row: dataSource.count, section: 0)
            dataSource.append(p)
            tableView.insertRows(at: [indexPath], with: .automatic)
        case let .update(p):
            guard let row = (dataSource.firstIndex() { $0.identifier == p.identifier } ) else {
                return
            }
            dataSource[row] = p
            let indexPath = IndexPath(row: row, section: 0)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case let .remove(identifier):
            guard let row = (dataSource.firstIndex() { $0.identifier == identifier } ) else {
                return
            }
            dataSource.remove(at: row)
            let indexPath = IndexPath(row: row, section: 0)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }

        tableView.endUpdates()
    }
}
