# DO NOT EDIT FILES CALLED 'Dockerfile'; they are automatically
# generated. Edit 'Dockerfile.in' and generate the 'Dockerfile'
# with the 'rake' command.

# The suggested name for this image is: bioconductor/devel_base.

FROM rocker/rstudio-daily

# FIXME? in release, default CRAN mirror is set to rstudio....should it be fhcrc?

MAINTAINER dtenenba@fredhutch.org

# nuke cache dirs before installing pkgs; tip from Dirk E fixes broken img
RUN  rm -f /var/lib/dpkg/available && rm -rf  /var/cache/apt/*


# temporarily (?) change mirror used
RUN sed -i.bak 's!http://httpredir.debian.org/debian jessie main!http://mirrors.kernel.org/debian jessie main!' /etc/apt/sources.list


RUN apt-get update --fix-missing && \
    apt-get -y -t unstable install gdb libxml2-dev python-pip
    # valgrind

RUN pip install awscli



RUN apt-get -y -t unstable install --fix-missing \
    texlive texinfo  texlive-fonts-extra texlive-latex-extra




# There should only be one version of R on this container
#RUN dpkg --purge --force-depends r-base-core
# FIXME figure out how to REALLY remove r-base-core and deps
# so that it does not come back.

RUN rm -rf /usr/lib/R/library /usr/bin/R /usr/bin/Rscript



RUN apt-get remove -y libfreetype6; echo "ignoring return value"


RUN cd /tmp && \
svn co https://svn.r-project.org/R/branches/R-3-3-branch R \
  && cd R \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
                libblas-dev \
                libbz2-dev  \
                libcairo2-dev \
                libfontconfig1-dev \
                libfreetype6-dev \
                libglib2.0-dev \
                libjpeg-dev \
                liblapack-dev  \
                liblzma-dev \
                libncurses5-dev \
                libpango1.0-dev \
                libpcre3-dev \
                #libpng12-dev \
                libreadline-dev \
                libtiff5-dev \
                libxft-dev \
                libxt-dev \
                r-base-dev \
                tcl8.6-dev \
                texlive-base \
                texlive-fonts-recommended \
                texlive-generic-recommended \
                texlive-latex-base \
                texlive-latex-recommended \
                tk8.6-dev && \
    R_PAPERSIZE=letter \
                R_BATCHSAVE="--no-save --no-restore" \
                R_BROWSER=xdg-open \
                PAGER=/usr/bin/pager \
                PERL=/usr/bin/perl \
                R_UNZIPCMD=/usr/bin/unzip \
                R_ZIPCMD=/usr/bin/zip \
                R_PRINTCMD=/usr/bin/lpr \
                LIBnn=lib \
                AWK=/usr/bin/awk \
                CFLAGS=$(R CMD config CFLAGS) \
                CXXFLAGS=$(R CMD config CXXFLAGS) \
                ./configure --prefix=/usr/local --enable-R-shlib \
                        --without-blas \
                        --without-lapack \
                        --with-readline \
                        --without-recommended-packages \
                        --program-suffix=dev && \
                make  && \
                make install && \
          cd / && \
          rm -rf /tmp/R /tmp/downloaded_packages/ /tmp/*.rds \
  && echo "R_LIBS=\${R_LIBS-'/usr/local/lib/R/site-library:/usr/local/lib/R/library:/usr/lib/R/library'}" >> /usr/local/lib/R/etc/Renviron \
    && echo 'options("repos"="http://cran.rstudio.com")' >> /usr/local/lib/R/etc/Rprofile.site
RUN dpkg --purge  \
                libblas-dev \
                libbz2-dev  \
                libcairo2-dev \
                libfontconfig1-dev \
                libfreetype6-dev \
                libglib2.0-dev \
                libjpeg-dev \
                liblapack-dev  \
                liblzma-dev \
                libncurses5-dev \
                libpango1.0-dev \
                libpcre3-dev \
               # libpng12-dev \
                libreadline-dev \
                libtiff5-dev \
                libxft-dev \
                libxt-dev \
                r-base-dev \
                tcl8.6-dev \
                texlive-base \
                texlive-fonts-recommended \
                texlive-generic-recommended \
                texlive-latex-base \
                texlive-latex-recommended  ; \
                echo "ignoring return value"
RUN apt-get autoremove -qy



RUN dpkg --purge --force-depends r-base-core
RUN rm -rf /usr/lib/R/library /usr/bin/R /usr/bin/Rscript



### naechste 3 sachen waren nicht auskommentiert. Fehler irgendwo im ADD
#ADD install.R /tmp/

#RUN R -f /tmp/install.R && \
  #  echo "library(BiocInstaller)" > $HOME/.Rprofile
 
 #Fehler dann:
#Step 15 : RUN R         install.packages("devtools")
 #---> Running in e8c5d8103c1c
#/bin/sh: 1: Syntax error: "(" unexpected
#The command '/bin/sh -c R       install.packages("devtools")' returned a non-zero code: 2


RUN R -e	"install.packages('devtools');library(devtools);source('https://bioconductor.org/biocLite.R');biocLite('pcaMethods', ask=FALSE);install.github('mongosoup/rmongodb');install.github('stanstrup/Rplot.extra');install.github('stanstrup/massageR');install.github('stanstrup/PredRet', subdir='PredRetR')"
#RUN R -e "library(devtools)"
#RUN R -e			"source('https://bioconductor.org/biocLite.R')"
#RUN R -e			"biocLite('pcaMethods', ask=FALSE)"
#RUN R -e			"install.github('mongosoup/rmongodb')"
#RUN R -e			"install.github('stanstrup/Rplot.extra')"
#RUN R -e			"install.github('stanstrup/massageR')"
#RUN R -e			"install.github('stanstrup/PredRet', subdir='PredRetR')"