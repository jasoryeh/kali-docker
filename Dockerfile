FROM lscr.io/linuxserver/kali-linux:latest

RUN apt update && apt -y install imhex ghidra openjdk-21-jdk

# Export JDK JAVA_HOME
RUN echo DETECTED_ARCH=$(dpkg --print-architecture)
RUN echo JAVA_HOME=$(cd $(dirname $(realpath $(which java))) && cd ../ && echo $PWD) >> /etc/bash.bashrc

RUN echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
RUN sudo apt-get install wget gpg
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
RUN sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
RUN echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
RUN rm -f packages.microsoft.gpg
RUN apt update && apt -y install apt-transport-https code

