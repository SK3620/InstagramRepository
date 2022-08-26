//
//  PostViewController.swift
//  Instagram
//
//  Created by 鈴木健太 on 2022/08/15.
//

import UIKit
import Firebase
import SVProgressHUD


class PostViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    var image: UIImage!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageView.image = image
    }
    
//     投稿ボタン
    @IBAction func handlePostButton(_ sender: Any) {
        // 画像をJPEG形式に変換する
               let imageData = image.jpegData(compressionQuality: 0.75)
               // 画像と投稿データの保存場所を定義する　データベース内の指定したパスにあるコレクションを参照する `FIRCollectionReference` を取得します。
        //        コメントデータなどの保存場所を定義　document()で自動生成されたIDを持つ新規ドキュメントを指すFIRDocumentReferenceを返します。だから、post(comment)フォルダの中に新たなドキュメントを指定（作成）しとる　んで、そこに保存するように指定
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
//        postRefはfireStoreに保存する投稿データの保存場所
//        データベース内の指定したパスにあるコレクションを参照する `FIRCollectionReference` を取得します。collectionPath FIRCollectionReference` を取得するコレクションのパス (スラッシュで区切られた文字列)。戻り値 指定した _collectionPath_ にある `FIRCollectionReference` を返します。
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
//        imageRefはstoreageに保存する画像の保存場所
               // HUDで投稿処理中の表示を開始
               SVProgressHUD.show()
               // Storageに画像をアップロードする
               let metadata = StorageMetadata()
               metadata.contentType = "image/jpeg"
               imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
                   if error != nil {
                       // 画像のアップロード失敗
                       print(error!)
                       SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
                       // 投稿処理をキャンセルし、先頭画面に戻る
                      self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                       return
                   }
                   // FireStoreに投稿データを保存する
                   let name = Auth.auth().currentUser?.displayName
                   let postDic = [
                       "name": name!,
                       "caption": self.textField.text!,
                       "date": FieldValue.serverTimestamp(),
                   ] as [String : Any]
                   postRef.setData(postDic)
                   // HUDで投稿完了を表示する
                   SVProgressHUD.showSuccess(withStatus: "投稿しました")
                   // 投稿処理が完了したので先頭画面に戻る
                 self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
               }
    }
    
//    キャンセルボタン
    @IBAction func handleCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
