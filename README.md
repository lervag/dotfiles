# Introduction

This is my personal dotfiles repo.
It relies on [`mise bootstrap`](https://mise.jdx.dev/bootstrap.html).
The `mise` config is split into a bootstrap file `mise.toml` and a global user config `.mise.global.config`.
The latter will be installed to `~/.config/mise/config.toml` and provides the global tools and tasks.

The dotfile entries in `mise.toml` mostly rely on symlinking.
The target `{}` indicates that the target has the same path as the source, whereas `{ mode = "symlink-each" }` is used for directories with multiple targets.

The dotfiles include a utility script `dots` to manage and sync dotfiles across machines.

## TODO

- Convert battery checker systemd units into `bootstrap.linux.systemd`
  https://mise.jdx.dev/bootstrap/systemd.html
- Add `[bootstrap.packages]`? Not sure if it is needed...
