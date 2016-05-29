#!/bin/bash
# Install Bigchaindb on CentOS

# The MIT License (MIT)

# Copyright (c) 2016 Shankar Narayanan

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


# Update the system
yum -y update

# Install development packages required for compiling python and beyond
yum -y install libffi-devel gcc gcc-c++ redhat-rpm-config python34-devel
yum groupinstall -y development
yum install -y zlib-dev openssl-devel sqlite-devel bzip2-devel
yum install -y xz-libs
yum -y install epel-release

# Download and extract Python 3.3
cd /tmp
wget http://www.python.org/ftp/python/3.3.3/Python-3.3.3.tar.xz
xz -d Python-3.3.3.tar.xz
tar -xvf Python-3.3.3.tar

# Build and Install Python 3.3
cd Python-3.3.3    
./configure
make && make altinstall

export PATH="/usr/local/bin:$PATH"

# Install pip
curl https://bootstrap.pypa.io/get-pip.py | python3.4

# Install Rethinkdb
cd /tmp
wget http://download.rethinkdb.com/centos/`cut -d ' ' -f 4 /etc/centos-release | cut -d '.' -f 1`/`uname -m`/rethinkdb.repo -O /etc/yum.repos.d/rethinkdb.repo
yum install rethinkdb

# Install OpenSSL with ECC
mkdir -p /opt/openssl-1.0.1s/build; cd /opt/openssl-1.0.1s
wget https://www.openssl.org/source/openssl-1.0.1s.tar.gz
tar xzvf openssl-1.0.1s.tar.gz
mv openssl-1.0.1s src; cd src
export CFLAGS="-fPIC"
./config --prefix=/opt/openssl-1.0.1s/build shared enable-ec enable-ecdh enable-ecdsa
make all && make install

# Install BigchainDB
CFLAGS='-I /opt/openssl-1.0.1s/src/include' LDFLAGS='-L /opt/openssl-1.0.1s/build/lib -Wl,-rpath=/opt/openssl-1.0.1s/build/lib' pip --no-cache-dir install bigchaindb