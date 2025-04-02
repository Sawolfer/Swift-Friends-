import SwiftUI

struct TimeGrid: View {
    struct Cell: Hashable {
        let row: Int
        let column: Int
    }

    private enum Mode {
        case select
        case deselect
    }

    var cells = [Cell: Double]()
    @Binding var selectedCells: Set<Cell>
    let rows: Int
    let columns: Int
    var onCellTapAction: (Cell) -> Void = {_ in }
    var isEditable = true
    @State private var tempSelectedCells: Set<Cell> = []
    @State private var tempDeselectedCells: Set<Cell> = []
    @State private var startCell: Cell?
    @State private var mode: Mode = .select
    @State private var isDragging = false
    private let generator = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        GeometryReader { geometry in
            let cellSize = CGSize(
                width: geometry.size.width / CGFloat(columns),
                height: geometry.size.height / CGFloat(rows)
            )

            VStack(spacing: 1) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: 1) {
                        ForEach(0..<columns, id: \.self) { column in
                            Rectangle()
                                .fill(getFillColor(for: Cell(row: row, column: column)))
                                .onTapGesture {
                                    let cell = Cell(row: row, column: column)
                                    if isEditable {
                                        toggleCell(cell)
                                    }

                                    onCellTapAction(cell)
                                    generator.impactOccurred()
                                }
                        }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 9))
            .highPriorityGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let cell = getCell(at: value.location, cellSize: cellSize)

                        if !isDragging {
                            startCell = cell
                            mode = selectedCells.contains(cell) ? .deselect : .select
                            isDragging = true
                            generator.impactOccurred()
                        }

                        toggleTempRect(start: startCell ?? Cell(row: 0, column: 0), end: cell, mode: mode)
                    }
                    .onEnded { _ in
                        isDragging = false
                        switch mode {
                        case .select:
                            selectedCells.formUnion(tempSelectedCells)
                            tempSelectedCells = []
                        case .deselect:
                            selectedCells.subtract(tempDeselectedCells)
                            tempDeselectedCells = []
                        }
                        generator.impactOccurred()
                    }
            )
        }
    }

    private func toggleTempRect(start: Cell, end: Cell, mode: Mode) {
        let minColumn = min(start.column, end.column)
        let maxColumn = max(start.column, end.column)
        let minRow = min(start.row, end.row)
        let maxRow = max(start.row, end.row)

        var cells = Set<Cell>()
        for row in Int(minRow)...Int(maxRow) {
            for column in Int(minColumn)...Int(maxColumn) {
                let cell = Cell(row: row, column: column)
                cells.insert(cell)
            }
        }

        switch mode {
        case .select:
            tempSelectedCells = cells
        case .deselect:
            tempDeselectedCells = cells
        }
    }

    private func isHighlighted(_ cell: Cell) -> Bool {
        return !tempDeselectedCells.contains(cell) && (tempSelectedCells.contains(cell) || selectedCells.contains(cell))
    }

    private func getFillColor(for cell: Cell) -> Color {
        if isHighlighted(cell) {
            return .green
        } else if let opacity = cells[cell] {
            return .green.opacity(opacity)
        }

        return .gray.opacity(0.2)
    }

    private func toggleCell(_ cell: Cell) {
        if selectedCells.contains(cell) {
            selectedCells.remove(cell)
        } else {
            selectedCells.insert(cell)
        }
    }

    private func getCell(at location: CGPoint, cellSize: CGSize) -> Cell {
        let column = max(0, min(Int(location.x / cellSize.width), columns - 1))
        let row = max(0, min(Int(location.y / cellSize.height), rows - 1))
        return Cell(row: row, column: column)
    }
}
