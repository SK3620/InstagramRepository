//
//  PostDate.swift
//  Instagram
//
//  Created by 鈴木健太 on 2022/08/19.
//

import UIKit
import Firebase

//投稿データを格納するクラス

//1Firebaseから投稿データを取得
//2投稿データを格納するクラスを作成してテーブル表示用の配列を作成
//3UITableViewを更新
class PostData: NSObject {
//    投稿ID（保存する際に作られたユニークなID）
//    投稿者名
//    キャプション
//    日付
//    いいねをした人のIDの配列
//    自分がいいねしたかどうかのフラグ
    var id: String
    var name: String?
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false
    
    
    
//    追加した。投稿者名　と　コメント内容
    var poster : String?
    var comments: [String] = []

        init(document: QueryDocumentSnapshot) {
//            FIRQueryDocumentSnapshot` は、クエリの一部として Firestore データベース内のドキュメントから読み込まれたデータを含む
            self.id = document.documentID

            let postDic = document.data()
//            print("データ : \(postDic)")
            let commentDic = document.data()
            
//            print("DEBUG_PRINT :  \(postDic)")
//ドキュメントに含まれるすべてのフィールドを `NSDictionary` として取得する。data()メソっド
//            辞書形式のデータを取り出している。全部取り出す
            
            self.name = postDic["name"] as? String
            print("名前 : \(self.name!)")
//            上位のオプショナルany型から下位のオプショナルstring型へ変換　辞書で取り出した値はオプショナルAny型である

            self.caption = postDic["caption"] as? String

            let timestamp = postDic["date"] as? Timestamp
            self.date = timestamp?.dateValue()
//            現在指定されている日付？dateValue()

            if let likes: [String] = postDic["likes"] as? [String] {
//                取り出した値オプショナルAny型からオプショナルのString配列型に変更　んでif letでまたアンラップ
                self.likes = likes
//                いいねしたユーザーのIDを保持する配列
//                var likesに上書きしてる。
            }
            if let myid = Auth.auth().currentUser?.uid {
                // likesの配列の中にmyidが含まれているかチェックすることで、自分がいいねを押しているかを判断
                if self.likes.firstIndex(of: myid) != nil {
//Parameters    element　 An element to search for in the collection.
                    // myidがあれば、いいねを押していると認識する。
                    self.isLiked = true
                }
            }
            
            if let comments: [String] = postDic["name&comment"] as? [String]{
                self.comments = comments
            }
        }
    }


