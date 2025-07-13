//
//  ViewController.swift
//  GlobeSales
//
//  Created by Иван Дроботов on 7/7/25.
//

import UIKit

protocol ProductListViewProtocol: AnyObject {
    func display(viewModel: ProductListViewModel)
}

final class ProductListViewController: UIViewController, ProductListViewProtocol {
    
    private let presenter: ProductListPresenterProtocol
    private lazy var customView = ProductListView(presenter: presenter)
    
    init(presenter: ProductListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products"
        navigationController?.navigationBar.prefersLargeTitles = true
        presenter.viewDidLoad()
    }
    
    func display(viewModel: ProductListViewModel) {
        customView.display(viewModel: viewModel)
    }
}
