//
//  ViewController.swift
//  yomikatakun
//
//  Created by Kiyoshi Sano on 2019/10/31.
//  Copyright © 2019 Kiyoshi Sano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var text_string = ""
    @IBOutlet weak var in_text: UITextField!
    @IBOutlet weak var out_text: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func Btn_convert(_ sender: Any) {

        text_string = in_text.text!
        
        var request = URLRequest(url: URL(string: "https://labs.goo.ne.jp/api/hiragana")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let postData = PostData(app_id: "fb54db1168a647b25abea9b37b093ac1414ffd25873593f4417f8f508a16daa1", request_id: "record003", sentence: text_string, output_type: "hiragana")
        
        
        guard let uploadData = try? JSONEncoder().encode(postData) else {
            print("json生成に失敗しました")
            return
        }
        request.httpBody = uploadData
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            
            guard let data = data, let jsonData = try? JSONDecoder().decode(Rubi.self, from: data) else {
                print("json変換に失敗しました")
                return
            }
            print(jsonData.converted)
            DispatchQueue.main.async {
                self.out_text.text = (jsonData.converted)
            }
        }
        task.resume()
    }
}
struct Rubi:Codable {
    var request_id: String
    var output_type: String
    var converted: String
}

struct PostData: Codable {
    var app_id:String
    var request_id: String
    var sentence: String
    var output_type: String
}

