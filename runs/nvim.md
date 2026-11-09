# nvim

Builds and installs Neovim from source.

- source: `~/.local/src/neovim`
- installed binary: `~/.local/bin/nvim`

## Usage

```bash
./runs/nvim
```

## Behavior

Safe to re-run (idempotent):

- skips Xcode CLT install if already present
- `git clone` only if `~/.local/src/neovim` doesn't exist yet, otherwise
  pulls latest and rebuilds

## Dependencies

- Xcode Command Line Tools
- `ninja`, `cmake`, `gettext`, `curl` (via Homebrew)

Reference: [neovim/BUILD.md](https://github.com/neovim/neovim/blob/master/BUILD.md)
(see "macOS / Homebrew" section)

## Troubleshooting

### Stale `.deps/` cache

CMake complains about mismatched source/cache after an interrupted run.
Delete it:
- single dependency: `rm -rf ~/.local/src/neovim/.deps/<dependency>`
- everything: `rm -rf ~/.local/src/neovim/.deps`

### Homebrew library shadowing a bundled dependency

Build fails with errors like "no member named ... in 'struct ...'". It means that a
Homebrew-installed library (e.g. `utf8proc`, pulled in as a dependency of
another formula like `tmux`) is shadowing neovim's bundled copy of the same
library.

On a Mac, `cc` gives `/usr/local/include` a higher priority
than the `-isystem` paths the build passes for the bundled deps. 

The solution was to explicitly specify the nvim `$src_dir/.deps/usr/include` path via the 
`CMAKE_EXTRA_FLAGS`:

```bash
CMAKE_EXTRA_FLAGS="-DCMAKE_C_FLAGS=-I$src_dir/.deps/usr/include"
```

### CMake config changes not taking effect

After changing `CMAKE_EXTRA_FLAGS` or other build flags, the build keeps
using the old configuration. The Makefile skips reconfiguring if
`build/.ran-cmake` already exists from a previous run. 

Force a reconfigure:
- `rm ~/.local/src/neovim/build/.ran-cmake`
- or, more thoroughly: `rm -rf ~/.local/src/neovim/build`
