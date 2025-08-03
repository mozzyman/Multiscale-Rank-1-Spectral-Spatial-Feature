# Multiscale Rank-1 Spectral-Spatial Feature Extraction for Hyperspectral Image Classification

This repository provides the implementation of the method proposed in our paper on **Multiscale Rank-1 Spectral-Spatial Feature (MRSSF)** extraction for hyperspectral image (HSI) classification.

## Overview

Spectral-spatial features play a crucial role in improving the classification results of hyperspectral images (HSIs). However, due to the low interclass and high intraclass variability of HSI, extraction of robust spectral-spatial features is still a challenging research issue. In this work, we propose a method for extracting novel spectral-spatial features in HSI. The method exploits singular value decomposition (SVD) to obtain rank-1 approximation of the pixels inside a fixed-size window. Then the features associated with the center pixel of the window, which are called **Rank-1 Spectral-Spatial Features (RSSF)**, are used to represent the pixel. Since a single window may not define the appropriate spatial neighborhood of the center pixel, multiple windows are considered, resulting in the generation of multiple RSSFs. These RSSFs are stacked together to form a **Multiscale RSSF (MRSSF)**. The superiority of the proposed MRSSF for the classification of HSI is validated by comparing it with several state-of-the-art methods across three real benchmark datasets.
