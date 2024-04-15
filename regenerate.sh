#!/usr/bin/env bash

mkdir -p vimruntime/doc
bundle exec ruby formatters/jq.rb > vimruntime/doc/vimuals-jq.txt

