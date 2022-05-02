//
//  BoardView.swift
//  TicTacToe
//
//  Created by Mykhailo Seleznov on 28.04.2022.
//

import UIKit

protocol BoardViewDelegate: AnyObject {
    func didSelectCell(at indexPath: IndexPath)
}

class BoardView: UIView {
    struct CellState {
        let text: String
        let color: UIColor
    }

    struct State {
        let cells: [[CellState]]
    }

    weak var delegate: BoardViewDelegate?

    private let collectionView: UICollectionView
    private var viewState = State(cells: [])

    override init(frame: CGRect) {
        let layout = GridCollectionViewLayout()
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)

        super.init(frame: frame)

        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        let layout = GridCollectionViewLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(coder: coder)

        setupCollectionView()
    }

    func applyViewState(state: State) {
        viewState = state

        collectionView.reloadData()
    }

    private func setupCollectionView() {
        collectionView.register(BoardCollectionViewCell.self, forCellWithReuseIdentifier: "BoardCell")
        collectionView.dataSource = self
        collectionView.delegate = self

        addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
    }
}

extension BoardView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoardCell", for: indexPath) as? BoardCollectionViewCell else {
            return UICollectionViewCell()
        }

        let cellRow = indexPath.item % 3
        let cellColumn = indexPath.item / 3
        if cellColumn < viewState.cells.count {
            let column = viewState.cells[cellColumn]
            if cellRow < column.count {
                cell.applyViewState(column[cellRow])
            }
        }

        cell.backgroundColor = .lightGray

        return cell
    }
}

extension BoardView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did tap at \(indexPath)")
        let cellRow = indexPath.item % 3
        let cellColumn = indexPath.item / 3

        delegate?.didSelectCell(at: IndexPath(row: cellRow, section: cellColumn))
    }
}

class BoardCollectionViewCell: UICollectionViewCell {
    private let textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(textLabel)

        textLabel.translatesAutoresizingMaskIntoConstraints = false

        textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true

        textLabel.textAlignment = .center
        textLabel.font = .systemFont(ofSize: 32.0)
    }

    func applyViewState(_ state: BoardView.CellState) {
        textLabel.text = state.text
        textLabel.textColor = state.color
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GridCollectionViewLayout: UICollectionViewLayout {

    let gridSpacing: CGFloat = 10.0

    var contentBounds = CGRect.zero
    var cachedAttributes = [UICollectionViewLayoutAttributes]()

    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }

    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }

        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        let smallerDimension: CGFloat
        let xOffset: CGFloat
        let yOffset: CGFloat

        if contentBounds.size.width < contentBounds.size.height {
            smallerDimension = contentBounds.size.width
            xOffset = 0.0
            yOffset = floor((contentBounds.size.height - smallerDimension) / 2.0)
        }
        else {
            smallerDimension = contentBounds.size.height
            xOffset = floor((contentBounds.size.width - smallerDimension) / 2.0)
            yOffset = 0.0
        }

        let cellSize = floor((smallerDimension - gridSpacing * 4.0) / 3.0)

        cachedAttributes.removeAll()

        for index in 0..<9 {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
            attributes.frame = CGRect(x: xOffset + gridSpacing * CGFloat(index%3 + 1) + cellSize * CGFloat(index%3),
                                      y: yOffset + gridSpacing * CGFloat(index/3 + 1) + cellSize * CGFloat(index/3),
                                      width: cellSize,
                                      height: cellSize)
            cachedAttributes.append(attributes)
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes.filter { $0.frame.intersects(rect) }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }
}
