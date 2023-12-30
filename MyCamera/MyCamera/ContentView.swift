//
//  ContentView.swift
//  MyCamera
//
//  Created by 飯塚 秀幸 on 2023/12/29.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    //撮影した写真を保持する状態変数
    @State var captureImage: UIImage? = nil
    //撮影画面（sheet）の開閉状態を管理
    @State var isShowSheet = false
    //フォトライブラリーで選択した写真を管理
    @State var photoPickerSelectedImage: PhotosPickerItem? = nil

    var body: some View {
        VStack {
            //スペース追加
            Spacer()
            //撮影した写真がある時
            if let captureImage{
                //撮影写真を表示
                Image(uiImage: captureImage)
                //リサイズ
                    .resizable()
                //アスペクト比
                    .scaledToFit()
            }
            //スペース追加
            Spacer()
            //「カメラを起動する」ボタン
            Button{
                //ボタンをタップした時のアクション
                //カメラが利用可能かチェック
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    print("カメラは利用できます")
                    //カメラが使えるなら、isShowSheetをtrue
                    isShowSheet.toggle()
                } else {
                    print("カメラは利用できません")
                }
            } label: {
                //テキスト表示
                Text("カメラを起動する")
                //横幅いっぱい
                    .frame(maxWidth: .infinity)
                //高さ５０ポイントを指定
                    .frame(height: 50)
                //文字列をセンタリング指定
                    .multilineTextAlignment(.center)
                //背景を青色に指定
                    .background(Color.blue)
                //文字色を白色に指定
                    .foregroundStyle(Color.white)
            }//カメラを起動するボタンはここまで
            //上下左右に余白を追加
            .padding()
            //sheetを表示
            //isPresentedで指定した状態変数がtrueの時に実行
            .sheet(isPresented: $isShowSheet){
                //UIImagePickerController（写真撮影）を表示
                ImagePickerView(isShowSheet: $isShowSheet, captureImage: $captureImage)
            }//『カメラを起動する』ボタンのsheetここまで

            //フォトライブラリーから写真を選択して使用する
            PhotosPicker(selection: $photoPickerSelectedImage, matching: .images, preferredItemEncoding: .automatic, photoLibrary: .shared()){
                //テキスト表示
                Text("フォトライブラリーから選択する")
                //横幅いっぱい
                    .frame(maxWidth: .infinity)
                //高さ５０ポイント
                    .frame(height: 50)
                //背景を青
                    .background(Color.blue)
                //文字色を白に指定
                    .foregroundColor(Color.white)
                //上下左右に余白
                    .padding()
            }//PhotosPickerここまで
            //選択した写真情報をもとに写真を取り出す
            .onChange(of: photoPickerSelectedImage, initial: true, { oldValue, newValue in
                //選択した写真がある時
                if let newValue {
                    //Date型で写真を取り出す
                    newValue.loadTransferable(type: Data.self){ result in
                        switch result {
                        case .success(let data):
                            //写真がある時
                            if let data {
                                //写真をcaptureImageに保存
                                captureImage = UIImage(data: data)
                            }
                        case .failure:
                            return
                        }
                    }
                }
            })//.onChangeここまで

            //captureImageをアンラップする
            if let captureImage {
                //captureImageから共有する画像を生成する
                let shareImage = Image(uiImage: captureImage)
                //共有シート
                ShareLink(item: shareImage, subject: nil, message: nil, preview: SharePreview("photo", image: shareImage)){
                    //テキスト表示
                    Text("SNSに投稿する")
                    //横幅いっぱい
                        .frame(maxWidth: .infinity)
                    //高さ50ポイント
                        .frame(height: 50)
                    //背景を青色に指定
                        .background(Color.blue)
                    //文字色を白色に指定
                        .foregroundStyle(Color.white)
                    //上下左右に余白を追加
                        .padding()
                }//shareLinkここまで
            }//アンラップここまで
        }//VStackここまで
    }//bodyここまで
}

#Preview {
    ContentView()
}
