//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 鈴木健太 on 2022/08/19.
//

import UIKit
import FirebaseStorageUI

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentSectionLabel: UILabel!
    
    
    @IBOutlet weak var commentTextField: UITextField?
    @IBOutlet weak var commentButton2: UIButton!
    
    

    
//    @IBOutlet weak var postImageView: UIImageView!
//    @IBOutlet weak var likeButton: UIButton!
//    @IBOutlet weak var likeLabel: UILabel!
//    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var captionLabel: UILabel!
//    @IBOutlet weak var commentButton: UIButton!
//

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // PostDataの内容をセルに表示　PostDataクラスから。
//    PostDataオブジェクト（インスタンス）を引数で受け取り、その内容をセルに表示するsetPostData(_:)メソッドを作成します。
    func setPostData(_ postData: PostData) {
        // 画像の表示
        print("DEBUG: セルの数分呼んでる")
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
//        imageRef画像保存場所から画像ダウンロード
        postImageView.sd_setImage(with: imageRef)
        

        // キャプションの表示
        self.captionLabel.text = ("\(postData.name!):\(postData.caption!)")
//        [投稿者名：キャプション情報]
//        一つの文字列に結合して、表示している
        
        // 日時の表示
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }

        // いいね数の表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"

        // いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        
//        コメント内容、コメント投稿者名の表示
        
        
        var commentData = ""
        for value in postData.comments{
            commentData += "\(value)\n"
        }
        self.commentSectionLabel.text = commentData
        
    }
}



//Dateは現在の日付を取得することができる構造体
//日付を取得する以外にも日付同士を比較したり、日付間の時間間隔の計算、新しい日付の作成などができます。
//let date:Date = Date()
//print(date)
//実行結果：
//2017-10-25 05:29:30 +0000


//let calendar = Calendar.current
//let date = Date()
////それぞれのスマホに設定されている暦（ぐれごれ暦とか和暦とか中国の暦とかなど）を取得。
//// 明日の日付を取得
//let day_tomorrow = calendar.date(
//    byAdding: .day, value: 1, to: calendar.startOfDay(for: date))
//// 昨日の日付を取得
//let day_yesterday = calendar.date(
//    byAdding: .day, value: -1, to: calendar.startOfDay(for: date))
//valueの値を1（明日）、-1（昨日）を指定して日付を取得


////現在の日付を取得
//let date:Date = Date()
////日付のフォーマットを指定する。
//let format = DateFormatter()
//format.dateFormat = "yyyy/MM/dd HH:mm:ss"
////日付をStringに変換する
//let sDate = format.string(from: date)
////from: date　は、 formatする現在の日付であるdateを入れる。
