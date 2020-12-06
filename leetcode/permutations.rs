fn permute(nums: Vec<i32>) -> Vec<Vec<i32>> {
    let mut res = Vec::new();

    fn permute_(res: &mut Vec<Vec<i32>>, v: &Vec<i32>, num_fixed: usize) {
        if num_fixed >= v.len() {
            res.push(v.clone());
        } else {
            permute_(res, v, num_fixed + 1);

            for i in num_fixed + 1..v.len() {
                let mut v = v.clone();
                v.swap(num_fixed, i);
                permute_(res, &v, num_fixed + 1);
            }
        }
    }

    permute_(&mut res, &nums, 0);
    res
}

fn main() {
    println!("{:?}", permute(vec![1, 2, 3, 4]));
}
