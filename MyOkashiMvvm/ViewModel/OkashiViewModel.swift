//
//  ViewModel.swift
//  MyOkashiMvvm
//
//  Created by 神　樹里乃 on 2022/07/09.
//

import Foundation

// UIImageを利用するため
import UIKit

// お菓子データ検索用クラス
// ObservableObjectはclassのみ使用可能
// パブリッシャー
class OkashiData: ObservableObject {

    // プロパティserchOkashiを監視してOkashiData（ObservableObject）へ自動通知
    @Published var okashiList: [OkashiItem] = []
    
    // Web API検索用メソッド　第一引数：検索したいキーワード(inputText)
    // asyncでsearchOkashiを非同期で実行したい
    func okashiData(keyword: String) async {
        // OkashiModelをインスタンス化
        let okashiModel = OkashiModel()
        // @Publishedの変数を更新するときはメインスレッドで更新する必要がある
        DispatchQueue.main.async {
            // okashiLostのデータを初期化（前回検索データが保持されているため.removwAll())
            self.okashiList.removeAll()
            print("remove:\(self.okashiList)")
            
        }// DispatchQueue
        // serchOkashiメソッドを呼び出し
        self.okashiList = await okashiModel.searchOkashi(keyword: keyword)
        print("append:\(self.okashiList)")
    }// seachOkashi
}// OkashiData



// メールアドレス妥当性チェック
// 半角・全角チェック
// 未入力チェック
// Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
// バックグラウンドスレッドからの変更の発行は許可されていません。モデルの更新時には、必ずメインスレッドから(receive(on:) のような演算子を使って) 値を発行するようにしてください。
