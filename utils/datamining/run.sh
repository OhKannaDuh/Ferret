#!/bin/bash

node prepare.js

npm install
npx ts-node src/main.ts

stylua output
