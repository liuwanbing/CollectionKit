//
//  HeaderExampleViewController.swift
//  CollectionKitExample
//
//  Created by Luke Zhao on 2018-06-09.
//  Copyright © 2018 lkzhao. All rights reserved.
//

import UIKit
import CollectionKit

class HeaderExampleViewController: CollectionViewController {

  let toggleButton: UIButton = {
    let button = UIButton()
    button.setTitle("Toggle Sticky Header", for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 20)
    button.backgroundColor = UIColor(hue: 0.6, saturation: 0.68, brightness: 0.98, alpha: 1)
    button.layer.shadowColor = UIColor.black.cgColor
    button.layer.shadowOffset = CGSize(width: 0, height: -12)
    button.layer.shadowRadius = 10
    button.layer.shadowOpacity = 0.1
    return button
  }()

  var headerComposer: ComposedWithHeaderProvider<UILabel>!

  override func viewDidLoad() {
    super.viewDidLoad()

    toggleButton.addTarget(self, action: #selector(toggleSticky), for: .touchUpInside)
    view.addSubview(toggleButton)

    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)

    let sections: [Provider] = (1...10).map { _ in
      return BasicProviderBuilder
        .with(data: Array(1...9))
        .with(viewUpdater: { (view: SquareView, data: Int, index: Int) in
          view.backgroundColor = UIColor(hue: CGFloat(index) / 10,
                                         saturation: 0.68, brightness: 0.98, alpha: 1)
          view.text = "\(data)"
        })
        .with(layout: FlowLayout(spacing: 10, justifyContent: .spaceAround, alignItems: .center)
          .inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)))
        .with(sizeSource: { (index, data, maxSize) -> CGSize in
          return CGSize(width: 80, height: 80)
        })
        .build()
    }

    let provider = ComposedWithHeaderProvider(
      headerViewProvider: ClosureViewSource(
        viewUpdater: { (view: UILabel, data, index) in
          view.backgroundColor = UIColor.darkGray
          view.textColor = .white
          view.textAlignment = .center
          view.text = "Header \(data.index)"
      }),
      headerSizeProvider: { (index, data, maxSize) -> CGSize in
        return CGSize(width: maxSize.width, height: 40)
      },
      sections: sections
    )

    self.headerComposer = provider
    self.provider = provider
  }

  @objc func toggleSticky() {
    headerComposer.isSticky = !headerComposer.isSticky
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    toggleButton.frame = CGRect(x: 0, y: view.bounds.height - 44, width: view.bounds.width, height: 44)
  }
}