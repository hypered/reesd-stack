FROM images.reesd.com/reesd/stack-dependencies:7.8.4

USER gusdev
WORKDIR /home/gusdev
ENV HOME /home/gusdev
RUN /home/gusdev/stack-dependencies/build.sh
CMD ghc-pkg list
