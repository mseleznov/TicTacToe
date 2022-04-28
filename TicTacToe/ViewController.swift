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
        // Do any additional setup after loading the view.

        boardView.setup()

        boardView.delegate = self

        let viewState = model.makeViewState()
        boardView.applyViewState(state: viewState)

        model.delegate = self
    }

    @IBOutlet weak var boardView: BoardView!

    let model = BoardModel()
}

extension ViewController: BoardModelDelegate {
    func applyViewState(_ viewState: BoardViewState) {
        DispatchQueue.main.async {
            self.boardView.applyViewState(state: viewState)
        }
    }
}

extension ViewController: BoardViewDelegate {
    func didTapButton(at indexPath: IndexPath) {
        model.didSelect(at: indexPath)

//        let viewState = model.makeViewState()
//        boardView.applyViewState(state: viewState)
    }
}

struct BoardViewState {
    enum ButtonState {
        case empty
        case filled(String, color: UIColor)
    }

    let buttonStates: [[ButtonState]]
}

protocol BoardViewDelegate: AnyObject {
    func didTapButton(at indexPath: IndexPath)
}

class BoardView: UIView {
    @IBOutlet weak var button1x1: UIButton!
    @IBOutlet weak var button1x2: UIButton!
    @IBOutlet weak var button1x3: UIButton!
    @IBOutlet weak var button2x1: UIButton!
    @IBOutlet weak var button2x2: UIButton!
    @IBOutlet weak var button2x3: UIButton!
    @IBOutlet weak var button3x1: UIButton!
    @IBOutlet weak var button3x2: UIButton!
    @IBOutlet weak var button3x3: UIButton!

    weak var delegate: BoardViewDelegate?

    func setup() {
        guard superview != nil else {
            return
        }

        button1x1.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        button1x2.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        button1x3.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        button2x1.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        button2x2.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        button2x3.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        button3x1.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        button3x2.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        button3x3.addTarget(self, action: #selector(didTap), for: .touchUpInside)

        button1x1.tag = 100
        button1x2.tag = 101
        button1x3.tag = 102
        button2x1.tag = 103
        button2x2.tag = 104
        button2x3.tag = 105
        button3x1.tag = 106
        button3x2.tag = 107
        button3x3.tag = 108
    }

    @objc func didTap(sender: UIButton) {
        var indexPath: IndexPath?

        switch sender.tag {
        case 100:
            indexPath = IndexPath(row: 0, section: 0)
        case 101:
            indexPath = IndexPath(row: 1, section: 0)
        case 102:
            indexPath = IndexPath(row: 2, section: 0)
        case 103:
            indexPath = IndexPath(row: 0, section: 1)
        case 104:
            indexPath = IndexPath(row: 1, section: 1)
        case 105:
            indexPath = IndexPath(row: 2, section: 1)
        case 106:
            indexPath = IndexPath(row: 0, section: 2)
        case 107:
            indexPath = IndexPath(row: 1, section: 2)
        case 108:
            indexPath = IndexPath(row: 2, section: 2)
        default:
            break
        }

        if let indexPath = indexPath {
            delegate?.didTapButton(at: indexPath)
        }
    }

    func applyViewState(state: BoardViewState) {
        button1x1.setTitle(titleFor(state.buttonStates[0][0]), for: .normal)
        button1x2.setTitle(titleFor(state.buttonStates[0][1]), for: .normal)
        button1x3.setTitle(titleFor(state.buttonStates[0][2]), for: .normal)
        button2x1.setTitle(titleFor(state.buttonStates[1][0]), for: .normal)
        button2x2.setTitle(titleFor(state.buttonStates[1][1]), for: .normal)
        button2x3.setTitle(titleFor(state.buttonStates[1][2]), for: .normal)
        button3x1.setTitle(titleFor(state.buttonStates[2][0]), for: .normal)
        button3x2.setTitle(titleFor(state.buttonStates[2][1]), for: .normal)
        button3x3.setTitle(titleFor(state.buttonStates[2][2]), for: .normal)

        button1x1.setTitleColor(colorFor(state.buttonStates[0][0]), for: .normal)
        button1x2.setTitleColor(colorFor(state.buttonStates[0][1]), for: .normal)
        button1x3.setTitleColor(colorFor(state.buttonStates[0][2]), for: .normal)
        button2x1.setTitleColor(colorFor(state.buttonStates[1][0]), for: .normal)
        button2x2.setTitleColor(colorFor(state.buttonStates[1][1]), for: .normal)
        button2x3.setTitleColor(colorFor(state.buttonStates[1][2]), for: .normal)
        button3x1.setTitleColor(colorFor(state.buttonStates[2][0]), for: .normal)
        button3x2.setTitleColor(colorFor(state.buttonStates[2][1]), for: .normal)
        button3x3.setTitleColor(colorFor(state.buttonStates[2][2]), for: .normal)
    }

    private func titleFor(_ buttonState: BoardViewState.ButtonState) -> String {
        switch buttonState {
        case .empty:
            return " "
        case .filled(let title, _):
            return title
        }
    }

    private func colorFor(_ buttonState: BoardViewState.ButtonState) -> UIColor {
        switch buttonState {
        case .empty:
            return .blue
        case .filled(_, let color):
            return color
        }
    }

}
