//
//  TransactionDetailView.swift
//  GlobeSales
//
//  Created by Иван Дроботов on 7/13/25.
//

import UIKit

final class TransactionDetailView: UIView {
    
    private var viewModel: TransactionDetailViewModel?

    private let headerView = TransactionDetailHeaderView()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(TransactionDetailCell.self, forCellReuseIdentifier: TransactionDetailCell.reuseIdentifier)
        table.tableHeaderView = headerView
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func display(viewModel: TransactionDetailViewModel) {
        self.viewModel = viewModel
        headerView.configure(with: viewModel.totalAmountInGBP)
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var headerFrame = headerView.frame
        headerFrame.size.height = height
        headerView.frame = headerFrame
        
        tableView.tableHeaderView = headerView
        tableView.reloadData()
    }
    
    private func setupUI() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

extension TransactionDetailView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.transactions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionDetailCell.reuseIdentifier, for: indexPath) as? TransactionDetailCell,
              let transaction = viewModel?.transactions[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(with: transaction)
        return cell
    }
}
