//
//  ViewController.swift
//  GlobeSales
//
//  Created by Иван Дроботов on 7/7/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        let formatter = CurrencyFormatter()
        let value: Double = 30.20
        let currencyCode = "USD"
        
        // When
        let formattedString = formatter.getCurrencyFormat(value: value, currencyCode: currencyCode)
        print(formattedString)
    }
}

private extension String {
    static var rates: String { "rates" }
}
