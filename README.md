# Dotfiles Repo
Repo containing dot files and general dev environment files.

Legerage [GNU Stow](https://www.gnu.org/software/stow/) for symlink management.

Files and directories that begin with a dot are prefixed with `dot-` instead, and the `--dotfiles` flag is used to have `stow` alter them back. This is so the contents of the repository (or certain directories) are not completely hidden.

# Setup
- Create a dot-aliases.local in the `shells` folder. This is where you will add your local aliases that you don't want tracked in the repo (job-specific stuff, for example).
- Create a dot-gitconfig.local in the `git` folder. This is where you will add machine-specific git configs.
- Create a dot-functions.local in the `shells` folder. This is where you can add local functions you want to use.
- Create a config.local file in the `ssh/dot-ssh` folder. This is where you can keep personal, local ssh configs.

# Examples
- `$ stow -t ~ --dotfiles git` (Creates symlinks to all dot-files/directories in the git directory)
- `$ stow -v5 -t ~/.config --dotfiles -d i3status dot-config`
