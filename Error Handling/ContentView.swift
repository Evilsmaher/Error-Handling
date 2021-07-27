//
//  ContentView.swift
//  Error Handling
//
//  Created by Bradley French on 7/26/21.
//

import SwiftUI

struct ContentView: View {
    @State var money: Double = 0.0
    var items:[[String]] = [["KitKat",
                          "Reeses PB Cup",
                          "Chocolate Bar"],
                          ["Jolly Rancher",
                          "Skittles",
                          "Snickers"],
                          ["Gum",
                          "Wonka Bar",
                          "Laffy Taffy"]]
    var prices:[[Double]] = [[1.00,
                              0.50,
                              1.50],
                              [0.25,
                              1.25,
                              2.00],
                              [0.25,
                              3.00,
                              0.75
                            ]]
    
    @State var currentPrice: Double = 0.0
    @State var currentSelection: String = ""
    
    @State var outputString: String = ""
    
    var body: some View {
        VStack {
            Text("Codecademy Vending Machine")

            Form {
                HStack {
                    Text("Insert Money:")
                    TextField("", value: $money, formatter: Formatter.moneyFormatter())
                }
            }
            .frame(width: .infinity, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            VStack {
                ForEach(0..<3, id: \.self) { row in
                    HStack {
                        ForEach(items[row].indices, id: \.self) { column in
                            VStack {
                                Button(action: {
                                    print("Current Selection: \(items[row][column])")
                                    currentSelection = items[row][column]
                                    print("Price Tapped: \(prices[row][column])")
                                    currentPrice = prices[row][column]
                                }) {
                                    Text("\(items[row][column])\n$\(prices[row][column], specifier: "%.2f")")
                                        .frame(width: 100, height: 100, alignment: .center)
                                        .background(Color.orange)
                                        .border(Color.black, width: 1)
                                        .padding(5)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.black)
                                }
                            }
                        }
                    }
                }
            }
            Button(action: {
                let sufficientFunds = (money >= currentPrice)
                let selectionHasBeenMade = currentSelection != ""
                if(!selectionHasBeenMade || !sufficientFunds) {
                    safeVend()
                }
                else {
                    forceVend()
                }
            }) {
                Text("Vend")
                    .frame(width: 350, height: 100, alignment: .center)
                    .background(Color.green)
                    .foregroundColor(Color.black)
                    .border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            }
            Text("""
                Output:
                \(outputString)
                """)
                .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
    
    func forceVend() {
        print("Force Vending")
        try! vend()
    }
    
    func safeVend() {
        print("Safe Vending")
        do {
            try vend()
        }
        catch VendingMachineError.insufficientFunds(moneyNeeded: let moneyNeeded) {
            outputString = "Insufficient Funds. You need another $\(String(format: "%.2f", moneyNeeded)) to complete the transaction."
        }
        catch VendingMachineError.noSelection {
            outputString = "You have no selected any candy. Choose one!"
        }
        catch {
            outputString = "Unexpected Error: \(error)"
        }
    }
    
    func vend() throws {
        let price = String(format: "$%.2f", currentPrice)
        
        guard money >= currentPrice else {
            throw VendingMachineError.insufficientFunds(moneyNeeded: currentPrice-money)
        }
        
        guard currentSelection != "" else {
            throw VendingMachineError.noSelection
        }
        
        outputString = "Current Selection: \(currentSelection)\nCurrent Price: \(price)\nError: None"
    }
}

enum VendingMachineError: Error {
    case noSelection
    case insufficientFunds(moneyNeeded: Double)
}

extension Formatter {
    static func moneyFormatter() -> Formatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
