fn main() {
    //println!("{}", is_match(b"mississippi", b"mis*is*ip*."));
    println!("{}", is_match(b"aaaaaaaaabcde", b".*abcde"));
}

//fn is_match(input: &[u8], pattern: &[u8]) -> bool {
//    eprintln!(
//        "\"{}\", \"{}\"",
//        std::str::from_utf8(input).unwrap(),
//        std::str::from_utf8(pattern).unwrap()
//    );
//    match (pattern.first(), pattern.get(1)) {
//        (Some(b'.'), Some(b'*')) => match input.first() {
//            _ if is_match(input, &pattern[2..]) => true,
//            Some(_) => is_match(&input[1..], pattern),
//            None => false,
//        },
//        (Some(c), Some(b'*')) => match input.first() {
//            _ if is_match(input, &pattern[2..]) => true,
//            Some(ch) => c == ch && is_match(&input[1..], pattern),
//            None => false,
//        },
//        (Some(b'.'), _) => match input.first() {
//            Some(_) => is_match(&input[1..], &pattern[1..]),
//            None => false,
//        },
//        (Some(c), _) => match input.first() {
//            Some(ch) => ch == c && is_match(&input[1..], &pattern[1..]),
//            None => false,
//        },
//        _ => input.is_empty(),
//    }
//}

fn is_match(input: &[u8], pattern: &[u8]) -> bool {
    eprintln!(
        "\"{}\", \"{}\"",
        std::str::from_utf8(input).unwrap(),
        std::str::from_utf8(pattern).unwrap()
    );
    match (pattern.first(), pattern.get(1)) {
        (Some(b'.'), Some(b'*')) => match input.first() {
            _ if is_match(input, &pattern[2..]) => true,
            Some(_) => is_match(&input[1..], pattern),
            None => false,
        },
        (Some(c), Some(b'*')) => match input.first() {
            _ if is_match(input, &pattern[2..]) => true,
            Some(ch) => c == ch && is_match(&input[1..], pattern),
            None => false,
        },
        (Some(b'.'), _) => match input.first() {
            Some(_) => is_match(&input[1..], &pattern[1..]),
            None => false,
        },
        (Some(c), _) => match input.first() {
            Some(ch) => ch == c && is_match(&input[1..], &pattern[1..]),
            None => false,
        },
        _ => input.is_empty(),
    }
}