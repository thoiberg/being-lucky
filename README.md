# being-lucky
[![Build Status](https://travis-ci.org/thoiberg/being-lucky.svg?branch=master)](https://travis-ci.org/thoiberg/being-lucky)

Being Lucky is a simple app to play a small dice game.

Installation Instructions
-------------------------

Simply clone the repo and use `bundle install` to install all necessary gem dependencies

Usage Instructions
------------------
Run `bundle exec ruby execution.rb` and follow the prompts

Game Rules
----------
The game is simple, each player takes a turn rolling their 5 dice. Any dice that score (refer to the table below)
are removed and the player can any remaining dice again, however, if they run out of dice they lose their points
for the turn. To be able to cash in points the player needs to reach 300 on a single roll and the points from that
roll and any future rolls will be counted.

The game ends when the first player reaches 3000. Once that happens a final round is played and the scores are tallied.

Scoring table
-------------
| --------- | ----------- |
| Three 1's | 1000 points |
| Three 6's |  600 points |
| Three 5's |  500 points |
| Three 4's |  400 points |
| Three 3's |  300 points |
| Three 2's |  200 points |
| One   1   |  100 points |
| One   5   |   50 points |