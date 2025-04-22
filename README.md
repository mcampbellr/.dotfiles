## Welcome to my .dotfiles

[stow]: https://www.gnu.org/software/stow/
[homebrew]: https://formulae.brew.sh/formula/stow

Here you can find my dotfiles and configuration settings, to use them you can clone this repo.

```bash
$ git clone https://github.com/mcampbellr/.dotfiles
```

As personal preference i use [stow] to handle my dotfiles, you can read about [stow]
or just install it using [Homebrew] in Macos with the following command:

```bash
$ brew install stow
```

Then you just go to the .dotfiles you just clone and use:

```bash
$ stow */
```

Or any other [stow] command you wanna use.

---

[1]: https://github.com/mcampbellr/.dotfiles/blob/main/zsh/.zshrc#L10
[2]: https://medium.com/@mariocampbellr/c%C3%B3mo-ser-m%C3%A1s-productivo-con-tu-terminal-zsh-en-macos-49e855f5b63b

Here you can find my personal settings so maybe you have to modify some files to make them work for you.
For example the DOTFILES and DEV_FILES environment variables that you gonna find [here][1] as well as the Flutter installation path in same file
or maybe you just want to use your own `zsh` configuration, then you don't need to worry about this, and be sure to delete the `zsh` folder
from the repo you just clone.

## Zsh configuration

I have a blog post where you can learn how to properly set up your `zsh` is made for macos users since is the Os that i use for work and personal projects.

- [How to install ZSH and use it as your default terminal option][2]

... Work in progress
