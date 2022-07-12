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
    // JSONのデータ構造
    struct ResultJson: Codable {
        // JSONのitem内のデータ構造、たくさんあるうちの３つを選出
        struct Item: Codable {
            // nilを許すオプショナル型
            // お菓子の名称
            let name: String?
            // 掲載URL
            let url: URL?
            // 画像URL
            let image: URL?
        }// Item
        // 複数要素、上の３つの情報を配列に格納する
        let item: [Item]?
    }// ResultJSON
    
    //構造体OkashiItemを配列としてまとめる
    // お菓子のリスト（Identifiableプロトコル）
    // プロパティserchOkashiを監視してOkashiData（ObservableObject）へ自動通知
    @Published var okashiList: [OkashiItem] = []
    
    // Web API検索用メソッド　第一引数：検索したいキーワード(inputText)
    // asyncでsearchOkashiを非同期で実行したい
    func searchOkashi(keyword: String) async {
        // デバッグエリアに出力
        print(keyword)
        
        // お菓子の検索キーワードをURLエンコードする→半角英数字に変換
        // nilだったら即return
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            return
        }// keyword_encode

        // リクエストURLを組み立て(半角英数字に変換したものを\(keyword_encode)に代入)
        // nilだったら即return
        guard let req_url = URL(string: "https://sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r") else {
            // アンラップに失敗
            return
        }// req_url
        print(req_url)
        
        // @Publishedの変数を更新するときはメインスレッドで更新する必要がある
        DispatchQueue.main.async {
            // okashiLostのデータを初期化（前回検索データが保持されているため.removwAll())
            // classのcompletionHandlerの{}内の動き、selfをつけて循環参照を回避
            self.okashiList.removeAll()

            // 取得しているお菓子の数だけ処理
            for item in items {
                // お菓子の名称、掲載URL、画像URLをアンラップ
                if let name = item.name,
                   let link = item.url,
                   let image = item.image {
                    // １つのお菓子の情報をokashiに入れて構造体でまとめて管理
                    let okashi = OkashiItem(name: name, link: link, image: image)
                    // お菓子の配列okashiListへ追加
                    self.okashiList.append(okashi)
                }// name,link,image
            }// for item in items
            print(self.okashiList)
        }// DispatchQueue
    }// seachOkashi
}// OkashiData



// メールアドレス妥当性チェック
// 半角・全角チェック
// 見入力チェック
