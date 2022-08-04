FROM androidsdk/android-31

WORKDIR /usr
RUN git clone https://github.com/flutter/flutter.git -b stable

ENV FLUTTER_HOME=/usr/flutter/bin
ENV PATH=${FLUTTER_HOME}:${PATH}

RUN flutter upgrade && flutter precache
RUN yes | flutter doctor --android-licenses
RUN flutter doctor -v
