# Imagen para VsCodium (VsCode sin seguimiento)
FROM debian:buster-slim
MAINTAINER Luis GL <luisgulo@gmail.com>
# Todo actualizado
RUN apt -y update; apt -y upgrade
RUN apt -y install apt-transport-https wget gpg locales libgtk-3-0 libx11-xcb1 libdbus-glib-1-2 libxt6 libasound2 git
# Locales para es_ES
RUN sed -i '/es_ES.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG es_ES.UTF-8  
ENV LANGUAGE es_ES:es  
ENV LC_ALL es_ES.UTF-8
# Repositorio para VsCodium 
RUN wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | apt-key add -
RUN echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | tee --append /etc/apt/sources.list.d/vscodium.list 
RUN apt -y update && apt -y install codium && apt clean
# Usuario editor
RUN GID=1000; UID=1000; UNAME=vscodium; mkdir -p /home/$UNAME; echo "$UNAME:x:${UID}:${GID}:Developer,,,:/home/$UNAME:/bin/bash" >> /etc/passwd; echo "$UNAME:x:${UID}:" >> /etc/group; chown ${UID}:${GID} -R /home/$UNAME
RUN mkdir -p /home/vscodium/proyecto
RUN chown -R vscodium:vscodium /home/vscodium/proyecto
COPY arranque/vscodium.sh /home/vscodium/vscodium.sh
RUN  chmod +x /home/vscodium/vscodium.sh
USER vscodium
ENV HOME=/home/vscodium
WORKDIR /home/vscodium
# Incluimos extensiones y config
ADD extensiones/.config     /home/vscodium/.
ADD extensiones/.vscode-oss /home/vscodium/.
# Listo para Editar...
env SHELL /bin/bash
WORKDIR /home/vscodium
#CMD ["/usr/bin/codium"]
entrypoint ["/home/vscodium/vscodium.sh"]
