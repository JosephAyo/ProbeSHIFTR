# Use a specific R version (4.2.1) as the base
FROM --platform=linux/amd64 rocker/r-ver:4.2.1

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    bedtools \
    && rm -rf /var/lib/apt/lists/*

# Install AdoptOpenJDK 14 (Eclipse Temurin)
RUN wget https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14.0.2%2B12/OpenJDK14U-jdk_x64_linux_hotspot_14.0.2_12.tar.gz \
    && tar -xvf OpenJDK14U-jdk_x64_linux_hotspot_14.0.2_12.tar.gz -C /opt/ \
    && rm OpenJDK14U-jdk_x64_linux_hotspot_14.0.2_12.tar.gz

# Set environment variables for Java 14
ENV JAVA_HOME=/opt/jdk-14.0.2+12
ENV PATH=$JAVA_HOME/bin:$PATH

# Install BLAT
RUN wget -O blat http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/blat/blat && \
    chmod +x blat && \
    mv blat /usr/local/bin/ && \
    ls -l /usr/local/bin/blat && \
    file /usr/local/bin/blat  # Verify it's a binary

# Set working directory inside the container
WORKDIR /app/jar

# Copy all files into the container
COPY . /app

# Install required R packages
# RUN Rscript -e "install.packages(c('readr', 'data.table', 'rtracklayer', 'GenomicRanges', 'IRanges', 'tidyr', 'seqinr', 'ggplot2'), repos='http://cran.rstudio.com/')"
