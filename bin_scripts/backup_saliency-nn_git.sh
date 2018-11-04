#!/bin/bash

echo -----Removing old backups...-----
rm -rf ~/Backups/saliency-nn.git > /dev/null
rm -rf /mnt/extra/saliency-nn.git > /dev/null

echo -----Initiating backup...-----
cp -r ~/grive/GitRepos/GIT-PI/saliency-nn.git/ ~/Backups/saliency-nn.git/ > /dev/null

cp -r ~/grive/GitRepos/GIT-PI/saliency-nn.git/ /mnt/extra/saliency-nn.git > /dev/null
echo -----Done.-----
