FROM debian:jessie

ENV NAME askapsoft

# This line instructs debconf to store in its database an answer for the program
# debconf. If (the running program) debconf later asks (the database of answers)
# debconf what is my frontend the answer will be frontend is Noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install system packages
RUN apt-get update && apt-get install -y \
  vim-gtk git sudo linux-headers-amd64 unzip bzip2 build-essential gcc g++ \
  gfortran openjdk-7-jdk openjdk-7-doc libfreetype6-dev libpng12-dev python-dev \
  python3-dev autoconf meld subversion python-gpgme libzmq3 libzmq3-dev \
  python3-dev exuberant-ctags tree clang-format-3.5 astyle autoconf subversion \
  scons flex bison ant ant-optional unzip bzip2 build-essential gcc g++ \
  gcc-4.9-plugin-dev gfortran openjdk-7-jdk openmpi-bin libopenmpi-dev \
  libfreetype6-dev libpng12-dev python-dev libatlas-base-dev libatlas-dev \
  libblas-dev liblapack-dev libjpeg62-turbo-dev  \
  #x11-apps \
&& rm -rf /var/lib/apt/lists/*

# Create the askap user, with sudo permissions
RUN adduser askapuser
RUN echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/askapuser && \
    chmod 0440 /etc/sudoers.d/askapuser
WORKDIR /home/askapuser

# Set up the home directory and mount point
ADD . /home/askapuser
RUN mkdir /home/askapuser/askapsoft
RUN chown -R askapuser:askapuser /home/askapuser
VOLUME /home/askapuser/askapsoft

USER askapuser

# Set the DISPLAY variable so I can run GUI apps inside the container.
# See: https://stackoverflow.com/questions/16296753/can-you-run-gui-apps-in-a-docker-container/25280523#25280523
ENV DISPLAY :0

# Update Vim plugins
ENV TERM xterm
#RUN echo | echo | vim +qall
#RUN echo | echo | vim +PluginInstall! +qall

