//
//  ContentView.swift
//  MyOkashiMvvm
//
//  Created by 神　樹里乃 on 2022/07/09.
//

import SwiftUI

struct OkashiView: View {
    
    // OkashiDataを参照する状態変数
    @StateObject var okashiDataList = OkashiData()
    // 入力された文字列を保持する状態変数
    @State var inputText = ""
    // SafariViewの表示有無を管理する変数
    @State var showSafari = false
    
    var body: some View {
        // 垂直にレイアウト（縦方向にレイアウト）
        VStack {
            // 文字を受け取るTextFieldを表示する
            TextField("キーワード", text: $inputText
                      , prompt: Text("キーワードを入力してください"))
                .onSubmit {
                    // Taskは非同期で処理を実行できる
                    Task {
                        // 入力完了直後に検索をする
                        await okashiDataList.searchOkashi(keyword: inputText)
                        
                    }
                }
                // キーボードの改行を検索に変更する
                .submitLabel(.search)
                // 上下左右に空白を空ける
                .padding()
            
            // リスト表示する
            List(okashiDataList.okashiList) { okashi in
                // 1つ1つの要素を取り出す
                
                // ボタンを用意する
                Button(action: {
                    // SafariViewを表示する
                    showSafari.toggle()
                }) {
                    
                    // Listの表示内容を生成する
                    // 水平にレイアウト（横方向にレイアウト）
                    HStack {
                        // 画像を読み込み、表示する
                        AsyncImage(url: okashi.image) { image in
                            // 画像を表示する
                            image
                                // リサイズする
                                .resizable()
                                // アスペクト比（縦横比）を維持してエリア内に収まるようにする
                                .aspectRatio(contentMode: .fit)
                                // 高さ40
                                .frame(height: 40)
                            
                        } placeholder: {
                            // 読み込み中はインジケーターを表示する
                            ProgressView()
                        }
                        // テキスト表示する
                        Text(okashi.name)
                    } // HStackここまで
                    
                } // Buttonここまで
                .sheet(isPresented: $showSafari, content: {
                    // SafariViewを表示する
                    SafariView(url: okashi.link)
                        // 画面下部がセーフエリア外までいっぱいなるように指定
                        .edgesIgnoringSafeArea(.bottom)
                }) // sheetここまで
            } // Listここまで
            
        } // VStackここまで
    } // bodyここまで
} // ContentViewここまで

struct OkashiViewView_Previews: PreviewProvider {
    static var previews: some View {
        OkashiView()
    }
}
