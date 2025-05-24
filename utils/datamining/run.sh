#!/bin/bash

mkdir -p output/SinusArdorum

node prepare.js

npm install
npx ts-node src/main.ts

stylua output
