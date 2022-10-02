//
//  ListViewController.swift
//  Test-task
//
//  Created by zz on 02.10.2022.
//

import UIKit

class ListViewController: UIViewController {
    // MARK: - Private properties
    private var collectionView: UICollectionView?
    private var presenter: ListViewPresenter?
    private let searchBar = UISearchBar()
    
    private var mainTabBar: MainTabBarView {
        return (self.tabBarController as? MainTabBarView) ?? MainTabBarView()
    }
    // MARK: - Internal properties
    var dataSource: UICollectionViewDiffableDataSource<Section, LoadedData>?
    var snapShot = NSDiffableDataSourceSnapshot<Section, LoadedData>()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        setupView()
        setupCollectionView()
        setupCollectionViewDataSource()
        presenter?.setVC(self)
        presenter?.fetchFirstLaunchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupTabBar(mainTabBar, alphaValue: 1)
    }
}

// MARK: - Setup View
extension ListViewController: ListViewDelegate {
    func showDetailVC(_ data: LoadedData) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(
                DetailViewController(fromTableView: false,
                                     loadedData: data), animated: true)
        }
    }
    
    private func initPresenter() {
        self.presenter = ListViewPresenter()
        self.presenter?.setDelegate(self)
    }
}

// MARK: - Setup UI
extension ListViewController: UISearchBarDelegate {
    private func setupView() {
        self.view.backgroundColor = .white
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.addDoneButtonOnKeyboard()
        navigationItem.titleView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        guard textSearched.isEmpty else {
            presenter?.fetchQuerySearch(textSearched)
            return
        }
        presenter?.fetchFirstLaunchData()
        DispatchQueue.main.async {
            searchBar.searchTextField.resignFirstResponder()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.resignFirstResponder()
    }
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, LoadedData> {
        return NSDiffableDataSourceSnapshot<Section, LoadedData>()
    }
}

// MARK: - Setup Collection View
extension ListViewController: UICollectionViewDelegate {
    
    private func setupCollectionView() {
        let size = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        collectionView = UICollectionView(frame: CGRect(origin: .zero, size: size),
                                          collectionViewLayout: setupCompositionalLayout())
        collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView?.backgroundColor = .clear
        collectionView?.register(CollectionViewDataCell.self,
                                 forCellWithReuseIdentifier: CollectionViewDataCell.reuseID)
        view.addSubview(collectionView ?? UICollectionView())
        collectionView?.delegate = self
    }
    
    private func setupCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) ->
            NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex)
            else { fatalError("Unknown section") }
            switch section {
            case .list:
                return self.setupLayout()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
        
    }
    
    private func setupLayout() -> NSCollectionLayoutSection {
        // itemSize -> item -> groupSize -> groups -> section
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 2)
        group.interItemSpacing = .fixed(Constants.insetValue)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.insetValue
        section.contentInsets = NSDirectionalEdgeInsets(top: Constants.insetValue,
                                                        leading: Constants.insetValue,
                                                        bottom: Constants.insetValue,
                                                        trailing: Constants.insetValue)
        return section
    }
    
    private func setupCollectionViewDataSource() {
        // swiftlint:disable all
        dataSource = UICollectionViewDiffableDataSource<Section,
                                                        LoadedData>(collectionView:
                                                                        collectionView ?? UICollectionView()) {
            (collectionView, indexPath, data) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .list:
                return self.configureCell(collectionView: collectionView, cellType: CollectionViewDataCell.self,
                                          model: data,
                                          indexPath: indexPath)
            }
        }
    }
    // swiftlint:enable all
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.showDetailVC(indexPath: indexPath.row)
    }
}
