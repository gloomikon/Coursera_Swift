//
//  RadioViewController.swift
//  Course2Week4Task1
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class RadioViewController: UIViewController {
    // MARK: - UIElements

  private let songImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "albumImage"))
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  private lazy var songTitleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Aerosmith - Hole In My Sole"
    label.font = .systemFont(ofSize: 22)
    label.sizeToFit()
    label.textColor = .black
    label.numberOfLines = 1
    label.textAlignment = .center
    return label
  }()

  private let songProgressView: UIProgressView = {
    let progressView = UIProgressView()
    progressView.translatesAutoresizingMaskIntoConstraints = false
    progressView.progress = 0.5
    return progressView
  }()

  private let radioSlider: UISlider = {
    let slider = UISlider()
    slider.translatesAutoresizingMaskIntoConstraints = false
    slider.value = 0.5
    return slider
  }()

    // MARK: - Layout constraints

  let layoutGuide = UILayoutGuide()

  lazy var regularHeightConstraints: [NSLayoutConstraint] = [
        songProgressView.topAnchor.constraint(equalTo: songImageView.bottomAnchor, constant: 30),
        songProgressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        songProgressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

        songImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
        songImageView.widthAnchor.constraint(equalTo: songImageView.heightAnchor, multiplier: 1/1),
        songImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        songImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

        layoutGuide.topAnchor.constraint(equalTo: songProgressView.bottomAnchor),
        layoutGuide.bottomAnchor.constraint(equalTo: radioSlider.topAnchor),

        songTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        songTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        songTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
        songTitleLabel.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor),

        radioSlider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        radioSlider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        radioSlider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        radioSlider.heightAnchor.constraint(equalToConstant: 31)
      ]

  lazy var compactHeightConstrants: [NSLayoutConstraint] = [
        songProgressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
        songProgressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        songProgressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        songProgressView.bottomAnchor.constraint(equalTo: songImageView.topAnchor, constant: -16),
        songProgressView.heightAnchor.constraint(equalToConstant: 2),

        songImageView.bottomAnchor.constraint(equalTo: radioSlider.topAnchor, constant: -16),
        songImageView.trailingAnchor.constraint(equalTo: songTitleLabel.leadingAnchor, constant: 16),
        songImageView.widthAnchor.constraint(equalTo: songImageView.heightAnchor, multiplier: 1/1),
        songImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),

        layoutGuide.topAnchor.constraint(equalTo: songProgressView.bottomAnchor),
        layoutGuide.bottomAnchor.constraint(equalTo: radioSlider.topAnchor),

        songTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        songTitleLabel.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor),

        radioSlider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        radioSlider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        radioSlider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        radioSlider.heightAnchor.constraint(equalToConstant: 31)
      ]

    // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = .white
    view.addSubview(songProgressView)
    view.addSubview(songImageView)
    view.addSubview(songTitleLabel)
    view.addSubview(radioSlider)
    view.addLayoutGuide(layoutGuide)

    activateConstraints()
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    activateConstraints()
  }

    private func activateConstraints() {
        if view.traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.deactivate(compactHeightConstrants)
            NSLayoutConstraint.activate(regularHeightConstraints)
        } else {
            NSLayoutConstraint.deactivate(regularHeightConstraints)
            NSLayoutConstraint.activate(compactHeightConstrants)
        }
    }
}
