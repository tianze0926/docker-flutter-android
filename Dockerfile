FROM ubuntu:jammy

RUN apt-get update; \
    apt-get install -y bash curl file git unzip xz-utils zip; \
    useradd --create-home abc
# RUN sed -i "s@http://.*archive.ubuntu.com@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list; \
#     sed -i "s@http://.*security.ubuntu.com@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list; \
#     apt-get update; \
#     apt-get install -y bash curl file git unzip xz-utils zip; \
#     useradd --create-home abc

RUN apt-get install -y openjdk-18-jdk

USER abc

WORKDIR /home/abc/android
ENV PATH=/home/abc/android/cmdline-tools/latest/bin:$PATH
ENV PATH=/home/abc/android/platform-tools:$PATH
RUN curl -o commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip; \
    unzip commandlinetools.zip -d cmdline-tools; \
    rm commandlinetools.zip; \
    mv cmdline-tools/cmdline-tools cmdline-tools/latest; \
    sdkmanager --list; \
    yes | sdkmanager "build-tools;33.0.0" "platforms;android-33" "platform-tools"; \
    yes | sdkmanager --install "cmake;3.22.1" "ndk;25.1.8937393"

WORKDIR /home/abc
RUN git clone -b stable https://github.com/flutter/flutter.git
# RUN git clone -b stable https://mirrors.tuna.tsinghua.edu.cn/git/flutter-sdk.git flutter

ENV PATH=/home/abc/flutter/bin:$PATH
# ENV PUB_HOSTED_URL=https://pub.flutter-io.cn
# ENV FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
RUN flutter upgrade; \
    flutter precache; \
    yes | flutter doctor --android-licenses; \
    flutter doctor -v

CMD ["/bin/bash"]
