# zsh setup

```sh
tar xf zsh.tar.xz
cd zsh-*
```

```sh
# after cd into unzipped zsh-*/ e.g. zsh-5.9/
./configure --prefix=$HOME/.local/ # or $HOME/bin; remember to add to path
make
make install
```
