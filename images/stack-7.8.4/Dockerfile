FROM images.reesd.com/reesd/stack-dependencies:7.8.4

USER gusdev
WORKDIR /home/gusdev
ENV HOME /home/gusdev
RUN /home/gusdev/stack-dependencies/build.sh ghc-7.8.4
CMD ghc-pkg list
