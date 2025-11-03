FROM openturns/archlinux-base

RUN sudo pacman -Sy --noconfirm --noprogressbar openblas lapack
RUN git clone --depth 1 https://github.com/openturns/openturns.git /tmp/openturns && cd /tmp/openturns \
 && cmake -DBUILD_PYTHON=OFF -DCMAKE_UNITY_BUILD=ON -DCMAKE_UNITY_BUILD_BATCH_SIZE=32 -DUSE_EXTERNAL_LIBS=OFF . && make && sudo make install

# Install packages from AUR
RUN aurman -Syu --noconfirm --noedit --pgp_fetch libcxxwrap-julia
RUN julia -e 'import Pkg; Pkg.add("CxxWrap")'
