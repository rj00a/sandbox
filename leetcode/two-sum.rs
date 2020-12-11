use std::collections::HashMap;

fn main() {
    println!("{:?}", two_sum(vec![2, 15, -2, 7, 4], 9));
}

fn two_sum(nums: Vec<i32>, target: i32) -> Vec<i32> {
    let mut hm = HashMap::new();
    for i in 0..nums.len() {
        let n  = nums[i];
        if let Some(&j) = hm.get(&(target - n)) {
            return vec![j, i as i32];
        }
        hm.insert(n, i as i32);
    }
    unreachable!("No solution :(")
}