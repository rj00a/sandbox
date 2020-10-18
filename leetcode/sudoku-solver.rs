use std::fs::read_to_string;
use std::process::exit;

fn main() {
    match solve_board(
        &parse_board(
            read_to_string("leetcode/sudoku-board.txt")
                .unwrap_or_else(|e| {
                    eprintln!("Error: {}", e);
                    exit(1)
                })
                .split_whitespace(),
        )
        .unwrap_or_else(|e| {
            match e {
                WrongNumberOfElems => {
                    eprintln!("Error: Wrong number of elements in the Sudoku board.")
                }
                BadNumber(s) => eprintln!("Error: Invalid number in Sudoku board: {}", s),
            }
            exit(1)
        }),
    ) {
        Some(board) => print_board(&board),
        None => println!("The Sudoku board has no solution."),
    }
}

fn parse_board<'a>(it: impl Iterator<Item = &'a str>) -> Result<Board, BoardParseError> {
    let mut board: Board = Vec::new();
    let mut row_idx = 0;
    let mut col_idx = 0;

    for s in it {
        if s.len() != 1 {
            return Err(BadNumber(s.to_string()));
        }

        if row_idx == 0 {
            if col_idx > 8 {
                return Err(WrongNumberOfElems);
            }
            board.push(Vec::new());
        }

        board[col_idx].push(match s.chars().next().unwrap() {
            '1' => 1,
            '2' => 2,
            '3' => 3,
            '4' => 4,
            '5' => 5,
            '6' => 6,
            '7' => 7,
            '8' => 8,
            '9' => 9,
            '.' => 0, // Zero represents an empty cell.
            _ => return Err(BadNumber(s.to_string())),
        });

        if row_idx == 8 {
            col_idx += 1;
            row_idx = 0;
        } else {
            row_idx += 1;
        }
    }
    Ok(board)
}

type Board = Vec<Vec<u8>>;

#[derive(Debug)]
enum BoardParseError {
    WrongNumberOfElems,
    BadNumber(String),
}
use BoardParseError::*;

fn solve_board(b: &Board) -> Option<Board> {
    solve_at(b, 0, 0)
}

fn solve_at(board: &Board, row: usize, col: usize) -> Option<Board> {
    if board[row][col] != 0 {
        // Cell is already filled, go to next cell.
        return solve_at_next_cell(board, row, col);
    }

    'cell_loop: for cell in 1..=9 {
        // Check row
        for &c in &board[row] {
            if c == cell {
                continue 'cell_loop;
            }
        }

        // Check column
        for i in 0..9 {
            if board[i][col] == cell {
                continue 'cell_loop;
            }
        }

        // Check surrounding 3x3 grid.
        {
            let subgrid_row_off = row / 3 * 3;
            let subgrid_col_off = col / 3 * 3;
            for r in 0..3 {
                for c in 0..3 {
                    if board[subgrid_row_off + r][subgrid_col_off + c] == cell {
                        continue 'cell_loop;
                    }
                }
            }
        }

        // The current cell value is valid, so we clone the board and fill in the cell.
        let mut new_board = board.clone();
        new_board[row][col] = cell;

        if let Some(solved_board) = solve_at_next_cell(&new_board, row, col) {
            return Some(solved_board);
        }
    }

    // None of the cell values we tried were successful.
    None
}

fn solve_at_next_cell(board: &Board, curr_row: usize, curr_col: usize) -> Option<Board> {
    if curr_row == 8 && curr_col == 8 {
        // At the last cell, so we're done.
        return Some(board.clone());
    }

    let (next_row, next_col) = if curr_col == 8 {
        (curr_row + 1, 0)
    } else {
        (curr_row, curr_col + 1)
    };

    solve_at(board, next_row, next_col)
}

fn print_board(board: &Board) {
    for rows in board {
        for &cell in rows {
            if cell == 0 {
                print!(". ");
            } else {
                print!("{} ", cell);
            }
        }
        println!("");
    }
}
