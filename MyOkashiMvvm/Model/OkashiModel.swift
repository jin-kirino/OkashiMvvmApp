//
//  OkashiModel.swift
//  MyOkashiMvvm
//
//  Created by 神　樹里乃 on 2022/07/15.
//

import Foundation
import UIKit

class OkashiModel {
    // JSONのデータ構造
    struct ResultJson: Codable {
        // JSONのitem内のデータ構造、たくさんあるうちの３つを選出
        struct Item: Codable {
            // nilを許すオプショナル型
            // お菓子の名称
            let name: String?
            // お菓子のURL
            let url: URL?
            // お菓子の画像
            let image: URL?
        }// Item
        // 上の３つの情報を配列に格納する
        let item: [Item]?
    }// ResultJson

    // webAPI検索用のメソッド　引数：検索したいキーワード(inputText)
    func serchOkashi(keyword: String) {
        // デバックにinputTextを出力
        print(keyword)
        
        // お菓子の検索キーワードをURLエンコードする→半角英数字に変換
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            // アンラップに失敗したら
            return
        }
        
        // リクエストURLを組み立て(半角英数字に変換したものを\(keyword_encode)に代入)
        guard let req_url = URL(string: "https://sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r") else {
            // アンラップに失敗したら
            return
        }
        
        print(req_url)
        
        // リクエストに必要な情報を生成、引数：req_url
        let req = URLRequest(url: req_url)
        // データの転送を管理するセッション=サーバとの開始から終了のこと
        // 1.デフォルトの構成　2.データダウンロード後のデータ取り出し（今回はクロージャだからnilを指定 3.画面の更新はmainスレッド,OperationQueueは非同期処理ができる
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        // 1.リクエストに必要な情報をパラメータに引き渡し 2.completionHandler:データのダウンロードが終了した時に実行したいコード
        let task = session.dataTask(with: req, completionHandler: {
            // JSONダウンロード後のデータを格納,通信状態の情報,失敗時のエラー内容を格納
            (data, response, error) in
            // セッション終了
            session.finishTasksAndInvalidate()
            // 例外処理do,try,catch
            // do行いたい処理
            do {
                // JSON Decoderのインスタンス
                let decoder = JSONDecoder()
                // 受け取ったJSONデータを解析してデコード、定数ResultJsonに格納
                let json = try decoder.decode(ResultJson.self, from: data!)
                
                // データが存在すればitemsに格納
                if let items = json.item {
                    // okashiLostのデータを初期化（前回検索データが保持されているため.removwAll())
                    // classのcompletionHandlerの{}内の動き、selfをつけて循環参照を回避
//                    self.okashiList.removeAll()
                    //
                    for item in items {
                        // お菓子のname,掲載URL,画像をアンラップ
                        // カンマで区切る、３つ全部あることが確認できたら
                        if let name = item.name,
                           let link = item.url,
                           let imageUrl = item.image,
                           let imageData = try? Data(contentsOf: imageUrl),
                           // withRenderingModeオリジナルの画像として保持
                           let image = UIImage(data: imageData)?.withRenderingMode(.alwaysOriginal) {
                            
                            // １つのお菓子の情報をokashiに入れて構造体でまとめて管理
                            let okashi = OkashiItem(name: name, link: link, image: image)
                            // okashiList配列に追加
//                            self.okashiList.append(okashi)
                            
                        }// let image
                    }// for in
                }// if let
//                print(self.okashiList)
            // catch doでエラーが出たとき
            } catch {
                // エラー処理
                print("エラーが発生しました")
            }// catch
        })// task
        // ダウンロードの処理が開始→完了したらcompletionHandler{}の中身が実行される
        task.resume()
    }// serchOkashi
}// OkashiModel

// ViewとModelは直接受け渡しできないルール→エンコードしてリクエストしてデコードするsearchOkashiメソッドの引数はどうすれば良いのか？
// 「Cannot convert value of type 'UIImage' to expected argument type 'URL'（タイプ 'UIImage' の値を期待される引数タイプ 'URL' に変換できません。）」
