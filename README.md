[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=msiplab/AtipWork&project=AtipWork.prj)

# AtipWork

Sample codes of "Advanced Topics in Image Processing" (画像処理特論), Niigata University.

The notation follows the reference text
[MsipText](https://github.com/msiplab/MsipText)
(S. Muramatsu, *Fundamentals and Developments of Multidimensional Signal and Image Processing*, Corona Publishing),
whose MATLAB examples are in [MsipWorkM](https://github.com/msiplab/MsipWorkM).

## Folders

```
AtipWork/
├── AtipWork.prj        MATLAB project (sets the path automatically)
├── scripts/            sample codes for students: sampleNN_MM.m (lecture NN, item MM)
├── code/matlab/
│   ├── +atip/          common utilities (project folders, images, LaTeX snippets)
│   ├── +msip/          algorithm helpers (undecimated Haar DWT, polyphase matrix, ...)
│   └── atip_secNN_*.m  live scripts that make the figures and numbers of the slides
├── data/               image data (msipimg01-08.tif of the reference text and others)
├── results/            outputs of the scripts (not under Git)
├── python/             Google Colab notebooks (sparse modeling exercises)
└── legacy/             old code kept for reference (not on the path; may use removed functions)
```

## Requirements

- MATLAB **R2025a or later** (the live scripts are saved in the plain-text Live Code format `.m`).
  Verified with R2026b.
- Image Processing Toolbox, Signal Processing Toolbox
- Optional, depending on the lecture:
  - Wavelet Toolbox (lectures 9 and 11; a fallback is used if it is absent)
  - Optimization Toolbox (`linprog`, lecture 10)
  - Statistics and Machine Learning Toolbox (`rica`, lecture 13)
  - Deep Learning Toolbox (lecture 13) and [SaivDr](https://github.com/msiplab/SaivDr) (downloaded by `msip.saivdr_setup`)
- Students of Niigata University can use MATLAB under the
  [Campus-Wide License](https://www.cais.niigata-u.ac.jp/service/software/matlab/).
  MATLAB Online needs no installation: use the button at the top of this page.

## Usage

Open the project.  The path is set automatically.

```matlab
openProject('AtipWork.prj')
```

Download the exercise images once (Kodak Lossless True Color Image Suite).

```matlab
atip.download_img
```

Then open and run the sample of each lecture, e.g.

```matlab
edit sample04_02     % Lecture 4, sample 2: correlation and convolution
sample04_02
```

- `sampleNN_MM.m` corresponds to lecture NN.  The list is on the "Sample codes" slide of each lecture.
- Input data are read from `data/` and outputs are written to `results/`.
  Use `[datfolder,resfolder] = atip.prjfolders();` for the locations.

| Lecture | Title | Samples |
|---|---|---|
| 01 | Digital Image Representation | `sample01_01`–`05` |
| 02 | Input and Output of Images | `sample02_01`–`05` |
| 03 | Image Smoothing and Sharpening | `sample03_01`–`05` |
| 04 | Linear Shift-Invariant Systems | `sample04_01`–`06` |
| 05 | Fourier Analysis | `sample05_01`–`06` |
| 06 | Sampling | `sample06_01`–`06` |
| 07 | Geometric Image Processing | `sample07_01`–`06` |
| 08 | Discrete Cosine Transforms | `sample08_01`–`06` |
| 09 | Discrete Wavelet Transforms | `sample09_01`–`06` |
| 10 | Redundant Transforms | `sample10_01`–`06` |
| 11 | Image Denoising | `sample11_01`–`06` |
| 12 | Image Restoration | `sample12_01`–`06` |
| 13 | Dictionary Learning | `sample13_01`–`06` |

## Link with the slides

The live scripts `code/matlab/atip_secNN_<topic>.m` write the figures `atip-NN-*.png` and
the numbers `atip-NN-*.tex` of lecture NN to `results/`.
The slide repository (AtipSlides) imports them with `tools/sync-results.ps1`
and refers to them with `\includegraphics` and `\atipsnippet{}`.

| Function | Role |
|---|---|
| `atip.prjfolders()` | locations of `data/` and `results/` |
| `atip.msipimg(idx,sz,mode)` | sample image `msipimg##.tif` of the reference text |
| `atip.download_img()` | download the Kodak images to `data/` |
| `atip.savetex(name, content)` | write a LaTeX snippet `results/<name>.tex` |
| `atip.arr2tex(X, fmt)` | format a matrix as `a & b \\ c & d` |
| `atip.fmtint(v)` | format an integer with `{,}` every three digits |

Scripts may be run one after another in the same workspace, so do not use
variable names that shadow built-in functions (`det`, `edge`, `psnr`, ...).

## References

- S. Muramatsu, *Fundamentals and Developments of Multidimensional Signal and Image Processing
  — Modeling, Approximation, Restoration and Learning —* (in Japanese), Corona Publishing (manuscript).
- S. Muramatsu, "Analysis and synthesis systems in image restoration" (in Japanese),
  J. IEICE, vol. 106, no. 1, pp. 2–9, Jan. 2023.
- S. Muramatsu, "Redundant transforms and their application to image restoration" (in Japanese),
  J. Imaging Society of Japan, vol. 53, no. 4, pp. 290–300, 2014.

## Links

- [MATLAB Academy](https://matlabacademy.mathworks.com/)
- [MATLAB Grader](https://grader.mathworks.com/)
