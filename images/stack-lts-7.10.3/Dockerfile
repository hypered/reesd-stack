FROM images.reesd.com/reesd/stack-dependencies:7.10.3

USER gusdev
WORKDIR /home/gusdev
ENV HOME /home/gusdev
RUN /home/gusdev/stack-dependencies/build.sh lts-6.27
CMD ghc-pkg list
