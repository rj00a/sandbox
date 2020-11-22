fn main() {
    println!("{:?}", plus_one(vec![9, 9, 9]));
}

fn plus_one(mut digits: Vec<i32>) -> Vec<i32> {
    for i in digits.iter_mut().rev() {
        if *i == 9 {
            *i = 0;
        } else {
            *i += 1;
            return digits;
        }
    }

    digits[0] = 1;
    digits.push(0);

    digits
}
