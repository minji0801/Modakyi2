//
//  ViewController.swift
//  Modakyi2
//
//  Created by 김민지 on 2023/06/25.
//

import UIKit

final class ViewController: UIViewController {
  
  // MARK: - Properties
  
  private let bonfire1 = UIImage(named: "bonfire1")
  private let bonfire2 = UIImage(named: "bonfire2")
  
  private let hillView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemGreen
    view.clipsToBounds = true
    return view
  }()
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = self.bonfire1
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  // MARK: - Init

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.startTimer()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.hillView.layer.cornerRadius = self.hillView.frame.width / 2
  }
  
  // MARK: - Setup
  
  private func setup() {
    self.view.backgroundColor = .systemBlue
    
    [self.hillView, self.imageView].forEach {
      self.view.addSubview($0)
    }
    
    self.hillView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.view.snp.centerY)
      make.width.height.equalTo(self.view.frame.width * 2)
    }
    
    self.imageView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.height.equalTo(100)
    }
  }
  
  // MARK: - Functions
  
  private func startTimer() {
    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
      self.imageView.image = self.imageView.image == self.bonfire1 ? self.bonfire2 : self.bonfire1
    }
  }
}

