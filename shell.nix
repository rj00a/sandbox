with import <nixpkgs> {};
stdenv.mkDerivation {
    name = "rust-env";
    buildInputs = [ lldb pkg-config ];
}
