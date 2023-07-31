#!/usr/bin/fish

# Remove old nchad if possible
echo "Do you want to remove old nvim config? [y/N]"
read answer
if test "$answer" = "y" -o "$answer" = "Y"
    rm -rf ~/.config/nvim
    rm -rf ~/.local/share/nvim
end

# Clone new nvchad
 git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
