fn main() {
    println!("{}", find_peak_element(vec![1, 2, 2]));
}

fn find_peak_element(nums: Vec<i32>) -> i32 {
    assert!(!nums.is_empty());

    let mut lower = 0;
    let mut upper = nums.len() - 1;

    loop {
        let mid = (lower + upper) / 2;

        if lower == upper {
            return lower as i32;
        }

        let m = nums[mid];

        if mid != 0 && nums[mid - 1] > m {
            upper = mid - 1;
        } else if mid < nums.len() && nums[mid + 1] > m {
            lower = mid + 1;
        } else {
            return mid as i32;
        }
    }
}
