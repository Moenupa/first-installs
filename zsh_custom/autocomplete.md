# set up autocomplete with oh-my-zsh

first check `$fpath` and then generate completions for your app:

```
mkdir $ZSH/completions
uv generate-shell-completion zsh > $ZSH/completions/_uv
uvx --generate-shell-completion zsh > $ZSH/completions/_uvx
ruff generate-shell-completion zsh > $ZSH/completions/_ruff
```
