//
//  Const.swift
//  Instagram
//
//  Created by 鈴木健太 on 2022/08/17.
//

import Foundation
//Firebase関連の定数を別ファイルに記述する（このファイルに記述）一つのファイルにまとめておくこと重要　どのような定数が定義されているか一覧できるようになり、管理しやすい

struct Const {
    static let ImagePath = "images"
//    ImagePathはStorage内の画像ファイルの保存場所を定義
    static let PostPath = "posts"
//    postPathはFirebase内の投稿データ（投稿者名、キャプション、投稿日時等）の保存場所を定義
   
}
