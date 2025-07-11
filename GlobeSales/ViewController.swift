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
        let fileReader = FileReaderService()
        let rates = fileReader.loadSafely(RateDataModel.self, from: .rates)
        print(rates.count)
        print(rates[0])
    }
}

private extension String {
    static var rates: String { "rates" }
}
