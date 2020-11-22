
fn main() {
    let n = 8;
    println!("There were {} solution(s) for a(n) {1}x{1} board.", total_n_queens(n), n);
}

fn total_n_queens(n: i32) -> i32 {
    let mut solutions = 0;
    let mut queens = Vec::new();
    rec(n, &mut queens, &mut solutions);
    solutions
}

type Queens = Vec<i32>;

fn rec(n: i32, queens: &mut Queens, solutions: &mut i32) {
    for col in 0..n {
        if ok_here(&queens, col) {
            queens.push(col);
            if queens.len() as i32 == n {
                *solutions += 1;
            } else {
                rec(n, queens, solutions);
            }
            queens.pop();
        }
    }
}

/// Can we put a queen in this column without challenging the existing queens?
fn ok_here(queens: &Vec<i32>, col: i32) -> bool {
    let mut diag = 1;
    for &q in queens.iter().rev() {
        if q == col || q == col - diag || q == col + diag  {
            return false;
        }
        diag += 1;
    }
    true
}