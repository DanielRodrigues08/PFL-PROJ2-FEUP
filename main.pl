:- use_module(library(lists)). % Load list library
:- use_module(library(between)).
:- use_module(library(clpfd)).
:- use_module(library(random)).
:- use_module(library(system)).

:- consult('board.pl').       
:- consult('game.pl').
:- consult('logic.pl').
:- consult('menu.pl').
:- consult('input.pl').
:- consult('utils.pl').
:- consult('ai.pl').

%play
%Inicia o jogo
play :-
    menu.

