function install_logger
    set_color ECEB7B
    echo "$argv[1]"
    set_color normal
end

function update_keyring
    install_logger "[Update keyring]"
    sudo pacman-key --init
    sudo pacman-key --populate archlinux
    sudo pacman -Sy
    sudo pacman -S --needed archlinux-keyring
    return $status
end

function install_aur_helper
    install_logger "[Install aur helper]"
    sudo pacman -S --needed base-devel rustup
    rustup default nightly
    if not command -sq paru
        echo 'Paru is not installed. Do you wanna install it? [Y/n]'
        read answer
        # If the answer is yes or empty, install paru
        if test -z "$answer" -o "$answer" = Y -o "$answer" = y
            git clone https://aur.archlinux.org/paru.git /tmp/paru
            cd /tmp/paru
            makepkg -si
        end
    else
        echo "Paru was installed."
    end
end

function install_general_applications
    install_logger "[Install general applications]"
    paru -S --needed \
        git fish vim neovim \
        htop neofetch lsb-release openssh \
        wget curl openssh rsync wl-clipboard \
        unzip unarchiver xdg-user-dirs \
        pipewire pipewire-pulse lib32-pipewire wireplumber \
        ffmpeg flatpak firefox caprine
    return $status
end

function install_dev_tools
    install_logger "[Install development tools]"
    paru -S --needed base-devel clang \
        python python-pip dbus-python python-gobject \
        lua luajit
    return $status
end

function install_lsp
    install_logger "[Install language server]"
    paru -S --needed tree-sitter ripgrep
    paru -S --needed \
        astyle \
        bash-language-server \
        clang \
        cmake-language-server \
        lua-language-server \
        pyright \
        rust-analyzer \
        slint-lsp-bin \
        stylua \
        typescript-language-server \
        vscode-css-languageserver \
        vscode-json-languageserver \
        yamlfmt
    return $status
end

function install_fonts
    install_logger "[Install fonts]"
    paru -S --needed \
        ttf-jetbrains-mono-nerd \
        ttf-liberation \
        noto-fonts-cjk \
        noto-fonts-emoji \
        otf-codenewroman-nerd \
        ttf-cascadia-code-nerd
    return $status
end

function install_input_method
    install_fonts "[Install input method]"
    paru -S --needed fcitx5-im fcitx5-bamboo
    echo "QT_IM_MODULE=fcitx" | sudo tee -a /etc/environment
    echo "XMODIFIERS=@im=fcitx" | sudo tee -a /etc/environment
    echo "SDL_IM_MODULE=fcitx" | sudo tee -a /etc/environment
    echo "GLFW_IM_MODULE=ibus" | sudo tee -a /etc/environment
end

function install_other_services
    install_logger "[install bluetooth service]"
    echo "Do you wanna install bluetooth? [y/N]"
    read answer
    if test "$answer" = Y -o "$answer" = y
        paru -S --needed bluez bluez-utils blueman
        systemctl enable --now bluetooth
    end

    install_logger "[install iwd service]"
    echo "Do you wanna install iwd? [y/N]"
    read answer
    if test "$answer" = Y -o "$answer" = y
        paru -S --needed iwd
        sudo systemctl enable --now iwd
    end
end

function pacman_clean_up
    install_logger "[Clean up]"
    sudo pacman -Rns (pacman -Qdttq)
end

function clone_dotfiles
    install_logger "[Clone dotfiles]"
    echo "Do you want to clone dotfiles? [Y/n] "
    read answer
    if test -z "$answer" -o "$answer" = Y -o "$answer" = y
        rm -rf $HOME/.dotfiles
        git clone https://github.com/lulkien/dotfiles.git $HOME/.dotfiles
        echo "Please run the setup script in $HOME/.dotfiles"
    end
end