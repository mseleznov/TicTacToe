//
//  BoardViewStateFactory.swift
//  TicTacToe
//
//  Created by Mykhailo Seleznov on 11.04.2022.
//

import Foundation

protocol BoardModelDelegate: AnyObject {
    func applyViewState(_ viewState: BoardView.State)
}

class BoardModel {
    enum SquareState {
        case empty
        case x
        case o
    }

    enum Player {
        case x
        case o

        mutating func toggle() {
            switch self {
            case .o:
                self = .x
            case .x:
                self = .o
            }
        }
    }


    var player = Player.x
    var board:[[SquareState]] = [[.empty, .empty, .empty],[.empty, .empty, .empty],[.empty, .empty, .empty]]
    let service = Service()
    weak var delegate: BoardModelDelegate?

    func didSelect(at indexPath: IndexPath) {
        guard indexPath.row < 3, indexPath.section < 3, board[indexPath.section][indexPath.row] == .empty else {
            print("invalid index path \(indexPath)")
            return
        }

        board[indexPath.section][indexPath.row] = .x

        applyViewState()

        let serviceBoard = makeServiceBoard()

        print(serviceBoard)
        print("==================")
        service.makeMove(board: serviceBoard) { newBoard in
            guard let newBoard = newBoard else {
                return
            }

            print(newBoard)

            for xPos in newBoard.x {
                self.board[xPos.c][xPos.r] = .x
            }
            for oPos in newBoard.o {
                self.board[oPos.c][oPos.r] = .o
            }

            self.applyViewState()
        }
    }

    private func makeServiceBoard() -> Board {
        var x: [Board.Position] = []
        var o: [Board.Position] = []

        for (section, rows) in board.enumerated() {
            for (row, cell) in rows.enumerated() {
                switch cell {
                case .empty:
                    break
                case .x:
                    x.append(Board.Position(r: row, c: section))
                case .o:
                    o.append(Board.Position(r: row, c: section))
                }
            }
        }

        return Board(x: x, o: o)
    }

    private func applyViewState() {
        let viewState = self.makeViewState()
        self.delegate?.applyViewState(viewState)
    }

    func makeViewState() -> BoardView.State {
        var filesX = [0, 0, 0]
        var columnsX = [0, 0, 0]
        var leftDiagX = 0
        var rightDiagX = 0
        var filesO = [0, 0, 0]
        var columnsO = [0, 0, 0]
        var leftDiagO = 0
        var rightDiagO = 0

        for (section, rows) in board.enumerated() {
            for (row, cell) in rows.enumerated() {
                switch cell {
                case .empty:
                    break
                case .x:
                    filesX[row] = filesX[row] + 1
                    columnsX[section] = columnsX[section] + 1
                    if section == row {
                        leftDiagX += 1
                    }
                    if (section + row) == 2 {
                        rightDiagX += 1
                    }
                case .o:
                    filesO[row] = filesO[row] + 1
                    columnsO[section] = columnsO[section] + 1
                    if section == row {
                        leftDiagO += 1
                    }
                    if (section + row) == 2 {
                        rightDiagO += 1
                    }
                }
            }
        }

        let buttons = board.enumerated().map { (columnIndex, row) in
            row.enumerated().map { (rowIndex, cell) -> BoardView.CellState in
                let winningCell = columnsX[columnIndex] == 3 || columnsO[columnIndex] == 3 ||
                filesX[rowIndex] == 3 || filesO[rowIndex] == 3 ||
                ((columnIndex == rowIndex) && leftDiagX == 3) || ((columnIndex == rowIndex) && leftDiagO == 3) ||
                ((columnIndex + rowIndex) == 2 && rightDiagX == 3) || ((columnIndex + rowIndex) == 2 && rightDiagO == 3)
                switch cell {
                case .empty:
                    return BoardView.CellState(text: "", color: .black)
                case .x:
                    return BoardView.CellState(text: "X", color: winningCell ? .red : .black)
                case .o:
                    return BoardView.CellState(text: "O", color: winningCell ? .red : .black)
                }
            }
        }

        return BoardView.State(cells: buttons)
    }
}
