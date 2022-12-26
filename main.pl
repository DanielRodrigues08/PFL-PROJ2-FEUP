:- use_module(library(lists)). % Load list library

:- consult('board.pl').       
:- consult('game.pl').
:- consult('logic.pl').
:- consult('menu.pl').
:- consult('input.pl').

play:-init_menu.

