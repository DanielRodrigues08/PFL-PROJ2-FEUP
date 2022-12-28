:- use_module(library(lists)). % Load list library
:- use_module(library(between)).

:- consult('board.pl').       
:- consult('game.pl').
:- consult('logic.pl').
:- consult('menu.pl').
:- consult('input.pl').

play :-
    menu.

