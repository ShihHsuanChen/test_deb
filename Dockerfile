FROM ubuntu:18.04

ENV DEB_NAME="mycalc_0.0.1_amd64.deb"
COPY dist_wizard/$DEB_NAME /home/

ENV DEB_PATH="/home/$DEB_NAME"
RUN chmod a+rwx $DEB_PATH
RUN dpkg -i $DEB_PATH
WORKDIR /home/

CMD ["MyCalc", "-n", "5", "6", "7"]
