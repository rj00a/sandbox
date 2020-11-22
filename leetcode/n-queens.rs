/// A list of column positions for the queens.
/// queens[0] is the first row, queens[1] is the second row, etc.
type Queens = Vec<i32>;

fn main() {
    let n = 5;
    let solutions = solve_n_queens(n);
    //for solution in &solutions {
    //    for line in solution {
    //        println!("{}  ", line);
    //    }
    //    println!("");
    //}
    println!(
        "There were {} solutions with a {1}x{1} board.",
        solutions.len(),
        n
    );
}

fn solve_n_queens(n: i32) -> Vec<Vec<String>> {
    let mut solutions = Vec::new();
    let mut queens = Vec::new();
    rec(n, &mut queens, &mut solutions);
    // Massage the data into the format that leetcode expects.
    solutions
        .into_iter()
        .map(|queens| {
            queens
                .into_iter()
                .map(|col| {
                    (0..col)
                        .map(|_| '.')
                        .chain(std::iter::once('Q'))
                        .chain((col + 1..n).map(|_| '.'))
                        .collect()
                })
                .collect::<Vec<String>>()
        })
        .collect()
}

fn rec(n: i32, queens: &mut Queens, solutions: &mut Vec<Queens>) {
    for col in 0..n {
        if ok_here(&queens, col) {
            queens.push(col);
            if queens.len() as i32 == n {
                solutions.push(queens.clone())
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
        if q == col || q == col - diag || q == col + diag {
            return false;
        }
        diag += 1;
    }
    true
}
