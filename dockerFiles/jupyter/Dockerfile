FROM jupyter/all-spark-notebook

USER root

# Gnu plot
RUN apt-get update && apt-get install -yq --no-install-recommends \
    gnuplot \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN  pip install --no-cache-dir gnuplot_kernel && \
    rm -rf /home/$NB_USER/.local && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER


# PHP 7
RUN apt-get update && apt-get install -yq --no-install-recommends \
    php \
    php-zmq \
    composer \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

RUN curl -o /tmp/jupyter-php-installer.phar  https://litipk.github.io/Jupyter-PHP-Installer/dist/jupyter-php-installer.phar && \
    echo "starting installer..." && \
    php /tmp/jupyter-php-installer.phar install -vvv && \
    rm /tmp/jupyter-php-installer.phar

USER $NB_UID