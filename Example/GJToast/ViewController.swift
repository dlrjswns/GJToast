//
//  ViewController.swift
//  GJToast
//
//  Created by dlrjswns on 11/02/2023.
//  Copyright (c) 2023 dlrjswns. All rights reserved.
//

import UIKit

import GJToast

class ViewController: UIViewController {
  
  private lazy var button: UIButton = {
    $0.setTitle("Show GJToast", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.addTarget(self, action: #selector(didTappedButton), for: .touchUpInside)
    return $0
  }(UIButton())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      view.backgroundColor = .systemBackground
      
      view.addSubview(button)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @objc private func didTappedButton() {
    GJToast.makeToast("안녕하세요", toastImage: UIImage(systemName: "person.fill"))
  }

}

