## Introduction

![shiki in action](http://i.imgur.com/xHzSwVM.png)

This is `shiki`, a neat little script that allows you to browse Wikipedia articles right in your Terminal.
Imagine you're in the zone, don't recognize something and don't want to break your flow by tabbing to your browser: Shiki has you covered!

## Usage

`shiki NASCAR` will give you the article overview/intro to NASCAR, in English.

Furthermore `shiki` has some useful options. These are:
* `--full/-f`: requests the full article
* `--simple/-s`: requests the simple article. This is especially handy if you want a quick understanding of something!
* `NASCAR --language fr`: requests the article in French

So, if you would want to read the full article about 'The Netherlands' in 'Dutch', you would `shiki -f "The Netherlands" -l nl`

Note that 'simple' is a Wikipedia language, and thus can't be combined with the `--language` option.

## Installation

Copy the code into your '.bash_profile', '.zshrc' or '.functions'.  
Another (cleaner) way is to clone this repository and add `source "${HOME}/shiki/shiki.sh"` to one of the aforementioned files.

## With help from…

[Konsolebox](git.io/konsolebox)  
[#bash](http://webchat.freenode.net/?channels=bash) on freenode
