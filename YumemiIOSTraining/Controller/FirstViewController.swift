//
//  FirstViewController.swift
//  YumemiIOSTraining
//
//  Created by 今村京平 on 2021/08/09.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentViewController()
    }

    private func presentViewController() {
        let storyBoard = UIStoryboard(
            name: "Main",
            bundle: nil
        )
        let viewController = storyBoard
            .instantiateViewController(identifier: "ViewController", creator: { coder in
                ViewController(coder: coder, weatherModel: WeatherModelImpl())
            })
        viewController.modalPresentationStyle = .fullScreen
        present(
            viewController,
            animated: true,
            completion: nil
        )
    }
}
