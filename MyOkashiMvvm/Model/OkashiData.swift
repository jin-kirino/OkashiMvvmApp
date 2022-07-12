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
    // 一意でなきゃだめ
    let id = UUID()
    let name: String
    let link: URL
    let image: URL
}// OkashiItem


do {
    // リクエストURLからダウンロード
    // リクエストに必要な情報を生成、引数：req_url
    // await 処理が終わるまで待機
    let (data , _) = try await URLSession.shared.data(from: okashiData.searchOkashi(keyword: req_url))
    
    // JSONDecoderのインスタンス取得
    let decoder = JSONDecoder()
    // 受け取ったJSONデータをパース（解析）して格納
    let json = try decoder.decode(ResultJson.self, from: data)
    
    // print(json)
    
    // お菓子の情報が取得できているか確認
    guard let items = json.item else {
        return
    }// items
    
    
// doでエラーが出た時
} catch {
    // エラー処理
    print("エラーが出ました")
}// catch
