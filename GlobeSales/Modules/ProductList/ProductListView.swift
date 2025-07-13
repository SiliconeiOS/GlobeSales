//
//  ProductListView.swift
//  GlobeSales
//
//  Created by Иван Дроботов on 7/13/25.
//

import UIKit

final class ProductListView: UIView {
    
    private let presenter: ProductListPresenterProtocol
    private var viewModel: ProductListViewModel?
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    init(presenter: ProductListPresenterProtocol) {
        self.presenter = presenter
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        tableView.register(ProductListCell.self, forCellReuseIdentifier: ProductListCell.reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func display(viewModel: ProductListViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
    
    private func setupUI() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

extension ProductListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductListCell.reuseIdentifier, for: indexPath) as? ProductListCell,
              let product = viewModel?.products[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(with: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectProduct(at: indexPath.row)
    }
}
