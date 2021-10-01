
### EXPORT ###
set fish_greeting                      # Supresses fish's intro message
set EDITOR "nvim"      # $EDITOR use Nvim in terminal

### SET EITHER DEFAULT EMACS MODE OR VI MODE ###
function fish_user_key_bindings
  fish_default_key_bindings
  # fish_vi_key_bindings
end
### END OF VI MODE ###

### AUTOCOMPLETE AND HIGHLIGHT COLORS ###
set fish_color_normal brcyan
set fish_color_autosuggestion '#7d7d7d'
set fish_color_command brcyan
set fish_color_error '#ff6c6b'
set fish_color_param brcyan


### FUNCTIONS ###

# Run last command as root
function please
        eval command sudo $history[1]
end

#Remove unused packages
function cleanup
         eval command sudo pacman -Rns (pacman -Qtdq) ; yay -c ; sudo pacman -Scc ; sudo rm -rf ~/.cache/* ; sudo journalctl --vacuum-size=50M
end

# Function for creating a backup file
# ex: backup file.txt
# result: copies file as file.txt.bak
function backup --argument filename
    cp $filename $filename.bak
end

#su into fish
function su
   command su -c "HOME=$HOME /usr/bin/fish"
end

#resotre backup file to orig name
function restore --argument file
    mv $file (echo $file | sed s/.bak//)
end

#create a directory and cd into it
function mkdircd
    mkdir $argv && cd $argv
end

#Test if file exists
function file-exists --argument file
    test -e $file
end

### ALIASES ###
alias nvim='sudoedit'
alias semacs='sudoedit'
alias doom='~/.emacs.d/bin/doom'
alias todo='~/Dotfiles/Scripts/todo.sh'
alias ks='ls'
alias wumount="sudo umount /dev/nvme0n1p3"
alias wmount="sudo mount /dev/nvme0n1p3 /mnt/Windows" 
alias cupdate="/home/keb/Dotfiles/Scripts/recentlyinstalled.sh"
alias pfetch='curl https://raw.githubusercontent.com/dylanaraps/pfetch/master/pfetch | sh'
alias reloadx='xrdb $XDG_DATA_HOME/.Xresources'
alias update='yay -Syyuu'
alias shutdown='shutdown now'
alias scrot='scrot ~/Pictures/Screenshots/%b%d::%H%M%S.png'
alias polkitpass='exec /usr/bin/lxsession'
alias music='mocp'
alias ...='cd ../../'
alias ....='cd ../../../'
alias ..='cd ..'
alias stow="sudo stow"
alias ls='exa -al --color=always --group-directories-first'
alias lsh='exa -a --color=always --group-directories-first'
alias hibernate='sudo systemctl suspend'
alias tree="tree -a"
alias mkdir="mkdir -p"
alias mkdircp="cp --parents"
alias cp="cp -ri"
alias mv='mv -i'
alias rm='rm -i'
alias yeet='rm -i'
alias mocp='mocp -M /home/keb/SYSTEM/.config/moc'
alias nvidia-settings='nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings'
alias ranger="/path/to/bin/ranger ; rm -rf ~/.cache"
## BINDINGS ###
bind -k btab accept-autosuggestion execute
bind \t complete

