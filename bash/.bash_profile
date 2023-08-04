# Suppress shell recommendation prompts
export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH="/Users/leeren/Library/Python/3.8/bin:$PATH"


# Source $HOME/.profile for generic shell settings.
if [[ -f "$HOME/.profile" ]]; then
  . "$HOME/.profile"
fi

# If shell options indicate use of non-interactive mode, do nothing.
# if [[ ! $- =~ 'i' ]]; then
# 	return
# fi

# Source .bashrc since we're running in interactive mode.
if [[ -f "$HOME/.bashrc" ]]; then
  . "$HOME/.bashrc"
fi

# Source all the bash aliases.
if [[ -f "$HOME/.bash_aliases" ]]; then
  . "$HOME/.bash_aliases"
fi
. "$HOME/.cargo/env"

complete -C /usr/local/bin/terraform terraform
