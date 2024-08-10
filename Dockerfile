FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
	autoconf automake build-essential cmake git-core libass-dev libfreetype6-dev \
	libgnutls28-dev libmp3lame-dev libsdl2-dev libtool libva-dev libvdpau-dev libvorbis-dev \
	libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev meson ninja-build pkg-config texinfo wget \
	yasm zlib1g-dev nasm libx264-dev libx265-dev libnuma-dev libvpx-dev \
	libfdk-aac-dev libopus-dev libdav1d-dev libaom-dev libtheora-dev \
 	libunistring-dev libchromaprint-dev libfrei0r-ocaml-dev ladspa-sdk libc-dev \
 	libaribb24-dev liblilv-dev libbluray-dev libbs2b-dev libcaca-dev libcodec2-dev \
 	libdc1394-dev libdvdread-dev libgme-dev libgsm1-dev libmysofa-dev libopencore-amrnb-dev \
 	libopencore-amrwb-dev libopenh264-dev libopenmpt-dev libplacebo-dev librabbitmq-dev libomxil-bellagio-dev \
 	libcdio-paranoia-dev fonts-noto-cjk librsvg2-dev librubberband-dev libshine-dev \
        libxcb-shm0-dev libxcb-xfixes0-dev ladspa-sdk libaribb24-dev libbluray-dev libbs2b-dev libcaca-dev \
        libcdio-dev libcodec2-dev  libdrm-dev libdvdread-dev libfontconfig1-dev libfribidi-dev \
        libgme-dev libgsm1-dev libharfbuzz-dev libjack-jackd2-dev libmysofa-dev libopencore-amrnb-dev \
        libopencore-amrwb-dev libopenh264-dev libopenmpt-dev libplacebo-dev libpulse-dev librabbitmq-dev \
        librsvg2-dev librubberband-dev libshine-dev libsmbclient-dev libsnappy-dev libsoxr-dev libspeex-dev \
        libtesseract-dev libtwolame-dev libvidstab-dev libvo-amrwbenc-dev libvpx-dev libwebp-dev libxml2-dev \
        libxvidcore-dev libzimg-dev libzmq3-dev libzvbi-dev lv2-dev libopenal-dev  libopengl-dev \
        frei0r-plugins-dev libgcrypt20-dev


RUN apt-get update && apt-get install -y --no-install-recommends \
    git gnupg2 curl ca-certificates && \
    git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git && \
    cd nv-codec-headers && make install && ldconfig

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
RUN dpkg -i cuda-keyring_1.1-1_all.deb
RUN apt-get update
RUN apt-get -y install cuda-toolkit-12-5
RUN apt-get install -y cuda-drivers


ENV CUDA_HOME=/usr/local/cuda-12.5
ENV PATH=$PATH:$CUDA_HOME/bin

RUN mkdir -p /ffmpeg_sources && \
cd /ffmpeg_sources && \
wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
tar xjvf ffmpeg-snapshot.tar.bz2  && \
cd ffmpeg && \
   ./configure \
   --ld="g++" \
   --enable-gpl \
   --enable-gnutls \
   --enable-libaom \
   --enable-libfdk-aac \
   --enable-libfreetype \
   --enable-libmp3lame \
   --enable-libopus \
   --enable-libdav1d \
   --enable-libx264 \
   --enable-libx265 \
   --enable-cuda-nvcc \
   --enable-libnpp \
   --enable-nonfree \
   --enable-libtheora \
   --enable-libvorbis \
   --enable-libxcb \
   --enable-cuvid \
   --enable-nvenc \
   --enable-libass \
   --enable-fontconfig \
   --enable-libfribidi \
   --extra-cflags=-I/usr/local/cuda/include \
   --extra-ldflags=-L/usr/local/cuda/lib64 \
   --enable-avfilter \
   --enable-shared \
   --enable-chromaprint \
   --enable-frei0r \
   --enable-gcrypt \
   --enable-ladspa \
   --enable-libaribb24 \
   --enable-libbluray \
   --enable-libbs2b \
   --enable-libcaca \
   --enable-libcdio \
   --enable-libcodec2 \
   --enable-libdc1394 \
   --enable-libdrm \
   --enable-libdvdread \
   --enable-libfontconfig \
   --enable-libgme \
   --enable-libgsm \
   --enable-libharfbuzz \
   --enable-libjack \
   --enable-libmysofa \
   --enable-libopencore-amrnb \
   --enable-libopencore-amrwb \
   --enable-libopenh264 \
   --enable-libopenmpt \
   --enable-libplacebo \
   --enable-libpulse \
   --enable-librabbitmq \
   --enable-librsvg \
   --enable-librubberband \
   --enable-libshine \
   --enable-libsmbclient \
   --enable-libsnappy \
   --enable-libsoxr \
   --enable-libspeex \
   --enable-libtesseract \
   --enable-libtheora \
   --enable-libtwolame \
   --enable-libvidstab \
   --enable-libvo-amrwbenc \
   --enable-libvorbis \
   --enable-libvpx \
   --enable-libwebp \
   --enable-libxml2 \
   --enable-libxvid \
   --enable-libzimg \
   --enable-libzmq \
   --enable-libzvbi \
   --enable-lv2 \
   --enable-omx \
   --enable-openal \
   --enable-opencl \
   --enable-opengl \
   --enable-postproc \
   --enable-pthreads \
   --enable-version3 \
   --enable-vaapi && \
   make -j$(nproc) && \
   make install


 CMD ["ffmpeg"]

