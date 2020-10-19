// TODO: Use bottom-up DP approach

use std::collections::HashMap;

fn main() {
    let input = b"bbbbbbbabbaabbabbbbaaabbabbabaaabbababbbabbbabaaabaab";
    let pattern = b"b*b*ab**ba*b**b***bba";

    let mut pattern = pattern.to_vec();
    pattern.dedup_by(|&mut l, &mut r| l == b'*' && r == b'*');

    let mut cache = HashMap::new();
    println!("{}", is_match(input, &pattern, 0, 0, &mut cache));
}

fn is_match(
    input: &[u8],
    pattern: &[u8],
    i_pos: usize,
    p_pos: usize,
    cache: &mut HashMap<(usize, usize), bool>,
) -> bool {
    match cache.get(&(i_pos, p_pos)) {
        Some(&b) => b,
        None => {
            let res = match (input.get(i_pos), pattern.get(p_pos)) {
                (None, Some(b'*')) => is_match(input, pattern, i_pos, p_pos + 1, cache),
                (Some(_), Some(b'*')) => {
                    is_match(input, pattern, i_pos, p_pos + 1, cache)
                        || is_match(input, pattern, i_pos + 1, p_pos, cache)
                }
                (Some(_), Some(b'?')) => is_match(input, pattern, i_pos + 1, p_pos + 1, cache),
                (Some(c), Some(ch)) => {
                    c == ch && is_match(input, pattern, i_pos + 1, p_pos + 1, cache)
                }
                (None, None) => true,
                _ => false,
            };
            cache.insert((i_pos, p_pos), res);
            res
        }
    }
}
