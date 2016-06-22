#!/bin/bash
# Install Bigchaindb on Ubuntu

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
apt-get -y update

# Install development packages required for compiling python and beyond
apt-get -y install libffi-dev g++ gcc gcc-c++ libssl-dev
apt-get -y install python3-dev python-pip python-virtualenv

# Install Rethinkdb
source /etc/lsb-release && echo "deb http://download.rethinkdb.com/apt $DISTRIB_CODENAME main" | tee /etc/apt/sources.list.d/rethinkdb.list  
wget -qO- https://download.rethinkdb.com/apt/pubkey.gpg | apt-key add -  
apt-get -y update
apt-get -y install rethinkdb

# Install BigchainDB
virtualenv -p python3.4 env
source env/bin/activate
pip install bigchaindb
bigchaindb -y configure
rethinkdb --daemon && bigchaindb start