FROM ubuntu:15.10

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y language-pack-en
RUN update-locale LANG=en_US.UTF-8

RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y ghc cabal-install
RUN apt-get install -q -y git

# Dependencies for some Haskell packages
RUN apt-get install -q -y libpq-dev
RUN apt-get install -q -y libssl-dev
RUN apt-get install -q -y zlib1g-dev

RUN useradd -s /bin/bash -m gusdev

ADD . /home/gusdev/stack-dependencies
RUN chown -R gusdev:gusdev /home/gusdev/stack-dependencies

USER gusdev
WORKDIR /home/gusdev
ENV HOME /home/gusdev
ENV PATH /home/gusdev/.cabal/bin:$PATH
CMD /home/gusdev/stack-dependencies/build.sh
