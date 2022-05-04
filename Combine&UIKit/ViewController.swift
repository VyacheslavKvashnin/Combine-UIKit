//
//  ViewController.swift
//  Combine&UIKit
//
//  Created by Вячеслав Квашнин on 04.05.2022.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var acceptSwitch: UISwitch!
    
    @IBOutlet weak var pressedButtonLabel: UIButton!
    
    @IBOutlet weak var postLabel: UILabel!
    
    @Published var isShowButton: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        $isShowButton
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: pressedButtonLabel)
        
        setupCombine()
    }

    @IBAction func showButtonSwitch(_ sender: UISwitch) {
        isShowButton = sender.isOn
    }
    
    @IBAction func pressedButton(_ sender: Any) {
        let blogPost = BlogPost(title: "Some Titel\n \(Date())")
        NotificationCenter.default.post(name: .newBlogPost, object: blogPost)
    }
    
    private func setupCombine() {
        let blogPostPublisher = NotificationCenter.Publisher(
            center: .default,
            name: .newBlogPost,
            object: nil
        )
            .map { notification -> String? in
                return (notification.object as? BlogPost)?.title
            }
        
        let postSubscriber = Subscribers.Assign(object: postLabel, keyPath: \.text)
        blogPostPublisher
            .subscribe(postSubscriber)
    }
}

struct BlogPost {
    let title: String
}

extension Notification.Name {
    static let newBlogPost = Notification.Name("newBlogPost")
}
