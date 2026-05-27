# AI Invoke

Invoke AI code assistants from inside a container! Keep the genie somewhat in the bottle!

If you are somewhat afraid of letting AI code assistants such as Github Copilot and Claude Code use your computer and damage your file system (`rm -rf`), `ainvoke` is the tool! It creates an [overlayfs](https://docs.kernel.org/filesystems/overlayfs.html) mount of a directory that you the AI to work with and run a container that access this mount. This way, you can let the assistant do the work in a throwaway environment. If the results are good, just push them to some repo, close the container and pull the changes - via version control - to your local directory. If the AI does some naughty thing, you file system shall be safe!

## Using it

First, you'll need [docker](https://www.docker.com). Clone this repo and create a `variables.sh` file with your AI assistant token (see `variables-sample.sh` for a sample), then run `build-container.sh` to\.\.\. build the container. Add the ainvoke directory to your `PATH`, and invoke it:

```bash
$ ainvoke.sh .
```

That will drop you inside a container seeing the same directory passed as argument to `ainvoke.sh`. In it, you can call `copilot` or `claude` to do your work! When finished, exit the container and get back to your original directory, untouched. Remember, if the changes were good, you should've already pushed them to some remote repository, and you can pull them on your local.

## Possible questions

Q: Is this really safe?

A: Of course not! This help prevent accidents that are more like "honest mistakes" by the assistant. If you let it push stuff direct to production, you'll still be doomed. But at least your local directory is fine. And if the AI goes the way of Skynet, containers are not safe - one could argue a VM would be better, but I guess a container is a good compromise.

Q: I don't understand, inside the container there's no `apt` or `dnf` to install stuff.

A: Yeah, I use [Arch](https://archlinux.org), so the container is Arch based. Use `pacman` instead. And `yay` is also installed. And other stuff that I use.

Q: There are some warnings about secrets when I build the container. Why?

A: This is all supposed to run locally, so it doesn't really matter.
