//
//  ViewController.swift
//  OS13_HW12
//
//  Created by Евгений Сушков on 10.06.2024.
//

import UIKit

class ViewController: UIViewController {
    
    var isWorkTime = true
    var isStarted = false
    var timer: Timer?
    let workTime = 25
    let restTime = 5
    
    let logoImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(named: "logo") // Замените "logo" на имя вашего логотипа в Assets
            return imageView
        }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

