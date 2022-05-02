//
//  ViewController.swift
//  TicTacToe
//
//  Created by Mykhailo Seleznov on 11.04.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewState = model.makeViewState()

        boardView.delegate = self

        boardView.applyViewState(state: viewState)

        model.delegate = self
    }

    @IBOutlet weak var boardView: BoardView!

    let model = BoardModel()
}

extension ViewController: BoardModelDelegate {
    func applyViewState(_ viewState: BoardView.State) {
        DispatchQueue.main.async {
            self.boardView.applyViewState(state: viewState)
        }
    }
}

extension ViewController: BoardViewDelegate {
    func didSelectCell(at indexPath: IndexPath) {
        model.didSelect(at: indexPath)
    }
}
