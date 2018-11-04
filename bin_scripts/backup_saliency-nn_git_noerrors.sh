#!/bin/bash

echo -----Removing old backups...-----
rm -rf ~/Backups/saliency-nn.git > /dev/null 2>&1
rm -rf /mnt/extra/saliency-nn.git > /dev/null 2>&1

echo -----Initiating backup...-----
cp -r ~/grive/GitRepos/GIT-PI/saliency-nn.git/ ~/Backups/saliency-nn.git/ > /dev/null 2>&1

cp -r ~/grive/GitRepos/GIT-PI/saliency-nn.git/ /mnt/extra/saliency-nn.git > /dev/null 2>&1
echo -----Done.-----
