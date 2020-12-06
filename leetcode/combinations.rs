fn combine(n: i32, k: i32) -> Vec<Vec<i32>> {
    fn rec(res: &mut Vec<Vec<i32>>, tmp: &mut Vec<i32>, start: i32, n: i32, k: i32) {
        if k == 0 {
            res.push(tmp.clone());
        } else {
            for i in start..=n {
                tmp.push(i);
                rec(res, tmp, i + 1, n, k - 1);
                tmp.pop();
            }
        }
    }

    let mut res = Vec::new();
    rec(&mut res, &mut Vec::new(), 1, n, k);
    res
}

fn main() {
    println!("{:?}", combine(4, 3));
}
