# Extract the derivations closure from a flake

The concept of flake closure is not well defined (as far as I know), here I mean the union of all of
the derivations in a flake outputs.

This flake provides a new utilty that, given a flake, returns a derivation that produces a file
containing (and referencing!) all the derivations between outputs.  Notice that the outputs names
list, by default, contains the usual outputs (e.g. `packages`, `devShells`, `checks`, ...).

Also it will consider derivations only for a single fixed `system` which, by default, is the same from
the package set where the utility is intanced.

For ease of implementation it ignores the case where these outputs contains attributes sets containing
derivations i.e. it only considers derivations "at first level" like `packages.x86_64-linux.hello`.


## Usage

Running

```bash
nix run github:aciceri/flake-closure
```

will show you a list of all the output paths for in the flake closure of the flake
`github:NixOS/patchelf`.

You can use a different flake with the following the command:

```bash
nix run github:aciceri/flake-closure --override-input demo-flake "flakeRef"
```
