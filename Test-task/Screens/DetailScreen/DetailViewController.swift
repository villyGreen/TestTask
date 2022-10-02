//
//  DetailViewController.swift
//  Test-task
//
//  Created by zz on 02.10.2022.
//

import UIKit

class DetailViewController: UIViewController {
    private let previewImageView = UIImageView()
    private let nameAuthorLabel = UILabel()
    private let dateCreateLabel = UILabel()
    private let locationLabel = UILabel()
    private let countOfDownloadsLabel = UILabel()
    private var barButton: UIBarButtonItem?
    private var downloadButton = UIButton(type: .system)

    private var mainTabBar: MainTabBarView {
        return (self.tabBarController as? MainTabBarView) ?? MainTabBarView()
    }
    private var loadedData: LoadedData?
    private var presenter: DetailViewPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        initPresenter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupTabBar(self.mainTabBar, alphaValue: 0)
        checkID()
    }

    convenience init(fromTableView: Bool, loadedData: LoadedData) {
        self.init()
        self.loadedData = loadedData
        setupView()
        guard fromTableView else {
            return
        }
        self.navigationItem.rightBarButtonItem = nil
        self.previewImageView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor,
                                                   constant: 0).isActive = true
        self.view.setNeedsLayout()
    }

    private func checkID() {
        self.presenter?.containsId(loadedData?.uuid.uuidString ?? "",
                                   completion: { success in
                                    guard success else { return }
                                    self.navigationItem.rightBarButtonItem = nil
                                   })
    }
}

private extension DetailViewController {
    private func setupView() {
        self.view.backgroundColor = .white
        setupImageView()
        setupLabels()
    }

    private func initPresenter() {
        self.presenter = DetailViewPresenter()
    }

    private func setupImageView() {
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.clipsToBounds = true
        previewImageView.layer.cornerRadius = 10
        previewImageView.backgroundColor = .systemFill
        previewImageView.downloadImage(loadedData?.url ?? "")
        self.view.addSubview(previewImageView)
        previewImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.previewImageView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor,
                                                       constant: Constants.defaultValue),
            self.previewImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.previewImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25),
            self.previewImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                           constant: Constants.defaultValue),
            self.previewImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                            constant: -Constants.defaultValue)
        ])
    }

    private func setupNavigationBar() {
        barButton = UIBarButtonItem(barButtonSystemItem: .add,
                                    target: self, action: #selector(addToFavorite))
        self.navigationItem.rightBarButtonItem = barButton
    }

    @objc
    private func addToFavorite() {
        self.showAlert(title: "Added", message: "Current image was added to your list",
                       actionTitle: "Ok",
                       isCancelButton: false,
                       completion: { success in
                        guard success else { return }
                        self.navigationItem.rightBarButtonItem = nil
                        self.presenter?.saveDataToStorage(self.loadedData ?? LoadedData())
                       })
    }

    @objc
    private func downloadImage() {
        UIImageWriteToSavedPhotosAlbum(previewImageView.image ?? UIImage(),
                                       self, #selector(saveCompleted),
                                       nil)
    }

    @objc
    func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        self.showAlert(title: "Success",
                       message: "Image was success load to library",
                       actionTitle: "Ok",
                       isCancelButton: false) { _ in
        }
    }
    private func setupLabels() {
        let labels = [nameAuthorLabel, dateCreateLabel,
                      locationLabel, countOfDownloadsLabel]
        labels.forEach { label in
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Label"
            label.numberOfLines = 0
        }
        let labelsStackView = UIStackView(arrangedSubviews: labels)
        labelsStackView.axis = .vertical
        labelsStackView.alignment = .leading
        labelsStackView.spacing = Constants.defaultValue
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(labelsStackView)
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.tintColor = .systemBlue
        downloadButton.setTitleColor(.systemRed, for: .normal)
        downloadButton.addTarget(self, action: #selector(downloadImage), for: .touchUpInside)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(downloadButton)
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: self.previewImageView.bottomAnchor,
                                                 constant: Constants.defaultValue),
            labelsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                     constant: Constants.defaultValue * 2),
            labelsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                      constant: Constants.defaultValue),
            downloadButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                                   constant: -Constants.defaultValue),
            downloadButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                    constant: Constants.defaultValue),
            downloadButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                     constant: -Constants.defaultValue),
            downloadButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        fillLabels()
    }

    private func fillLabels() {
        DispatchQueue.main.async {
            self.nameAuthorLabel.text = "Name of Author: \(self.loadedData?.nameAuthor ?? "No author")"
            self.dateCreateLabel.text = "Date of Create: \(self.loadedData?.dateCreate ?? "")"
            self.locationLabel.text = "Location: \(self.loadedData?.location ?? "No Location")"
            self.countOfDownloadsLabel.text = "Count of Downloads: \(self.loadedData?.countOfDownloads ?? 0)"
            guard self.loadedData?.countOfDownloads == nil || self.loadedData?.countOfDownloads == 0 else { return }
            self.countOfDownloadsLabel.isHidden = true
        }
    }
}
