//
//  ProductListModels.swift
//  GlobeSales
//
//  Created by Иван Дроботов on 7/13/25.
//

struct ProductCellViewModel {
    let sku: String
    let transactionCount: String
}

struct ProductListViewModel {
    let products: [ProductCellViewModel]
}
