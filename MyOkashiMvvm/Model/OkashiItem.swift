//
//  Model.swift
//  MyOkashiMvvm
//
//  Created by 神　樹里乃 on 2022/07/09.
//

import Foundation

struct OkashiItem: Identifiable {
    // 一意でなきゃだめ
    let id = UUID()
    let name: String
    let link: URL
    let image: URL
}// OkashiItem



