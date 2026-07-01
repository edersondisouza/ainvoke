FROM archlinux:multilib-devel AS ainvoke

ARG USER
ARG USER_ID
ARG GROUP
ARG GROUP_ID
ARG CLAUDE_CODE_OAUTH_TOKEN
ARG COPILOT_GITHUB_TOKEN

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm git vim screen python-pip cmake wget ninja \
    dtc tig less bash-completion

RUN python -m venv /venv && \
    source /venv/bin/activate && \
    pip install --upgrade pip && \
    pip install west

RUN groupadd -g ${GROUP_ID} ${GROUP} && \
    useradd -rm -d /home/${USER} -s /bin/bash -g ${GROUP} -G wheel -u ${USER_ID} ${USER}

RUN echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "Defaults env_keep += \"http_proxy https_proxy HTTP_PROXY HTTPS_PROXY\"" >> /etc/sudoers

USER ${USER}

RUN sudo chown -R ${USER}:${GROUP} /venv

RUN mkdir ~/yay && \
    pushd ~/yay && \
    wget -O PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=yay && \
    makepkg --noconfirm -si && \
    popd

RUN yay --noconfirm -S zig0.15-bin

RUN curl -fsSL https://claude.ai/install.sh | bash
RUN curl -fsSL https://gh.io/copilot-install | bash

# Work around a Claude Code bug where CLAUDE_CODE_OAUTH_TOKEN is ignored
# unless onboarding is marked complete in ~/.claude.json.
RUN python -c "import json, os; p = os.path.expanduser('~/.claude.json'); d = json.load(open(p)) if os.path.exists(p) else {}; d['hasCompletedOnboarding'] = True; json.dump(d, open(p, 'w'))"

ENV PATH=${PATH}:/home/${USER}/.local/bin
ENV CLAUDE_CODE_OAUTH_TOKEN=${CLAUDE_CODE_OAUTH_TOKEN}
ENV COPILOT_GITHUB_TOKEN=${COPILOT_GITHUB_TOKEN}
