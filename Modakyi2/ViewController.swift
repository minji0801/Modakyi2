//
//  ViewController.swift
//  Modakyi2
//
//  Created by 김민지 on 2023/06/25.
//

import AVFoundation
import UIKit

final class ViewController: UIViewController {
  
  // MARK: - Properties
  
  private let soundStateStorage = SoundStateStorage.shared
  
  private lazy var soundState: SoundState = {
    return self.soundStateStorage.getSoundState()
  }()
  
  private var musicPlayer: AVAudioPlayer?
  private var effectPlayer: AVAudioPlayer?
  
  private let bonfire1 = UIImage(named: "bonfire1")
  private let bonfire2 = UIImage(named: "bonfire2")
  
  private let musicAndEffectIcon = UIImage(systemName: "speaker.wave.2.fill")
  private let onlyEffectIcon = UIImage(systemName: "speaker.wave.1.fill")
  private let soundOffIcon = UIImage(systemName: "speaker.slash.fill")
  
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
  
  private lazy var soundButton: UIButton = {
    let button = UIButton()
    button.tintColor = .white
    button.addTarget(self, action: #selector(controlSound), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Init

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.startTimer()
    self.setupMusic()
    self.setupEffect()
    self.setupSoundState()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.hillView.layer.cornerRadius = self.hillView.frame.width / 2
  }
  
  // MARK: - Setup
  
  private func setup() {
    self.view.backgroundColor = .systemBlue
    
    [self.hillView, self.imageView, self.soundButton].forEach {
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
    
    self.soundButton.snp.makeConstraints { make in
      make.top.equalTo(self.view.safeAreaLayoutGuide)
      make.leading.equalTo(self.view.safeAreaLayoutGuide).inset(10)
      make.width.height.equalTo(50)
    }
  }
  
  // MARK: - Functions
  
  private func startTimer() {
    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
      self.imageView.image = self.imageView.image == self.bonfire1 ? self.bonfire2 : self.bonfire1
    }
  }
  
  private func setupMusic() {
    let url = Bundle.main.url(forResource: "ylangylang", withExtension: "mp3")
    if let url = url {
      do {
        self.musicPlayer = try AVAudioPlayer(contentsOf: url)
        self.musicPlayer?.numberOfLoops = -1
        self.musicPlayer?.volume = 0.5
      } catch {
        print(error)
      }
    }
  }
  
  private func setupEffect() {
    let url = Bundle.main.url(forResource: "bonfire", withExtension: "mp3")
    if let url = url {
      do {
        self.effectPlayer = try AVAudioPlayer(contentsOf: url)
        self.effectPlayer?.numberOfLoops = -1
      } catch {
        print(error)
      }
    }
  }
  
  private func setupSoundState() {
    print("soundState: \(self.soundState)")
    switch self.soundState {
    case .musicAndEffect:
      self.soundButton.setImage(musicAndEffectIcon, for: .normal)
      self.musicPlayer?.play()
      self.effectPlayer?.play()
    case .onlyEffect:
      self.soundButton.setImage(onlyEffectIcon, for: .normal)
      self.musicPlayer?.pause()
      self.effectPlayer?.play()
    case .off:
      self.soundButton.setImage(soundOffIcon, for: .normal)
      self.musicPlayer?.pause()
      self.effectPlayer?.pause()
    }
  }
  
  // MARK: - Actions
  
  @objc private func controlSound() {
    switch self.soundState {
    case .musicAndEffect:
      self.soundState = .onlyEffect
    case .onlyEffect:
      self.soundState = .off
    case .off:
      self.soundState = .musicAndEffect
    }
    self.setupSoundState()
    self.soundStateStorage.setSoundState(soundState: self.soundState)
  }
}
