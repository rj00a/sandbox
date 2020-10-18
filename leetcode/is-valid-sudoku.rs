impl Solution {
    pub fn is_valid_sudoku(board: Vec<Vec<char>>) -> bool {
        let mut row = 0;
        let mut col = 0;
        loop {
            if board[row][col] != '.' {
                // Check row
                let mut cell_set = 0;
                for &c in &board[row] {
                    if !check_cell(c, &mut cell_set) {
                        return false;
                    }
                }

                // Check column
                cell_set = 0;
                for i in 0..9 {
                    if !check_cell(board[i][col], &mut cell_set) {
                        return false;
                    }
                }

                // Check surrounding 3x3 grid
                cell_set = 0;
                let subgrid_row_off = row / 3 * 3;
                let subgrid_col_off = col / 3 * 3;
                for r in 0..3 {
                    for c in 0..3 {
                        if !check_cell(
                            board[subgrid_row_off + r][subgrid_col_off + c],
                            &mut cell_set,
                        ) {
                            return false;
                        }
                    }
                }
            }

            if row == 8 && col == 8 {
                break;
            }
            if col == 8 {
                row += 1;
                col = 0;
            } else {
                col += 1;
            }
        }
        true
    }
}

fn check_cell<'a>(ch: char, cell_set: &'a mut u16) -> bool {
    if ch == '.' {
        return true;
    }
    let bit = 1u16 << ch.to_digit(10).unwrap() - 1;
    if *cell_set | bit == *cell_set {
        false
    } else {
        *cell_set |= bit;
        true
    }
}

struct Solution {}

fn main() {
    //    let board = vec![
    //        vec!['5','3','.','.','7','.','.','.','.'],
    //        vec!['6','.','.','1','9','5','.','.','.'],
    //        vec!['.','9','8','.','.','.','.','6','.'],
    //        vec!['8','.','.','.','6','.','.','.','3'],
    //        vec!['4','.','.','8','.','3','.','.','1'],
    //        vec!['7','.','.','.','2','.','.','.','6'],
    //        vec!['.','6','.','.','.','.','2','8','.'],
    //        vec!['.','.','.','4','1','9','.','.','5'],
    //        vec!['.','.','.','.','8','.','.','7','9']
    //    ];
    let board = vec![
        vec!['.', '.', '4', '.', '.', '.', '6', '3', '.'],
        vec!['.', '.', '.', '.', '.', '.', '.', '.', '.'],
        vec!['5', '.', '.', '.', '.', '.', '.', '9', '.'],
        vec!['.', '.', '.', '5', '6', '.', '.', '.', '.'],
        vec!['4', '.', '3', '.', '.', '.', '.', '.', '1'],
        vec!['.', '.', '.', '7', '.', '.', '.', '.', '.'],
        vec!['.', '.', '.', '5', '.', '.', '.', '.', '.'],
        vec!['.', '.', '.', '.', '.', '.', '.', '.', '.'],
        vec!['.', '.', '.', '.', '.', '.', '.', '.', '.'],
    ];
    println!("{}", Solution::is_valid_sudoku(board));
}
