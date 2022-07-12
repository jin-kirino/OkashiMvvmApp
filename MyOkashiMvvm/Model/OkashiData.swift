//
//  Model.swift
//  MyOkashiMvvm
//
//  Created by 神　樹里乃 on 2022/07/09.
//

import Foundation
import UIKit

// Identifiableプロトコルを利用して、お菓子の情報をまとめる構造体
struct OkashiItem: Identifiable {
    let id = UUID()
    let name: String
    let link: URL
    let image: URL
}


