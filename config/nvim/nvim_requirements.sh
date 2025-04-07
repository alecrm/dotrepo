# === Neovim ===
# neovim>=0.9          # Neovim core (required)
NEOVIM_VERSION=">=0.9"


# === Required CLI Tools ===
# fd                   # Used by Telescope for file discovery (use 'fd-find' on Debian/Ubuntu)
# git                  # Required for gitsigns.nvim, diffview.nvim, lazy.nvim plugin management
# make                 # Required to build native Telescope FZF extension (telescope-fzf-native)
# node                 # Required by some language servers (e.g., tsserver)
# ripgrep              # Required for Telescope's :live_grep and similar fuzzy search
REQUIRED_TOOLS=(
  fd
  git
  make
  node
  ripgrep
)


# === Optional ===
# bat                  # Pretty file viewer used by Telescope and bat previewers
# delta                # Enhances git diffs, useful in lazygit and diffview.nvim
# eza                  # Enhanced ls replacement (nice for previews or custom integrations)
# fzf                  # Optional fuzzy finder for backup/compat with Telescope
# htop                 # Useful for launching inside toggleterm
# lazygit              # Used with toggleterm.nvim for terminal Git UI
# stylua               # Lua code formatter that can be used with null-ls.nvim, etc.
OPTIONAL_TOOLS=(
  bat
  delta
  eza
  fzf
  htop
  lazygit
  stylua
)


# === Fonts ===
# MesloLGS             # Nerd Font for proper UI rendering in terminal + Neovim
FONT_NAME="MesloLGS NF"
FONT_FILE="MesloLGSNerdFont-Regular.ttf"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"

