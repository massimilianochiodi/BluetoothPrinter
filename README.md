
# ESC/POS Printer Driver per Swift

# Descrizione
Swift ticket printer framework per stampanti termiche compatibili con ESC/POS

### Caratteristiche
* Connessione a stampanti bluetooth generiche con ESC/POS
* Crea con semplicità uno scontrino.

## Requisiti
* iOS 12.0 + 
* Swift 5.0

## Installazione
### Swift Package Manager
File -> Add Package -> Enter Package URL 
```
https://github.com/massimilianochiodi/BluetoothPrinter
```

## Getting Started
### Import

```swift
import BluetoothPrinter

  /// Esempio per la stampa di uno scontrino semplice :

    var scontrino = Scontrino(
	    .image(image, attributes: .alignment(.center)),
	    .titolo("Nexid S.r.l."),
	    .testonormale("Via Fabio Filzi Milano"),
	    .testonormale("373 7316141"),
	    .testonormale("info@nexid.it"),
	    .vuoto,
	    .divisore,
	    .testo(.init(content: Date().description, predefined: .alignment(.center))),
	    .vuoto,
	    .testoincolonna(k: "Pomodori Pelati", v: "€ 0,92"),
	    .testoincolonna(k: "Capperi", v: "€ 1,22"),
	    .testoincolonna(k: "Acciughe", v: "€ 2,92"),
	    .testoincolonna(k: "Taleggio 1,22h", v: "€ 4,52"),
	    .divisore,
	    .testoincolonna(k: "ID transazione:", v: "32423000321"),
	    .testonormale("Vendita"),
	    .testoincolonna(k: "Sub Totale", v: "€ 9,58"),
	    .testoincolonna(k: "Shopper", v: "€ 0,10"),
	    .divisore,
	    .testoincolonnagrassetto(k: "Totale", v: "€ 9,68",attributi: [Testo.AttributiPredefiniti.bold]),
	    .vuoto(1),
	    BloccoDati(Testo(content: "Pagato con carta", predefined: .alignment(.center))),
	    .vuoto(1),    
	    BloccoDati(Testo(content: "Grazie per l'acquisto", predefined: .alignment(.center))),
	    .vuoto,
	    .qr("https://www.nexid.it")
    )
    
    scontrino.feedLinesOnHead = 1
    scontrino.feedLinesOnTail = 1
    if bluetoothPrinterManager.canPrint {
	    bluetoothPrinterManager.stampa(scontrino)
    }
    
    stampantedummy.stampa(scontrino)
```
