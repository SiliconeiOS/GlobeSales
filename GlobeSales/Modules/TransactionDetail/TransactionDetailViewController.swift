//
//  TransactionDetailViewController.swift
//  GlobeSales
//
//  Created by Иван Дроботов on 7/13/25.
//

import UIKit

protocol TransactionDetailViewProtocol: AnyObject {
    func display(viewModel: TransactionDetailViewModel)
    func setTitle(_ title: String)
}

final class TransactionDetailViewController: UIViewController, TransactionDetailViewProtocol {

    private let presenter: TransactionDetailPresenterProtocol
    private lazy var customView = TransactionDetailView()

    init(presenter: TransactionDetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        presenter.viewDidLoad()
    }

    func display(viewModel: TransactionDetailViewModel) {
        customView.display(viewModel: viewModel)
    }
    
    func setTitle(_ title: String) {
        self.title = title
    }
}
