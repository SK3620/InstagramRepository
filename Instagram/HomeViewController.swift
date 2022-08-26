//
//  HomeViewController.swift
//  Instagram
//
//  Created by 鈴木健太 on 2022/08/15.
//

import UIKit
import Firebase
import SVProgressHUD

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
  
    // 投稿データを格納する配列　これをテーブルに表示する
    var postArray: [PostData] = []
    
   

    // Firestoreのリスナー　firestoreのデータ更新の監視を行うためのもの。
    var listener: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        // カスタムセルを登録する
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
//        さらにカスタムセルを CellというIdentifierで登録します。カスタムセルを登録するには、UINib(nibName:bundle)を使ってxibファイルを読み込み、それをregister(_:forCellReuseIdentifier:)メソッドで登録します。
//        セルを含む nib オブジェクトを、指定された識別子の下でテーブルビューに登録する。
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        // ログイン済みか確認
        if Auth.auth().currentUser != nil {
            // listenerを登録して投稿データの更新を監視する
//           ログイン済みの場合のみ、投稿データの読み込み 投稿データを読み込むために、まずはデータベースの参照場所と取得順序を指定したクエリを作成します。
            let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
            print("DEBUG_PRINT:\(postsRef)")
            listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
                // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                self.postArray = querySnapshot!.documents.map { document in
                    print("DEBUG_PRINT: document取得 \(document.documentID)")
                    let postData = PostData(document: document)
                    return postData
                }
                
                print("DEBUG_PRINT: \(self.postArray)")
//               printで、この時点で全ての投稿データが格納されている。
                // TableViewの表示を更新する
                self.tableView.reloadData()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillDisappear")
        // listenerを削除して監視を停止する
        listener?.remove()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
//        　引数に指定して呼び出してるだけ
        
//        セル内のボタンのアクションをソースコードで設定する
//        この addTarget(_:action:for:)メソッドが、青い線を引っ張ってActionを設定する代わりになります。
//        モーダル遷移用のコメントボタン
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
//        textView用のコメントボタン
        cell.commentButton2.addTarget(self, action: #selector(handleButton2(_: forEvent:)), for: .touchUpInside)
        
//        cell.commentButton.addTarget(self, action: #selector(handleCommentButton(_:forevent:)), for: .touchUpInside)
    
        
        return cell
    }
    
//    セル内のコメントボタンが押された時（モーダル遷移するほう）
//    @objc func handleCommentButton(_ sender: UIButton, forevent event: UIEvent){
//
//        let touch = event.allTouches?.first
//        let point = touch!.location(in: self.tableView)
//        let indexPath = tableView.indexPathForRow(at: point)
//
//        let postData = postArray[indexPath!.row]
////        この辺からわからない
//
//        let commentViewController = self.storyboard?.instantiateViewController(withIdentifier: "Comment")
//        if let sheet = commentViewController?.sheetPresentationController {
//            sheet.detents = [.medium()]
//        }
//        present(commentViewController!, animated: true, completion: nil)
//    }
    
//    セル内のコメント投稿ボタンを押した時
    @objc func handleButton2(_ sender: UIButton, forEvent event: UIEvent){
        print("DEBUG_PRINT: セル内のコメント投稿ボタンがタップされました。")
        
        
        
        SVProgressHUD.show()
        
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData = postArray[indexPath!.row]
        
//        タップされたセルを取得
        let cell: PostTableViewCell = tableView.cellForRow(at: indexPath!) as! PostTableViewCell
        
        if let name = Auth.auth().currentUser?.displayName{
            if cell.commentTextField!.text!.isEmpty{
                print("動作")
                SVProgressHUD.showError(withStatus: "コメントを入力して下さい")
                cell.commentTextField?.endEditing(true)
              
            }else{
                
            let contentOfComment = cell.commentTextField!.text!
        print("名前確認 : \(name)")
//            更新データを作成
                
                let commentData = "\(name):\(contentOfComment)"
                
        var updateValue: FieldValue
        updateValue = FieldValue.arrayUnion([commentData])
        
        Firestore.firestore().collection(Const.PostPath).document(postData.id).updateData(["name&comment": updateValue])
        
        SVProgressHUD.showSuccess(withStatus: "コメントが投稿されました。")
        
                cell.commentTextField!.text! = ""
        cell.commentTextField?.endEditing(true)
            
            }
        }
    }
        
    
//    let store = Firestore.firestore()
//    store.collection("hoge").document("hogehoge").setData("name": FieldValue.arrayUnion()["taro", "jiro", "saburo"])
    
//    store.collection("hoge").document("hogehoge").updateData("name": FieldValue.arrayRemove()["jiro"])
    
    
    
    // セル内のボタン（ハートボタン）がタップされた時に呼ばれるメソッド
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")

        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)

        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]

        // likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            print("ユーザー名 : \(myid)")
            // 更新データを作成する
            var updateValue: FieldValue
            if postData.isLiked {
                // すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                // 今回新たにいいねを押した場合は、myidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            // likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
    }
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


