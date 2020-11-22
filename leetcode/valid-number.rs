// Parser combinators!

fn main() {
    [
        ("1234", true),
        ("2e6", true),
        ("+5e-7", true),
        ("    0    ", true),
        ("1234  g", false),
        ("0xdeadbeef", false),
        ("5.00000001e+4", true),
        ("99e2.5", false),
        ("5.", true),
    ]
    .iter()
    .for_each(|(s, b)| assert_eq!(is_number(s.to_string()), *b));

    println!("Done!")
}

fn is_number(s: String) -> bool {
    let whitespace = Opt(Many(Char(' ')));
    #[rustfmt::skip]
    let digit = Or(Char('0'), Or(Char('1'), Or(Char('2'), Or(Char('3'), Or(Char('4'), Or(Char('5'), Or(Char('6'), Or(Char('7'), Or(Char('8'), Char('9'))))))))));
    let opt_sign = Opt(Or(Char('+'), Char('-')));
    let some_digits = And(digit, Many(digit));

    let number = And(
        And(
            And(
                And(whitespace, opt_sign),
                Or(
                    And(some_digits, Opt(And(Char('.'), Many(digit)))),
                    And(Char('.'), some_digits),
                ),
            ),
            Opt(And(Or(Char('e'), Char('E')), And(opt_sign, some_digits))),
        ),
        whitespace,
    );

    match number.parse(s.chars()) {
        Some(mut it) => it.next().is_none(),
        None => false,
    }
}

type I<'a> = std::str::Chars<'a>;

trait Parser: Copy {
    fn parse<'a>(&self, it: I<'a>) -> Option<I<'a>>;
}

#[derive(Copy, Clone)]
struct And<P1: Parser, P2: Parser>(P1, P2);

impl<P1: Parser, P2: Parser> Parser for And<P1, P2> {
    fn parse<'a>(&self, it: I<'a>) -> Option<I<'a>> {
        self.0.parse(it).and_then(|it| self.1.parse(it))
    }
}

#[derive(Copy, Clone)]
struct Or<P1: Parser, P2: Parser>(P1, P2);

impl<P1: Parser, P2: Parser> Parser for Or<P1, P2> {
    fn parse<'a>(&self, it: I<'a>) -> Option<I<'a>> {
        let it1 = it.clone();
        self.0.parse(it).or_else(|| self.1.parse(it1))
    }
}

#[derive(Copy, Clone)]
struct Char(char);

impl Parser for Char {
    fn parse<'a>(&self, mut it: I<'a>) -> Option<I<'a>> {
        match it.next() {
            Some(c) if c == self.0 => Some(it),
            _ => None,
        }
    }
}

#[derive(Copy, Clone)]
struct Opt<P: Parser>(P);

impl<P: Parser> Parser for Opt<P> {
    fn parse<'a>(&self, it: I<'a>) -> Option<I<'a>> {
        self.0.parse(it.clone()).or(Some(it))
    }
}

#[derive(Copy, Clone)]
struct Many<P: Parser>(P);

impl<P: Parser> Parser for Many<P> {
    fn parse<'a>(&self, it: I<'a>) -> Option<I<'a>> {
        let old = it.clone();
        match self.0.parse(it) {
            Some(it) => self.parse(it),
            None => Some(old),
        }
    }
}
