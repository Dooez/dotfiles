if status is-interactive
    # Commands to run in interactive sessions can go here
end
set fish_greeting
starship init fish | source
zoxide init fish | source

# Created by `pipx` on 2024-06-03 11:52:37
set PATH $PATH /home/timofey/.local/bin
fish_add_path /home/timofey/.cargo/bin
