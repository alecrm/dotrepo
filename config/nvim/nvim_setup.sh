#!/usr/bin/env bash

set -euo pipefail

# ------------------------------
# Config
# ------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/nvim_requirements.sh"
INSTALL_OPTIONAL=false
DRY_RUN=false

# ------------------------------
# Functions
# ------------------------------
parse_args() {
  while getopts "od" flag; do
    case "${flag}" in
      o) INSTALL_OPTIONAL=true ;;
      d) DRY_RUN=true ;;
    esac
  done
}

version_gte() {
  # usage: version_gte "0.9" "0.8"
  [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" = "$2" ]
}


ensure_brew() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is not installed. Please install it first: https://brew.sh"
    exit 1
  fi
}

detect_platform() {
  UNAME=$(uname)
  if [[ "$UNAME" == "Linux" ]]; then
    PLATFORM="linux"
  elif [[ "$UNAME" == "Darwin" ]]; then
    PLATFORM="macos"
  else
    echo "Unsupported platform: $UNAME"
    exit 1
  fi
}

install_nvim_linux() {
  echo "Installing Neovim..."
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  tar xzf nvim-linux-x86_64.tar.gz
  sudo mv nvim-linux64 /opt/nvim
  sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
  rm -f nvim-linux-x86_64.tar.gz
}

install_nvim_macos() {
  echo "Installing Neovim..."
  ensure_brew
  brew install neovim
}

check_nvim() {
  echo
  echo "### Neovim ###"
  if ! command -v nvim >/dev/null 2>&1; then
    install_nvim_$PLATFORM
  else
    # Extract installed version
    VERSION=$(nvim --version | head -n1 | sed 's/^NVIM v//' | cut -d. -f1-2)
    REQUIRED="${NEOVIM_VERSION//>=/}"

    if version_gte "$VERSION" "$REQUIRED"; then
      echo "✅ Neovim version OK: $VERSION"
    else
      echo "⚠️  Neovim version too old ($VERSION < $REQUIRED). Upgrading..."
      install_nvim_$PLATFORM
    fi
  fi
}

install_lazygit_linux() {
  LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep tag_name | cut -d '\"' -f4)
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm -f lazygit lazygit.tar.gz
}

install_node_linux() {
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm install node

  echo "Installation complete."
  echo
  echo "To enable nvm in future shell sessions, add the following lines to your shell profile (e.g., ~/.bashrc or ~/.zshrc):"
  echo 'export NVM_DIR="$HOME/.nvm"'
  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm'
}

install_stylua_linux() {
  curl -Lo stylua "https://github.com/JohnnyMorganz/StyLua/releases/latest/download/stylua-linux-x86_64"
  chmod +x stylua
  sudo mv stylua /usr/local/bin/stylua
 
}

install_tool_linux() {
  echo "Installing $1..."
  case "$1" in
    delta)
      sudo apt install -y git-delta || echo "Could not install git-delta with apt. You may need to build from source."
      ;;
    fd)
      sudo apt install -y fdfind
      if ! command -v fd >/dev/null 2>&1; then
        echo "Linking fdfind → fd..."
        sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
      fi
      ;;
    lazygit)
      install_lazygit_linux
      ;;
    node)
      install_node_linux
      ;;
    stylua)
      install_stylua_linux
      ;;
    *)
      sudo apt install -y "$1" || echo "Could not install $1 with apt. You may need to build from source."
      ;;
  esac
}

install_tool_macos() {
  ensure_brew
  brew install "$1" || echo "Could not install $1 with brew."
}

install_tools() {
  if [[ $PLATFORM == "linux" ]]; then
    sudo apt update >/dev/null 2>&1
  fi
  if [[ $PLATFORM == "macos" ]]; then
    brew update >/dev/null
  fi

  echo
  echo "### Required packages ###"
  for tool in "${REQUIRED_TOOLS[@]}"; do
    case "$tool" in
      ripgrep)
        if ! command -v "rg" >/dev/null 2>&1; then
          install_tool_$PLATFORM "$tool"
        else
          echo "✅ $tool already installed."
        fi
        ;;
      *)
        if ! command -v "$tool" >/dev/null 2>&1; then
          install_tool_$PLATFORM "$tool"
        else
          echo "✅ $tool already installed."
        fi
        ;;
    esac
  done

  if $INSTALL_OPTIONAL; then
    echo
    echo "### Optional packages ###"
    for tool in "${OPTIONAL_TOOLS[@]}"; do
      if ! command -v "$tool" >/dev/null 2>&1; then
        install_tool_$PLATFORM "$tool"
      else
        echo "✅ $tool already installed."
      fi
    done
  fi
}

install_font_linux() {
  echo
  echo "### Fonts ###"
  FONT_DIR="$HOME/.local/share/fonts"
  mkdir -p "$FONT_DIR"
  if ! fc-list | grep -i "$FONT_NAME" >/dev/null; then
    echo "Installing $FONT_NAME font..."
    curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
    unzip Meslo.zip -d "$HOME/.local/share/fonts"
    fc-cache -fv "$HOME/.local/share/fonts"
    rm Meslo.zip
  else
    echo "✅ $FONT_NAME already installed."
  fi
}

install_font_macos() {
  echo
  echo "### Fonts ###"
  if ! fc-list | grep -qi "$FONT_NAME"; then
    echo "Installing $FONT_NAME font..."
    brew install --cask font-meslo-lg-nerd-font
  else
    echo "✅ $FONT_NAME already installed."
  fi
}

dry_run_report() {
  echo "🔍 Dry run enabled — no changes will be made."
  echo
  echo "Required tools to be installed:"
  NEEDS_INSTALL=false
  for tool in "${REQUIRED_TOOLS[@]}"; do
    case "$tool" in
      ripgrep)
        if ! command -v "rg" >/dev/null 2>&1; then
          echo "  - $tool (rg not found)"  
          NEEDS_INSTALL=true
        fi
        ;;
      *)
        if ! command -v "$tool" >/dev/null 2>&1; then
          echo "  - $tool"
          NEEDS_INSTALL=true
        fi
        ;;
    esac
  done
  if ! $NEEDS_INSTALL; then
    echo "✅ All required tools are already installed!"
  fi

  if $INSTALL_OPTIONAL; then
    NEEDS_INSTALL=false
    echo
    echo "Optional tools to be installed:"
    for tool in "${OPTIONAL_TOOLS[@]}"; do
      if ! command -v "$tool" >/dev/null 2>&1; then
        echo "  - $tool"
        NEEDS_INSTALL=true
      fi
    done
    if ! $NEEDS_INSTALL; then
      echo "✅ All optional tools are already installed!"
    fi
  fi

  NEEDS_INSTALL=false
  echo
  echo "Neovim:"
  if ! command -v nvim >/dev/null 2>&1; then
    NEEDS_INSTALL=true
    echo "  - Neovim (not installed)"
  else
    VERSION=$(nvim --version | head -n1 | sed 's/^NVIM v//' | cut -d. -f1-2)
    MAJOR=$(echo $VERSION | cut -d. -f1)
    MINOR=$(echo $VERSION | cut -d. -f2)
    if [[ "$MAJOR" -eq 0 && "$MINOR" -lt 9 ]]; then
      NEEDS_INSTALL=true
      echo "  - Neovim (too old: $VERSION)"
    fi
  fi
  if ! $NEEDS_INSTALL; then
    echo "✅ Neovim already installed!"
  fi


  NEEDS_INSTALL=false
  echo
  echo "Font:"
  if ! fc-list | grep -i "$FONT_NAME" >/dev/null; then
    echo "  - $FONT_NAME (not installed)"
    NEEDS_INSTALL=true
  fi
  if ! $NEEDS_INSTALL; then
    echo "✅ Nerd font already installed!"
  fi
}

# ------------------------------
# Run
# ------------------------------
main() {
  echo "Installing Neovim CLI tools..."
  parse_args "$@"
  detect_platform
  
  if $DRY_RUN; then
    dry_run_report
    exit 0
  fi

  check_nvim
  install_tools
  install_font_$PLATFORM
 
  echo
  echo "All packages installed! Neovim is ready to use!"
  echo "Run \`nvim\` to start"
}

main "$@"

