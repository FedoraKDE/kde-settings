#!/bin/sh

qdbus-qt5 org.kde.kuiserver >& /dev/null && \
qdbus-qt5 org.kde.kuiserver /MainApplication org.qtproject.Qt.QCoreApplication.quit

qdbus-qt5 org.kde.kuiserver5 >& /dev/null && \
qdbus-qt5 org.kde.kuiserver5 /MainApplication org.qtproject.Qt.QCoreApplication.quit
