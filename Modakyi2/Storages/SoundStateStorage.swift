//
//  SoundStateStorage.swift
//  Modakyi2
//
//  Created by 김민지 on 2023/06/26.
//

import Foundation

enum SoundState: Int {
  case musicAndEffect
  case onlyEffect
  case off
}

class SoundStateStorage {
  static let shared = SoundStateStorage()
  
  private let userDefaults = UserDefaults.standard
  private let key = "SoundState"
  
  func getSoundState() -> SoundState {
    let rawValue = self.userDefaults.integer(forKey: key)
    print("soundGet: \(rawValue)")
    return SoundState(rawValue: rawValue) ?? .musicAndEffect
  }
  
  func setSoundState(soundState: SoundState) {
    print("soundSave: \(soundState.rawValue)")
    self.userDefaults.setValue(soundState.rawValue, forKey: key)
  }
}
