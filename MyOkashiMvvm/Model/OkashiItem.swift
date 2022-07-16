//
//  Model.swift
//  MyOkashiMvvm
//
//  Created by 神　樹里乃 on 2022/07/09.
//

import Foundation
import UIKit

//構造体OkashiItemを配列としてまとめる
// お菓子のリスト（Identifiableプロトコル）
struct OkashiItem: Identifiable {
    // 一意でなきゃだめ
    let id = UUID()
    let name: String
    let link: URL
    let image: URL
}// OkashiItem
