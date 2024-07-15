FROM nvcr.io/nvidia/cuda:11.3.1-devel-ubuntu20.04

# 環境変数の設定
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y \
    python3.8 \
    python3.8-dev \
    python3.8-distutils \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Python 3.8をデフォルトに設定
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1
RUN update-alternatives --set python3 /usr/bin/python3.8

# pipのアップグレードと必要なパッケージのインストール
RUN python3 -m pip install --upgrade pip setuptools wheel

# PyTorchとTorchVisionのインストール
RUN pip install torch==1.11.0 torchvision==0.12.0 -f https://download.pytorch.org/whl/cu113/torch_stable.html

# 必要なPythonパッケージのインストール
RUN pip install \
    numpy==1.19.2 \
    albumentations==0.4.3 \
    diffusers \
    opencv-python==4.1.2.30 \
    pudb==2019.2 \
    invisible-watermark \
    imageio==2.9.0 \
    imageio-ffmpeg==0.4.2 \
    pytorch-lightning==1.4.2 \
    omegaconf==2.1.1 \
    test-tube>=0.7.5 \
    streamlit>=0.73.1 \
    einops==0.3.0 \
    torch-fidelity==0.3.0 \
    transformers==4.19.2 \
    torchmetrics==0.6.0 \
    kornia==0.6

# GitHubリポジトリからのインストール
RUN pip install -e git+https://github.com/CompVis/taming-transformers.git@master#egg=taming-transformers
RUN pip install -e git+https://github.com/openai/CLIP.git@main#egg=clip

# 作業ディレクトリの設定
WORKDIR /app

# プロジェクトファイルのコピー（必要に応じて）
COPY . /app

# プロジェクトのインストール（必要に応じて）
RUN pip install -e .

# エントリーポイントの設定
CMD ["/bin/bash"]
