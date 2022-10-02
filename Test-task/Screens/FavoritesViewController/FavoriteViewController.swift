//
//  FavoriteViewController.swift
//  Test-task
//
//  Created by zz on 02.10.2022.
//

import UIKit

class FavoriteViewController: UIViewController {
    private var tableView: UITableView?
    private var presenter: FavoriteViewPresenter?
    private var mainTabBar: MainTabBarView {
        return (self.tabBarController as? MainTabBarView) ?? MainTabBarView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        initPresenter()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupTabBar(mainTabBar, alphaValue: 1)
        self.presenter?.fetchData()
    }
}

private extension FavoriteViewController {
    private func setupView() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Favourites"
        self.view.backgroundColor = .white
    }

    private func setupTableView() {
        let size = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        tableView = UITableView(frame: CGRect(origin: .zero, size: size))
        tableView?.backgroundColor = .clear
        tableView?.register(FavouriteTableViewCell.self,
                            forCellReuseIdentifier: FavouriteTableViewCell.reuseID)
        tableView?.delegate = self
        tableView?.tableFooterView = UIView()
        tableView?.dataSource = self
        self.view.addSubview(tableView ?? UITableView())
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.data.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteTableViewCell.reuseID,
                                                 for: indexPath) as? FavouriteTableViewCell
        cell?.configure(value: presenter?.data[indexPath.row])
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(DetailViewController(fromTableView: true,
                                                                           loadedData: presenter?.data[indexPath.row]
                                                                            ?? LoadedData()),
                                                      animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightTableViewRow
    }

    // swiftlint:disable all
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .destructive, title: "Delete",
                                              handler: { (_: UIContextualAction,
                                                          _: UIView,
                                                          success: (Bool) -> Void) in
                                                CoreDataService.standart.delete(id: self.presenter?.data[indexPath.row].uuid ?? UUID())
                                                self.presenter?.fetchData()
                                                success(true)
                                              })
        modifyAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    // swiftlint:enable all
}

extension FavoriteViewController: FavouriteViewDelegate {

    private func initPresenter() {
        self.presenter = FavoriteViewPresenter()
        presenter?.setDelegate(self)
    }
    func getFetchedData() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
}
