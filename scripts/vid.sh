#!/bin/bash
#
# Copyright 2019 Lime Microsystems Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ./vid.sh
rm leandvb.iq
rm video.ts
rm fifo.264
mkfifo leandvb.iq
mkfifo video.ts
mkfifo fifo.264

# LimeStream, from git clone https://github.com/myriadrf/lime-tools.git
# LimeStream -h
# -s symbol rate S/s
# -f frequency in Hz
# -g gain 0.8 0-1
# -r receive with s16

# leansdr, from git clone -b work http://github.com/pabr/leansdr.git
# ./leansdr/src/apps/leandvb -h
# --u8 (default)
# --cr DVBS code rate
# -f input sampe rate
# --sr sample rate Hz 2e6
# -d debug info while running
# --gui
# --linger

# ts2es, from TS tools version 1.11 (repo), extract transport stream
# -video first video stream to h264 format (i.e. .mp4)
# -audio first audio stream

# ffplay, part of ffmpeg pkg
# -vf scale=640:-1  Scale
# -fs full screen

LimeStream -s 500000 -f 437000000 -g 0.5 -r leandvb.iq &
./leansdr/src/apps/leandvb --cr 3/4 --sr 250e3 --s16 -f 0.5e6 --gui <leandvb.iq >video.ts &
ts2es -video video.ts fifo.264 &
ffplay fifo.264 -vf scale=640:-1

#LimeStream -s 1000000 -f 437000000 -g 0.8 -r spectrum.iq &
#./kisspectrum/kisspectrum -i spectrum.iq -t i16 -s 1000000 -r 25 


