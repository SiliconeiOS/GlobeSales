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
        let transactionServise = TransactionService()
        let transactions = transactionServise.loadTransactionsSafely()
        print(transactions.count)
        print(transactions[0].currency)
        let rateService = RateService()
        let rates = rateService.loadRatesSafely()
        print(rates.count)
        print(rates[0].from)
    }
}

