Xc = dctii([1 2 3 0])

Hf = fft([1 1/2 0 0 0 0 0 1/2])

y = conv([1/2 1 1/2],xc)

Yc = Xc .* Hf(1:4)

real(ifft([Yc 0 0 0 0]))