//
//  OkashiModel.swift
//  MyOkashiMvvm
//
//  Created by 神　樹里乃 on 2022/07/15.
//

import Foundation
// UIImageを利用するため
import UIKit

class OkashiModel {
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
    
    // webAPI検索用のメソッド　引数：検索したいキーワード(inputText)
    // async(エィシンク)でsearchOkashiを非同期で実行したい
    // Web API検索用メソッド　第一引数：keyword 検索したいワード
    func searchOkashi(keyword: String) async -> [OkashiItem] {
        var okashiList: [OkashiItem] = []
        // デバッグエリアに出力
        print(keyword)
        
        // お菓子の検索キーワードをURLエンコードする→半角英数字に変換
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            // アンラップに失敗したら
            return okashiList
        }// keyword_encode
        
        // リクエストURLの組み立て(半角英数字に変換したものを\(keyword_encode)に代入)
        guard let req_url = URL(string: "https://sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r") else {
            // アンラップに失敗したら
            return okashiList
        }// req_url
        print(req_url)
        
        do {
            // リクエストURLからダウンロード
            // await 待機状態（acyncと一対）
            let (data , _) = try await URLSession.shared.data(from: req_url)
            // JSONDecoderのインスタンス取得
            let decoder = JSONDecoder()
            // デコード、受け取ったJSONデータをパース（解析）して格納
            let json = try decoder.decode(ResultJson.self, from: data)
            // お菓子の情報が取得できているか確認,items:[OkashiModel.ResultJson.Item]
            guard let items = json.item else {
                return okashiList
            }
            // 取得しているお菓子の数だけ処理
            for item in items {
                // お菓子の名称、掲載URL、画像URLをアンラップ
                if let name = item.name,
                   let link = item.url,
                   let image = item.image {
                    // 1つのお菓子を構造体OkashiItemでまとめて管理
                    let okashi = OkashiItem(name: name, link: link, image: image)
                    okashiList.append(okashi)
                }// if let
            }// for item in items
        } catch {
            // エラー処理
            print("エラーが出ました")
        }// catch
        return okashiList
    }// searchOkashi
}// OkashiModel


// 1 ViewとModelは直接受け渡しできないルール→エンコードしてリクエストしてデコードするsearchOkashiメソッドの引数はどうすれば良いのか？
// ViewからViewModel、ViewModelからModel
// 2「Cannot convert value of type 'UIImage' to expected argument type 'URL'（タイプ 'UIImage' の値を期待される引数タイプ 'URL' に変換できません。）」
// OkashiItemのimageをUIImageに変換→上のokashiでは通ったが、OkashiViewの「AsyncImage(url: okashi.image) { image in」でエラー
// 画像はwebサーバから引っ張ってきてるからURLにしておくべき→上記の型の相違の解決策は？
