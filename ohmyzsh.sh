#!/usr/bin/env bash
# file: ohmyzsh.sh
# Revised script to correctly install OMZ to custom location and handle .zshrc

# Exit immediately if a command exits with a non-zero status.
# Treat unset variables as an error when substituting.
# Pipelines return the exit status of the last command to exit non-zero.
set -euo pipefail

# --- Helper Functions ---
highlight()  { echo -e "\n\033[1m\033[43m$1\033[0m"; }
ehighlight() { echo -e "\033[1m\033[41m ERROR: $1 \033[0m" >&2; } # Print errors to stderr

# --- Configuration Variables ---
# Target directory for Oh My Zsh installation
OMZ_DIR="$HOME/.config/oh-my-zsh"
# Target directory for Zsh configuration files (.zshrc, etc.)
ZDOTDIR_PATH="$HOME/.config/zsh"
# Full path to the target .zshrc file
ZSHRC_PATH="$ZDOTDIR_PATH/.zshrc"
# Font download URL
NERDFONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip"
NERDFONT_ZIP="Hack.zip"

# --- SUDO Handling ---
# Check if SUDOPASS is set and not empty, otherwise use standard sudo
if [[ -n "${SUDOPASS:-}" ]]; then
    SUDO_CMD="echo \"$SUDOPASS\" | sudo -S --" # Use -- to separate sudo options from the command
else
    SUDO_CMD="sudo"
fi

# Function to run commands with sudo correctly
run_sudo() {
    echo "Executing: $SUDO_CMD $@"
    if [[ -n "${SUDOPASS:-}" ]]; then
        # Use bash -c to handle potential complex commands with pipes/quotes correctly
        bash -c "echo \"$SUDOPASS\" | sudo -S -- $*"
    else
        sudo "$@"
    fi
}

# --- Installation Steps ---

highlight "<<< Installing Zsh and prerequisites >>>"
run_sudo apt update || { ehighlight "apt update failed"; exit 1; }
# Note: zsh-autosuggestions/syntax-highlighting from apt might conflict if OMZ also manages them.
# OMZ method is generally preferred. Installing zsh, git, curl, wget, unzip is sufficient.
run_sudo nala install -y zsh git curl wget unzip || {
    ehighlight "Failed to install prerequisites (zsh, git, curl, wget, unzip)."
    exit 1
}

highlight "<<< Cleaning up potential old files >>>"
# Remove potential leftovers from previous attempts or default configs
rm -rf "$OMZ_DIR" "$ZDOTDIR_PATH" ~/.zshrc ~/.zshrc.pre-oh-my-zsh ~/.zshenv 2>/dev/null || true

highlight "<<< Installing Oh My Zsh to $OMZ_DIR >>>"
# IMPORTANT: Remove KEEP_ZSHRC=yes. Let the installer create/overwrite ~/.zshrc.
# Use --unattended to prevent the installer from prompting to change the shell or run zsh.
ZSH="$OMZ_DIR" RUNZSH=no \
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || {
    ehighlight "Oh My Zsh installation script failed."
    exit 1
}

# Verify that the installer created the default ~/.zshrc
if [ ! -f "$HOME/.zshrc" ]; then
    ehighlight "OMZ installer did not create $HOME/.zshrc as expected."
    exit 1
fi

highlight "<<< Setting up ZDOTDIR and moving .zshrc >>>"
# Create the target directory for Zsh config files
mkdir -p "$ZDOTDIR_PATH" || { ehighlight "Failed to create $ZDOTDIR_PATH"; exit 1; }

# Configure Zsh to look for config files in $ZDOTDIR_PATH
echo "export ZDOTDIR=\"$ZDOTDIR_PATH\"" > ~/.zshenv || { ehighlight "Failed to write to ~/.zshenv"; exit 1; }
echo ".zshenv created pointing ZDOTDIR to $ZDOTDIR_PATH"

# Move the .zshrc created by OMZ to the ZDOTDIR location
mv "$HOME/.zshrc" "$ZSHRC_PATH" || { ehighlight "Failed to move ~/.zshrc to $ZSHRC_PATH"; exit 1; }
echo "Moved OMZ default .zshrc to $ZSHRC_PATH"

highlight "<<< Patching $ZSHRC_PATH for custom ZSH location >>>"
# The OMZ template likely has 'export ZSH="$HOME/.oh-my-zsh"'. We need to change it.
# Using double quotes around $OMZ_DIR in sed replacement to allow variable expansion. Use a different sed delimiter (#) to avoid issues with paths containing /.
sed -i 's#^export ZSH=.*#export ZSH="'"$OMZ_DIR"'"#' "$ZSHRC_PATH" || {
    ehighlight "Failed to patch ZSH variable in $ZSHRC_PATH"
    exit 1
}
# The ZSH_CUSTOM variable is typically derived automatically by OMZ,
# but you can uncomment the next lines to set it explicitly if needed.
# echo "export ZSH_CUSTOM=\"\$ZSH/custom\"" >> "$ZSHRC_PATH"
echo "Patched ZSH path in $ZSHRC_PATH"

highlight "<<< Cloning Zsh plugins into custom location >>>"
# Define ZSH_CUSTOM based on the actual OMZ directory for clarity
ZSH_CUSTOM="$OMZ_DIR/custom"
mkdir -p "$ZSH_CUSTOM/plugins" # Ensure the custom plugins directory exists

# Clone plugins (add --depth 1 for faster clones)
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" || echo "Warning: Failed to clone zsh-autosuggestions" &
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" || echo "Warning: Failed to clone zsh-syntax-highlighting" &
git clone --depth 1 https://github.com/zdharma-continuum/fast-syntax-highlighting "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" || echo "Warning: Failed to clone fast-syntax-highlighting" &
git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete "$ZSH_CUSTOM/plugins/zsh-autocomplete" || echo "Warning: Failed to clone zsh-autocomplete" &
wait # Wait for all background git clones to finish

highlight "<<< Installing Nerd Font (Hack) >>>"
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
echo "Downloading $NERDFONT_ZIP..."
wget -O "$FONT_DIR/$NERDFONT_ZIP" "$NERDFONT_URL" || { ehighlight "Failed to download Nerd Font"; exit 1; }

echo "Extracting font..."
# Use a subshell to avoid changing the script's working directory
(
    cd "$FONT_DIR"
    unzip -o "$NERDFONT_ZIP" || { ehighlight "Failed to unzip Nerd Font"; exit 1; }
    rm -f "$NERDFONT_ZIP" # Use -f to ignore error if file doesn't exist
    echo "Updating font cache..."
    fc-cache -fv
)

highlight "<<< Installing icons-in-terminal >>>"
ICONS_DIR="$HOME/icons-in-terminal"
if [ ! -d "$ICONS_DIR" ]; then
    echo "Cloning icons-in-terminal..."
    git clone --depth 1 https://github.com/sebastiencs/icons-in-terminal.git "$ICONS_DIR" || { ehighlight "Failed to clone icons-in-terminal"; exit 1; }
else
    echo "icons-in-terminal already cloned."
fi
# Use a subshell for installation
(
    cd "$ICONS_DIR"
    echo "Running icons-in-terminal installer..."
    # The installer might need bash specifically
    bash ./install-autodetect.sh || { ehighlight "icons-in-terminal installation failed"; exit 1; }
)

highlight "<<< Setting Zsh as default shell >>>"
if command -v zsh >/dev/null 2>&1; then
    zsh_path=$(command -v zsh)
    current_shell=$(getent passwd "$(whoami)" | cut -d: -f7)

    if [ "$current_shell" != "$zsh_path" ]; then
        echo "Changing default shell to $zsh_path for user $(whoami)..."
        # Use run_sudo function for changing shell
        run_sudo chsh -s "$zsh_path" "$(whoami)" || {
            ehighlight "Failed to change default shell via chsh. Manual change may be needed."
            # Don't exit; the rest of the setup might still be valuable.
        }
    else
        echo "Zsh ($zsh_path) is already the default shell."
    fi
else
    ehighlight "Zsh command not found even after installation attempt!"
    exit 1
fi

highlight "✅ Done."
echo "Please close and reopen your terminal or run 'exec zsh' for changes to take full effect."
echo "Remember to configure your terminal emulator (e.g., Terminator) to use the 'Hack Nerd Font'."